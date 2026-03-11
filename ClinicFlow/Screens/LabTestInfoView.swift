import SwiftUI

struct LabTestInfoView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    @Binding var isPresented: Bool
    var onProceed: () -> Void
    
    var body: some View {
        ZStack {
            // Blur Background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissModal()
                }
            
            // MARK: - Floating Instructions Card
            VStack(spacing: 0) {
                // Instructions Card
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text(languageManager.localized("instructions_title"))
                        .font(.poppins(.semiBold, size: 18))
                        .foregroundColor(AppColors.darkBlue)
                        .padding(.bottom, 4)
                    
                    // Instructions List
                    VStack(alignment: .leading, spacing: 14) {
                        InstructionItem(
                            icon: "fork.knife",
                            title: languageManager.localized("instruction_fasting_title"),
                            description: languageManager.localized("instruction_fasting_desc")
                        )
                        
                        InstructionItem(
                            icon: "pills.fill",
                            title: languageManager.localized("instruction_medicines_title"),
                            description: languageManager.localized("instruction_medicines_desc")
                        )
                        
                        InstructionItem(
                            icon: "clock.fill",
                            title: languageManager.localized("instruction_time_title"),
                            description: languageManager.localized("instruction_time_desc")
                        )
                        
                        InstructionItem(
                            icon: "doc.text.fill",
                            title: languageManager.localized("instruction_documents_title"),
                            description: languageManager.localized("instruction_documents_desc")
                        )
                    }
                    
                    // Bottom message
                    Text(languageManager.localized("instructions_footer"))
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color(red: 60/255, green: 150/255, blue: 100/255))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    
                    // OK Button
                    Button(action: {
                        // Haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                        
                        // Small delay before proceeding
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onProceed()
                        }
                    }) {
                        Text(languageManager.localized("ok"))
                            .font(.poppins(.semiBold, size: 17))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
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
                            .cornerRadius(14)
                            .shadow(color: Color(red: 60/255, green: 150/255, blue: 100/255).opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            }
            .padding(.horizontal, 24)
            .frame(maxHeight: .infinity)
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    private func dismissModal() {
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isPresented = false
        }
    }
}

// MARK: - Instruction Item Component
struct InstructionItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(red: 60/255, green: 150/255, blue: 100/255))
                .frame(width: 24)
                .padding(.top, 2)
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.poppins(.semiBold, size: 14))
                    .foregroundColor(AppColors.darkBlue)
                
                Text(description)
                    .font(.poppins(.regular, size: 13))
                    .foregroundColor(Color.gray.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var languageManager = LanguageManager()
    @Previewable @State var router = AppRouter()
    @Previewable @State var isPresented = true
    
    ZStack {
        // Background content (simulating previous screen)
        AppColors.background.ignoresSafeArea()
        
        if isPresented {
            LabTestInfoView(isPresented: $isPresented) {
                print("Proceeding to Lab Tests")
            }
            .environment(languageManager)
            .environment(router)
        }
    }
}
