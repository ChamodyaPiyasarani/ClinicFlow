import SwiftUI

struct TermsConditionsView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

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

                // MARK: - Logo & App Name
                VStack(spacing: 8) {
                    Image("ClinicFlowLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)

                    AppNameText(fontSize: 20)
                }
                .padding(.top, 8)

                // MARK: - Scrollable Terms Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Section 1
                        TermsSectionCard(
                            title: languageManager.localized("terms_section_1_title"),
                            paragraphs: [
                                languageManager.localized("terms_section_1_p1"),
                                languageManager.localized("terms_section_1_p2")
                            ]
                        )

                        // Section 2
                        TermsSectionCard(
                            title: languageManager.localized("terms_section_2_title"),
                            paragraphs: [
                                languageManager.localized("terms_section_2_p1"),
                                languageManager.localized("terms_section_2_p2")
                            ]
                        )

                        // Section 3
                        TermsSectionCard(
                            title: languageManager.localized("terms_section_3_title"),
                            paragraphs: [
                                languageManager.localized("terms_section_3_p1"),
                                languageManager.localized("terms_section_3_p2")
                            ]
                        )

                        // Section 4
                        TermsSectionCard(
                            title: languageManager.localized("terms_section_4_title"),
                            bulletPoints: [
                                languageManager.localized("terms_section_4_b1"),
                                languageManager.localized("terms_section_4_b2"),
                                languageManager.localized("terms_section_4_b3")
                            ]
                        )

                        // Section 5
                        TermsSectionCard(
                            title: languageManager.localized("terms_section_5_title"),
                            paragraphs: [
                                languageManager.localized("terms_section_5_p1"),
                                languageManager.localized("terms_section_5_p2")
                            ]
                        )

                        // Section 6
                        TermsSectionCard(
                            title: languageManager.localized("terms_section_6_title"),
                            paragraphs: [
                                languageManager.localized("terms_section_6_p1"),
                                languageManager.localized("terms_section_6_p2")
                            ]
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

// MARK: - Terms Section Card Component
/// Reusable card for displaying a terms section with a title and body content.
struct TermsSectionCard: View {
    let title: String
    var paragraphs: [String] = []
    var bulletPoints: [String] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.poppins(.bold, size: 17))
                .foregroundColor(AppColors.darkBlue)

            ForEach(paragraphs, id: \.self) { paragraph in
                Text(paragraph)
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }

            ForEach(bulletPoints, id: \.self) { point in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(AppColors.brandBlue)
                        .frame(width: 6, height: 6)
                        .padding(.top, 7)

                    Text(point)
                        .font(.poppins(.regular, size: 14))
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    TermsConditionsView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
