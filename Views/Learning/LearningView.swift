import SwiftUI

struct LearningView: View {
    @State private var selectedFilter: LearningFilter = .all
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                    
                    FilterScrollView(selectedFilter: $selectedFilter)
                    
                    VStack(spacing: 16) {
                        CourseCard(
                            title: "Advanced Swift Programming",
                            subtitle: "Master modern Swift concepts",
                            difficulty: .advanced,
                            progress: 0.65,
                            tags: ["Swift", "iOS", "Programming"]
                        )
                        
                        CourseCard(
                            title: "Data Structures & Algorithms",
                            subtitle: "Learn essential CS fundamentals",
                            difficulty: .intermediate,
                            progress: 0.30,
                            tags: ["CS", "Algorithms", "Problem Solving"]
                        )
                        
                        CourseCard(
                            title: "SwiftUI Masterclass",
                            subtitle: "Build beautiful iOS apps",
                            difficulty: .beginner,
                            progress: 0.85,
                            tags: ["SwiftUI", "UI/UX", "iOS"]
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(AppColors.background)
            .navigationTitle("Learning Paths")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
        }
    }
}

enum LearningFilter: String, CaseIterable {
    case all = "All"
    case inProgress = "In Progress"
    case completed = "Completed"
    case notStarted = "Not Started"
}

enum DifficultyLevel: String {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var color: Color {
        switch self {
        case .beginner: return AppColors.success
        case .intermediate: return AppColors.accent
        case .advanced: return AppColors.danger
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search courses...", text: $text)
                .font(.system(size: 16))
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.textSecondary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct FilterScrollView: View {
    @Binding var selectedFilter: LearningFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(LearningFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.primary : AppColors.cardBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.textSecondary.opacity(0.2), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct CourseCard: View {
    let title: String
    let subtitle: String
    let difficulty: DifficultyLevel
    let progress: Double
    let tags: [String]
    
    var body: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)
                        
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.textSecondary)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppColors.primary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(AppColors.primary.opacity(0.1))
                                .cornerRadius(6)
                        }
                        
                        Text(difficulty.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(difficulty.color)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(difficulty.color.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Progress")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Spacer()
                        
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(AppColors.textSecondary.opacity(0.2))
                                .frame(height: 6)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .fill(AppColors.gradient1)
                                .frame(width: geometry.size.width * progress, height: 6)
                                .cornerRadius(3)
                        }
                    }
                    .frame(height: 6)
                }
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        }
    }
}

#Preview {
    LearningView()
}
