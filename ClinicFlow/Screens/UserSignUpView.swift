//
//  UserSignUpView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import SwiftUI

struct UserSignUpView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @State private var userName: String = ""
    @State private var contactNumber: String = ""
    @State private var agreedToTerms: Bool = false

    private var isFormValid: Bool {
        !userName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !contactNumber.trimmingCharacters(in: .whitespaces).isEmpty &&
        agreedToTerms
    }

    var body: some View {
        ZStack {
                // Background
                AppColors.background
                    .ignoresSafeArea()

                // Decorative circles
                BackgroundCirclesView(
                    color: AppColors.brandBlue,
                    opacity: 0.08,
                    lineWidth: 60
                )

                VStack(spacing: 0) {
                    // MARK: - Back Button
                    HStack {
                        BackButton {
                            router.goBack()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    // MARK: - Card Content
                    ScrollView {
                        // Single white card containing everything
                        VStack(spacing: 0) {
                            // App name
                            HStack(spacing: 0) {
                                Text("CLINIC")
                                    .font(.poppins(.bold, size: 20))
                                    .foregroundColor(AppColors.brandBlue)
                                Text("FLOW")
                                    .font(.poppins(.bold, size: 20))
                                    .foregroundColor(AppColors.darkBlue)
                            }
                            .padding(.top, 24)

                            // Illustration
                            Image("undraw_sign-up_qamz")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .padding(.top, 12)

                            // MARK: - Title
                            Text(languageManager.localized("user_signup"))
                                .font(.poppins(.bold, size: 22))
                                .foregroundColor(AppColors.darkBlue)
                                .padding(.top, 24)

                            // MARK: - Text Fields
                            VStack(spacing: 16) {
                                CustomTextField(
                                    placeholder: languageManager.localized("user_name"),
                                    text: $userName
                                )

                                CustomTextField(
                                    placeholder: languageManager.localized("contact_number"),
                                    text: $contactNumber,
                                    keyboardType: .phonePad
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)

                            // MARK: - Terms & Conditions
                            HStack(spacing: 8) {
                                Button {
                                    agreedToTerms.toggle()
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1.5)
                                            .frame(width: 22, height: 22)

                                        if agreedToTerms {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(AppColors.brandBlue)
                                        }
                                    }
                                }

                                Text(languageManager.localized("agree_to"))
                                    .font(.poppins(.regular, size: 13))
                                    .foregroundColor(.gray)

                                Button {
                                    router.navigate(to: .termsConditions)
                                } label: {
                                    Text(languageManager.localized("terms_and_conditions"))
                                        .font(.poppins(.regular, size: 13))
                                        .foregroundColor(AppColors.brandBlue)
                                        .underline()
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 18)

                            // MARK: - Send OTP Button
                            PrimaryButton(title: languageManager.localized("send_otp")) {
                                router.navigate(to: .otpVerification)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 28)
                            .padding(.bottom, 28)
                            .opacity(isFormValid ? 1.0 : 0.6)
                            .disabled(!isFormValid)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 16)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
    }
}

#Preview {
    UserSignUpView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
