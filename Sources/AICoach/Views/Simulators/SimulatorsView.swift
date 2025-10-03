import SwiftUI

struct SimulatorsView: View {
    @State private var selectedCategory: SimulatorCategory = .all
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    CategorySelector(selectedCategory: $selectedCategory)
                    
                    VStack(spacing: 16) {
                        SimulatorCard(
                            title: "Technical Interview Prep",
                            description: "Practice coding interviews with AI feedback",
                            icon: "laptopcomputer",
                            color: AppColors.primary,
                            sessionCount: 12,
                            averageScore: 85
                        )
                        
                        SimulatorCard(
                            title: "System Design Scenarios",
                            description: "Design scalable systems step-by-step",
                            icon: "network",
                            color: AppColors.accent,
                            sessionCount: 8,
                            averageScore: 78
                        )
                        
                        SimulatorCard(
                            title: "Debugging Challenges",
                            description: "Find and fix bugs in real code",
                            icon: "ant.fill",
                            color: AppColors.danger,
                            sessionCount: 15,
                            averageScore: 92
                        )
                        
                        SimulatorCard(
                            title: "Architecture Patterns",
                            description: "Apply design patterns to solve problems",
                            icon: "building.columns.fill",
                            color: AppColors.success,
                            sessionCount: 6,
                            averageScore: 81
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(AppColors.background)
            .navigationTitle("AI Simulators")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
        }
    }
}

enum SimulatorCategory: String, CaseIterable {
    case all = "All"
    case coding = "Coding"
    case design = "Design"
    case debugging = "Debugging"
    case architecture = "Architecture"
}

struct CategorySelector: View {
    @Binding var selectedCategory: SimulatorCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SimulatorCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SimulatorCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let sessionCount: Int
    let averageScore: Int
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: icon)
                            .font(.system(size: 28))
                            .foregroundColor(color)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)
                        
                        Text(description)
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(16)
                
                Divider()
                
                HStack(spacing: 24) {
                    StatItem(icon: "number", value: "\(sessionCount)", label: "Sessions")
                    
                    Divider()
                        .frame(height: 30)
                    
                    StatItem(icon: "chart.line.uptrend.xyaxis", value: "\(averageScore)%", label: "Avg Score")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SimulatorsView()
}
