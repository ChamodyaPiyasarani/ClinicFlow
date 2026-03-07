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
}

/// Centralized navigation manager using NavigationStack path.
@Observable
class AppRouter {
    static let shared = AppRouter()
    
    var path = NavigationPath()

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
    }
}
