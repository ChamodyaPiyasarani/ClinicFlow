//
//  AppRouter.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import SwiftUI
import Observation

/// Defines all navigable routes in the app.
enum AppRoute: Hashable {
    case splash
    case languageSelection
    case userSignUp
    case termsConditions
    case otpVerification
}

/// Centralized navigation manager using NavigationStack path.
@Observable
class AppRouter {
    var path = NavigationPath()

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
