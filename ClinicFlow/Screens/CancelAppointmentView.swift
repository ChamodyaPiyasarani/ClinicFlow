import SwiftUI

struct CancelAppointmentView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @Environment(ToastManager.self) var toastManager
    
    let appointment: Appointment
    
    @State private var cancellationNote: String = ""
    @State private var showConfirmPopup = false
    @State private var showConfirmation = false
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: appointment.date)
    }
    
    private var departmentColor: Color {
        ClinicDepartment.samples.first { $0.localizationKey == appointment.departmentKey }?.color ?? AppColors.brandBlue
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if showConfirmation {
                // Confirmation View
                confirmationView
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                // Cancel Form View
                cancelFormView
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
            
            // Confirmation Popup
            if showConfirmPopup {
                confirmationPopup
            }
        }
        
        BottomNavBar()
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Cancel Form View
    
    private var cancelFormView: some View {
        VStack(spacing: 0) {
            // Header
            headerBar
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Title
                    Text(languageManager.localized("cancel_appointment"))
                        .font(.poppins(.bold, size: 20))
                        .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    // Appointment Details Card
                    appointmentDetailsCard
                        .padding(.horizontal, 20)
                    
                    // Reason for cancellation
                    VStack(alignment: .leading, spacing: 10) {
                        Text(languageManager.localized("reason_for_cancellation_optional"))
                            .font(.poppins(.medium, size: 14))
                            .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255))
                            .padding(.horizontal, 20)
                        
                        // Note text field
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.3), lineWidth: 1.5)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.white)
                                )
                                .frame(height: 100)
                            
                            if cancellationNote.isEmpty {
                                Text(languageManager.localized("note"))
                                    .font(.poppins(.regular, size: 14))
                                    .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.4))
                                    .padding(.horizontal, 16)
                                    .padding(.top, 12)
                            }
                            
                            TextEditor(text: $cancellationNote)
                                .font(.poppins(.regular, size: 14))
                                .foregroundColor(AppColors.darkBlue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(height: 100)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Cancel button
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showConfirmPopup = true
                        }
                    }) {
                        Text(languageManager.localized("cancel_this_appointment"))
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(red: 230/255, green: 100/255, blue: 70/255))
                            )
                            .shadow(color: Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    
                    // Policy note
                    Text(languageManager.localized("cancellation_policy_note"))
                        .font(.poppins(.regular, size: 11))
                        .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.7))
                        .multilineTextAlignment(.center)
                        .italic()
                        .padding(.horizontal, 30)
                    
                    Spacer().frame(height: 100)
                }
                .padding(.top, 8)
            }
        }
    }
    
    // MARK: - Appointment Details Card
    
    private var appointmentDetailsCard: some View {
        VStack(spacing: 0) {
            // Header section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(languageManager.localized("appointment_details"))
                        .font(.poppins(.semiBold, size: 13))
                        .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255))
                    Spacer()
                }
                
                // Token Number
                Text("Token \(appointment.tokenNumber)")
                    .font(.poppins(.bold, size: 28))
                    .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255))
                
                // Doctor and department
                Text("\(appointment.doctorName) • \(languageManager.localized(appointment.departmentKey))")
                    .font(.poppins(.medium, size: 15))
                    .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            
            Divider()
                .background(Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.2))
                .padding(.horizontal, 20)
            
            // Date and time section
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Date : \(dateString)")
                        .font(.poppins(.semiBold, size: 14))
                        .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255))
                    
                    Text("Time : \(appointment.timeSlot)")
                        .font(.poppins(.regular, size: 13))
                        .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255))
                }
                
                Spacer()
                
                // Clock icon
                ZStack {
                    Circle()
                        .fill(Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.15))
                        .frame(width: 56, height: 56)
                    Image(systemName: "clock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255))
                }
            }
            .padding(18)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(red: 255/255, green: 248/255, blue: 235/255))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.3), lineWidth: 2)
        )
    }
    
    // MARK: - Confirmation View
    
    private var confirmationView: some View {
        VStack(spacing: 0) {
            // Header
            headerBar
            
            VStack(spacing: 32) {
                Spacer()
                
                // Success icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 120, height: 120)
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 90, height: 90)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                }
                
                VStack(spacing: 12) {
                    Text(languageManager.localized("appointment_cancelled"))
                        .font(.poppins(.bold, size: 24))
                        .foregroundColor(AppColors.darkBlue)
                    
                    Text(languageManager.localized("appointment_cancelled_desc"))
                        .font(.poppins(.regular, size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Done button
                Button(action: {
                    // Navigate back to appointments tab
                    while router.path.count > 1 {
                        router.path.removeLast()
                    }
                    router.selectedTab = .appointment
                }) {
                    Text(languageManager.localized("done"))
                        .font(.poppins(.semiBold, size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppColors.brandBlue)
                        )
                        .shadow(color: AppColors.brandBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    // MARK: - Header Bar
    
    private var headerBar: some View {
        ZStack {
            HStack {
                BackButton { router.goBack() }
                Spacer()
                NotificationIcon()
            }
            AppNameText(fontSize: 20)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(AppColors.background)
    }
    
    // MARK: - Confirmation Popup (Liquid Glass Style)
    
    private var confirmationPopup: some View {
        ZStack {
            // Dimmed translucent background with blur
            Color.black.opacity(0.25)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        showConfirmPopup = false
                    }
                }
            
            // Liquid Glass Popup Card
            VStack(spacing: 0) {
                // Content Container
                VStack(spacing: 28) {
                    // Icon with glass effect
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.15))
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
                            .shadow(color: Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.2), radius: 12, x: 0, y: 4)
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 230/255, green: 100/255, blue: 70/255),
                                        Color(red: 210/255, green: 80/255, blue: 50/255)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .padding(.top, 36)
                    
                    // Text content
                    VStack(spacing: 10) {
                        Text(languageManager.localized("are_you_sure_cancel_appointment"))
                            .font(.poppins(.semiBold, size: 17))
                            .foregroundColor(AppColors.darkBlue)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                        Text("This action cannot be undone")
                            .font(.poppins(.regular, size: 13))
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    
                    // Buttons with glass effect
                    VStack(spacing: 12) {
                        // Confirm Cancel button (Primary - Glass)
                        Button(action: {
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                            toastManager.show(.success, message: "toast_appointment_cancelled")
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                showConfirmPopup = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                while router.path.count > 1 {
                                    router.path.removeLast()
                                }
                                router.selectedTab = .appointment
                            }
                        }) {
                            Text(languageManager.localized("confirm_cancel"))
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        // Base gradient
                                        LinearGradient(
                                            colors: [
                                                Color(red: 230/255, green: 100/255, blue: 70/255),
                                                Color(red: 210/255, green: 80/255, blue: 50/255)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        
                                        // Glass highlight overlay
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
                                .shadow(color: Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        
                        // Go Back button (Secondary - Glass)
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                showConfirmPopup = false
                            }
                        }) {
                            Text(languageManager.localized("go_back"))
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
                    // Glass material base
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    // Subtle gradient overlay for depth
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Light edge highlight (top-left)
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.8),
                                    Color.white.opacity(0.0)
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
            .scaleEffect(showConfirmPopup ? 1 : 0.9)
            .opacity(showConfirmPopup ? 1 : 0)
        }
        .transition(.opacity)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CancelAppointmentView(appointment: Appointment.samples[0])
            .environment(LanguageManager.shared)
            .environment(AppRouter())
            .environment(ToastManager.shared)
    }
}
