import SwiftUI

// MARK: - Main View

struct AppointmentDetailView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    let appointment: Appointment

    @State private var showCancelSheet = false
    @State private var cardAppear = false

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
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

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──
            DetailHeaderView(subtitle: languageManager.localized("appointment_details"))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // ── Doctor Card ──
                    VStack(spacing: 0) {
                        // Gradient top section
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                Image(systemName: "stethoscope")
                                    .font(.system(size: 26, weight: .medium))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(appointment.doctorName)
                                    .font(.poppins(.bold, size: 18))
                                    .foregroundColor(.white)
                                Text(languageManager.localized(appointment.departmentKey))
                                    .font(.poppins(.medium, size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }

                            Spacer()

                            // Status badge
                            Text(languageManager.localized(appointment.status.localizationKey))
                                .font(.poppins(.semiBold, size: 12))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.2))
                                )
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [departmentColor, departmentColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                        // Token number strip
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: "ticket.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.brandBlue)
                                Text(languageManager.localized("token_number"))
                                    .font(.poppins(.medium, size: 13))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(appointment.tokenNumber)
                                .font(.poppins(.bold, size: 16))
                                .foregroundColor(AppColors.darkBlue)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color.white)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
                    .opacity(cardAppear ? 1 : 0)
                    .offset(y: cardAppear ? 0 : 20)

                    // ── Appointment Details Card ──
                    VStack(alignment: .leading, spacing: 18) {
                        Text(languageManager.localized("details"))
                            .font(.poppins(.bold, size: 17))
                            .foregroundColor(AppColors.darkBlue)

                        DetailInfoRow(icon: "calendar", label: languageManager.localized("date"), value: dateString)
                        DetailInfoRow(icon: "clock.fill", label: languageManager.localized("time"), value: appointment.timeSlot)
                        DetailInfoRow(icon: "person.fill", label: languageManager.localized("patient"), value: appointment.patientName)
                        DetailInfoRow(icon: "phone.fill", label: languageManager.localized("contact"), value: appointment.contactNumber)

                        if !appointment.reasonForVisit.isEmpty {
                            DetailInfoRow(icon: "text.alignleft", label: languageManager.localized("reason"), value: appointment.reasonForVisit)
                        }

                        // Divider
                        Rectangle()
                            .fill(Color.gray.opacity(0.08))
                            .frame(height: 1)

                        // Fee row
                        HStack {
                            HStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.green.opacity(0.08))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "creditcard.fill")
                                        .font(.system(size: 15))
                                        .foregroundColor(.green)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(languageManager.localized("consultation_fee"))
                                        .font(.poppins(.regular, size: 12))
                                        .foregroundColor(.gray)
                                    Text("LKR \(appointment.consultationFee).00")
                                        .font(.poppins(.bold, size: 17))
                                        .foregroundColor(AppColors.darkBlue)
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                    .opacity(cardAppear ? 1 : 0)
                    .offset(y: cardAppear ? 0 : 16)

                    // ── Important Note ──
                    if isUpcoming {
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(AppColors.brandBlue)
                            Text(languageManager.localized("arrive_early_note"))
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
                        .opacity(cardAppear ? 1 : 0)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, isUpcoming ? 120 : 40)
            }

            // ── Action Buttons (only for upcoming) ──
            if isUpcoming {
                VStack(spacing: 12) {
                    HStack(spacing: 14) {
                        // Cancel button
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            showCancelSheet = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 16, weight: .medium))
                                Text(languageManager.localized("cancel_appointment"))
                                    .font(.poppins(.semiBold, size: 15))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.red.opacity(0.06))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.red.opacity(0.2), lineWidth: 1.5)
                                    )
                            )
                        }

                        // Reschedule button
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            router.navigate(to: .rescheduleAppointment(appointment))
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 16, weight: .medium))
                                Text(languageManager.localized("reschedule"))
                                    .font(.poppins(.semiBold, size: 15))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(AppColors.brandBlue)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -4)
                        .ignoresSafeArea(edges: .bottom)
                )
            }

            // ── Bottom Nav Bar ──
            BottomNavBar()
        }
        .background(AppColors.background)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                cardAppear = true
            }
        }
        .sheet(isPresented: $showCancelSheet) {
            CancelAppointmentSheet(appointment: appointment) {
                // On confirm cancel — go back to appointment list
                showCancelSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.goBack()
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Detail Header

private struct DetailHeaderView: View {
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
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(Color.white)
    }
}

// MARK: - Detail Info Row

private struct DetailInfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColors.brandBlue.opacity(0.08))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.brandBlue)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.poppins(.regular, size: 12))
                    .foregroundColor(.gray)
                Text(value)
                    .font(.poppins(.medium, size: 15))
                    .foregroundColor(AppColors.darkBlue)
            }

            Spacer()
        }
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
