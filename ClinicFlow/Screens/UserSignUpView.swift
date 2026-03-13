import SwiftUI

struct UserSignUpView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @Environment(ToastManager.self) var toastManager
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
                    GeometryReader { geometry in
                    ScrollView {
                        // Single white card containing everything
                        VStack(spacing: 0) {
                            // App name
                            AppNameText(fontSize: 20)
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
                                .onChange(of: contactNumber) { _, newValue in
                                    let filtered = newValue.filter { $0.isNumber || $0 == "+" }
                                    if filtered != newValue {
                                        contactNumber = filtered
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)

                            // MARK: - Terms & Conditions
                            HStack(spacing: 6) {
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
                                    .frame(width: 44, height: 44)
                                    .contentShape(Rectangle())
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

                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 18)

                            // MARK: - Send OTP Button
                            PrimaryButton(title: languageManager.localized("send_otp")) {
                                if !isFormValid {
                                    if !agreedToTerms {
                                        toastManager.show(.error, message: "toast_accept_terms")
                                    } else {
                                        toastManager.show(.error, message: "toast_fields_required")
                                    }
                                    return
                                }
                                toastManager.show(.success, message: "toast_otp_sent")
                                router.navigate(to: .otpVerification)
                            }
                            .opacity(isFormValid ? 1.0 : 0.45)
                            .disabled(!isFormValid)
                            .padding(.horizontal, 20)
                            .padding(.top, 28)
                            .padding(.bottom, 28)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 16)
                        .frame(minHeight: geometry.size.height, alignment: .center)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    } // GeometryReader
                }
            }
    }
}

#Preview {
    UserSignUpView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
        .environment(ToastManager.shared)
}
