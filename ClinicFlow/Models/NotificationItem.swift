import SwiftUI

/// Represents a single notification in the app
struct NotificationItem: Identifiable {
    let id = UUID()
    let iconName: String
    let iconBackgroundColor: Color
    let title: String
    let description: String
    let timestamp: String
    let isUnread: Bool
}
