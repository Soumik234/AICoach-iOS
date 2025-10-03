import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.0, green: 0.48, blue: 1.0)
    static let secondary = Color(red: 0.35, green: 0.34, blue: 0.84)
    static let accent = Color(red: 1.0, green: 0.58, blue: 0.0)
    static let success = Color(red: 0.2, green: 0.78, blue: 0.35)
    static let warning = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let danger = Color(red: 1.0, green: 0.23, blue: 0.19)
    
    static let background = Color(red: 0.98, green: 0.98, blue: 1.0)
    static let cardBackground = Color.white
    static let textPrimary = Color(red: 0.11, green: 0.11, blue: 0.12)
    static let textSecondary = Color(red: 0.56, green: 0.56, blue: 0.58)
    
    static let gradient1 = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradient2 = LinearGradient(
        colors: [accent, Color(red: 1.0, green: 0.35, blue: 0.35)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
