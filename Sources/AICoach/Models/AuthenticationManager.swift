import Foundation
import SwiftUI
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn

enum AuthError: LocalizedError {
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    case userNotFound
    case wrongPassword
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .weakPassword:
            return "Password should be at least 6 characters"
        case .emailAlreadyInUse:
            return "This email is already registered"
        case .userNotFound:
            return "No account found with this email"
        case .wrongPassword:
            return "Incorrect password. Please try again"
        case .networkError:
            return "Network error. Please check your connection"
        case .unknown(let message):
            return message
        }
    }
}

class AuthenticationManager: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    private let authStateKey = "isAuthenticated"
    private var currentNonce: String?
    
    override init() {
        super.init()
        loadUserSession()
        setupFirebaseAuthListener()
    }
    
    private func setupFirebaseAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.loadUserFromFirebase(user)
            } else {
                self?.clearSession()
            }
        }
    }
    
    private func loadUserSession() {
        if let savedUser = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: savedUser) {
            self.currentUser = user
            self.isAuthenticated = userDefaults.bool(forKey: authStateKey)
        }
    }
    
    private func saveUserSession() {
        if let user = currentUser,
           let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
            userDefaults.set(isAuthenticated, forKey: authStateKey)
        }
    }
    
    private func clearSession() {
        userDefaults.removeObject(forKey: userKey)
        userDefaults.removeObject(forKey: authStateKey)
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.currentUser = nil
        }
    }
    
    private func loadUserFromFirebase(_ firebaseUser: FirebaseAuth.User) {
        let user = User(
            email: firebaseUser.email ?? "",
            name: firebaseUser.displayName ?? firebaseUser.email?.components(separatedBy: "@").first ?? "User"
        )
        
        DispatchQueue.main.async {
            self.currentUser = user
            self.isAuthenticated = true
            self.saveUserSession()
        }
    }
    
    func signInWithEmail(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            return
        }
        
        guard email.contains("@") else {
            errorMessage = AuthError.invalidEmail.errorDescription
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = AuthError.weakPassword.errorDescription
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error as NSError? {
                    self?.handleFirebaseError(error)
                    return
                }
                
                if let firebaseUser = result?.user {
                    self?.loadUserFromFirebase(firebaseUser)
                }
            }
        }
    }
    
    func signUpWithEmail(email: String, password: String, name: String) {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard email.contains("@") else {
            errorMessage = AuthError.invalidEmail.errorDescription
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = AuthError.weakPassword.errorDescription
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error as NSError? {
                    self?.handleFirebaseError(error)
                    return
                }
                
                if let firebaseUser = result?.user {
                    let changeRequest = firebaseUser.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges { _ in
                        self?.loadUserFromFirebase(firebaseUser)
                    }
                }
            }
        }
    }
    
    func startSignInWithAppleFlow() {
        let nonce = CryptoHelpers.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoHelpers.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        signInWithApple(authorization: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
    
    func signInWithApple(authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            errorMessage = "Failed to get Apple credentials"
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            errorMessage = "Failed to fetch identity token"
            return
        }
        
        guard let nonce = currentNonce else {
            errorMessage = "Invalid state: A login callback was received, but no login request was sent"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                if let firebaseUser = result?.user {
                    if let fullName = appleIDCredential.fullName {
                        let displayName = [fullName.givenName, fullName.familyName]
                            .compactMap { $0 }
                            .joined(separator: " ")
                        
                        if !displayName.isEmpty {
                            let changeRequest = firebaseUser.createProfileChangeRequest()
                            changeRequest.displayName = displayName
                            changeRequest.commitChanges { _ in
                                self?.loadUserFromFirebase(firebaseUser)
                            }
                        } else {
                            self?.loadUserFromFirebase(firebaseUser)
                        }
                    } else {
                        self?.loadUserFromFirebase(firebaseUser)
                    }
                }
            }
        }
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Firebase client ID not found"
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = "Unable to get root view controller"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    self?.isLoading = false
                    self?.errorMessage = "Failed to get Google credentials"
                    return
                }
                
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )
                
                Auth.auth().signIn(with: credential) { result, error in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        
                        if let error = error {
                            self?.errorMessage = error.localizedDescription
                            return
                        }
                        
                        if let firebaseUser = result?.user {
                            self?.loadUserFromFirebase(firebaseUser)
                        }
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            clearSession()
        } catch {
            errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
    
    func resetPassword(email: String) {
        guard !email.isEmpty, email.contains("@") else {
            errorMessage = AuthError.invalidEmail.errorDescription
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error as NSError? {
                    self?.handleFirebaseError(error)
                } else {
                    self?.errorMessage = nil
                }
            }
        }
    }
    
    private func handleFirebaseError(_ error: NSError) {
        guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
            errorMessage = AuthError.unknown(error.localizedDescription).errorDescription
            return
        }
        
        switch errorCode {
        case .invalidEmail:
            errorMessage = AuthError.invalidEmail.errorDescription
        case .weakPassword:
            errorMessage = AuthError.weakPassword.errorDescription
        case .emailAlreadyInUse:
            errorMessage = AuthError.emailAlreadyInUse.errorDescription
        case .userNotFound:
            errorMessage = AuthError.userNotFound.errorDescription
        case .wrongPassword:
            errorMessage = AuthError.wrongPassword.errorDescription
        case .networkError:
            errorMessage = AuthError.networkError.errorDescription
        default:
            errorMessage = error.localizedDescription
        }
    }
}
