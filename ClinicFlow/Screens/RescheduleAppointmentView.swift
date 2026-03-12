import SwiftUI

// MARK: - Main View

struct RescheduleAppointmentView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    let appointment: Appointment

    @State private var selectedDate: Date = Date()
    @State private var selectedTimeSlot: TimeSlot? = nil
    @State private var timeSlots: [TimeSlot] = TimeSlot.generateSlots()
    @State private var showConfirmAlert = false
    @State private var showSuccessSheet = false

    // Calendar helpers
    private var currentWeekDates: [Date] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: selectedDate)
        return (-3...3).compactMap { cal.date(byAdding: .day, value: $0, to: today) }
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, yyyy"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // ── Header ──
                RescheduleHeaderView(subtitle: languageManager.localized("reschedule_appointment"))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {

                    // ── Current Appointment Info ──
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.brandBlue.opacity(0.1))
                                .frame(width: 48, height: 48)
                            Image(systemName: "stethoscope")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(AppColors.brandBlue)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(appointment.doctorName)
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(AppColors.darkBlue)
                            Text(languageManager.localized(appointment.departmentKey))
                                .font(.poppins(.regular, size: 13))
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        // Old time badge
                        VStack(spacing: 2) {
                            Text(languageManager.localized("current_slot"))
                                .font(.poppins(.regular, size: 10))
                                .foregroundColor(.gray)
                            Text(appointment.timeSlot)
                                .font(.poppins(.semiBold, size: 13))
                                .foregroundColor(AppColors.brandBlue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(AppColors.brandBlue.opacity(0.1))
                                )
                        }
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )

                    // ── Select New Date ──
                    VStack(alignment: .leading, spacing: 14) {
                        Text(languageManager.localized("select_new_date"))
                            .font(.poppins(.bold, size: 17))
                            .foregroundColor(AppColors.darkBlue)

                        // Month navigator
                        HStack {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate) ?? selectedDate
                                    timeSlots = TimeSlot.generateSlots()
                                    selectedTimeSlot = nil
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(AppColors.darkBlue)
                                    .frame(width: 36, height: 36)
                                    .background(Circle().fill(AppColors.brandBlue.opacity(0.08)))
                            }

                            Spacer()

                            Text(monthYearString)
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(AppColors.darkBlue)

                            Spacer()

                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate) ?? selectedDate
                                    timeSlots = TimeSlot.generateSlots()
                                    selectedTimeSlot = nil
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(AppColors.darkBlue)
                                    .frame(width: 36, height: 36)
                                    .background(Circle().fill(AppColors.brandBlue.opacity(0.08)))
                            }
                        }
                        .padding(.bottom, 4)

                        // Week day strip
                        HStack(spacing: 0) {
                            ForEach(currentWeekDates, id: \.self) { date in
                                let cal = Calendar.current
                                let isSelected = cal.isDate(date, inSameDayAs: selectedDate)
                                let isToday = cal.isDateInToday(date)
                                let dayName = dayAbbreviation(date)
                                let dayNum = cal.component(.day, from: date)

                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedDate = date
                                        timeSlots = TimeSlot.generateSlots()
                                        selectedTimeSlot = nil
                                    }
                                }) {
                                    VStack(spacing: 6) {
                                        Text("\(dayNum)")
                                            .font(.poppins(.bold, size: 16))
                                            .foregroundColor(isSelected ? .white : (isToday ? AppColors.brandBlue : AppColors.darkBlue))
                                        Text(dayName)
                                            .font(.poppins(.medium, size: 11))
                                            .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(isSelected ? AppColors.brandBlue : Color.clear)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.gray.opacity(0.06))
                        )

                        // ── Select New Time ──
                        Text(languageManager.localized("select_new_time"))
                            .font(.poppins(.semiBold, size: 15))
                            .foregroundColor(AppColors.darkBlue)
                            .padding(.top, 8)

                        let columns = [GridItem(.adaptive(minimum: 90), spacing: 10)]
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(timeSlots.filter(\.isAvailable)) { slot in
                                let isSelected = selectedTimeSlot?.id == slot.id
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        selectedTimeSlot = slot
                                    }
                                }) {
                                    Text(slot.time)
                                        .font(.poppins(.medium, size: 13))
                                        .foregroundColor(isSelected ? .white : AppColors.darkBlue)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(isSelected ? AppColors.brandBlue : Color.white)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )

                    // ── Policy Note ──
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.brandBlue)
                        Text(languageManager.localized("reschedule_policy_text"))
                            .font(.poppins(.regular, size: 13))
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(AppColors.brandBlue.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(AppColors.brandBlue.opacity(0.12), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }

            // ── Action Buttons ──
            HStack(spacing: 14) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    router.goBack()
                }) {
                    Text(languageManager.localized("cancel"))
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(AppColors.darkBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(AppColors.darkBlue.opacity(0.3), lineWidth: 1.5)
                        )
                }

                Button(action: {
                    guard selectedTimeSlot != nil else { return }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showConfirmAlert = true
                }) {
                    Text(languageManager.localized("confirm_reschedule"))
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(selectedTimeSlot != nil ? AppColors.brandBlue : AppColors.brandBlue.opacity(0.4))
                        )
                }
                .disabled(selectedTimeSlot == nil)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Color.white
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -4)
                    .ignoresSafeArea(edges: .bottom)
            )
            
            BottomNavBar()
        }
        .background(AppColors.background)
        .onAppear {
            selectedDate = appointment.date
        }
            
            // Confirmation Popup overlay
            if showConfirmAlert {
                confirmationPopup
            }
            
            // Success Card Overlay
            if showSuccessSheet {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 24) {
                    // Success Icon
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.7, blue: 0.4).opacity(0.15))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.4))
                    }
                    .padding(.top, 32)
                    
                    // Success Message
                    VStack(spacing: 8) {
                        Text("Appointment Rescheduled")
                            .font(.poppins(.bold, size: 22))
                            .foregroundColor(Color(red: 0.15, green: 0.45, blue: 0.25))
                            .multilineTextAlignment(.center)
                        
                        Text("Successfully!")
                            .font(.poppins(.semiBold, size: 20))
                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.35))
                            .multilineTextAlignment(.center)
                    }
                    
                    // Appointment Details Card
                    VStack(spacing: 18) {
                        // Token Number
                        VStack(spacing: 4) {
                            Text("Token \(appointment.tokenNumber)")
                                .font(.poppins(.bold, size: 26))
                                .foregroundColor(Color(red: 0.15, green: 0.45, blue: 0.25))
                        }
                        
                        // Doctor Info
                        VStack(spacing: 2) {
                            Text(appointment.doctorName)
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(Color(red: 0.2, green: 0.35, blue: 0.25))
                            Text(languageManager.localized(appointment.departmentKey))
                                .font(.poppins(.regular, size: 14))
                                .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.4))
                        }
                        
                        Divider()
                            .background(Color(red: 0.2, green: 0.7, blue: 0.4).opacity(0.2))
                            .padding(.horizontal, 20)
                        
                        // Date & Time
                        VStack(spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.35))
                                Text("Date:")
                                    .font(.poppins(.medium, size: 14))
                                    .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.4))
                                Text(formattedAppointmentDate(selectedDate))
                                    .font(.poppins(.semiBold, size: 14))
                                    .foregroundColor(Color(red: 0.15, green: 0.45, blue: 0.25))
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.35))
                                Text("Time:")
                                    .font(.poppins(.medium, size: 14))
                                    .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.4))
                                Text(selectedTimeSlot?.time ?? "")
                                    .font(.poppins(.semiBold, size: 14))
                                    .foregroundColor(Color(red: 0.15, green: 0.45, blue: 0.25))
                            }
                        }
                        
                        // Reminder Text
                        Text("You will receive a reminder before your appointment.")
                            .font(.poppins(.regular, size: 12))
                            .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.96, green: 0.99, blue: 0.97))
                    )
                    .padding(.horizontal, 24)
                    
                    // Action Button
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        showSuccessSheet = false
                        router.goBack() // Pop to detail
                        router.goBack() // Pop to appointments list
                    }) {
                        Text("View Appointments")
                            .font(.poppins(.semiBold, size: 17))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.2, green: 0.7, blue: 0.4),
                                                Color(red: 0.15, green: 0.6, blue: 0.35)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: Color(red: 0.2, green: 0.7, blue: 0.4).opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                .background(
                    ZStack {
                        // White glassy base
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .fill(Color.white.opacity(0.85))
                            .background(
                                RoundedRectangle(cornerRadius: 32, style: .continuous)
                                    .fill(.regularMaterial)
                            )
                        
                        // Light edge highlight (top-left)
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    }
                )
                .overlay(
                    // Outer border for definition
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 15)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 32)
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(100)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
    
    private func formattedAppointmentDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }

    private func dayAbbreviation(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
    
    // MARK: - Confirmation Popup (Glassy Style)
    
    private var confirmationPopup: some View {
        ZStack {
            // Dimmed translucent background without heavy blur
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        showConfirmAlert = false
                    }
                }
            
            // Glassy Popup Card
            VStack(spacing: 0) {
                // Content Container
                VStack(spacing: 28) {
                    // Icon with glass effect
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(AppColors.brandBlue.opacity(0.15))
                            .frame(width: 72, height: 72)
                            .blur(radius: 8)
                        
                        // Glass circle
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 64, height: 64)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.8),
                                                Color.white.opacity(0.2)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: AppColors.brandBlue.opacity(0.2), radius: 12, x: 0, y: 4)
                        
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        AppColors.brandBlue,
                                        Color(red: 0.15, green: 0.35, blue: 0.75)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .padding(.top, 36)
                    
                    // Text content
                    VStack(spacing: 10) {
                        Text(languageManager.localized("confirm_reschedule"))
                            .font(.poppins(.semiBold, size: 17))
                            .foregroundColor(AppColors.darkBlue)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                        Text(languageManager.localized("reschedule_confirm_message"))
                            .font(.poppins(.regular, size: 13))
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    
                    // Buttons with glass effect
                    VStack(spacing: 12) {
                        // Confirm action
                        Button(action: {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                showConfirmAlert = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation {
                                    showSuccessSheet = true
                                }
                            }
                        }) {
                            Text(languageManager.localized("confirm"))
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        LinearGradient(
                                            colors: [
                                                AppColors.brandBlue,
                                                Color(red: 0.15, green: 0.35, blue: 0.75)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.3),
                                                Color.clear
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .center
                                        )
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: AppColors.brandBlue.opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        
                        // Go Back action
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                showConfirmAlert = false
                            }
                        }) {
                            Text(languageManager.localized("cancel"))
                                .font(.poppins(.medium, size: 16))
                                .foregroundColor(AppColors.darkBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.6),
                                                    Color.gray.opacity(0.2)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
            .background(
                ZStack {
                    // White glassy base
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.85))
                        .background(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .fill(.regularMaterial)
                        )
                    
                    // Light edge highlight (top-left)
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color.white.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .overlay(
                // Outer border for definition
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 15)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 28)
            .scaleEffect(showConfirmAlert ? 1 : 0.9)
            .opacity(showConfirmAlert ? 1 : 0)
        }
        .transition(.opacity)
        .zIndex(200)
    }
}

// MARK: - Reschedule Header

private struct RescheduleHeaderView: View {
    @Environment(AppRouter.self) var router
    let subtitle: String

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                HStack {
                    BackButton { router.goBack() }
                    Spacer()
                }
                AppNameText(fontSize: 20)
                HStack(spacing: 4) {
                    Spacer()
                    NotificationIcon(unreadCount: 3, iconSize: 22, showBackground: false)
                }
            }
            Text(subtitle)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(AppColors.darkBlue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(AppColors.background)
    }
}

// MARK: - Preview

#Preview {
    RescheduleAppointmentView(appointment: Appointment.samples[0])
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
