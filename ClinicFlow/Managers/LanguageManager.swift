//
//  LanguageManager.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import SwiftUI
import Observation

// MARK: - Language Manager
@Observable
class LanguageManager {
    static let shared = LanguageManager()

    var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
        }
    }

    /// Whether the user has ever selected a language (first launch detection)
    var hasSelectedLanguage: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSelectedLanguage") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSelectedLanguage") }
    }

    init() {
        let stored = UserDefaults.standard.string(forKey: "selectedLanguage") ?? AppLanguage.english.rawValue
        self.currentLanguage = AppLanguage(rawValue: stored) ?? .english
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

// MARK: - Convenient View Extension
extension View {
    func localizedText(_ key: String, languageManager: LanguageManager) -> String {
        return languageManager.localized(key)
    }
}
