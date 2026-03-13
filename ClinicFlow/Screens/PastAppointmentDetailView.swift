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

    private var cardColor: Color {
        switch appointment.status {
        case .confirmed:
            return AppColors.brandBlue
        case .pending:
            return Color.orange
        default:
            return departmentColor
        }
    }

    private var departmentIcon: String {
        ClinicDepartment.samples.first { $0.localizationKey == appointment.departmentKey }?.icon ?? "stethoscope"
    }

    private var statusColor: Color {
        appointment.status.color
    }

    var body: some View {
        ZStack(alignment: .bottom) {
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
                .padding(.bottom, 100)
            }
        }
        .background(AppColors.background)
        
        BottomNavBar()
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
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
            // Vibrant gradient header section
            ZStack(alignment: .top) {
                LinearGradient(
                    colors: [cardColor.opacity(0.8), cardColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        // Status badge
                        Text(languageManager.localized(appointment.status.localizationKey))
                            .font(.poppins(.semiBold, size: 12))
                            .foregroundColor(cardColor)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.95))
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )

                        Spacer()

                        // Calendar icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "calendar")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 2) {
                        Text(languageManager.localized(appointment.departmentKey))
                            .font(.poppins(.bold, size: 24))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 1)

                        Text("Department of \(languageManager.localized(appointment.departmentKey))")
                            .font(.poppins(.medium, size: 14))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .frame(height: 165)
            
            // White section with doctor and details
            VStack(spacing: 0) {
                // Doctor info
                HStack(spacing: 16) {
                    // Doctor avatar
                    ProfessionalAvatarView(
                        size: 64,
                        gradientColors: [cardColor.opacity(0.8), cardColor]
                    )
                    .shadow(color: cardColor.opacity(0.25), radius: 8, x: 0, y: 4)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(appointment.doctorName)
                            .font(.poppins(.bold, size: 18))
                            .foregroundColor(AppColors.darkBlue)

                        HStack(spacing: 4) {
                            Image(systemName: "stethoscope")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(cardColor.opacity(0.9))
                            Text(languageManager.localized(appointment.departmentKey))
                                .font(.poppins(.medium, size: 13))
                                .foregroundColor(.gray.opacity(0.9))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(cardColor.opacity(0.08))
                        .cornerRadius(6)
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 16)
                
                // Divider
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.clear, cardColor.opacity(0.2), Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                    .padding(.horizontal, 24)

                // Appointment details
                VStack(spacing: 4) {
                    // Date
                    PastAppointmentDetailRow(
                        icon: "calendar",
                        iconBg: cardColor.opacity(0.08),
                        iconColor: cardColor,
                        label: "Date",
                        value: dateString
                    )

                    // Time
                    PastAppointmentDetailRow(
                        icon: "clock.fill",
                        iconBg: cardColor.opacity(0.08),
                        iconColor: cardColor,
                        label: "Time",
                        value: appointment.timeSlot
                    )

                    // Location
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(cardColor.opacity(0.08))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(cardColor)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Location")
                                    .font(.poppins(.regular, size: 13))
                                    .foregroundColor(.gray.opacity(0.8))
                                Text("Building A, Room 12")
                                    .font(.poppins(.semiBold, size: 16))
                                    .foregroundColor(AppColors.darkBlue)
                                Text("1st Floor")
                                    .font(.poppins(.regular, size: 14))
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    }

                    // Token Number
                    PastAppointmentDetailRow(
                        icon: "number.circle.fill",
                        iconBg: cardColor.opacity(0.08),
                        iconColor: cardColor,
                        label: "Token Number",
                        value: appointment.tokenNumber
                    )
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
            }
            .background(Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: cardColor.opacity(0.12), radius: 20, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
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
        .padding(.vertical, 8)
    }
}

// MARK: - Doctor Avatar View

private struct DoctorAvatarView: View {
    let avatarColor: Color
    let hairColor: Color
    let shirtColor: Color
    let size: CGFloat
    
    private var faceSize: CGFloat { size * 0.40 }
    private var bodyWidth: CGFloat { size * 0.50 }
    private var bodyHeight: CGFloat { size * 0.30 }
    private var eyeSize: CGFloat { size * 0.04 }
    private var glassesWidth: CGFloat { size * 0.60 }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [avatarColor, avatarColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: shirtColor.opacity(0.2), radius: 8, x: 0, y: 4)
            
            // Doctor avatar illustration
            VStack(spacing: size * 0.025) {
                // Head
                ZStack {
                    Circle()
                        .fill(Color(red: 240/255, green: 205/255, blue: 175/255))
                        .frame(width: faceSize, height: faceSize)
                    
                    // Facial features
                    VStack(spacing: size * 0.04) {
                        // Eyes with glasses
                        ZStack {
                            // Glasses frame
                            HStack(spacing: size * 0.06) {
                                // Left lens
                                Circle()
                                    .stroke(Color.black.opacity(0.7), lineWidth: size * 0.014)
                                    .frame(width: size * 0.17, height: size * 0.17)
                                // Right lens
                                Circle()
                                    .stroke(Color.black.opacity(0.7), lineWidth: size * 0.014)
                                    .frame(width: size * 0.17, height: size * 0.17)
                            }
                            // Bridge
                            .overlay(
                                Rectangle()
                                    .fill(Color.black.opacity(0.7))
                                    .frame(width: size * 0.04, height: size * 0.01)
                            )
                            
                            // Eyes behind glasses
                            HStack(spacing: size * 0.10) {
                                Circle().fill(Color.black)
                                    .frame(width: eyeSize, height: eyeSize)
                                Circle().fill(Color.black)
                                    .frame(width: eyeSize, height: eyeSize)
                            }
                        }
                        .offset(y: -size * 0.02)
                        
                        // Friendly smile
                        Path { path in
                            path.addArc(
                                center: CGPoint(x: faceSize/2, y: faceSize * 0.68),
                                radius: faceSize * 0.20,
                                startAngle: .degrees(10),
                                endAngle: .degrees(170),
                                clockwise: false
                            )
                        }
                        .stroke(Color.black.opacity(0.8), lineWidth: size * 0.014)
                        .frame(width: faceSize, height: faceSize)
                        .offset(y: -size * 0.05)
                    }
                    .frame(width: faceSize, height: faceSize)
                }
                
                // Body/white coat
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [shirtColor, shirtColor.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: bodyWidth, height: bodyHeight)
                    .overlay(
                        // Collar detail
                        VStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: bodyWidth * 0.4, height: size * 0.02)
                            Spacer()
                        }
                    )
                    .offset(y: -size * 0.05)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PastAppointmentDetailView(appointment: Appointment.samples[0])
        .environment(LanguageManager.shared)
        .environment(AppRouter.shared)
}
