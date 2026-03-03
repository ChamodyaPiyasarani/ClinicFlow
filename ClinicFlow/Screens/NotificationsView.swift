//
//  NotificationsView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-03-03.
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AppRouter.self) var router
    @State private var selectedTab: BottomTab = .home
    @State private var notifications: [NotificationItem] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──
            NotificationHeader(
                onBack: { dismiss() },
                onClearAll: { clearAllNotifications() }
            )
            
            // ── Notifications List ──
            if notifications.isEmpty {
                EmptyNotificationsView()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(notifications) { notification in
                            NotificationRow(notification: notification)
                            
                            // Divider
                            if notification.id != notifications.last?.id {
                                Divider()
                                    .padding(.leading, 72)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Spacer()
            
            // ── Bottom Navigation Bar ──
            BottomNavBar(selectedTab: $selectedTab)
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            loadHardcodedNotifications()
        }
    }
    
    private func loadHardcodedNotifications() {
        notifications = [
            NotificationItem(
                iconName: "person.2.fill",
                iconBackgroundColor: Color.orange.opacity(0.15),
                title: "Queue Update",
                description: "Your queue number is 12. Please proceed to Room 3 for consultation.",
                timestamp: "2 min ago",
                isUnread: true
            ),
            NotificationItem(
                iconName: "flask.fill",
                iconBackgroundColor: Color.green.opacity(0.15),
                title: "Lab Results Ready",
                description: "Your blood test results are now available. Tap to view details.",
                timestamp: "1 hour ago",
                isUnread: false
            ),
            NotificationItem(
                iconName: "calendar.badge.checkmark",
                iconBackgroundColor: Color.blue.opacity(0.15),
                title: "Appointment Confirmed",
                description: "Your appointment with Dr. Sarah Wilson is confirmed for 3:30 PM today.",
                timestamp: "2 hours ago",
                isUnread: false
            ),
            NotificationItem(
                iconName: "bell.fill",
                iconBackgroundColor: Color.red.opacity(0.15),
                title: "Appointment Reminder",
                description: "Don't forget your follow-up appointment tomorrow at 10:00 AM.",
                timestamp: "Yesterday",
                isUnread: false
            )
        ]
    }
    
    private func clearAllNotifications() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            notifications.removeAll()
        }
        
        // Haptic feedback
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }
}

// MARK: - Header
private struct NotificationHeader: View {
    let onBack: () -> Void
    let onClearAll: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                // Back button
                BackButton(action: onBack)
                
                Spacer()
                
                // Clear All button
                Button(action: onClearAll) {
                    Text("Clear All")
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(AppColors.brandBlue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Title section
            VStack(spacing: 4) {
                Text("CLINICFLOW")
                    .font(.poppins(.bold, size: 20))
                    .foregroundColor(AppColors.darkBlue)
                
                Text("Notifications")
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(Color.gray.opacity(0.8))
            }
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Notification Row
private struct NotificationRow: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Notification icon
            ZStack {
                Circle()
                    .fill(notification.iconBackgroundColor)
                    .frame(width: 48, height: 48)
                
                Image(systemName: notification.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(getIconColor())
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(notification.title)
                        .font(.poppins(.semiBold, size: 15))
                        .foregroundColor(AppColors.darkBlue)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Timestamp and unread indicator
                    HStack(spacing: 8) {
                        Text(notification.timestamp)
                            .font(.poppins(.regular, size: 12))
                            .foregroundColor(Color.gray.opacity(0.6))
                        
                        if notification.isUnread {
                            Circle()
                                .fill(AppColors.brandBlue)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                
                Text(notification.description)
                    .font(.poppins(.regular, size: 13))
                    .foregroundColor(Color.gray.opacity(0.8))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }
    
    private func getIconColor() -> Color {
        // Extract the base color from the background
        if notification.iconBackgroundColor.description.contains("orange") {
            return Color.orange
        } else if notification.iconBackgroundColor.description.contains("green") {
            return Color.green
        } else if notification.iconBackgroundColor.description.contains("blue") {
            return Color.blue
        } else if notification.iconBackgroundColor.description.contains("red") {
            return Color.red
        }
        return AppColors.brandBlue
    }
}

// MARK: - Empty State
private struct EmptyNotificationsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "bell.slash.fill")
                .font(.system(size: 64))
                .foregroundColor(Color.gray.opacity(0.3))
            
            Text("No Notifications")
                .font(.poppins(.semiBold, size: 18))
                .foregroundColor(AppColors.darkBlue)
            
            Text("You're all caught up!")
                .font(.poppins(.regular, size: 14))
                .foregroundColor(Color.gray.opacity(0.7))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
            .environment(AppRouter())
            .environment(LanguageManager())
    }
}
