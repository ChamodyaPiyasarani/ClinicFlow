import SwiftUI

struct HomeView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    @State private var showJoinQueueConfirmation = false
    @State private var pendingQueueStatus: QueueStatus?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // ── Header ──
                HomeHeaderView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // ── Current Visit Status ──
                        VisitStatusSection()
                        
                        // ── Upcoming Appointments ──
                        UpcomingAppointmentSection(onJoinQueue: { status in
                            pendingQueueStatus = status
                            showJoinQueueConfirmation = true
                        })

                        // ── Clinic Service List ──
                        ClinicServiceSection()
                    }
                    .padding(.bottom, 20)
                }
            }
            .background(AppColors.background)
            
            // Join Queue Confirmation Popup
            if showJoinQueueConfirmation, let status = pendingQueueStatus {
                 GlassyConfirmationPopup(
                    isPresented: $showJoinQueueConfirmation,
                    icon: "person.2.fill",
                    iconColors: [AppColors.brandBlue, AppColors.opdBlue],
                    titleKey: "join_now",
                    messageKey: "join_queue_confirmation",
                    confirmLabelKey: "join_now",
                    onConfirm: {
                        router.currentQueueStatus = status
                    }
                )
            }
        }
    }
}

// MARK: - Upcoming Appointment Section
private struct UpcomingAppointmentSection: View {
    @Environment(LanguageManager.self) var languageManager
    let onJoinQueue: (QueueStatus) -> Void
    
    private var nextAppointment: Appointment? {
        Appointment.samples
            .filter { $0.status == .confirmed && $0.date >= Date().addingTimeInterval(-3600*24) }
            .sorted { $0.date < $1.date }
            .first
    }

    var body: some View {
        if let appointment = nextAppointment {
            VStack(alignment: .leading, spacing: 14) {
                Text(languageManager.localized("upcoming_appointments"))
                    .font(.poppins(.medium, size: 16))
                    .foregroundColor(AppColors.darkBlue)
                    .padding(.horizontal, 20)
                
                Button(action: {
                    // Start Join Queue flow
                    let status = QueueStatus(
                        id: appointment.id,
                        queueType: .opd,
                        tokenNumber: appointment.tokenNumber,
                        queuePosition: 8,
                        peopleAhead: 7,
                        estimatedWaitMinutes: 45,
                        checkInTime: "2:00 PM",
                        locationName: "Room - 1st floor (Room No. A01)",
                        locationDetail: "Building A, 1st Floor",
                        steps: [
                            VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: "1:45 PM"),
                            VisitStep(id: "s2", localizationKey: "step_consultation", icon: "stethoscope", status: .inProgress, completedTime: nil)
                        ],
                        isActive: true
                    )
                    onJoinQueue(status)
                }) {
                    HStack(spacing: 16) {
                        ProfessionalAvatarView(size: 48)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appointment.doctorName)
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(AppColors.darkBlue)
                            Text(languageManager.localized(appointment.departmentKey))
                                .font(.poppins(.regular, size: 13))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(appointment.timeSlot)
                                .font(.poppins(.semiBold, size: 15))
                                .foregroundColor(AppColors.brandBlue)
                            
                            HStack(spacing: 4) {
                                Text(languageManager.localized("join_now"))
                                    .font(.poppins(.medium, size: 12))
                                    .foregroundColor(AppColors.brandBlue)
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(AppColors.brandBlue)
                            }
                        }
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppColors.brandBlue.opacity(0.1), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Header
private struct HomeHeaderView: View {
    @Environment(LanguageManager.self) var languageManager
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        return formatter.string(from: Date())
    }
    
    private var greetingKey: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "good_morning" }
        else if hour < 17 { return "good_afternoon" }
        else { return "good_evening" }
    }

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateString)
                    .font(.poppins(.bold, size: 14))
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    Text(languageManager.localized(greetingKey))
                    Text("John")
                }
                .font(.poppins(.bold, size: 24))
                .foregroundColor(AppColors.darkBlue)
            }
            
            Spacer()
            
            NotificationIcon(unreadCount: 3, iconSize: 22, showBackground: true)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}

// MARK: - Visit Status Section
private struct VisitStatusSection: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Walk-In Card
                QuickActionCard(
                    titleKey: "walk_in",
                    subtitleKey: "no_appointment_needed",
                    buttonKey: "select_a_department",
                    icon: "clock.fill",
                    iconBgColor: AppColors.brandBlue.opacity(0.1),
                    iconForegroundColor: AppColors.brandBlue,
                    isDark: false,
                    action: { router.navigate(to: .opdDepartments) }
                )
                
                // Appointment Card
                QuickActionCard(
                    titleKey: "appointment",
                    subtitleKey: "book_an_appointment",
                    buttonKey: "schedule",
                    icon: "calendar.badge.plus",
                    iconBgColor: AppColors.brandBlue.opacity(0.35),
                    iconForegroundColor: .white,
                    isDark: true,
                    action: { router.navigate(to: .bookAppointment) }
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 10)
    }
}

// MARK: - Quick Action Card
private struct QuickActionCard: View {
    @Environment(LanguageManager.self) var languageManager
    let titleKey: String
    let subtitleKey: String
    let buttonKey: String
    let icon: String
    let iconBgColor: Color
    let iconForegroundColor: Color
    let isDark: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // Icon
                ZStack {
                    if isDark {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 44, height: 44)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(iconBgColor)
                            .frame(width: 44, height: 44)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isDark ? .white : iconForegroundColor)
                }
                .padding(.bottom, 24)
                
                Spacer()
                
                // Title
                Text(languageManager.localized(titleKey))
                    .font(.poppins(.bold, size: 18))
                    .foregroundColor(isDark ? .white : AppColors.darkBlue)
                    .padding(.bottom, 4)
                
                // Subtitle
                Text(languageManager.localized(subtitleKey))
                    .font(.poppins(.regular, size: 12))
                    .foregroundColor(isDark ? .white.opacity(0.8) : .gray)
                    .padding(.bottom, 20)
                
                // Action Label
                HStack(spacing: 4) {
                    Text(languageManager.localized(buttonKey))
                        .font(.poppins(.bold, size: 14))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(isDark ? .white : iconForegroundColor)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    if isDark {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 30/255, green: 100/255, blue: 180/255),
                                        Color(red: 20/255, green: 80/255, blue: 150/255)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(AppColors.brandBlue.opacity(0.03))
                            )
                    }
                    
                    // Decorative circle
                    GeometryReader { geo in
                        Circle()
                            .fill(isDark ? Color.white.opacity(0.12) : AppColors.brandBlue.opacity(0.06))
                            .frame(width: 120, height: 120)
                            .offset(x: geo.size.width - 60, y: -30)
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: isDark ? AppColors.brandBlue.opacity(0.15) : Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isDark ? Color.clear : AppColors.brandBlue.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
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
                    iconColor: AppColors.brandBlue,
                    iconBgColor: AppColors.brandBlue.opacity(0.12),
                    titleKey: "service_opd",
                    subtitleKey: "service_opd_desc",
                    borderColor: AppColors.brandBlue.opacity(0.3),
                    fillColor: Color(red: 0xF0/255, green: 0xF5/255, blue: 0xFF/255),
                    textColor: AppColors.darkBlue,
                    chevronColor: AppColors.brandBlue,
                    action: .opdDepartments
                )
                ServiceCard(
                    icon: "flask.fill",
                    iconColor: AppColors.labGreen,
                    iconBgColor: AppColors.labGreen.opacity(0.15),
                    titleKey: "service_lab",
                    subtitleKey: "service_lab_desc",
                    borderColor: AppColors.labGreen.opacity(0.4),
                    fillColor: Color(red: 0xF0/255, green: 0xFD/255, blue: 0xFA/255),
                    textColor: Color(red: 0x13/255, green: 0x4E/255, blue: 0x48/255),
                    chevronColor: AppColors.labGreen,
                    action: .labTests
                )
                ServiceCard(
                    icon: "pills.fill",
                    iconColor: AppColors.pharmacyGreen,
                    iconBgColor: AppColors.pharmacyGreen.opacity(0.15),
                    titleKey: "service_pharmacy",
                    subtitleKey: "service_pharmacy_desc",
                    borderColor: AppColors.pharmacyGreen.opacity(0.4),
                    fillColor: Color(red: 0xF7/255, green: 0xFE/255, blue: 0xFA/255),
                    textColor: Color(red: 0x06/255, green: 0x4E/255, blue: 0x3B/255),
                    chevronColor: AppColors.pharmacyGreen,
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
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    iconBgColor.opacity(0.7),
                                    iconBgColor.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(iconColor.opacity(0.2), lineWidth: 1)
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(iconColor)
                        .shadow(color: iconColor.opacity(0.3), radius: 4, x: 0, y: 2)
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
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(fillColor.opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(borderColor.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(
                        color: Color.black.opacity(0.04),
                        radius: 10,
                        x: 0,
                        y: 4
                    )
                    .shadow(
                        color: iconColor.opacity(0.06),
                        radius: 12,
                        x: 0,
                        y: 6
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
