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
    @State private var router = AppRouter.shared
    @State private var toastManager = ToastManager.shared

    init() {
        FontRegistrar.registerAllFonts()
    }

    var body: some Scene {
        WindowGroup {
            RootView(router: router)
                .environment(languageManager)
                .environment(router)
                .environment(toastManager)
        }
    }
}

// MARK: - Root View with Toast Overlay

private struct RootView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(ToastManager.self) var toastManager
    
    @Bindable var router: AppRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            SplashScreenView()
                .id(router.splashScreenId)
                .navigationBarHidden(true)
                .navigationDestination(for: AppRoute.self) { route in
                    Group {
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
                        case .visitHistory:
                            VisitHistoryView()
                                .navigationBarHidden(true)
                        case .bookAppointment:
                            BookAppointmentView()
                                .navigationBarHidden(true)
                        case .patientDetailsForm(let doctor, let department, let date, let timeSlot):
                            PatientDetailsFormView(doctor: doctor, department: department, selectedDate: date, selectedTimeSlot: timeSlot)
                                .navigationBarHidden(true)
                        case .appointmentReview(let doctor, let department, let date, let timeSlot, let patientName, let contactNumber, let reason):
                            AppointmentReviewView(doctor: doctor, department: department, selectedDate: date, selectedTimeSlot: timeSlot, patientName: patientName, contactNumber: contactNumber, reasonForVisit: reason)
                                .navigationBarHidden(true)
                        case .appointmentConfirmed(let appointment):
                            AppointmentConfirmedView(appointment: appointment)
                                .navigationBarHidden(true)
                        case .appointmentDetail(let appointment):
                            AppointmentDetailView(appointment: appointment)
                                .navigationBarHidden(true)
                        case .pastAppointmentDetail(let appointment):
                            PastAppointmentDetailView(appointment: appointment)
                                .navigationBarHidden(true)
                        case .cancelAppointment(let appointment):
                            CancelAppointmentView(appointment: appointment)
                                .navigationBarHidden(true)
                        case .rescheduleAppointment(let appointment):
                            RescheduleAppointmentView(appointment: appointment)
                                .navigationBarHidden(true)
                        case .queueStatus(let queueStatus):
                            QueueStatusView(queueStatus: queueStatus)
                                .navigationBarHidden(true)
                        case .afterVisitProgress(let journey):
                            AfterVisitProgressView(journey: journey)
                                .navigationBarHidden(true)
                        case .settings:
                            SettingsView()
                                .navigationBarHidden(true)
                        }
                    }
                }
        }
        .toastOverlay()
    }
}
