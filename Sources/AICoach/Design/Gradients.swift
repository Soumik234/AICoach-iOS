import SwiftUI

struct AppGradients {
    static let primaryGradient = LinearGradient(
        colors: [
            Color(red: 0.0, green: 0.48, blue: 1.0),
            Color(red: 0.35, green: 0.34, blue: 0.84)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.58, blue: 0.0),
            Color(red: 1.0, green: 0.35, blue: 0.35)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successGradient = LinearGradient(
        colors: [
            Color(red: 0.2, green: 0.78, blue: 0.35),
            Color(red: 0.0, green: 0.6, blue: 0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.98, green: 0.98, blue: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.98, blue: 1.0),
            Color(red: 0.95, green: 0.96, blue: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
