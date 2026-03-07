import SwiftUI

/// A reusable notification bell icon with an optional badge showing the count of new notifications.
/// Taps navigate to the Notifications screen via AppRouter.
struct NotificationIcon: View {
    @Environment(AppRouter.self) var router

    /// Number of unread notifications. Pass 0 or omit to hide the badge.
    var unreadCount: Int = 0

    /// Icon size (SF Symbol font size). Defaults to 22.
    var iconSize: CGFloat = 22

    /// Whether to show the circular background behind the bell icon.
    var showBackground: Bool = true

    var body: some View {
        Button(action: {
            router.navigate(to: .notifications)
        }) {
            ZStack(alignment: .topTrailing) {
                // Bell icon with optional circular background
                if showBackground {
                    ZStack {
                        Circle()
                            .fill(AppColors.darkBlue.opacity(0.08))
                            .frame(width: max(iconSize * 2, 44), height: max(iconSize * 2, 44))
                        Image(systemName: "bell.fill")
                            .font(.system(size: iconSize))
                            .foregroundColor(AppColors.darkBlue)
                    }
                } else {
                    Image(systemName: "bell.fill")
                        .font(.system(size: iconSize))
                        .foregroundColor(AppColors.darkBlue)
                        .frame(minWidth: 44, minHeight: 44)
                }

                // Badge
                if unreadCount > 0 {
                    Text(unreadCount > 99 ? "99+" : "\(unreadCount)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .frame(minWidth: 18, minHeight: 18)
                        .background(
                            Capsule()
                                .fill(Color.red)
                        )
                        .offset(x: showBackground ? 4 : 8, y: showBackground ? 0 : -6)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(unreadCount > 0 ? "Notifications, \(unreadCount) unread" : "Notifications")
    }
}
