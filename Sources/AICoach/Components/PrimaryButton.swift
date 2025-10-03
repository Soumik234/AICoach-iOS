import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var backgroundColor: LinearGradient = AppColors.gradient1
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}
