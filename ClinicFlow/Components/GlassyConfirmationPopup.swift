import SwiftUI

struct GlassyConfirmationPopup: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var isPresented: Bool
    
    let icon: String
    let iconColors: [Color]
    let titleKey: String
    let messageKey: String
    let confirmLabelKey: String
    let onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            // Dimmed translucent background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissModal()
                }
            
            // Glassy Popup Card
            VStack(spacing: 0) {
                VStack(spacing: 28) {
                    // Icon with glass effect
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(iconColors.first?.opacity(0.15) ?? AppColors.brandBlue.opacity(0.15))
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
                            .shadow(color: iconColors.first?.opacity(0.2) ?? AppColors.brandBlue.opacity(0.2), radius: 12, x: 0, y: 4)
                        
                        Image(systemName: icon)
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: iconColors,
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .padding(.top, 36)
                    
                    VStack(spacing: 10) {
                        Text(languageManager.localized(titleKey))
                            .font(.poppins(.bold, size: 22))
                            .foregroundColor(AppColors.darkBlue)
                            .multilineTextAlignment(.center)
                        
                        Text(languageManager.localized(messageKey))
                            .font(.poppins(.regular, size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    
                    // Buttons with glass effect
                    VStack(spacing: 12) {
                        // Confirm action
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                isPresented = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onConfirm()
                            }
                        }) {
                            Text(languageManager.localized(confirmLabelKey))
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        LinearGradient(
                                            colors: iconColors,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        
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
                                .shadow(color: iconColors.first?.opacity(0.4) ?? AppColors.brandBlue.opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        
                        // Go Back action
                        Button(action: {
                            dismissModal()
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
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.85))
                        .background(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .fill(.regularMaterial)
                        )
                    
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
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 15)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 28)
            .scaleEffect(isPresented ? 1 : 0.9)
            .opacity(isPresented ? 1 : 0)
        }
        .transition(.opacity)
    }
    
    private func dismissModal() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            isPresented = false
        }
    }
}
