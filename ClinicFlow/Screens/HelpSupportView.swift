import SwiftUI

struct HelpSupportView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @Binding var selectedTab: BottomTab

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
                            .foregroundColor(.gray)
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

                        // MARK: - Contact Support Title
                        Text(languageManager.localized("contact_support"))
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundColor(AppColors.darkBlue)
                            .padding(.top, 12)

                        // MARK: - Support Cards
                        ContactSupportCard(
                            icon: "phone.fill",
                            iconColor: Color(red: 34/255, green: 139/255, blue: 34/255),
                            bgColor: Color(red: 230/255, green: 255/255, blue: 230/255),
                            title: languageManager.localized("phone_support"),
                            subtitle: languageManager.localized("phone_support_number")
                        )

                        ContactSupportCard(
                            icon: "envelope.fill",
                            iconColor: Color(red: 34/255, green: 139/255, blue: 34/255),
                            bgColor: Color(red: 230/255, green: 255/255, blue: 230/255),
                            title: languageManager.localized("email_support"),
                            subtitle: languageManager.localized("email_support_address")
                        )

                        ContactSupportCard(
                            icon: "bubble.left.and.bubble.right.fill",
                            iconColor: Color(red: 34/255, green: 139/255, blue: 34/255),
                            bgColor: Color(red: 230/255, green: 255/255, blue: 230/255),
                            title: languageManager.localized("live_chat"),
                            subtitle: languageManager.localized("live_chat_subtitle")
                        )

                        // MARK: - Support Hours
                        Text(languageManager.localized("support_hours"))
                            .font(.poppins(.regular, size: 12))
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                            .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 20)
                }

                // MARK: - Bottom Nav Bar
                BottomNavBar(selectedTab: $selectedTab)
            }
        }
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
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            // Icon circle
            ZStack {
                Circle()
                    .fill(bgColor)
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(AppColors.darkBlue)

                Text(subtitle)
                    .font(.poppins(.regular, size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(bgColor.opacity(0.5))
        .cornerRadius(14)
    }
}

#Preview {
    @Previewable @State var tab: BottomTab = .account
    HelpSupportView(selectedTab: $tab)
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
