import SwiftUI

// MARK: - Main View

struct AppointmentDetailView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    let appointment: Appointment

    @State private var showCancelSheet = false
    @State private var headerAppear = false
    @State private var detailsAppear = false
    @State private var actionsAppear = false

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: appointment.date)
    }

    private var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: appointment.date)
    }

    private var departmentColor: Color {
        ClinicDepartment.samples.first { $0.localizationKey == appointment.departmentKey }?.color ?? AppColors.brandBlue
    }

    private var departmentIcon: String {
        ClinicDepartment.samples.first { $0.localizationKey == appointment.departmentKey }?.icon ?? "stethoscope"
    }

    private var isUpcoming: Bool {
        appointment.status == .confirmed || appointment.status == .pending
    }

    private var statusColor: Color {
        appointment.status.color
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Minimal Header ──
            DetailHeaderBar()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // ── Hero Card: Doctor + Status ──
                    heroCard
                        .opacity(headerAppear ? 1 : 0)
                        .offset(y: headerAppear ? 0 : 30)

                    // ── Quick Info Pills ──
                    quickInfoStrip
                        .opacity(headerAppear ? 1 : 0)
                        .offset(y: headerAppear ? 0 : 20)

                    // ── Details Section ──
                    detailsSection
                        .opacity(detailsAppear ? 1 : 0)
                        .offset(y: detailsAppear ? 0 : 20)

                    // ── Fee Card ──
                    feeCard
                        .opacity(detailsAppear ? 1 : 0)
                        .offset(y: detailsAppear ? 0 : 16)

                    // ── Note Banner ──
                    if isUpcoming {
                        noteBanner
                            .opacity(actionsAppear ? 1 : 0)
                            .offset(y: actionsAppear ? 0 : 12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, isUpcoming ? 140 : 40)
            }

            // ── Bottom Action Bar ──
            if isUpcoming {
                bottomActionBar
                    .opacity(actionsAppear ? 1 : 0)
                    .offset(y: actionsAppear ? 0 : 30)
            }
        }
        .background(AppColors.background)
        .onAppear { triggerStaggeredAnimations() }
        .sheet(isPresented: $showCancelSheet) {
            CancelAppointmentSheet(appointment: appointment) {
                showCancelSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.goBack()
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Staggered Animations

    private func triggerStaggeredAnimations() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.05)) {
            headerAppear = true
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.15)) {
            detailsAppear = true
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.25)) {
            actionsAppear = true
        }
    }

    // MARK: - Hero Card

    private var heroCard: some View {
        VStack(spacing: 0) {
            // Top gradient section
            ZStack(alignment: .topTrailing) {
                LinearGradient(
                    colors: [departmentColor, departmentColor.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Decorative circles
                Circle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 120, height: 120)
                    .offset(x: 40, y: -30)
                Circle()
                    .fill(Color.white.opacity(0.04))
                    .frame(width: 80, height: 80)
                    .offset(x: -20, y: 60)

                VStack(spacing: 16) {
                    // Status chip at top
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 7, height: 7)
                            Text(languageManager.localized(appointment.status.localizationKey).uppercased())
                                .font(.poppins(.bold, size: 11))
                                .foregroundColor(.white)
                                .tracking(0.8)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(
                            Capsule().fill(Color.white.opacity(0.2))
                        )
                    }

                    // Doctor info
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 56, height: 56)
                            Image(systemName: departmentIcon)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(appointment.doctorName)
                                .font(.poppins(.bold, size: 19))
                                .foregroundColor(.white)
                            Text(languageManager.localized(appointment.departmentKey))
                                .font(.poppins(.medium, size: 13))
                                .foregroundColor(.white.opacity(0.85))
                        }
                        Spacer()
                    }
                }
                .padding(20)
            }
            .frame(minHeight: 140)

            // Token strip
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "number.square.fill")
                        .font(.system(size: 18))
                        .foregroundColor(departmentColor)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(languageManager.localized("token_number").uppercased())
                            .font(.poppins(.medium, size: 10))
                            .foregroundColor(.gray)
                            .tracking(0.5)
                        Text(appointment.tokenNumber)
                            .font(.poppins(.bold, size: 18))
                            .foregroundColor(AppColors.darkBlue)
                    }
                }
                Spacer()
                Image(systemName: "qrcode")
                    .font(.system(size: 22))
                    .foregroundColor(AppColors.darkBlue.opacity(0.25))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: departmentColor.opacity(0.18), radius: 16, x: 0, y: 8)
    }

    // MARK: - Quick Info Strip

    private var quickInfoStrip: some View {
        HStack(spacing: 10) {
            DetailPill(icon: "calendar", text: shortDateString, color: AppColors.brandBlue)
            DetailPill(icon: "clock.fill", text: appointment.timeSlot, color: .orange)
            DetailPill(icon: "mappin.circle.fill", text: languageManager.localized("department"), color: .purple)
        }
    }

    // MARK: - Details Section

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            HStack {
                Text(languageManager.localized("details").uppercased())
                    .font(.poppins(.bold, size: 12))
                    .foregroundColor(.gray)
                    .tracking(1)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 14)

            // Rows
            DetailRow(
                icon: "calendar",
                iconColor: AppColors.brandBlue,
                label: languageManager.localized("date"),
                value: dateString
            )
            thinDivider
            DetailRow(
                icon: "clock.fill",
                iconColor: .orange,
                label: languageManager.localized("time"),
                value: appointment.timeSlot
            )
            thinDivider
            DetailRow(
                icon: "person.fill",
                iconColor: .purple,
                label: languageManager.localized("patient"),
                value: appointment.patientName
            )
            thinDivider
            DetailRow(
                icon: "phone.fill",
                iconColor: .green,
                label: languageManager.localized("contact"),
                value: appointment.contactNumber
            )

            if !appointment.reasonForVisit.isEmpty {
                thinDivider
                DetailRow(
                    icon: "text.alignleft",
                    iconColor: .teal,
                    label: languageManager.localized("reason"),
                    value: appointment.reasonForVisit
                )
            }

            Spacer().frame(height: 6)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }

    private var thinDivider: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.08))
            .frame(height: 1)
            .padding(.leading, 68)
    }

    // MARK: - Fee Card

    private var feeCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.green.opacity(0.12), Color.green.opacity(0.06)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(languageManager.localized("consultation_fee"))
                    .font(.poppins(.medium, size: 12))
                    .foregroundColor(.gray)
                Text("LKR \(appointment.consultationFee).00")
                    .font(.poppins(.bold, size: 20))
                    .foregroundColor(AppColors.darkBlue)
            }

            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 22))
                .foregroundColor(.green.opacity(0.6))
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }

    // MARK: - Note Banner

    private var noteBanner: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(AppColors.brandBlue.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.brandBlue)
            }
            Text(languageManager.localized("arrive_early_note"))
                .font(.poppins(.regular, size: 13))
                .foregroundColor(AppColors.darkBlue.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.brandBlue.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppColors.brandBlue.opacity(0.1), lineWidth: 1)
                )
        )
    }

    // MARK: - Bottom Action Bar

    private var bottomActionBar: some View {
        VStack(spacing: 10) {
            // Primary: Reschedule
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                router.navigate(to: .rescheduleAppointment(appointment))
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 16, weight: .semibold))
                    Text(languageManager.localized("reschedule"))
                        .font(.poppins(.semiBold, size: 16))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.brandBlue, AppColors.brandBlue.opacity(0.85)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(color: AppColors.brandBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }

            // Secondary: Cancel
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showCancelSheet = true
            } label: {
                Text(languageManager.localized("cancel_appointment"))
                    .font(.poppins(.semiBold, size: 15))
                    .foregroundColor(.red.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.red.opacity(0.2), lineWidth: 1.5)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

// MARK: - Detail Header Bar (Minimal)

private struct DetailHeaderBar: View {
    @Environment(AppRouter.self) var router
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        ZStack {
            HStack {
                BackButton { router.goBack() }
                Spacer()
            }
            AppNameText(fontSize: 20)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Detail Pill

private struct DetailPill: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(color)
            Text(text)
                .font(.poppins(.medium, size: 11))
                .foregroundColor(AppColors.darkBlue)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(color.opacity(0.06))
        )
    }
}

// MARK: - Detail Row

private struct DetailRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.poppins(.regular, size: 11))
                    .foregroundColor(.gray)
                Text(value)
                    .font(.poppins(.medium, size: 15))
                    .foregroundColor(AppColors.darkBlue)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

// MARK: - Cancel Appointment Sheet

private struct CancelAppointmentSheet: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(\.dismiss) var dismiss

    let appointment: Appointment
    let onConfirmCancel: () -> Void

    @State private var selectedReason: String? = nil
    @State private var showConfirmation = false

    private var cancellationReasons: [String] {
        [
            languageManager.localized("cancel_reason_schedule"),
            languageManager.localized("cancel_reason_feeling_better"),
            languageManager.localized("cancel_reason_different_doctor"),
            languageManager.localized("cancel_reason_other"),
        ]
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if showConfirmation {
                    // ── Confirmation State ──
                    cancelledConfirmationView
                } else {
                    // ── Reason Selection ──
                    cancelReasonView
                }
            }
            .background(AppColors.background)
            .navigationTitle(showConfirmation ? "" : languageManager.localized("cancel_appointment"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !showConfirmation {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray.opacity(0.4))
                        }
                    }
                }
            }
        }
    }

    // MARK: - Reason Selection View

    private var cancelReasonView: some View {
        VStack(spacing: 20) {
            // Warning icon
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.08))
                    .frame(width: 64, height: 64)
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.red.opacity(0.8))
            }
            .padding(.top, 8)

            Text(languageManager.localized("cancel_confirm_title"))
                .font(.poppins(.bold, size: 18))
                .foregroundColor(AppColors.darkBlue)
                .multilineTextAlignment(.center)

            Text(languageManager.localized("cancel_confirm_subtitle"))
                .font(.poppins(.regular, size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            // Reason list
            VStack(spacing: 10) {
                Text(languageManager.localized("cancel_select_reason"))
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(AppColors.darkBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)

                ForEach(cancellationReasons, id: \.self) { reason in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedReason = reason
                        }
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .stroke(selectedReason == reason ? Color.red : Color.gray.opacity(0.3), lineWidth: 2)
                                    .frame(width: 22, height: 22)
                                if selectedReason == reason {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 12, height: 12)
                                }
                            }
                            Text(reason)
                                .font(.poppins(.regular, size: 14))
                                .foregroundColor(AppColors.darkBlue)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedReason == reason ? Color.red.opacity(0.04) : Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedReason == reason ? Color.red.opacity(0.2) : Color.gray.opacity(0.1), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 20)
                }
            }

            Spacer()

            // Confirm cancel button
            HStack(spacing: 14) {
                Button(action: { dismiss() }) {
                    Text(languageManager.localized("go_back"))
                        .font(.poppins(.semiBold, size: 15))
                        .foregroundColor(AppColors.darkBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(AppColors.darkBlue.opacity(0.3), lineWidth: 1.5)
                        )
                }

                Button(action: {
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showConfirmation = true
                    }
                }) {
                    Text(languageManager.localized("confirm_cancellation"))
                        .font(.poppins(.semiBold, size: 15))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(selectedReason != nil ? Color.red : Color.red.opacity(0.35))
                        )
                }
                .disabled(selectedReason == nil)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }

    // MARK: - Cancelled Confirmation View

    private var cancelledConfirmationView: some View {
        VStack(spacing: 24) {
            Spacer()

            // Checkmark animation
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.08))
                    .frame(width: 100, height: 100)
                Circle()
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 76, height: 76)
                Image(systemName: "calendar.badge.minus")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.red)
            }

            Text(languageManager.localized("appointment_cancelled"))
                .font(.poppins(.bold, size: 22))
                .foregroundColor(AppColors.darkBlue)

            Text(languageManager.localized("appointment_cancelled_desc"))
                .font(.poppins(.regular, size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            // Appointment summary
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.06))
                        .frame(width: 48, height: 48)
                    Image(systemName: "stethoscope")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(appointment.doctorName)
                        .font(.poppins(.semiBold, size: 15))
                        .foregroundColor(AppColors.darkBlue)
                        .strikethrough(color: .red.opacity(0.5))
                    Text(appointment.timeSlot)
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(languageManager.localized("status_cancelled"))
                    .font(.poppins(.semiBold, size: 12))
                    .foregroundColor(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.red.opacity(0.1)))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            )
            .padding(.horizontal, 20)

            Spacer()

            // Done button
            Button(action: {
                onConfirmCancel()
            }) {
                Text(languageManager.localized("done"))
                    .font(.poppins(.semiBold, size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(AppColors.brandBlue)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Preview

#Preview {
    AppointmentDetailView(appointment: Appointment.samples[0])
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
