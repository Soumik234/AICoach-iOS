import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ProfileHeaderView()
                    
                    BadgesSection()
                    
                    StatsSection()
                    
                    SettingsSection(showSettings: $showSettings)
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
        }
    }
}

struct ProfileHeaderView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.gradient1)
                    .frame(width: 100, height: 100)
                
                Text(authManager.currentUser?.name.prefix(1).uppercased() ?? "U")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 6) {
                Text(authManager.currentUser?.name ?? "User")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(authManager.currentUser?.email ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            HStack(spacing: 16) {
                LevelBadge(level: authManager.currentUser?.currentLevel ?? 1)
                
                Button(action: {}) {
                    Text("Edit Profile")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(AppColors.primary.opacity(0.1))
                        .cornerRadius(20)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct LevelBadge: View {
    let level: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.system(size: 12))
                .foregroundColor(AppColors.accent)
            
            Text("Level \(level)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(AppColors.accent.opacity(0.1))
        .cornerRadius(16)
    }
}

struct BadgesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                BadgeItem(icon: "flame.fill", name: "7 Day Streak", color: AppColors.danger)
                BadgeItem(icon: "trophy.fill", name: "Top Scorer", color: AppColors.accent)
                BadgeItem(icon: "bolt.fill", name: "Fast Learner", color: AppColors.primary)
                BadgeItem(icon: "star.fill", name: "Perfect Score", color: AppColors.success)
                BadgeItem(icon: "brain.head.profile", name: "AI Master", color: AppColors.secondary)
                BadgeItem(icon: "medal.fill", name: "100 Sessions", color: AppColors.accent)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct BadgeItem: View {
    let icon: String
    let name: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(color)
            }
            
            Text(name)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}

struct StatsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learning Stats")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                StatRow(icon: "checkmark.circle.fill", label: "Completed Sessions", value: "24", color: AppColors.success)
                StatRow(icon: "clock.fill", label: "Total Time", value: "12h 30m", color: AppColors.primary)
                StatRow(icon: "chart.line.uptrend.xyaxis", label: "Average Score", value: "85%", color: AppColors.accent)
                StatRow(icon: "flame.fill", label: "Current Streak", value: "7 days", color: AppColors.danger)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

struct SettingsSection: View {
    @Binding var showSettings: Bool
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 0) {
                SettingsRow(icon: "bell.fill", label: "Notifications", color: AppColors.accent)
                Divider().padding(.leading, 50)
                SettingsRow(icon: "moon.fill", label: "Dark Mode", color: AppColors.secondary)
                Divider().padding(.leading, 50)
                SettingsRow(icon: "globe", label: "Language", color: AppColors.primary)
                Divider().padding(.leading, 50)
                SettingsRow(icon: "questionmark.circle.fill", label: "Help & Support", color: AppColors.success)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        
        Button(action: { authManager.signOut() }) {
            Text("Sign Out")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.danger)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.danger, lineWidth: 1)
                )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(label)
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
}
