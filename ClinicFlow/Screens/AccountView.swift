import SwiftUI

struct AccountView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @Environment(ToastManager.self) var toastManager
    
    @State private var showLogoutConfirmation = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // ── Header ──
                AccountHeaderView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // ── Profile Card ──
                        ProfileCardSection()
                            .padding(.top, 20)

                        // ── Menu Items ──
                        MenuItemsSection(router: router)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }

                // ── Logout Button ──
                LogoutButton(showConfirmation: $showLogoutConfirmation)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .background(AppColors.background)
            
            if showLogoutConfirmation {
                LogoutConfirmationPopup(
                    isPresented: $showLogoutConfirmation,
                    onConfirm: {
                        toastManager.show(.success, message: "toast_logged_out")
                        router.hasCompletedOnboarding = false
                        router.goToRoot()
                    }
                )
            }
        }
    }
}

// MARK: - Header
private struct AccountHeaderView: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        ZStack {
            // Centered title
            AppNameText(fontSize: 22)

            // Left-aligned label if needed or just keep it premium centered
        }
        .padding(.horizontal, 20)
        .padding(.top, 22)
        .padding(.bottom, 8)
        .background(Color.white.opacity(0.001))
    }
}

// MARK: - Profile Card Section
private struct ProfileCardSection: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        ZStack {
            // Premium Gradient Background
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            AppColors.brandBlue.opacity(0.9),
                            AppColors.darkBlue.opacity(0.95)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Decorative background elements
            GeometryReader { _ in
                Circle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 120, height: 120)
                    .offset(x: 260, y: -20)
                
                Circle()
                    .fill(Color.white.opacity(0.04))
                    .frame(width: 90, height: 90)
                    .offset(x: -20, y: 140)
            }
            .clipped()

            VStack(spacing: 16) {
                // Avatar with premium ring
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 4)
                        .frame(width: 100, height: 100)
                    
                    ProfessionalAvatarView(size: 92)
                }
                
                VStack(spacing: 4) {
                    Text("John Doe")
                        .font(.poppins(.bold, size: 24))
                        .foregroundColor(.white)
                    
                    Text("\(languageManager.localized("patient_id_label")): CF-2024-001")
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                // Active status chip
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                    Text(languageManager.localized("active_status"))
                        .font(.poppins(.medium, size: 12))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.white.opacity(0.15)))
            }
            .padding(.vertical, 32)
        }
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: AppColors.brandBlue.opacity(0.25), radius: 15, x: 0, y: 8)
    }
}

// MARK: - Menu Items Section
private struct MenuItemsSection: View {
    @Environment(LanguageManager.self) var languageManager
    let router: AppRouter
    
    var body: some View {
        VStack(spacing: 14) {
            MenuItemRow(
                icon: "person.2.fill",
                iconColor: AppColors.brandBlue,
                iconBackground: AppColors.brandBlue.opacity(0.12),
                title: languageManager.localized("patient_profiles")
            ) {
                router.navigate(to: .patientProfiles)
            }
            
            MenuItemRow(
                icon: "clock.arrow.circlepath",
                iconColor: AppColors.opdBlue,
                iconBackground: AppColors.opdBlue.opacity(0.12),
                title: languageManager.localized("visit_history")
            ) {
                router.navigate(to: .visitHistory)
            }
            
            MenuItemRow(
                icon: "questionmark.circle.fill",
                iconColor: AppColors.pharmacyGreen,
                iconBackground: AppColors.pharmacyGreen.opacity(0.12),
                title: languageManager.localized("help_support")
            ) {
                router.navigate(to: .helpSupport)
            }
            
            MenuItemRow(
                icon: "gearshape.fill",
                iconColor: AppColors.darkBlue.opacity(0.6),
                iconBackground: AppColors.darkBlue.opacity(0.08),
                title: languageManager.localized("settings")
            ) {
                router.navigate(to: .settings)
            }
        }
    }
}

// MARK: - Menu Item Row
private struct MenuItemRow: View {
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 20) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(iconBackground)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                // Title
                Text(title)
                    .font(.poppins(.medium, size: 16))
                    .foregroundColor(AppColors.darkBlue)
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.darkBlue.opacity(0.25))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(AppColors.darkBlue.opacity(0.04), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Logout Button
private struct LogoutButton: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var showConfirmation: Bool
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showConfirmation = true
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18, weight: .bold))
                
                Text(languageManager.localized("logout"))
                    .font(.poppins(.semiBold, size: 17))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(red: 235/255, green: 75/255, blue: 85/255),
                            Color(red: 215/255, green: 45/255, blue: 55/255)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Subtle shimmer highlight
                    LinearGradient(
                        colors: [.white.opacity(0.15), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color(red: 235/255, green: 75/255, blue: 85/255).opacity(0.35), radius: 12, x: 0, y: 6)
        }
    }
}

// MARK: - Logout Confirmation Popup
private struct LogoutConfirmationPopup: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var isPresented: Bool
    var onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            // Dimmed translucent background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissModal()
                }
            
            // Liquid Glass Popup Card
            VStack(spacing: 0) {
                VStack(spacing: 28) {
                    // Icon with glass effect
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(Color(red: 240/255, green: 80/255, blue: 90/255).opacity(0.15))
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
                            .shadow(color: Color(red: 240/255, green: 80/255, blue: 90/255).opacity(0.2), radius: 12, x: 0, y: 4)
                        
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 240/255, green: 80/255, blue: 90/255),
                                        Color(red: 220/255, green: 50/255, blue: 60/255)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .offset(x: 2)
                    }
                    .padding(.top, 36)
                    
                    VStack(spacing: 10) {
                        Text(languageManager.localized("logout_title"))
                            .font(.poppins(.bold, size: 22))
                            .foregroundColor(AppColors.darkBlue)
                        
                        Text(languageManager.localized("logout_confirmation"))
                            .font(.poppins(.regular, size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    
                    // Buttons with glass effect
                    VStack(spacing: 12) {
                        // Confirm Cancel button (Primary - Glass)
                        Button(action: {
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                isPresented = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onConfirm()
                            }
                        }) {
                            Text(languageManager.localized("logout"))
                                .font(.poppins(.semiBold, size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        LinearGradient(
                                            colors: [
                                                Color(red: 240/255, green: 80/255, blue: 90/255),
                                                Color(red: 220/255, green: 50/255, blue: 60/255)
                                            ],
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
                                .shadow(color: Color(red: 240/255, green: 80/255, blue: 90/255).opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        
                        // Go Back button (Secondary - Glass)
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

// MARK: - Preview
#Preview {
    AccountView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
