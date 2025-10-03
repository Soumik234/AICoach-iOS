import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 70))
                        .foregroundStyle(AppColors.gradient1)
                    
                    Text("AI Coach")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Your Personalized Learning Assistant")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 50)
                
                VStack(spacing: 16) {
                    CustomTextField(
                        placeholder: "Email",
                        text: $email,
                        iconName: "envelope.fill"
                    )
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    
                    CustomTextField(
                        placeholder: "Password",
                        text: $password,
                        iconName: "lock.fill",
                        isSecure: !showPassword
                    )
                    .overlay(alignment: .trailing) {
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.trailing, 16)
                        }
                    }
                    
                    if let error = authManager.errorMessage {
                        Text(error)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.danger)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                    }
                    
                    PrimaryButton(
                        title: "Sign In",
                        isLoading: authManager.isLoading
                    ) {
                        authManager.signInWithEmail(email: email, password: password)
                    }
                    .padding(.top, 8)
                    
                    HStack {
                        Rectangle()
                            .fill(AppColors.textSecondary.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("or")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, 12)
                        
                        Rectangle()
                            .fill(AppColors.textSecondary.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.vertical, 8)
                    
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            authManager.signInWithApple(authorization: authorization)
                        case .failure(let error):
                            authManager.errorMessage = error.localizedDescription
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(12)
                    
                    SocialButton(
                        title: "Continue with Google",
                        iconName: "g.circle.fill",
                        backgroundColor: .white,
                        foregroundColor: AppColors.textPrimary
                    ) {
                        authManager.signInWithGoogle()
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Button("Sign Up") {
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.primary)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationManager())
}
