import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var email: String
    var name: String
    var avatar: String?
    var learningGoals: [String]
    var totalScore: Int
    var completedSessions: Int
    var timeSpent: TimeInterval
    var badges: [Badge]
    var currentLevel: Int
    
    init(id: UUID = UUID(), email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
        self.learningGoals = []
        self.totalScore = 0
        self.completedSessions = 0
        self.timeSpent = 0
        self.badges = []
        self.currentLevel = 1
    }
}

struct Badge: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let iconName: String
    let earnedDate: Date
}
