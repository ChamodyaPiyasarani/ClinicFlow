//
//  NotificationItem.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-03-03.
//

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
