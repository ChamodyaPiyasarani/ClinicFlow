import SwiftUI
import Observation

/// Defines all navigable routes in the app.
enum AppRoute: Hashable {
    case splash
    case languageSelection
    case userSignUp
    case termsConditions
    case otpVerification
    case locationPermission
    case notificationPermission
    case home
    case helpSupport
    case opdDepartments
    case labTests
    case pharmacy
    case notifications
    case patientProfiles
    case profileDetails(PatientProfile)
    case visitHistory
    case bookAppointment
    case patientDetailsForm(doctor: Doctor, department: ClinicDepartment, date: Date, timeSlot: TimeSlot)
    case appointmentReview(doctor: Doctor, department: ClinicDepartment, date: Date, timeSlot: TimeSlot, patientName: String, contactNumber: String, reasonForVisit: String)
    case appointmentConfirmed(Appointment)
    case appointmentDetail(Appointment)
    case pastAppointmentDetail(Appointment)
    case cancelAppointment(Appointment)
    case rescheduleAppointment(Appointment)
    case queueStatus(QueueStatus)
    case afterVisitProgress(VisitJourney)
    case settings
}

/// Centralized navigation manager using NavigationStack path.
@Observable
class AppRouter {
    static let shared = AppRouter()
    
    var path = NavigationPath()
    var selectedTab: BottomTab = .home
    var splashScreenId = UUID()

    /// Whether the user has completed the full onboarding flow.
    /// Persisted so returning users skip straight to Home.
    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding") }
    }

    func navigate(to route: AppRoute) {
        path.append(route)
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func goToRoot() {
        path = NavigationPath()
        splashScreenId = UUID() // Force splash screen to recreate
    }
}
