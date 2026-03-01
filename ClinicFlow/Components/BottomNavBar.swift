//
//  BottomNavBar.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-03-01.
//

import SwiftUI

/// The four tabs available in the bottom navigation bar.
enum BottomTab: CaseIterable {
    case home
    case map
    case appointment
    case account

    /// Localization key for each tab label.
    var localizationKey: String {
        switch self {
        case .home:        return "tab_home"
        case .map:         return "tab_map"
        case .appointment: return "tab_appointment"
        case .account:     return "tab_account"
        }
    }

    /// SF Symbol name for each tab.
    var icon: String {
        switch self {
        case .home:        return "house.fill"
        case .map:         return "map.fill"
        case .appointment: return "calendar"
        case .account:     return "person.circle"
        }
    }
}

/// Reusable bottom navigation bar component with localized labels.
struct BottomNavBar: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var selectedTab: BottomTab

    var body: some View {
        HStack {
            ForEach(BottomTab.allCases, id: \.self) { tab in
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: tab.icon)
                        .font(.system(size: 22))
                    Text(languageManager.localized(tab.localizationKey))
                        .font(.poppins(.medium, size: 11))
                }
                .foregroundColor(selectedTab == tab ? AppColors.darkBlue : .gray)
                .onTapGesture {
                    selectedTab = tab
                }
                Spacer()
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(
            Color.white
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -4)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    @Previewable @State var tab: BottomTab = .home
    BottomNavBar(selectedTab: $tab)
        .environment(LanguageManager.shared)
}
