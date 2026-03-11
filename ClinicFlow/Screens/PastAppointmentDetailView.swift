import SwiftUI

// MARK: - Main View

struct PastAppointmentDetailView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    let appointment: Appointment

    @State private var headerAppear = false
    @State private var detailsAppear = false

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

    private var statusColor: Color {
        appointment.status.color
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Minimal Header ──
            PastAppointmentHeaderBar()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // ── Hero Card: Doctor + Status ──
                    heroCard
                        .opacity(headerAppear ? 1 : 0)
                        .offset(y: headerAppear ? 0 : 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .background(AppColors.background)
        .onAppear { triggerStaggeredAnimations() }
    }

    // MARK: - Staggered Animations

    private func triggerStaggeredAnimations() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.05)) {
            headerAppear = true
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.15)) {
            detailsAppear = true
        }
    }

    // MARK: - Hero Card

    private var heroCard: some View {
        VStack(spacing: 0) {
            // Blue header section
            ZStack(alignment: .top) {
                departmentColor
                
                HStack(alignment: .top) {
                    // Status badge
                    Text(languageManager.localized(appointment.status.localizationKey))
                        .font(.poppins(.semiBold, size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.25))
                        )
                    
                    Spacer()
                    
                    // Calendar icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 44, height: 44)
                        Image(systemName: "calendar")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer().frame(height: 50)
                    
                    Text(languageManager.localized(appointment.departmentKey))
                        .font(.poppins(.bold, size: 22))
                        .foregroundColor(.white)
                    
                    Text("Department of \(languageManager.localized(appointment.departmentKey))")
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(height: 180)
            
            // White section with doctor and details
            VStack(spacing: 0) {
                // Doctor info
                HStack(spacing: 16) {
                    // Doctor avatar
                    DoctorAvatarView(
                        avatarColor: departmentColor.opacity(0.15),
                        hairColor: Color(red: 0.4, green: 0.26, blue: 0.13),
                        shirtColor: departmentColor,
                        size: 70
                    )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(appointment.doctorName)
                            .font(.poppins(.bold, size: 19))
                            .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.45))
                        
                        HStack(spacing: 6) {
                            Image(systemName: "stethoscope")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(departmentColor.opacity(0.8))
                            Text(languageManager.localized(appointment.departmentKey))
                                .font(.poppins(.medium, size: 14))
                                .foregroundColor(.gray.opacity(0.9))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)
                
                // Divider
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.clear, departmentColor.opacity(0.15), Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                
                // Appointment details
                VStack(spacing: 0) {
                    // Date
                    PastAppointmentDetailRow(
                        icon: "calendar",
                        iconBg: Color(red: 0.9, green: 0.94, blue: 1.0),
                        iconColor: departmentColor,
                        label: "Date",
                        value: dateString
                    )
                    
                    // Time
                    PastAppointmentDetailRow(
                        icon: "clock.fill",
                        iconBg: Color(red: 0.9, green: 0.94, blue: 1.0),
                        iconColor: departmentColor,
                        label: "Time",
                        value: appointment.timeSlot
                    )
                    
                    // Location
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.9, green: 0.94, blue: 1.0))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(departmentColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Location")
                                    .font(.poppins(.regular, size: 12))
                                    .foregroundColor(.gray.opacity(0.8))
                                Text("Building A, Room 12")
                                    .font(.poppins(.semiBold, size: 15))
                                    .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))
                                Text("1st Floor")
                                    .font(.poppins(.regular, size: 13))
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    // Token Number
                    PastAppointmentDetailRow(
                        icon: "number",
                        iconBg: Color(red: 0.9, green: 0.94, blue: 1.0),
                        iconColor: departmentColor,
                        label: "Token Number",
                        value: appointment.tokenNumber
                    )
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .background(Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: departmentColor.opacity(0.15), radius: 24, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}

// MARK: - Past Appointment Header Bar (Minimal)

private struct PastAppointmentHeaderBar: View {
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
        .background(AppColors.background)
    }
}

// MARK: - Past Appointment Detail Row

private struct PastAppointmentDetailRow: View {
    let icon: String
    let iconBg: Color
    let iconColor: Color
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconBg)
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.poppins(.regular, size: 12))
                    .foregroundColor(.gray.opacity(0.8))
                Text(value)
                    .font(.poppins(.semiBold, size: 15))
                    .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

// MARK: - Preview

#Preview {
    PastAppointmentDetailView(appointment: Appointment.samples[0])
        .environment(LanguageManager.shared)
        .environment(AppRouter.shared)
}
