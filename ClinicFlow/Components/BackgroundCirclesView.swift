import SwiftUI

/// Reusable decorative background circles used across multiple screens.
struct BackgroundCirclesView: View {
    var color: Color = AppColors.brandBlue
    var opacity: Double = 0.08
    var lineWidth: CGFloat = 60

    var body: some View {
        GeometryReader { geometry in
            // Top-left circle
            Circle()
                .stroke(color.opacity(opacity), lineWidth: lineWidth)
                .frame(width: 300, height: 300)
                .offset(x: -100, y: -80)

            // Top-right circle
            Circle()
                .stroke(color.opacity(opacity), lineWidth: lineWidth)
                .frame(width: 250, height: 250)
                .offset(x: geometry.size.width - 120, y: -60)

            // Bottom-left circle
            Circle()
                .stroke(color.opacity(opacity), lineWidth: lineWidth)
                .frame(width: 280, height: 280)
                .offset(x: -80, y: geometry.size.height - 200)

            // Bottom-right circle
            Circle()
                .stroke(color.opacity(opacity), lineWidth: lineWidth)
                .frame(width: 320, height: 320)
                .offset(x: geometry.size.width - 150, y: geometry.size.height - 150)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        BackgroundCirclesView()
    }
}
