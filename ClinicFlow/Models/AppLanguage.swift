import SwiftUI

/// Supported languages in the app.
enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case sinhala = "si"
    case tamil = "ta"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .sinhala: return "සිංහල"
        case .tamil: return "தமிழ்"
        }
    }

    var subtitleName: String {
        switch self {
        case .english: return "ENGLISH"
        case .sinhala: return "SINHALA"
        case .tamil: return "TAMIL"
        }
    }

    var letterIcon: String {
        switch self {
        case .english: return "EN"
        case .sinhala: return "සි"
        case .tamil: return "த"
        }
    }

    var iconColor: Color {
        switch self {
        case .english: return AppColors.brandBlue
        case .sinhala: return AppColors.brandBlue
        case .tamil: return AppColors.brandBlue
        }
    }
}
