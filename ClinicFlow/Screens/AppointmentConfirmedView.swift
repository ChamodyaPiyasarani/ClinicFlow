import SwiftUI

// MARK: - Main View

struct AppointmentConfirmedView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @Environment(ToastManager.self) var toastManager

    let appointment: Appointment

    @State private var checkmarkScale: CGFloat = 0
    @State private var contentOpacity: Double = 0
    @State private var confettiTrigger = false

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: appointment.date)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    Spacer().frame(height: 30)

                    // ── Success Animation ──
                    ZStack {
                        // Outer glow rings
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .stroke(Color.green.opacity(0.08 - Double(i) * 0.025), lineWidth: 2)
                                .frame(width: CGFloat(100 + i * 30), height: CGFloat(100 + i * 30))
                                .scaleEffect(checkmarkScale)
                        }

                        // Checkmark circle
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 80/255, green: 200/255, blue: 120/255),
                                            Color(red: 50/255, green: 180/255, blue: 100/255)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 88, height: 88)
                                .shadow(color: Color.green.opacity(0.3), radius: 16, x: 0, y: 6)

                            Image(systemName: "checkmark")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(checkmarkScale)
                    }
                    .frame(height: 170)

                    // ── Title ──
                    VStack(spacing: 8) {
                        Text(languageManager.localized("appointment_confirmed"))
                            .font(.poppins(.bold, size: 24))
                            .foregroundColor(AppColors.darkBlue)

                        Text(languageManager.localized("appointment_confirmed_desc"))
                            .font(.poppins(.regular, size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .opacity(contentOpacity)

                    // ── Appointment Details Card ──
                    VStack(spacing: 0) {
                        // Token Number Banner
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(languageManager.localized("token_number"))
                                    .font(.poppins(.medium, size: 13))
                                    .foregroundColor(.white.opacity(0.8))
                                Text(appointment.tokenNumber)
                                    .font(.poppins(.bold, size: 22))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 48, height: 48)
                                Image(systemName: "ticket.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [AppColors.brandBlue, AppColors.darkBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                        // Details
                        VStack(spacing: 16) {
                            ConfirmedDetailRow(
                                icon: "stethoscope",
                                label: languageManager.localized("doctor"),
                                value: appointment.doctorName
                            )
                            ConfirmedDetailRow(
                                icon: "building.2.fill",
                                label: languageManager.localized("department"),
                                value: languageManager.localized(appointment.departmentKey)
                            )
                            ConfirmedDetailRow(
                                icon: "calendar",
                                label: languageManager.localized("date"),
                                value: dateString
                            )
                            ConfirmedDetailRow(
                                icon: "clock.fill",
                                label: languageManager.localized("time"),
                                value: appointment.timeSlot
                            )
                            ConfirmedDetailRow(
                                icon: "creditcard.fill",
                                label: languageManager.localized("consultation_fee"),
                                value: "LKR \(appointment.consultationFee).00"
                            )
                        }
                        .padding(20)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .opacity(contentOpacity)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }

            // ── Bottom Buttons ──
            VStack(spacing: 10) {
                // View Queue Status Button
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    toastManager.show(.info, message: "toast_joining_queue")
                    router.navigate(to: .queueStatus(.appointmentSample))
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "person.line.dotted.person.fill")
                            .font(.system(size: 18))
                        Text(languageManager.localized("view_queue_status"))
                            .font(.poppins(.semiBold, size: 17))
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
                    .cornerRadius(14)
                    .shadow(color: AppColors.brandBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .opacity(contentOpacity)

                // View My Appointment Button
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    router.selectedTab = .appointment
                    router.goToRoot()
                    router.navigate(to: .home)
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "calendar.badge.checkmark")
                            .font(.system(size: 18))
                        Text(languageManager.localized("view_my_appointment"))
                            .font(.poppins(.semiBold, size: 17))
                    }
                    .foregroundColor(AppColors.brandBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(AppColors.brandBlue.opacity(0.3), lineWidth: 1.5)
                    )
                }
                .opacity(contentOpacity)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Color.white
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -4)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .background(AppColors.background)
        .onAppear {
            // Checkmark bounce in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.15)) {
                checkmarkScale = 1.0
            }
            // Content fade in
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                contentOpacity = 1.0
            }
        }
    }
}

// MARK: - Detail Row

private struct ConfirmedDetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
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

// MARK: - Preview

#Preview {
    AppointmentConfirmedView(appointment: Appointment.samples[0])
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
