import SwiftUI

// MARK: - Main View

struct AppointmentsView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    @State private var selectedSegment: Int = 0
    @State private var appointments: [Appointment] = Appointment.samples
    @State private var appearAnimation = false
    
    @State private var showJoinQueueConfirmation = false
    @State private var pendingQueueStatus: QueueStatus? = nil

    private var upcomingAppointments: [Appointment] {
        appointments.filter { $0.status == .confirmed || $0.status == .pending }
            .sorted { $0.date < $1.date }
    }

    private var pastAppointments: [Appointment] {
        appointments.filter { $0.status == .completed || $0.status == .cancelled }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──
            AppointmentsHeaderView()

            // ── Add Appointment Button ──
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                router.navigate(to: .bookAppointment)
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                    Text(languageManager.localized("add_an_appointment"))
                        .font(.poppins(.semiBold, size: 16))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [AppColors.brandBlue, AppColors.darkBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: AppColors.brandBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)

            // ── Segment Tabs ──
            SegmentTabBar(
                selectedSegment: $selectedSegment,
                tabs: [
                    languageManager.localized("apt_upcoming"),
                    languageManager.localized("apt_past")
                ]
            )
            .padding(.horizontal, 20)

            // ── Divider ──
            Rectangle()
                .fill(Color.gray.opacity(0.12))
                .frame(height: 1)
                .padding(.top, 8)

            // ── Appointment List ──
            ScrollView(showsIndicators: false) {
                let items = selectedSegment == 0 ? upcomingAppointments : pastAppointments
                if items.isEmpty {
                    EmptyAppointmentsPlaceholder(isUpcoming: selectedSegment == 0)
                        .padding(.top, 60)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, appointment in
                            AppointmentCard(
                                appointment: appointment,
                                isUpcoming: selectedSegment == 0,
                                onJoinQueue: { queueStatus in
                                    pendingQueueStatus = queueStatus
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        showJoinQueueConfirmation = true
                                    }
                                }
                            )
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 20)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.08),
                                value: appearAnimation
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(AppColors.background)
        .overlay {
            if showJoinQueueConfirmation, let queueStatus = pendingQueueStatus {
                GlassyConfirmationPopup(
                    isPresented: $showJoinQueueConfirmation,
                    icon: "person.line.dotted.person.fill",
                    iconColors: [AppColors.brandBlue, AppColors.darkBlue],
                    titleKey: "join_queue_title",
                    messageKey: "join_queue_confirmation",
                    confirmLabelKey: "join_now",
                    onConfirm: {
                        router.currentQueueStatus = queueStatus
                        router.selectedTab = .home
                    }
                )
            }
        }
        .onAppear {
            withAnimation { appearAnimation = true }
        }
        .onChange(of: selectedSegment) { _, _ in
            appearAnimation = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation { appearAnimation = true }
            }
        }
    }
}

// MARK: - Header

private struct AppointmentsHeaderView: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                AppNameText(fontSize: 20)

                HStack {
                    Spacer()
                    NotificationIcon(unreadCount: 3, iconSize: 22)
                }
            }

            Text(languageManager.localized("appointments_title"))
                .font(.poppins(.medium, size: 14))
                .foregroundColor(AppColors.darkBlue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

// MARK: - Segment Tab Bar

private struct SegmentTabBar: View {
    @Binding var selectedSegment: Int
    let tabs: [String]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, title in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedSegment = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.poppins(.semiBold, size: 15))
                            .foregroundColor(selectedSegment == index ? AppColors.darkBlue : .gray.opacity(0.6))

                        Rectangle()
                            .fill(selectedSegment == index ? AppColors.brandBlue : Color.clear)
                            .frame(height: 3)
                            .cornerRadius(1.5)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Appointment Card

private struct AppointmentCard: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    let appointment: Appointment
    let isUpcoming: Bool
    let onJoinQueue: (QueueStatus) -> Void
    @State private var isPressed = false

    private var dateString: String {
        let cal = Calendar.current
        if cal.isDateInToday(appointment.date) {
            return "\(languageManager.localized("apt_today")), \(appointment.timeSlot)"
        } else if cal.isDateInTomorrow(appointment.date) {
            return "\(languageManager.localized("apt_tomorrow")), \(appointment.timeSlot)"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return "\(formatter.string(from: appointment.date)), \(appointment.timeSlot)"
        }
    }

    var body: some View {
        cardContent
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if isUpcoming {
                    if appointment.status == .confirmed {
                        let queueStatus = QueueStatus(
                            id: "Q-\(appointment.id)",
                            queueType: .appointment,
                            tokenNumber: appointment.tokenNumber,
                            queuePosition: 5,
                            peopleAhead: 4,
                            estimatedWaitMinutes: 25,
                            checkInTime: appointment.timeSlot,
                            locationName: "Room - 1st floor (Room No. A01)",
                            locationDetail: "Building A, 1st Floor",
                            steps: [
                                VisitStep(id: "s1", localizationKey: "step_registration", icon: "pencil.and.list.clipboard", status: .completed, completedTime: nil),
                                VisitStep(id: "s2", localizationKey: "step_consultation", icon: "stethoscope", status: .inProgress, completedTime: nil),
                            ],
                            isActive: true
                        )
                        onJoinQueue(queueStatus)
                    } else {
                        router.navigate(to: .appointmentDetail(appointment))
                    }
                } else {
                    router.navigate(to: .pastAppointmentDetail(appointment))
                }
            }
    }
    
    private var cardContent: some View {
        HStack(spacing: 16) {
            // Avatar / Icon
            ProfessionalAvatarView(
                systemIcon: "person.fill",
                size: 52,
                gradientColors: appointment.status == .cancelled 
                    ? [Color.gray.opacity(0.4), Color.gray.opacity(0.2)]
                    : [AppColors.brandBlue, AppColors.brandBlue.opacity(0.6)]
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.doctorName)
                    .font(.poppins(.semiBold, size: 17))
                    .foregroundColor(appointment.status == .cancelled ? .gray : AppColors.darkBlue)

                Text(appointment.specialization)
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.gray)

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                    Text(dateString)
                        .font(.poppins(.medium, size: 13))
                }
                .foregroundColor(appointment.status == .cancelled ? .gray.opacity(0.6) : AppColors.brandBlue.opacity(0.8))
                .padding(.top, 2)

                // Status badge
                Text(languageManager.localized(appointment.status.localizationKey))
                    .font(.poppins(.semiBold, size: 11))
                    .foregroundColor(appointment.status.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(appointment.status.color.opacity(0.12))
                    )
                    .padding(.top, 4)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.gray.opacity(0.3))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(appointment.status == .cancelled ? 0.02 : 0.06), radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(appointment.status == .pending ? AppColors.brandBlue.opacity(0.15) : Color.clear, lineWidth: 1.5)
        )
        .opacity(appointment.status == .cancelled ? 0.8 : 1.0)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Empty State

private struct EmptyAppointmentsPlaceholder: View {
    @Environment(LanguageManager.self) var languageManager
    let isUpcoming: Bool

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.brandBlue.opacity(0.08))
                    .frame(width: 80, height: 80)
                Image(systemName: isUpcoming ? "calendar.badge.plus" : "clock.arrow.circlepath")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(AppColors.brandBlue.opacity(0.5))
            }

            Text(languageManager.localized(isUpcoming ? "no_upcoming_appointments" : "no_past_appointments"))
                .font(.poppins(.medium, size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    AppointmentsView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
