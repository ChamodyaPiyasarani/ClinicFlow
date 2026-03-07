import SwiftUI

struct SplashScreenView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @State private var progress: CGFloat = 0.0

    var body: some View {
        ZStack {
                // Background color
                AppColors.brandBlue
                    .ignoresSafeArea()

                // Decorative background circles
                BackgroundCirclesView(
                    color: AppColors.lightBlue,
                    opacity: 0.5,
                    lineWidth: 60
                )

                // Main content
                VStack(spacing: 0) {
                    Spacer()

                    // Logo
                    Image("Clinic_Flow_splach_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)

                    // App name
                    AppNameText(fontSize: 28, clinicColor: .white, flowColor: .white)
                        .padding(.top, 16)

                    Spacer()

                    // Progress bar
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 200, height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: 200 * progress, height: 6)
                    }
                    .padding(.bottom, 40)

                    // Footer
                    Text("© ClinicFlow 2026")
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.bottom, 20)
                }
            }
            .onAppear {
                // Animate progress bar
                withAnimation(.easeInOut(duration: 2.5)) {
                    progress = 1.0
                }
                // Navigate after progress completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    router.navigate(to: .languageSelection)
                }
            }
    }
}

#Preview {
    SplashScreenView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
