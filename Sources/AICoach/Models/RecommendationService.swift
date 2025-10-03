import Foundation

struct Recommendation: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let category: RecommendationCategory
    let priority: Int
}

enum RecommendationCategory {
    case learning
    case practice
    case review
    case challenge
}

class RecommendationService: ObservableObject {
    @Published var recommendations: [Recommendation] = []
    
    init() {
        loadRecommendations()
    }
    
    func loadRecommendations() {
        recommendations = [
            Recommendation(
                title: "Complete Advanced Swift Module",
                subtitle: "Based on your progress in iOS development",
                category: .learning,
                priority: 1
            ),
            Recommendation(
                title: "Practice Interview Scenarios",
                subtitle: "Improve your communication skills",
                category: .practice,
                priority: 2
            ),
            Recommendation(
                title: "Review Data Structures",
                subtitle: "Strengthen weak areas in algorithms",
                category: .review,
                priority: 3
            ),
            Recommendation(
                title: "Try System Design Challenge",
                subtitle: "Test your architecture knowledge",
                category: .challenge,
                priority: 4
            )
        ]
    }
    
    func refreshRecommendations() {
        loadRecommendations()
    }
}
