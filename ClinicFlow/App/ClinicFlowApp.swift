//
//  ClinicFlowApp.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-25.
//

import SwiftUI

@main
struct ClinicFlowApp: App {
    @StateObject private var languageManager = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(languageManager)
        }
    }
}
