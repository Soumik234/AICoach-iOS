import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ProgressOverviewCard()
                    
                    MetricsGrid()
                    
                    QuickActionsCard()
                    
                    AIRecommendationsCard()
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle("Dashboard")
        }
    }
}

struct ProgressOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(AppColors.textSecondary.opacity(0.2), lineWidth: 12)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: 0.65)
                        .stroke(AppColors.gradient1, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 4) {
                        Text("65%")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Complete")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    ProgressRow(title: "Learning Paths", value: "3/5", color: AppColors.primary)
                    ProgressRow(title: "Simulators", value: "12/20", color: AppColors.accent)
                    ProgressRow(title: "Roleplay Sessions", value: "8/15", color: AppColors.success)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct ProgressRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

struct MetricsGrid: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            MetricCard(icon: "checkmark.circle.fill", value: "24", label: "Completed", color: AppColors.success)
            MetricCard(icon: "star.fill", value: "1,250", label: "Total Score", color: AppColors.accent)
            MetricCard(icon: "clock.fill", value: "12h", label: "Time Spent", color: AppColors.primary)
            MetricCard(icon: "flame.fill", value: "7", label: "Day Streak", color: AppColors.danger)
        }
    }
}

struct MetricCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct QuickActionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                QuickActionButton(icon: "plus.circle.fill", title: "Create Learning Path", color: AppColors.primary)
                QuickActionButton(icon: "play.fill", title: "Start Simulator", color: AppColors.accent)
                QuickActionButton(icon: "bubble.left.and.bubble.right.fill", title: "Begin Roleplay", color: AppColors.success)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(16)
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct AIRecommendationsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("AI Recommendations")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(alignment: .leading, spacing: 12) {
                RecommendationRow(title: "Complete Advanced Swift Module", subtitle: "Based on your progress")
                RecommendationRow(title: "Practice Interview Scenarios", subtitle: "Improve your communication skills")
                RecommendationRow(title: "Review Data Structures", subtitle: "Strengthen weak areas")
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct RecommendationRow: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "sparkles")
                .foregroundColor(AppColors.accent)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(AppColors.background)
        .cornerRadius(10)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthenticationManager())
}
