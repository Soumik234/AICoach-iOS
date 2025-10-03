import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(0)
            
            LearningView()
                .tabItem {
                    Label("Learning", systemImage: "book.fill")
                }
                .tag(1)
            
            SimulatorsView()
                .tabItem {
                    Label("Simulators", systemImage: "cpu.fill")
                }
                .tag(2)
            
            RoleplayView()
                .tabItem {
                    Label("Roleplay", systemImage: "person.2.fill")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(4)
        }
        .accentColor(AppColors.primary)
    }
}
