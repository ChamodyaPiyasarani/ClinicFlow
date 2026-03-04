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
    @Environment(AppRouter.self) var router

    var body: some View {
        ZStack {
            // Centered title
            AppNameText(fontSize: 20)

            // Trailing notification bell
            HStack {
                Spacer()
                Button(action: {
                    router.navigate(to: .notifications)
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.darkBlue)
                        Circle()
                            .fill(Color.red)
                            .frame(width: 9, height: 9)
                            .offset(x: 2, y: -2)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(Color.white)
    }
}

// MARK: - Visit Status Section
private struct VisitStatusSection: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        VStack(spacing: 12) {
            Text(languageManager.localized("current_visit_status"))
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.gray)

            // Visit status card
            VStack(spacing: 16) {
                // Top info area
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(languageManager.localized("your_visit_status"))
                            .font(.poppins(.regular, size: 13))
                            .foregroundColor(.white.opacity(0.9))
                        Text(languageManager.localized("no_active_visit"))
                            .font(.poppins(.bold, size: 22))
                            .foregroundColor(.white)
                        Text(languageManager.localized("no_active_visit_desc"))
                            .font(.poppins(.regular, size: 12))
                            .foregroundColor(.white.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 28))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 4)
                }

                // Buttons area
                VStack(spacing: 10) {
                    Button(action: {}) {
                        Text(languageManager.localized("start_walk_in_visit"))
                            .font(.poppins(.semiBold, size: 15))
                            .foregroundColor(AppColors.darkBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(12)
                    }

                    Text(languageManager.localized("or"))
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(.white.opacity(0.8))

                    Button(action: {}) {
                        Text(languageManager.localized("add_an_appointment"))
                            .font(.poppins(.semiBold, size: 15))
                            .foregroundColor(AppColors.darkBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [AppColors.brandBlue, AppColors.lightBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Clinic Service Section
private struct ClinicServiceSection: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        VStack(spacing: 12) {
            Text(languageManager.localized("clinic_service_list"))
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.gray)

            VStack(spacing: 12) {
                ServiceCard(
                    icon: "cross.case.fill",
                    iconColor: AppColors.brandBlue,
                    iconBgColor: AppColors.brandBlue.opacity(0.15),
                    titleKey: "service_opd",
                    subtitleKey: "service_opd_desc",
                    action: .opdDepartments
                )
                ServiceCard(
                    icon: "flask.fill",
                    iconColor: Color(red: 80/255, green: 170/255, blue: 100/255),
                    iconBgColor: Color(red: 80/255, green: 170/255, blue: 100/255).opacity(0.15),
                    titleKey: "service_lab",
                    subtitleKey: "service_lab_desc",
                    action: .labTests
                )
                ServiceCard(
                    icon: "pills.fill",
                    iconColor: Color(red: 50/255, green: 160/255, blue: 140/255),
                    iconBgColor: Color(red: 50/255, green: 160/255, blue: 140/255).opacity(0.15),
                    titleKey: "service_pharmacy",
                    subtitleKey: "service_pharmacy_desc",
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
            HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconBgColor)
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(languageManager.localized(titleKey))
                    .font(.poppins(.semiBold, size: 15))
                    .foregroundColor(AppColors.darkBlue)
                Text(languageManager.localized(subtitleKey))
                    .font(.poppins(.regular, size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

                // Chevron
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 32, height: 32)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(
                color: .black.opacity(isPressed ? 0.08 : 0.04),
                radius: isPressed ? 4 : 6,
                x: 0,
                y: isPressed ? 1 : 2
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

#Preview {
    HomeView()
        .environment(LanguageManager.shared)
}
