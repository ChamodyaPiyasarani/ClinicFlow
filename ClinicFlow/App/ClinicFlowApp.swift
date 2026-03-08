//
//  ClinicFlowApp.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-25.
//

import SwiftUI

@main
struct ClinicFlowApp: App {
    @State private var languageManager = LanguageManager.shared
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                SplashScreenView()
                    .navigationBarHidden(true)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .splash:
                            SplashScreenView()
                                .navigationBarHidden(true)
                        case .languageSelection:
                            LanguageSelectionView()
                                .navigationBarHidden(true)
                        case .userSignUp:
                            UserSignUpView()
                                .navigationBarHidden(true)
                        case .termsConditions:
                            TermsConditionsView()
                                .navigationBarHidden(true)
                        case .otpVerification:
                            OTPVerificationView()
                                .navigationBarHidden(true)
                        case .locationPermission:
                            LocationPermissionView()
                                .navigationBarHidden(true)
                        case .notificationPermission:
                            NotificationPermissionView()
                                .navigationBarHidden(true)
                        case .home:
                            ContentView()
                                .navigationBarHidden(true)
                        case .helpSupport:
                            HelpSupportView()
                        case .opdDepartments:
                            OPDDepartmentsView()
                                .navigationBarHidden(true)
                        case .labTests:
                            LabTestsView()
                                .navigationBarHidden(true)
                        case .pharmacy:
                            PharmacyView()
                                .navigationBarHidden(true)
                        case .notifications:
                            NotificationsView()
                                .navigationBarHidden(true)
                        case .patientProfiles:
                            PatientProfilesView()
                                .navigationBarHidden(true)
                        case .profileDetails(let profile):
                            ProfileDetailsView(profile: profile)
                                .navigationBarHidden(true)
                        }
                    }
            }
            .environment(languageManager)
            .environment(router)
        }
    }
}
