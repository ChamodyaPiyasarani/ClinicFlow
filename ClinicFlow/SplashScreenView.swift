//
//  SplashScreenView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var progress: CGFloat = 0.0
    @State private var isActive = false

    // Brand blue color matching the design
    private let brandBlue = Color(red: 100/255, green: 140/255, blue: 200/255)
    private let lightBlue = Color(red: 130/255, green: 165/255, blue: 215/255)

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Background color
                brandBlue
                    .ignoresSafeArea()

                // Decorative background circles
                GeometryReader { geometry in
                    // Top-left circle (partially off-screen)
                    Circle()
                        .stroke(lightBlue.opacity(0.5), lineWidth: 60)
                        .frame(width: 300, height: 300)
                        .offset(x: -100, y: -80)

                    // Top-right circle (partially off-screen)
                    Circle()
                        .stroke(lightBlue.opacity(0.5), lineWidth: 60)
                        .frame(width: 250, height: 250)
                        .offset(x: geometry.size.width - 120, y: -60)

                    // Bottom-left circle (partially off-screen)
                    Circle()
                        .stroke(lightBlue.opacity(0.5), lineWidth: 60)
                        .frame(width: 280, height: 280)
                        .offset(x: -80, y: geometry.size.height - 200)

                    // Bottom-right circle (partially off-screen)
                    Circle()
                        .stroke(lightBlue.opacity(0.5), lineWidth: 60)
                        .frame(width: 320, height: 320)
                        .offset(x: geometry.size.width - 150, y: geometry.size.height - 150)
                }
                .ignoresSafeArea()

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
                        .font(.poppins(.black, size: 35))
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
}
