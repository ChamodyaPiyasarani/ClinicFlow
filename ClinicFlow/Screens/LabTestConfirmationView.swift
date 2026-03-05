import SwiftUI

struct LabTestConfirmationView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    @Binding var isPresented: Bool
    var onConfirm: () -> Void
    
    // Hardcoded lab test data
    let testData = LabTestConfirmationData(
        consultationStatus: "Consultation Completed !",
        doctorName: "Dr. Sarah Johnson",
        date: "22/01/2025",
        fastingRequired: false,
        estimatedDuration: 15,
        resultTimeDescription: "Results ready in 6 hours",
        fee: 500.00,
        currency: "Rs."
    )
    
    var body: some View {
        ZStack {
            // MARK: - Blur Background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .blur(radius: 2)
                .onTapGesture {
                    dismissModal()
                }
            
            // MARK: - Main Content
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    // Back button
                    HStack {
                        BackButton {
                            dismissModal()
                        }
                        Spacer()
                    }
                    
                    // Centered title
                    AppNameText(fontSize: 20)
                    
                    // Notification bell with badge
                    HStack {
                        Spacer()
                        NotificationIcon(unreadCount: 3, iconSize: 22, showBackground: false)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
                .background(Color.white)
                
                // MARK: - Content Area
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Spacer
                        Color.clear.frame(height: 8)
                        
                        // MARK: - Status Card
                        VStack(alignment: .leading, spacing: 12) {
                            // Status Header
                            HStack {
                                Text("Current Status")
                                    .font(.poppins(.regular, size: 14))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                    Text("Done")
                                        .font(.poppins(.medium, size: 13))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.25))
                                .cornerRadius(12)
                            }
                            
                            // Consultation Status
                            Text(testData.consultationStatus)
                                .font(.poppins(.bold, size: 22))
                                .foregroundColor(.white)
                                .padding(.top, 4)
                            
                            // Doctor Info
                            VStack(alignment: .leading, spacing: 4) {
                                Text(testData.doctorName)
                                    .font(.poppins(.semiBold, size: 15))
                                    .foregroundColor(.white.opacity(0.95))
                                
                                Text(testData.date)
                                    .font(.poppins(.regular, size: 13))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(.top, 4)
                            
                            // MARK: - Before You Proceed Card
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Before You Proceed")
                                    .font(.poppins(.bold, size: 20))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 4)
                                
                                // Information Items
                                VStack(alignment: .leading, spacing: 16) {
                                    ConfirmationInfoItem(
                                        label: "Fasting required?",
                                        value: testData.fastingRequired ? "Yes" : "No"
                                    )
                                    
                                    ConfirmationInfoItem(
                                        label: "Estimated test duration :",
                                        value: "\(testData.estimatedDuration) minutes"
                                    )
                                    
                                    ConfirmationInfoItem(
                                        label: "Estimated result time :",
                                        value: testData.resultTimeDescription

                                    )
                                    
                                    ConfirmationInfoItem(
                                        label: "Lab test fee :",
                                        value: "\(testData.currency) \(String(format: "%.2f", testData.fee))"
                                    )
                                }
                                
                                // OK Button
                                Button(action: {
                                    handleConfirmation()
                                }) {
                                    Text("OK")
                                        .font(.poppins(.semiBold, size: 16))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            Color(red: 40/255, green: 90/255, blue: 110/255)
                                        )
                                        .cornerRadius(25)
                                        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                                }
                                .padding(.top, 8)
                            }
                            .padding(24)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 110/255, green: 175/255, blue: 160/255),
                                        Color(red: 75/255, green: 140/255, blue: 135/255)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            .padding(.top, 12)
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 130/255, green: 165/255, blue: 215/255).opacity(0.85),
                                    Color(red: 100/255, green: 140/255, blue: 200/255).opacity(0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 20)
                        
                        // Bottom spacer
                        Color.clear.frame(height: 16)
                    }
                }
                .background(AppColors.background)
                
                // MARK: - Bottom Navigation Bar
                HStack(spacing: 0) {
                    BottomNavItem(icon: "house.fill", label: "Home", isActive: false)
                    BottomNavItem(icon: "map.fill", label: "Map", isActive: false)
                    BottomNavItem(icon: "calendar", label: "Appointment", isActive: false)
                    BottomNavItem(icon: "person.fill", label: "Account", isActive: false)
                }
                .padding(.vertical, 12)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: -2)
                )
            }
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.25), radius: 25, x: 0, y: 10)
            .padding(.horizontal, 12)
            .padding(.vertical, 50)
        }
        .transition(.scale(scale: 0.95).combined(with: .opacity))
    }
    
    // MARK: - Actions
    private func dismissModal() {
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            isPresented = false
        }
    }
    
    private func handleConfirmation() {
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            isPresented = false
        }
        
        // Small delay before proceeding
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onConfirm()
        }
    }
}

// MARK: - Confirmation Info Item Component
struct ConfirmationInfoItem: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(label)
                .font(.poppins(.regular, size: 15))
                .foregroundColor(.white.opacity(0.95))
            
            Text(value)
                .font(.poppins(.semiBold, size: 15))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Bottom Nav Item Component
struct BottomNavItem: View {
    let icon: String
    let label: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(isActive ? AppColors.brandBlue : Color.gray.opacity(0.6))
            
            Text(label)
                .font(.poppins(.medium, size: 11))
                .foregroundColor(isActive ? AppColors.brandBlue : Color.gray.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
}

// MARK: - Data Model
struct LabTestConfirmationData {
    let consultationStatus: String
    let doctorName: String
    let date: String
    let fastingRequired: Bool
    let estimatedDuration: Int
    let resultTimeDescription: String
    let fee: Double
    let currency: String
}

// MARK: - Preview
#Preview {
    @Previewable @State var languageManager = LanguageManager()
    @Previewable @State var router = AppRouter()
    @Previewable @State var isPresented = true
    
    ZStack {
        // Background content (simulating Lab Tests screen with blur)
        VStack(spacing: 0) {
            AppColors.background.ignoresSafeArea()
            
            Text("Lab Tests Background")
                .font(.poppins(.bold, size: 24))
                .foregroundColor(AppColors.darkBlue)
        }
        .blur(radius: isPresented ? 8 : 0)
        
        if isPresented {
            LabTestConfirmationView(isPresented: $isPresented) {
                print("User confirmed lab test details")
            }
            .environment(languageManager)
            .environment(router)
        }
    }
}
