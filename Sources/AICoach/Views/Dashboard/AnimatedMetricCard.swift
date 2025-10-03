import SwiftUI

struct AnimatedMetricCard: View {
    let icon: String
    let value: Int
    let label: String
    let color: Color
    
    @State private var animatedValue: Int = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
                .scaleEffect(scale)
            
            Text("\(animatedValue)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
                .contentTransition(.numericText())
            
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
                scale = 1.0
                opacity = 1.0
            }
            
            animateValue()
        }
    }
    
    private func animateValue() {
        let duration: Double = 1.5
        let steps = 60
        let increment = value / steps
        
        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration / Double(steps)) * Double(step)) {
                animatedValue = min(increment * step, value)
            }
        }
    }
}
