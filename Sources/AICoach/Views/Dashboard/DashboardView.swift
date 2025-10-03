import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var recommendationService = RecommendationService()
    @State private var showingQuickAction = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    WelcomeHeader()
                    
                    AnimatedProgressOverviewCard()
                    
                    AnimatedMetricsGrid()
                    
                    QuickActionsCard(showingQuickAction: $showingQuickAction)
                    
                    AIRecommendationsCard(recommendations: recommendationService.recommendations)
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle("Dashboard")
            .refreshable {
                recommendationService.refreshRecommendations()
            }
        }
    }
}

struct WelcomeHeader: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(authManager.currentUser?.name ?? "User")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.gradient1)
                    .frame(width: 50, height: 50)
                
                Text(authManager.currentUser?.name.prefix(1).uppercased() ?? "U")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 4)
    }
}

struct AnimatedProgressOverviewCard: View {
    @State private var appeared = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 20) {
                AnimatedProgressRing(
                    progress: 0.65,
                    lineWidth: 12,
                    size: 120,
                    gradient: AppColors.gradient1
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    AnimatedProgressRow(title: "Learning Paths", current: 3, total: 5, color: AppColors.primary, delay: 0.1)
                    AnimatedProgressRow(title: "Simulators", current: 12, total: 20, color: AppColors.accent, delay: 0.2)
                    AnimatedProgressRow(title: "Roleplay Sessions", current: 8, total: 15, color: AppColors.success, delay: 0.3)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }
}

struct AnimatedProgressRow: View {
    let title: String
    let current: Int
    let total: Int
    let color: Color
    let delay: Double
    
    @State private var animatedCurrent: Int = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text("\(animatedCurrent)/\(total)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
                .contentTransition(.numericText())
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(delay)) {
                opacity = 1.0
            }
            
            animateValue()
        }
    }
    
    private func animateValue() {
        let duration: Double = 1.0
        let steps = current
        
        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + (duration / Double(steps)) * Double(step)) {
                animatedCurrent = step
            }
        }
    }
}

struct AnimatedMetricsGrid: View {
    @State private var appeared = false
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            AnimatedMetricCard(icon: "checkmark.circle.fill", value: 24, label: "Completed", color: AppColors.success)
            AnimatedMetricCard(icon: "star.fill", value: 1250, label: "Total Score", color: AppColors.accent)
            AnimatedMetricCard(icon: "clock.fill", value: 12, label: "Hours Spent", color: AppColors.primary)
            AnimatedMetricCard(icon: "flame.fill", value: 7, label: "Day Streak", color: AppColors.danger)
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                appeared = true
            }
        }
    }
}

struct QuickActionsCard: View {
    @Binding var showingQuickAction: Bool
    @State private var appeared = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                QuickActionButton(
                    icon: "plus.circle.fill",
                    title: "Create Learning Path",
                    color: AppColors.primary
                ) {
                    showingQuickAction = true
                }
                
                QuickActionButton(
                    icon: "play.fill",
                    title: "Start Simulator",
                    color: AppColors.accent
                ) {
                    showingQuickAction = true
                }
                
                QuickActionButton(
                    icon: "bubble.left.and.bubble.right.fill",
                    title: "Begin Roleplay",
                    color: AppColors.success
                ) {
                    showingQuickAction = true
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
                appeared = true
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
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
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
    }
}

struct AIRecommendationsCard: View {
    let recommendations: [Recommendation]
    @State private var appeared = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("AI Recommendations")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .foregroundColor(AppColors.accent)
                    .font(.system(size: 16))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(recommendations.prefix(3).enumerated()), id: \.element.id) { index, recommendation in
                    RecommendationRow(
                        title: recommendation.title,
                        subtitle: recommendation.subtitle,
                        delay: Double(index) * 0.1
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4)) {
                appeared = true
            }
        }
    }
}

struct RecommendationRow: View {
    let title: String
    let subtitle: String
    let delay: Double
    
    @State private var appeared = false
    
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
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : -20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4 + delay)) {
                appeared = true
            }
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthenticationManager())
}
