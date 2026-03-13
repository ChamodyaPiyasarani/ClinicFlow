import SwiftUI
import UserNotifications

struct NotificationPermissionView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    
    var body: some View {
        ZStack {
            // Background
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Back Button
                HStack {
                    BackButton {
                        router.goBack()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // MARK: - Content
                GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 24) {
                        // Notification Icon with Badge (Liquid Glass Style)
                        ZStack(alignment: .topTrailing) {
                            ZStack {
                                // Outer glow
                                Circle()
                                    .fill(AppColors.brandBlue.opacity(0.15))
                                    .frame(width: 150, height: 150)
                                    .blur(radius: 12)
                                
                                // Glass circle
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 140, height: 140)
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
                                                lineWidth: 2
                                            )
                                    )
                                    .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)
                                    .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                                
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 55, weight: .semibold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                AppColors.darkBlue,
                                                AppColors.brandBlue
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            }
                            
                            // Red notification badge (glass effect)
                            ZStack {
                                // Badge glow
                                Circle()
                                    .fill(Color.red.opacity(0.3))
                                    .frame(width: 32, height: 32)
                                    .blur(radius: 4)
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.red,
                                                Color.red.opacity(0.8)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                                    )
                                    .shadow(color: Color.red.opacity(0.4), radius: 6, x: 0, y: 3)
                                
                                Text("1")
                                    .font(.poppins(.semiBold, size: 13))
                                    .foregroundColor(.white)
                            }
                            .offset(x: 12, y: -8)
                        }
                        .padding(.top, 32)
                        
                        // MARK: - Title
                        Text(languageManager.localized("stay_updated"))
                            .font(.poppins(.bold, size: 24))
                            .foregroundColor(AppColors.darkBlue)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 24)
                        
                        // MARK: - Subtitle
                        Text(languageManager.localized("notification_permission_subtitle"))
                            .font(.poppins(.regular, size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 32)
                            .lineSpacing(2)
                        
                        // MARK: - Feature Cards
                        VStack(spacing: 16) {
                            NotificationFeatureCard(
                                icon: "calendar.badge.clock",
                                title: languageManager.localized("appointment_reminders"),
                                subtitle: languageManager.localized("never_miss_appointments")
                            )
                            
                            NotificationFeatureCard(
                                icon: "person.2.fill",
                                title: languageManager.localized("queue_updates"),
                                subtitle: languageManager.localized("realtime_turn_notification")
                            )
                            
                            NotificationFeatureCard(
                                icon: "info.circle.fill",
                                title: languageManager.localized("important_alerts"),
                                subtitle: languageManager.localized("urgent_announcements")
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        // MARK: - Buttons
                        VStack(spacing: 12) {
                            // Primary Button
                            PrimaryButton(title: languageManager.localized("enable_notification")) {
                                // Request notification permission
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                                    // Navigate regardless of result (no backend needed)
                                    DispatchQueue.main.async {
                                        router.hasCompletedOnboarding = true
                                        router.selectedTab = .home
                                        // Clear navigation stack and navigate fresh to home
                                        router.path = NavigationPath()
                                        router.navigate(to: .home)
                                    }
                                }
                            }
                            
                            // Secondary Button
                            Button {
                                router.hasCompletedOnboarding = true
                                router.selectedTab = .home
                                // Clear navigation stack and navigate fresh to home
                                router.path = NavigationPath()
                                router.navigate(to: .home)
                            } label: {
                                Text(languageManager.localized("skip_for_now"))
                                    .font(.poppins(.semiBold, size: 17))
                                    .foregroundColor(AppColors.brandBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(AppColors.brandBlue, lineWidth: 2)
                                    )
                                    .cornerRadius(14)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                    }
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height, alignment: .center)
                }
                } // GeometryReader
            }
        }
    }
}

// MARK: - Notification Feature Card Component (Liquid Glass Style)
struct NotificationFeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with glass effect
            ZStack {
                // Outer glow
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppColors.brandBlue.opacity(0.2))
                    .frame(width: 52, height: 52)
                    .blur(radius: 6)
                
                // Glass rectangle
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.regularMaterial)
                    .frame(width: 48, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                AppColors.brandBlue,
                                AppColors.darkBlue.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.poppins(.semiBold, size: 16))
                    .foregroundColor(AppColors.darkBlue)
                
                Text(subtitle)
                    .font(.poppins(.regular, size: 12))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(18)
        .background(
            ZStack {
                // Glass material base
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                // Subtle gradient overlay
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Light edge highlight
                RoundedRectangle(cornerRadius: 16, style: .continuous)
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
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NotificationPermissionView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
