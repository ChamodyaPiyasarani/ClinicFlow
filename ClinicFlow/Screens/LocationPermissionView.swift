import SwiftUI
import CoreLocation
import Combine

struct LocationPermissionView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router
    @StateObject private var locationManager = LocationManager()
    
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
                        // Location Icon (Liquid Glass Style)
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
                            
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 60, weight: .semibold))
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
                        .padding(.top, 32)
                        
                        // MARK: - Title
                        Text(languageManager.localized("activate_your_visit"))
                            .font(.poppins(.bold, size: 24))
                            .foregroundColor(AppColors.darkBlue)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 24)
                        
                        // MARK: - Subtitle
                        Text(languageManager.localized("location_permission_subtitle"))
                            .font(.poppins(.regular, size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 32)
                            .lineSpacing(2)
                        
                        // MARK: - Feature Cards
                        VStack(spacing: 16) {
                            FeatureCard(
                                icon: "shield.fill",
                                title: languageManager.localized("secure_session_activation"),
                                subtitle: languageManager.localized("verify_presence_subtitle")
                            )
                            
                            FeatureCard(
                                icon: "gearshape.fill",
                                title: languageManager.localized("fair_token_allocation"),
                                subtitle: languageManager.localized("prevents_duplicate_checkins")
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        // MARK: - Buttons
                        VStack(spacing: 12) {
                            // Primary Button
                            PrimaryButton(title: languageManager.localized("enable_location_services")) {
                                locationManager.requestPermission()
                                // Navigate to next screen regardless of permission result
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    router.navigate(to: .notificationPermission)
                                }
                            }
                            
                            // Secondary Button
                            Button {
                                router.navigate(to: .notificationPermission)
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

// MARK: - Feature Card Component (Liquid Glass Style)
struct FeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with glass effect
            ZStack {
                // Outer glow
                Circle()
                    .fill(AppColors.brandBlue.opacity(0.2))
                    .frame(width: 52, height: 52)
                    .blur(radius: 6)
                
                // Glass circle
                Circle()
                    .fill(.regularMaterial)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Circle()
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

// MARK: - Location Manager
@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    nonisolated(unsafe) private let manager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
        }
    }
}

#Preview {
    LocationPermissionView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
