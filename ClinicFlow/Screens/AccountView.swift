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
        VStack(spacing: 8) {
            // Centered title
            AppNameText(fontSize: 20)

            // Profile subtitle
            Text(languageManager.localized("profile"))
                .font(.poppins(.medium, size: 14))
                .foregroundColor(AppColors.darkBlue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
}

// MARK: - Profile Card Section
private struct ProfileCardSection: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color(red: 200/255, green: 220/255, blue: 160/255))
                    .frame(width: 90, height: 90)

                // Simple avatar illustration
                VStack(spacing: 2) {
                    // Head
                    Circle()
                        .fill(Color(red: 240/255, green: 200/255, blue: 170/255))
                        .frame(width: 32, height: 32)
                        .overlay(
                            // Simple facial features
                            VStack(spacing: 3) {
                                // Eyes
                                HStack(spacing: 8) {
                                    Circle().fill(Color.black)
                                        .frame(width: 3, height: 3)
                                    Circle().fill(Color.black)
                                        .frame(width: 3, height: 3)
                                }
                                
                                // Smile arc
                                Path { path in
                                    path.addArc(
                                        center: CGPoint(x: 16, y: 20),
                                        radius: 6,
                                        startAngle: .degrees(0),
                                        endAngle: .degrees(180),
                                        clockwise: false
                                    )
                                }
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 32, height: 32)
                            }
                            .frame(width: 32, height: 32)
                        )
                    
                    // Body/shirt
                    Capsule()
                        .fill(Color(red: 70/255, green: 130/255, blue: 220/255))
                        .frame(width: 40, height: 24)
                        .offset(y: -4)
                }
            }
            
            // Name
            Text("John Doe")
                .font(.poppins(.semiBold, size: 22))
                .foregroundColor(AppColors.darkBlue)
            
            // Patient ID
            Text("\(languageManager.localized("patient_id_label")): CF-2024-001")
                .font(.poppins(.regular, size: 13))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Menu Items Section
private struct MenuItemsSection: View {
    @Environment(LanguageManager.self) var languageManager
    let router: AppRouter
    
    var body: some View {
        VStack(spacing: 16) {
            MenuItemRow(
                icon: "person.2.fill",
                iconColor: Color(red: 70/255, green: 130/255, blue: 220/255),
                iconBackground: Color(red: 70/255, green: 130/255, blue: 220/255).opacity(0.1),
                title: languageManager.localized("patient_profiles")
            ) {
                // Action: Navigate to patient profiles
                router.navigate(to: .patientProfiles)
            }
            
            MenuItemRow(
                icon: "clock.arrow.circlepath",
                iconColor: Color(red: 80/255, green: 180/255, blue: 100/255),
                iconBackground: Color(red: 80/255, green: 180/255, blue: 100/255).opacity(0.1),
                title: languageManager.localized("visit_history")
            ) {
                // Action: Navigate to visit history
                router.navigate(to: .visitHistory)
            }
            
            MenuItemRow(
                icon: "questionmark.circle.fill",
                iconColor: Color(red: 255/255, green: 140/255, blue: 60/255),
                iconBackground: Color(red: 255/255, green: 140/255, blue: 60/255).opacity(0.1),
                title: languageManager.localized("help_support")
            ) {
                // Action: Navigate to help & support
                router.navigate(to: .helpSupport)
            }
            
            MenuItemRow(
                icon: "gearshape.fill",
                iconColor: Color.gray,
                iconBackground: Color.gray.opacity(0.1),
                title: languageManager.localized("settings")
            ) {
                // Action: Navigate to settings
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
            // Haptic feedback for better UX
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconBackground)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(iconColor)
                }
                
                // Title
                Text(title)
                    .font(.poppins(.medium, size: 16))
                    .foregroundColor(AppColors.darkBlue)
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
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
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                
                Text(languageManager.localized("logout"))
                    .font(.poppins(.semiBold, size: 17))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 240/255, green: 80/255, blue: 90/255),
                        Color(red: 220/255, green: 50/255, blue: 60/255)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color(red: 240/255, green: 80/255, blue: 90/255).opacity(0.3), radius: 8, x: 0, y: 4)
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
