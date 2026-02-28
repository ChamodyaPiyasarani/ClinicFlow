//
//  SplashScreenView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-25.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var progress: CGFloat = 0.0
    @State private var isActive = false

    var body: some View {
        if isActive {
            LanguageSelectionView()
                .environmentObject(languageManager)
        } else {
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
                    Image("ClinicFlowLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)

                    // App name
                    Text("CLINICFLOW")
                        .font(.poppins(.extraBold, size: 28))
                        .foregroundColor(.white)
                        .tracking(2)
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
                    Text("@ClinicFlow 2026")
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
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(LanguageManager.shared)
}
