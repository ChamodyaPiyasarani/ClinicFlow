//
//  LocalizedStrings.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import Foundation

/// Central dictionary for all localized strings across the app.
/// Add new keys here as you build more screens.
struct LocalizedStrings {

    // MARK: - String Tables
    private static let strings: [String: [AppLanguage: String]] = [

        // ── Language Selection Screen ──
        "welcome": [
            .english: "Welcome",
            .sinhala: "ආයුබෝවන්",
            .tamil: "வணக்கம்"
        ],
        "select_language": [
            .english: "Select your preferred language",
            .sinhala: "ඔබේ භාෂාව තෝරන්න",
            .tamil: "உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்"
        ],
        "continue": [
            .english: "Continue",
            .sinhala: "ඉදිරියට",
            .tamil: "தொடரவும்"
        ],

        // ── Common / Navigation ──
        "back": [
            .english: "Back",
            .sinhala: "ආපසු",
            .tamil: "பின்செல்"
        ],
        "next": [
            .english: "Next",
            .sinhala: "ඊළඟ",
            .tamil: "அடுத்து"
        ],
        "cancel": [
            .english: "Cancel",
            .sinhala: "අවලංගු",
            .tamil: "ரத்து"
        ],
        "ok": [
            .english: "OK",
            .sinhala: "හරි",
            .tamil: "சரி"
        ],
        "done": [
            .english: "Done",
            .sinhala: "සම්පූර්ණයි",
            .tamil: "முடிந்தது"
        ],
        "save": [
            .english: "Save",
            .sinhala: "සුරකින්න",
            .tamil: "சேமி"
        ],
        "delete": [
            .english: "Delete",
            .sinhala: "මකන්න",
            .tamil: "நீக்கு"
        ],
        "edit": [
            .english: "Edit",
            .sinhala: "සංස්කරණය",
            .tamil: "திருத்து"
        ],
        "search": [
            .english: "Search",
            .sinhala: "සොයන්න",
            .tamil: "தேடு"
        ],
        "settings": [
            .english: "Settings",
            .sinhala: "සැකසුම්",
            .tamil: "அமைப்புகள்"
        ],
        "profile": [
            .english: "Profile",
            .sinhala: "පැතිකඩ",
            .tamil: "சுயவிவரம்"
        ],
        "home": [
            .english: "Home",
            .sinhala: "මුල් පිටුව",
            .tamil: "முகப்பு"
        ],
        "logout": [
            .english: "Logout",
            .sinhala: "පිටවීම",
            .tamil: "வெளியேறு"
        ],
        "login": [
            .english: "Login",
            .sinhala: "පිවිසීම",
            .tamil: "உள்நுழை"
        ],
        "register": [
            .english: "Register",
            .sinhala: "ලියාපදිංචි වන්න",
            .tamil: "பதிவு"
        ],

        // ── Placeholder – add more screen-specific keys below ──
        "hello_world": [
            .english: "Hello, World!",
            .sinhala: "ආයුබෝවන්, ලෝකය!",
            .tamil: "வணக்கம், உலகம்!"
        ],
    ]

    // MARK: - Lookup
    static func get(_ key: String, for language: AppLanguage) -> String {
        return strings[key]?[language] ?? strings[key]?[.english] ?? key
    }
}
