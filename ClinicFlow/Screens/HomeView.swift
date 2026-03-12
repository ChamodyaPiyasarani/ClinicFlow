import SwiftUI

struct HomeView: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──
            HomeHeaderView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // ── Current Visit Status ──
                    VisitStatusSection()

                    // ── Clinic Service List ──
                    ClinicServiceSection()
                }
                .padding(.bottom, 20)
            }
        }
        .background(AppColors.background)
    }
}

// MARK: - Header
private struct HomeHeaderView: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        ZStack {
            // Centered title
            AppNameText(fontSize: 22)

            // Trailing icons
            HStack(spacing: 4) {
                Spacer()
                LanguageSwitcher(fontSize: 14, showBackground: false)
                NotificationIcon(unreadCount: 3, iconSize: 22)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Visit Status Section
private struct VisitStatusSection: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    var body: some View {
        VStack(spacing: 14) {
            Text(languageManager.localized("current_visit_status"))
                .font(.poppins(.medium, size: 16))
                .foregroundColor(AppColors.darkBlue)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)

            // Visit status card
            VStack(spacing: 16) {
                // Top info area
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(languageManager.localized("your_visit_status"))
                            .font(.poppins(.regular, size: 13))
                            .foregroundColor(.white.opacity(0.9))
                        Text(languageManager.localized("no_active_visit"))
                            .font(.poppins(.bold, size: 24))
                            .foregroundColor(.white)
                        Text(languageManager.localized("no_active_visit_desc"))
                            .font(.poppins(.regular, size: 13))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.3))
                            .frame(width: 60, height: 60)
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 26, weight: .medium))
                            .foregroundColor(.white)
                    }
                }

                // Buttons area
                VStack(spacing: 10) {
                    Button(action: {
                        router.navigate(to: .opdDepartments)
                    }) {
                        Text(languageManager.localized("start_walk_in_visit"))
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundColor(AppColors.darkBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white)
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text(languageManager.localized("or"))
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.white.opacity(0.95))

                    Button(action: {
                        router.navigate(to: .bookAppointment)
                    }) {
                        Text(languageManager.localized("add_an_appointment"))
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundColor(AppColors.darkBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white)
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.brandBlue,
                                AppColors.gradientBlueStart,
                                AppColors.gradientBlueEnd,
                                AppColors.lightBlue
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: AppColors.brandBlue.opacity(0.3), radius: 12, x: 0, y: 6)
            )
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Clinic Service Section
private struct ClinicServiceSection: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        VStack(spacing: 14) {
            Text(languageManager.localized("clinic_service_list"))
                .font(.poppins(.medium, size: 16))
                .foregroundColor(AppColors.darkBlue)
                .frame(maxWidth: .infinity)

            VStack(spacing: 12) {
                ServiceCard(
                    icon: "plus.circle.fill",
                    iconColor: AppColors.opdBlue,
                    iconBgColor: AppColors.opdBlue.opacity(0.12),
                    titleKey: "service_opd",
                    subtitleKey: "service_opd_desc",
                    borderColor: Color(red: 0x2D/255, green: 0x4A/255, blue: 0x73/255),
                    fillColor: Color(red: 0xE3/255, green: 0xE9/255, blue: 0xFF/255),
                    textColor: AppColors.darkBlue,
                    chevronColor: Color(red: 0x2D/255, green: 0x4A/255, blue: 0x73/255),
                    action: .opdDepartments
                )
                ServiceCard(
                    icon: "flask.fill",
                    iconColor: AppColors.labGreen,
                    iconBgColor: AppColors.labGreen.opacity(0.12),
                    titleKey: "service_lab",
                    subtitleKey: "service_lab_desc",
                    borderColor: Color(red: 0x3D/255, green: 0x77/255, blue: 0x7D/255),
                    fillColor: Color(red: 0xE5/255, green: 0xE7/255, blue: 0xEB/255),
                    textColor: Color(red: 0x3D/255, green: 0x77/255, blue: 0x7D/255),
                    chevronColor: Color(red: 0x3D/255, green: 0x77/255, blue: 0x7D/255),
                    action: .labTests
                )
                ServiceCard(
                    icon: "pills.fill",
                    iconColor: AppColors.pharmacyGreen,
                    iconBgColor: AppColors.pharmacyGreen.opacity(0.12),
                    titleKey: "service_pharmacy",
                    subtitleKey: "service_pharmacy_desc",
                    borderColor: Color(red: 0x35/255, green: 0x84/255, blue: 0x64/255),
                    fillColor: Color(red: 0xF1/255, green: 0xFA/255, blue: 0xF7/255),
                    textColor: Color(red: 0x35/255, green: 0x84/255, blue: 0x64/255),
                    chevronColor: Color(red: 0x35/255, green: 0x84/255, blue: 0x64/255),
                    action: .pharmacy
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Service Card
private struct ServiceCard: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    let icon: String
    let iconColor: Color
    let iconBgColor: Color
    let titleKey: String
    let subtitleKey: String
    let borderColor: Color
    let fillColor: Color
    let textColor: Color
    let chevronColor: Color
    let action: AppRoute?
    
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            if let action = action {
                router.navigate(to: action)
            }
        }) {
            HStack(spacing: 16) {
                // Icon with gradient background
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [
                                    iconBgColor.opacity(1.2),
                                    iconBgColor.opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                // Text
                VStack(alignment: .leading, spacing: 3) {
                    Text(languageManager.localized(titleKey))
                        .font(.poppins(.semiBold, size: 17))
                        .foregroundColor(textColor)
                    Text(languageManager.localized(subtitleKey))
                        .font(.poppins(.regular, size: 14))
                        .foregroundColor(.gray.opacity(0.75))
                }

                Spacer()

                // Chevron
                ZStack {
                    Circle()
                        .fill(chevronColor.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(chevronColor)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(fillColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(borderColor, lineWidth: 1.5)
                    )
                    .shadow(
                        color: iconColor.opacity(isPressed ? 0.12 : 0.08),
                        radius: isPressed ? 6 : 10,
                        x: 0,
                        y: isPressed ? 2 : 4
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.12)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isPressed = false
                    }
                }
        )
    }
}

#Preview {
    HomeView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
