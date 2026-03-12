import SwiftUI

struct SettingsView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // ── Header ──
                HStack {
                    BackButton { router.goBack() }
                    Spacer()
                    AppNameText(fontSize: 20)
                    Spacer()
                    // Spacer to balance the back button
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 10)

                // Subtitle
                Text(languageManager.localized("settings"))
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(AppColors.darkBlue)
                    .padding(.bottom, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // ── Language Setting ──
                        SettingsRow(
                            icon: "globe",
                            iconColor: AppColors.brandBlue,
                            title: languageManager.localized("language")
                        ) {
                            LanguageSwitcher(fontSize: 14, showBackground: true)
                        }

                        // ── Notifications Setting ──
                        SettingsRow(
                            icon: "bell.fill",
                            iconColor: .orange,
                            title: languageManager.localized("notifications")
                        ) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray.opacity(0.4))
                        }

                        // ── About Section ──
                        VStack(alignment: .leading, spacing: 12) {
                            Text(languageManager.localized("about"))
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(AppColors.darkBlue)
                                .padding(.top, 8)

                            SettingsInfoRow(label: "App", value: "ClinicFlow")
                            SettingsInfoRow(label: "Version", value: "1.0.0")
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .background(AppColors.background)
            
            BottomNavBar()
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Settings Row

private struct SettingsRow<Trailing: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
            }

            Text(title)
                .font(.poppins(.medium, size: 16))
                .foregroundColor(AppColors.darkBlue)

            Spacer()

            trailing()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Settings Info Row

private struct SettingsInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.poppins(.regular, size: 14))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(AppColors.darkBlue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 1)
    }
}

#Preview {
    SettingsView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
