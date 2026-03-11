import SwiftUI

struct HelpSupportView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    /// Tracks which FAQ items are expanded
    @State private var expandedItems: Set<Int> = []

    /// FAQ data: pairs of (question key, answer key)
    private let faqItems: [(question: String, answer: String)] = [
        ("faq_q1", "faq_a1"),
        ("faq_q2", "faq_a2"),
        ("faq_q3", "faq_a3"),
        ("faq_q4", "faq_a4"),
    ]

    var body: some View {
        ZStack {
            // Background
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    // Back button (left)
                    HStack {
                        BackButton {
                            router.goBack()
                        }
                        Spacer()
                    }

                    // App name & subtitle (center)
                    VStack(spacing: 4) {
                        AppNameText(fontSize: 20)

                        Text(languageManager.localized("faq_title"))
                            .font(.poppins(.medium, size: 13))
                            .foregroundColor(AppColors.darkBlue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)

                // MARK: - Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // MARK: - FAQ Cards
                        ForEach(Array(faqItems.enumerated()), id: \.offset) { index, item in
                            FAQCard(
                                question: languageManager.localized(item.question),
                                answer: languageManager.localized(item.answer),
                                isExpanded: expandedItems.contains(index)
                            ) {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    if expandedItems.contains(index) {
                                        expandedItems.remove(index)
                                    } else {
                                        expandedItems.insert(index)
                                    }
                                }
                            }
                        }

                        // MARK: - Contact Support Card
                        VStack(spacing: 12) {
                            // Contact Support Title
                            Text(languageManager.localized("contact_support"))
                                .font(.poppins(.semiBold, size: 18))
                                .foregroundColor(AppColors.darkBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 4)

                            // Support Cards
                            ContactSupportCard(
                                icon: "phone.fill",
                                iconColor: Color(hex: "2D4A73"),
                                bgColor: Color(hex: "EFF6FF"),
                                strokeColor: Color(hex: "BFDBFE"),
                                title: languageManager.localized("phone_support"),
                                subtitle: languageManager.localized("phone_support_number")
                            )

                            ContactSupportCard(
                                icon: "envelope.fill",
                                iconColor: Color(hex: "16A34A"),
                                bgColor: Color(hex: "F0FDF4"),
                                strokeColor: Color(hex: "BBF7D0"),
                                title: languageManager.localized("email_support"),
                                subtitle: languageManager.localized("email_support_address")
                            )

                            ContactSupportCard(
                                icon: "bubble.left.and.bubble.right.fill",
                                iconColor: Color(hex: "9333EA"),
                                bgColor: Color(hex: "FAF5FF"),
                                strokeColor: Color(hex: "E9D5FF"),
                                title: languageManager.localized("live_chat"),
                                subtitle: languageManager.localized("live_chat_subtitle")
                            )
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                        // MARK: - Support Hours
                        Text(languageManager.localized("support_hours"))
                            .font(.poppins(.regular, size: 12))
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                            .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }

                // MARK: - Bottom Nav Bar
                BottomNavBar()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - FAQ Expandable Card
private struct FAQCard: View {
    let question: String
    let answer: String
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Question row
            Button(action: onTap) {
                HStack {
                    Text(question)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(AppColors.darkBlue)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.darkBlue)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }
            .buttonStyle(PlainButtonStyle())

            // Answer (shown when expanded)
            if isExpanded {
                Divider()
                    .padding(.horizontal, 18)

                Text(answer)
                    .font(.poppins(.regular, size: 13))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
            }
        }
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Contact Support Card
private struct ContactSupportCard: View {
    let icon: String
    let iconColor: Color
    let bgColor: Color
    let strokeColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            // Icon circle
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 52, height: 52)

                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.poppins(.semiBold, size: 16))
                    .foregroundColor(AppColors.darkBlue)

                Text(subtitle)
                    .font(.poppins(.regular, size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(bgColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(strokeColor, lineWidth: 1.5)
        )
    }
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    HelpSupportView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
