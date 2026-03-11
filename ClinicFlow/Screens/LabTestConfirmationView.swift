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
        fee: 2500.00,
        currency: "LKR"
    )
    
    var body: some View {
        ZStack {
            // MARK: - Blur Background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissModal()
                }
            
            // MARK: - Floating Confirmation Card
            VStack(spacing: 0) {
                // MARK: - Status Card (Light Green)
                VStack(alignment: .leading, spacing: 12) {
                    // Status Header
                    HStack {
                        Text(languageManager.localized("current_status"))
                            .font(.poppins(.regular, size: 14))
                            .foregroundColor(AppColors.darkBlue.opacity(0.8))
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                            Text(languageManager.localized("done"))
                                .font(.poppins(.medium, size: 13))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(red: 60/255, green: 150/255, blue: 100/255))
                        .cornerRadius(12)
                    }
                    
                    // Consultation Status
                    Text(testData.consultationStatus)
                        .font(.poppins(.bold, size: 22))
                        .foregroundColor(Color(red: 50/255, green: 130/255, blue: 90/255))
                        .padding(.top, 4)
                    
                    // Doctor Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(testData.doctorName)
                            .font(.poppins(.semiBold, size: 15))
                            .foregroundColor(AppColors.darkBlue.opacity(0.9))
                        
                        Text(testData.date)
                            .font(.poppins(.regular, size: 13))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .padding(.top, 4)
                    
                    // MARK: - Before You Proceed Card (White)
                    VStack(alignment: .leading, spacing: 20) {
                        Text(languageManager.localized("before_you_proceed"))
                            .font(.poppins(.bold, size: 20))
                            .foregroundColor(Color(red: 60/255, green: 150/255, blue: 100/255))
                            .padding(.bottom, 4)
                        
                        // Information Items
                        VStack(alignment: .leading, spacing: 16) {
                            ConfirmationInfoItem(
                                label: languageManager.localized("fasting_required"),
                                value: testData.fastingRequired ? languageManager.localized("yes") : languageManager.localized("no")
                            )
                            
                            ConfirmationInfoItem(
                                label: languageManager.localized("estimated_duration"),
                                value: "\(testData.estimatedDuration) \(languageManager.localized("minutes"))"
                            )
                            
                            ConfirmationInfoItem(
                                label: languageManager.localized("estimated_result_time"),
                                value: testData.resultTimeDescription

                            )
                            
                            ConfirmationInfoItem(
                                label: languageManager.localized("lab_test_fee"),
                                value: "\(testData.currency) \(String(format: "%.2f", testData.fee))"
                            )
                        }
                        
                        // OK Button (Green)
                        Button(action: {
                            handleConfirmation()
                        }) {
                            Text(languageManager.localized("ok"))
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 60/255, green: 150/255, blue: 100/255),
                                            Color(red: 50/255, green: 130/255, blue: 85/255)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: Color(red: 60/255, green: 150/255, blue: 100/255).opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.top, 12)
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 200/255, green: 235/255, blue: 220/255),
                            Color(red: 180/255, green: 225/255, blue: 210/255)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            }
            .padding(.horizontal, 24)
            .frame(maxHeight: .infinity)
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
                .foregroundColor(.gray.opacity(0.9))
            
            Text(value)
                .font(.poppins(.semiBold, size: 15))
                .foregroundColor(AppColors.darkBlue)
        }
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
