import SwiftUI
import FirebaseCore

@main
struct AICoachApp: App {
    @StateObject private var authManager = AuthenticationManager()
    
    init() {
        FirebaseConfig.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainTabView()
                    .environmentObject(authManager)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}
