//
//  LanguageManager.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import SwiftUI

// MARK: - Language Manager
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @AppStorage("selectedLanguage") private var storedLanguage: String = AppLanguage.english.rawValue

    @Published var currentLanguage: AppLanguage {
        didSet {
            storedLanguage = currentLanguage.rawValue
        }
    }

    /// Whether the user has ever selected a language (first launch detection)
    @AppStorage("hasSelectedLanguage") var hasSelectedLanguage: Bool = false

    init() {
        let stored = AppStorage(wrappedValue: AppLanguage.english.rawValue, "selectedLanguage")
        self.currentLanguage = AppLanguage(rawValue: stored.wrappedValue) ?? .english
    }

    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
        hasSelectedLanguage = true
    }

    /// Get a localized string for the given key
    func localized(_ key: String) -> String {
        return LocalizedStrings.get(key, for: currentLanguage)
    }
}

// MARK: - Environment Key
struct LanguageManagerKey: EnvironmentKey {
    static let defaultValue = LanguageManager.shared
}

extension EnvironmentValues {
    var languageManager: LanguageManager {
        get { self[LanguageManagerKey.self] }
        set { self[LanguageManagerKey.self] = newValue }
    }
}

// MARK: - Convenient View Extension
extension View {
    func localizedText(_ key: String, languageManager: LanguageManager) -> String {
        return languageManager.localized(key)
    }
}
