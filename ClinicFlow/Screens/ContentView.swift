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
                    MapView()
                case .appointment:
                    VStack {
                        Spacer()
                        Text(languageManager.localized("tab_appointment"))
                            .font(.poppins(.regular, size: 17))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background)
                case .account:
                    AccountView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Bottom Navigation Bar
            BottomNavBar(selectedTab: $selectedTab)
        }
        .background(AppColors.background)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
        .environment(LanguageManager.shared)
}
