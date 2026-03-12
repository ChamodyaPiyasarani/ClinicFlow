import SwiftUI

struct OTPVerificationView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @State private var otpCode: String = ""
    @State private var resendTimer: Int = 30
    @State private var canResend: Bool = false
    @State private var timer: Timer?

    private let otpLength = 4

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
                    // Single white card
                    VStack(spacing: 0) {
                        // App name
                        AppNameText(fontSize: 20)
                            .padding(.top, 24)

                        // Illustration
                        Image("undraw_medicine")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .padding(.top, 12)

                        // MARK: - Title
                        Text(languageManager.localized("otp_verification"))
                            .font(.poppins(.bold, size: 22))
                            .foregroundColor(AppColors.darkBlue)
                            .padding(.top, 24)

                        // MARK: - Subtitle
                        Text(languageManager.localized("otp_subtitle"))
                            .font(.poppins(.regular, size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)

                        // MARK: - OTP Input
                        OTPTextField(length: otpLength, code: $otpCode)
                            .padding(.top, 28)

                        // MARK: - Resend Timer / Button
                        HStack(spacing: 4) {
                            Text(languageManager.localized("didnt_receive_code"))
                                .font(.poppins(.regular, size: 13))
                                .foregroundColor(.gray)

                            if canResend {
                                Button {
                                    resendOTP()
                                } label: {
                                    Text(languageManager.localized("resend"))
                                        .font(.poppins(.semiBold, size: 13))
                                        .foregroundColor(AppColors.brandBlue)
                                }
                            } else {
                                Text("\(resendTimer)s")
                                    .font(.poppins(.semiBold, size: 13))
                                    .foregroundColor(AppColors.brandBlue)
                            }
                        }
                        .padding(.top, 16)

                        // MARK: - Verify Button
                        PrimaryButton(title: languageManager.localized("verify_otp")) {
                            router.navigate(to: .locationPermission)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 28)
                        .padding(.bottom, 28)
                        .opacity(otpCode.count == otpLength ? 1.0 : 0.6)
                        .disabled(otpCode.count != otpLength)
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
        .onAppear {
            startResendTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    // MARK: - Timer Logic
    private func startResendTimer() {
        resendTimer = 30
        canResend = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if resendTimer > 1 {
                resendTimer -= 1
            } else {
                canResend = true
                timer?.invalidate()
            }
        }
    }

    private func resendOTP() {
        // TODO: Trigger OTP resend
        startResendTimer()
    }
}

#Preview {
    OTPVerificationView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
