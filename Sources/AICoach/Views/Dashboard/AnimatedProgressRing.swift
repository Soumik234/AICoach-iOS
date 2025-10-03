import SwiftUI

struct AnimatedProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let gradient: LinearGradient
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.textSecondary.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 1.2, dampingFraction: 0.8), value: animatedProgress)
            
            VStack(spacing: 4) {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(size: size / 5, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .contentTransition(.numericText())
                
                Text("Complete")
                    .font(.system(size: size / 10))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .onAppear {
            withAnimation {
                animatedProgress = progress
            }
        }
    }
}
