//
//  NotificationPermissionView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-03-01.
//

import SwiftUI

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
                        // Notification Icon with Badge
                        ZStack(alignment: .topTrailing) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 140, height: 140)
                                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                                
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 55, weight: .semibold))
                                    .foregroundColor(AppColors.darkBlue)
                            }
                            
                            // Red notification badge
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 28, height: 28)
                                
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
                                // TODO: Request notification permission, then navigate
                                router.navigate(to: .home)
                            }
                            
                            // Secondary Button
                            Button {
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

// MARK: - Notification Feature Card Component
struct NotificationFeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColors.brandBlue.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(AppColors.brandBlue)
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
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    NotificationPermissionView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
