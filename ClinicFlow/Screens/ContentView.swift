//
//  ContentView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-25.
//

import SwiftUI

struct ContentView: View {
    @Environment(LanguageManager.self) var languageManager
    @State private var selectedTab: BottomTab = .home

    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .map:
                    Text(languageManager.localized("tab_map"))
                        .font(.poppins(.regular, size: 17))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .appointment:
                    Text(languageManager.localized("tab_appointment"))
                        .font(.poppins(.regular, size: 17))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .account:
                    Text(languageManager.localized("tab_account"))
                        .font(.poppins(.regular, size: 17))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Bottom Navigation Bar
            BottomNavBar(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
        .environment(LanguageManager.shared)
}
