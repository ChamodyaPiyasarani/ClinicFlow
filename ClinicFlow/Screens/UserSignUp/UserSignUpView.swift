//
//  UserSignUpView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import SwiftUI

struct UserSignUpView: View {
    @Environment(LanguageManager.self) var languageManager
    @State private var userName: String = ""
    @State private var contactNumber: String = ""
    @State private var agreedToTerms: Bool = false
    @State private var goBack: Bool = false

    var body: some View {
        if goBack {
            LanguageSelectionView()
                .environment(languageManager)
        } else {
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
                            withAnimation {
                                goBack = true
                            }
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
                            Text("User SignUp")
                                .font(.poppins(.bold, size: 22))
                                .foregroundColor(AppColors.darkBlue)
                                .padding(.top, 24)

                            // MARK: - Text Fields
                            VStack(spacing: 16) {
                                CustomTextField(
                                    placeholder: "User Name",
                                    text: $userName
                                )

                                CustomTextField(
                                    placeholder: "Contact Number",
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

                                Text("Agree to ")
                                    .font(.poppins(.regular, size: 13))
                                    .foregroundColor(.gray)
                                +
                                Text("terms and conditions")
                                    .font(.poppins(.regular, size: 13))
                                    .foregroundColor(AppColors.brandBlue)
                                    .underline()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 18)

                            // MARK: - Send OTP Button
                            PrimaryButton(title: "Send OTP") {
                                // TODO: Handle send OTP action
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 28)
                            .padding(.bottom, 28)
                            .opacity(agreedToTerms ? 1.0 : 0.6)
                            .disabled(!agreedToTerms)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 28)
                        .padding(.top, 16)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
}

#Preview {
    UserSignUpView()
        .environment(LanguageManager.shared)
}
