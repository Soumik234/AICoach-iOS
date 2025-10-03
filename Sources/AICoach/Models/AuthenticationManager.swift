import Foundation
import SwiftUI
import AuthenticationServices

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    func signInWithEmail(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            self?.currentUser = User(email: email, name: email.components(separatedBy: "@").first ?? "User")
            self?.isAuthenticated = true
            self?.errorMessage = nil
        }
    }
    
    func signInWithApple(authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email ?? "\(userIdentifier)@apple.com"
            let name = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
                .compactMap { $0 }
                .joined(separator: " ")
            
            currentUser = User(email: email, name: name.isEmpty ? "User" : name)
            isAuthenticated = true
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            self?.currentUser = User(email: "user@gmail.com", name: "Google User")
            self?.isAuthenticated = true
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
}
