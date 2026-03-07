import SwiftUI

/// Reusable circular back button with a left arrow icon.
struct BackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 44, height: 44)
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)

                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.darkBlue)
            }
        }
        .accessibilityLabel("Go back")
    }
}

#Preview {
    ZStack {
        AppColors.background.ignoresSafeArea()
        BackButton { }
    }
}
