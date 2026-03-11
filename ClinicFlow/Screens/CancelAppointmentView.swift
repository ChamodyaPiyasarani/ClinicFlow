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
                    
                    Spacer().frame(height: 30)
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
                    // Navigate back to home or appointments
                    router.goToRoot()
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
                .padding(.bottom, 32)
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
    
    // MARK: - Confirmation Popup
    
    private var confirmationPopup: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showConfirmPopup = false
                    }
                }
            
            // Popup card
            VStack(spacing: 24) {
                Text(languageManager.localized("are_you_sure_cancel_appointment"))
                    .font(.poppins(.semiBold, size: 18))
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                
                // Buttons
                HStack(spacing: 14) {
                    // Go Back button
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showConfirmPopup = false
                        }
                    }) {
                        Text(languageManager.localized("go_back"))
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundColor(Color(red: 230/255, green: 100/255, blue: 70/255))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.3), lineWidth: 1.5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .fill(Color.white)
                                    )
                            )
                    }
                    
                    // Confirm Cancel button
                    Button(action: {
                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showConfirmPopup = false
                        }
                        toastManager.show(.success, message: "toast_appointment_cancelled")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            // Pop back to ContentView (keeping .home route in path)
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
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(red: 230/255, green: 100/255, blue: 70/255))
                            )
                            .shadow(color: Color(red: 230/255, green: 100/255, blue: 70/255).opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 32)
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
    }
}
