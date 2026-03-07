import SwiftUI

struct AccountView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    var body: some View {
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
            LogoutButton(router: router)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .background(AppColors.background)
    }
}

// MARK: - Header
private struct AccountHeaderView: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Back button (left aligned) - Hidden for now as it's in the bottom nav
                HStack {
                    Spacer()
                }

                // Centered title
                AppNameText(fontSize: 20)

                // Notification bell (right)
                HStack {
                    Spacer()
                    NotificationIcon(unreadCount: 3, iconSize: 22, showBackground: false)
                }
            }

            // Profile subtitle
            Text(languageManager.localized("profile"))
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.white)
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
                                // Hair/curls
                                HStack(spacing: 3) {
                                    Circle().fill(Color(red: 139/255, green: 90/255, blue: 43/255))
                                        .frame(width: 6, height: 6)
                                    Circle().fill(Color(red: 139/255, green: 90/255, blue: 43/255))
                                        .frame(width: 6, height: 6)
                                    Circle().fill(Color(red: 139/255, green: 90/255, blue: 43/255))
                                        .frame(width: 6, height: 6)
                                }
                                .offset(y: -12)
                                
                                Spacer()
                                
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
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Menu Items Section
private struct MenuItemsSection: View {
    @Environment(LanguageManager.self) var languageManager
    let router: AppRouter
    
    var body: some View {
        VStack(spacing: 12) {
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
            }
            
            MenuItemRow(
                icon: "questionmark.circle.fill",
                iconColor: Color(red: 255/255, green: 140/255, blue: 60/255),
                iconBackground: Color(red: 255/255, green: 140/255, blue: 60/255).opacity(0.1),
                title: languageManager.localized("help_support")
            ) {
                // Action: Navigate to help & support
            }
            
            MenuItemRow(
                icon: "gearshape.fill",
                iconColor: Color.gray,
                iconBackground: Color.gray.opacity(0.1),
                title: languageManager.localized("settings")
            ) {
                // Action: Navigate to settings
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
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
            .background(Color.white)
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
    let router: AppRouter
    
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        Button(action: {
            showLogoutConfirmation = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                
                Text(languageManager.localized("logout"))
                    .font(.poppins(.semiBold, size: 17))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.red, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                    )
            )
        }
        .alert(languageManager.localized("logout_title"), isPresented: $showLogoutConfirmation) {
            Button(languageManager.localized("cancel"), role: .cancel) { }
            Button(languageManager.localized("logout"), role: .destructive) {
                // Navigate back to splash screen
                router.goToRoot()
            }
        } message: {
            Text(languageManager.localized("logout_confirmation"))
        }
    }
}

// MARK: - Preview
#Preview {
    AccountView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
