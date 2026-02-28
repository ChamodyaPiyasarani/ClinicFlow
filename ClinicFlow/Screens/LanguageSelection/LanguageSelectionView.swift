//
//  LanguageSelectionView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import SwiftUI

struct LanguageSelectionView: View {
    @Environment(LanguageManager.self) var languageManager
    @State private var selectedLanguage: AppLanguage = .english
    @State private var navigateToSignUp = false

    var body: some View {
        if navigateToSignUp {
            UserSignUpView()
                .environment(languageManager)
        } else {
            ZStack {
                // Light background
                AppColors.background.ignoresSafeArea()

                // Decorative background circles
                BackgroundCirclesView(
                    color: AppColors.brandBlue,
                    opacity: 0.08,
                    lineWidth: 60
                )

                ScrollView {
                    VStack(spacing: 0) {

                        // MARK: - Logo
                        Image("ClinicFlowLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.top, 60)

                        // MARK: - Welcome texts (all three languages)
                        VStack(spacing: 2) {
                            Text("ආයුබෝවන්")
                                .font(.poppins(.bold, size: 26))
                                .foregroundColor(AppColors.darkBlue)

                            Text("வணக்கம்")
                                .font(.poppins(.bold, size: 26))
                                .foregroundColor(AppColors.darkBlue)

                            Text("Welcome")
                                .font(.poppins(.bold, size: 26))
                                .foregroundColor(AppColors.darkBlue)
                        }
                        .padding(.top, 12)

                        // MARK: - Divider
                        RoundedRectangle(cornerRadius: 1)
                            .fill(AppColors.brandBlue.opacity(0.3))
                            .frame(width: 40, height: 3)
                            .padding(.top, 24)

                        // MARK: - Subtitle
                        Text("Select your preferred language")
                            .font(.poppins(.regular, size: 15))
                            .foregroundColor(.gray)
                            .padding(.top, 16)

                        // MARK: - Language Options
                        VStack(spacing: 16) {
                            ForEach(AppLanguage.allCases) { language in
                                LanguageOptionCard(
                                    language: language,
                                    isSelected: selectedLanguage == language
                                ) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedLanguage = language
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.top, 32)

                        // MARK: - Continue Button
                        PrimaryButton(title: "Continue") {
                            languageManager.setLanguage(selectedLanguage)
                            withAnimation {
                                navigateToSignUp = true
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
}

#Preview {
    LanguageSelectionView()
        .environment(LanguageManager.shared)
}
