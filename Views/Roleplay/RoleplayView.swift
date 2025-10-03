import SwiftUI

struct RoleplayView: View {
    @State private var showNewRoleplay = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Start New Session")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                NewRoleplayCard(
                                    title: "Job Interview",
                                    icon: "person.crop.circle.badge.checkmark",
                                    color: AppColors.primary
                                )
                                
                                NewRoleplayCard(
                                    title: "Sales Pitch",
                                    icon: "megaphone.fill",
                                    color: AppColors.accent
                                )
                                
                                NewRoleplayCard(
                                    title: "Negotiation",
                                    icon: "handshake.fill",
                                    color: AppColors.success
                                )
                                
                                NewRoleplayCard(
                                    title: "Custom",
                                    icon: "plus.circle.fill",
                                    color: AppColors.secondary
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Sessions")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            RoleplayHistoryCard(
                                title: "Technical Interview - Senior iOS Developer",
                                date: "2 hours ago",
                                duration: "25 min",
                                score: 88,
                                avatar: "person.fill"
                            )
                            
                            RoleplayHistoryCard(
                                title: "Salary Negotiation Practice",
                                date: "Yesterday",
                                duration: "18 min",
                                score: 92,
                                avatar: "person.fill"
                            )
                            
                            RoleplayHistoryCard(
                                title: "Client Presentation",
                                date: "3 days ago",
                                duration: "30 min",
                                score: 85,
                                avatar: "person.fill"
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(AppColors.background)
            .navigationTitle("AI Roleplay")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showNewRoleplay = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
        }
    }
}

struct NewRoleplayCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 120)
            .padding(.vertical, 16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
    }
}

struct RoleplayHistoryCard: View {
    let title: String
    let date: String
    let duration: String
    let score: Int
    let avatar: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primary.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: avatar)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primary)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        Label(date, systemImage: "clock")
                            .font(.system(size: 13))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Label(duration, systemImage: "timer")
                            .font(.system(size: 13))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(score)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(scoreColor(score))
                    
                    Text("Score")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
    }
    
    private func scoreColor(_ score: Int) -> Color {
        if score >= 90 { return AppColors.success }
        if score >= 75 { return AppColors.accent }
        return AppColors.danger
    }
}

#Preview {
    RoleplayView()
}
