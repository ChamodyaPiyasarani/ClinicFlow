import SwiftUI

struct SettingsView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // ── Header ──
                ZStack {
                    AppNameText(fontSize: 20)
                    HStack {
                        BackButton { router.goBack() }
                        Spacer()
                        Color.clear.frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 4)

                Text(languageManager.localized("settings"))
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(AppColors.darkBlue)
                    .padding(.bottom, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {

                        // ── Preferences Section ──
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: languageManager.localized("preferences"))

                            // Language Row
                            SettingsCard {
                                HStack(spacing: 14) {
                                    SettingsIconView(icon: "globe", color: AppColors.brandBlue)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(languageManager.localized("language"))
                                            .font(.poppins(.semiBold, size: 15))
                                            .foregroundColor(AppColors.darkBlue)
                                        Text(languageManager.localized("select_preferred_language"))
                                            .font(.poppins(.regular, size: 12))
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    LanguageSwitcher(fontSize: 13, showBackground: true)
                                }
                            }
                        }

                        // ── About Section ──
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: languageManager.localized("about"))

                            // App identity card
                            SettingsCard {
                                HStack(spacing: 16) {
                                    // App icon area
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                LinearGradient(
                                                    colors: [AppColors.brandBlue, AppColors.gradientBlueEnd],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 56, height: 56)
                                            .shadow(color: AppColors.brandBlue.opacity(0.35), radius: 8, x: 0, y: 4)

                                        Image("Clinic_Flow_splach_icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 38, height: 38)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("ClinicFlow")
                                            .font(.poppins(.bold, size: 18))
                                            .foregroundColor(AppColors.darkBlue)
                                        Text(languageManager.localized("smart_clinic_companion"))
                                            .font(.poppins(.regular, size: 12))
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()
                                }
                                .padding(.bottom, 14)

                                Divider()
                                    .padding(.bottom, 14)

                                HStack {
                                    AboutInfoItem(label: languageManager.localized("version"), value: "1.0.0")
                                    Divider()
                                        .frame(height: 30)
                                    AboutInfoItem(label: languageManager.localized("build"), value: "100")
                                    Divider()
                                        .frame(height: 30)
                                    AboutInfoItem(label: languageManager.localized("platform"), value: "iOS")
                                }
                            }

                            // Developer info row
                            SettingsCard {
                                HStack(spacing: 14) {
                                    SettingsIconView(icon: "person.crop.circle.fill", color: Color(red: 0.4, green: 0.3, blue: 0.85))

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(languageManager.localized("developed_by"))
                                            .font(.poppins(.regular, size: 12))
                                            .foregroundColor(.gray)
                                        Text("Mcee")
                                            .font(.poppins(.semiBold, size: 14))
                                            .foregroundColor(AppColors.darkBlue)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.gray.opacity(0.4))
                                }
                            }

                            // Legal row
                            SettingsCard {
                                HStack(spacing: 14) {
                                    SettingsIconView(icon: "doc.text.fill", color: Color(red: 0.18, green: 0.62, blue: 0.45))

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(languageManager.localized("terms_and_conditions"))
                                            .font(.poppins(.semiBold, size: 15))
                                            .foregroundColor(AppColors.darkBlue)
                                        Text(languageManager.localized("privacy_policy_short"))
                                            .font(.poppins(.regular, size: 12))
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.gray.opacity(0.4))
                                }
                            }
                            .onTapGesture {
                                router.navigate(to: .termsConditions)
                            }
                        }
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

// MARK: - Section Header

private struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.poppins(.semiBold, size: 13))
            .foregroundColor(.gray)
            .tracking(0.8)
            .padding(.horizontal, 4)
    }
}

// MARK: - Settings Card Container

private struct SettingsCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Settings Icon View

private struct SettingsIconView: View {
    let icon: String
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.12))
                .frame(width: 44, height: 44)
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
        }
    }
}

// MARK: - About Info Item

private struct AboutInfoItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.poppins(.bold, size: 15))
                .foregroundColor(AppColors.darkBlue)
            Text(label)
                .font(.poppins(.regular, size: 11))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SettingsView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
