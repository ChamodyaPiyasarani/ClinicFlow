import SwiftUI

// MARK: - Main View

struct AppointmentReviewView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    let doctor: Doctor
    let department: ClinicDepartment
    let selectedDate: Date
    let selectedTimeSlot: TimeSlot
    let patientName: String
    let contactNumber: String
    let reasonForVisit: String

    @State private var showDiscardAlert = false
    @State private var cardAppear = false

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──
            ReviewHeaderView(subtitle: languageManager.localized("appointment_details"))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    // ── Step Indicator ──
                    ReviewStepIndicator(currentStep: 3, totalSteps: 3)
                        .padding(.top, 4)

                    // ── Doctor & Department Card ──
                    VStack(spacing: 0) {
                        // Doctor header
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(department.color.opacity(0.12))
                                    .frame(width: 56, height: 56)
                                Image(systemName: "stethoscope")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(department.color)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(doctor.name)
                                    .font(.poppins(.bold, size: 17))
                                    .foregroundColor(AppColors.darkBlue)
                                Text(languageManager.localized(department.localizationKey))
                                    .font(.poppins(.regular, size: 14))
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding(20)

                        // Divider
                        Rectangle()
                            .fill(Color.gray.opacity(0.08))
                            .frame(height: 1)
                            .padding(.horizontal, 20)

                        // Detail rows
                        VStack(spacing: 16) {
                            ReviewDetailRow(
                                icon: "calendar",
                                label: languageManager.localized("date"),
                                value: dateString
                            )
                            ReviewDetailRow(
                                icon: "clock.fill",
                                label: languageManager.localized("time"),
                                value: selectedTimeSlot.time
                            )
                            ReviewDetailRow(
                                icon: "person.fill",
                                label: languageManager.localized("patient"),
                                value: patientName
                            )
                            ReviewDetailRow(
                                icon: "phone.fill",
                                label: languageManager.localized("contact"),
                                value: contactNumber
                            )
                            if !reasonForVisit.isEmpty {
                                ReviewDetailRow(
                                    icon: "text.alignleft",
                                    label: languageManager.localized("reason"),
                                    value: reasonForVisit
                                )
                            }
                        }
                        .padding(20)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .opacity(cardAppear ? 1 : 0)
                    .offset(y: cardAppear ? 0 : 20)

                    // ── Fee Card ──
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(languageManager.localized("consultation_fee"))
                                .font(.poppins(.medium, size: 14))
                                .foregroundColor(.gray)
                            Text("LKR \(doctor.consultationFee).00")
                                .font(.poppins(.bold, size: 22))
                                .foregroundColor(AppColors.darkBlue)
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 48, height: 48)
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                    .opacity(cardAppear ? 1 : 0)
                    .offset(y: cardAppear ? 0 : 16)

                    // ── Cancellation Policy ──
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.brandBlue)
                        Text(languageManager.localized("cancellation_policy_text"))
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
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 20)
            }

            // ── Action Buttons ──
            HStack(spacing: 14) {
                // Discard
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    showDiscardAlert = true
                }) {
                    Text(languageManager.localized("discard"))
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(AppColors.darkBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(AppColors.darkBlue.opacity(0.3), lineWidth: 1.5)
                        )
                }

                // Confirm Booking
                Button(action: {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    let appointment = Appointment(
                        id: "A-\(Int.random(in: 1000...9999))",
                        doctorName: doctor.name,
                        department: department.name,
                        departmentKey: department.localizationKey,
                        specialization: doctor.specialization,
                        date: selectedDate,
                        timeSlot: selectedTimeSlot.time,
                        status: .confirmed,
                        consultationFee: doctor.consultationFee,
                        tokenNumber: "#A-\(Int.random(in: 2000...5000))",
                        patientName: patientName,
                        contactNumber: contactNumber,
                        reasonForVisit: reasonForVisit
                    )
                    router.navigate(to: .appointmentConfirmed(appointment))
                }) {
                    Text(languageManager.localized("confirm_booking"))
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(AppColors.brandBlue)
                        )
                }
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
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                cardAppear = true
            }
        }
        .alert(languageManager.localized("discard_appointment"), isPresented: $showDiscardAlert) {
            Button(languageManager.localized("cancel"), role: .cancel) { }
            Button(languageManager.localized("discard"), role: .destructive) {
                // Pop back to appointments list (removes 3 screens)
                router.goBack()
                router.goBack()
                router.goBack()
            }
        } message: {
            Text(languageManager.localized("discard_appointment_message"))
        }
    }
}

// MARK: - Review Header

private struct ReviewHeaderView: View {
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
                    NotificationIcon(unreadCount: 3, iconSize: 22)
                }
            }
            Text(subtitle)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(AppColors.darkBlue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

// MARK: - Step Indicator

private struct ReviewStepIndicator: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? AppColors.brandBlue : Color.gray.opacity(0.15))
                    .frame(height: 4)
            }
        }
    }
}

// MARK: - Detail Row

private struct ReviewDetailRow: View {
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

// MARK: - Preview

#Preview {
    AppointmentReviewView(
        doctor: Doctor.samples[0],
        department: ClinicDepartment.samples[0],
        selectedDate: Date(),
        selectedTimeSlot: TimeSlot.generateSlots()[0],
        patientName: "John Doe",
        contactNumber: "+94 71 234 5678",
        reasonForVisit: "Routine checkup"
    )
    .environment(LanguageManager.shared)
    .environment(AppRouter())
}
