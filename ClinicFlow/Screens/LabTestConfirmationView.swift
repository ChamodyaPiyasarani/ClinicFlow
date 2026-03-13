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
                // MARK: - Before You Proceed Card
                VStack(spacing: 28) {
                    
                    // Icon with glass effect
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(Color(red: 46/255, green: 213/255, blue: 115/255).opacity(0.15))
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
                            .shadow(color: Color(red: 39/255, green: 174/255, blue: 96/255).opacity(0.2), radius: 12, x: 0, y: 4)
                        
                        Image(systemName: "flask.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 46/255, green: 213/255, blue: 115/255),
                                        Color(red: 39/255, green: 174/255, blue: 96/255)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .padding(.top, 36)
                    
                    VStack(alignment: .center, spacing: 20) {
                        Text(languageManager.localized("before_you_proceed"))
                            .font(.poppins(.bold, size: 20))
                            .foregroundColor(AppColors.darkBlue)
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
                    }
                        
                    // Buttons with glass effect
                    VStack(spacing: 12) {
                        // OK Button (Primary - Glass)
                        Button(action: {
                            handleConfirmation()
                        }) {
                            Text(languageManager.localized("ok"))
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        // Base gradient
                                        LinearGradient(
                                            colors: [
                                                Color(red: 46/255, green: 213/255, blue: 115/255),
                                                Color(red: 39/255, green: 174/255, blue: 96/255)
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
                                .shadow(color: Color(red: 39/255, green: 174/255, blue: 96/255).opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        
                        // Cancel Button (Secondary - Glass)
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                isPresented = false
                            }
                        }) {
                            Text(languageManager.localized("cancel"))
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
                    // White glassy base
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.85))
                        .background(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .fill(.regularMaterial)
                        )
                    
                    // Light edge highlight (top-left)
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color.white.opacity(0.3)
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
            .scaleEffect(isPresented ? 1 : 0.9)
            .frame(maxHeight: .infinity)
        }
        .transition(.opacity)
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
                .foregroundColor(Color(red: 127/255, green: 140/255, blue: 141/255))
            
            Text(value)
                .font(.poppins(.semiBold, size: 15))
                .foregroundColor(Color(red: 52/255, green: 73/255, blue: 94/255))
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
