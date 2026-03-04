//
//  AppColors.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import SwiftUI

/// Centralized color definitions used across the app.
struct AppColors {
    static let brandBlue = Color(red: 100/255, green: 140/255, blue: 200/255)
    static let lightBlue = Color(red: 130/255, green: 165/255, blue: 215/255)
    static let darkBlue = Color(red: 45/255, green: 74/255, blue: 115/255) // #2D4A73
    static let background = Color(red: 245/255, green: 247/255, blue: 250/255)
    
    // Gradient colors for cards
    static let gradientBlueStart = Color(red: 95/255, green: 135/255, blue: 195/255)
    static let gradientBlueEnd = Color(red: 115/255, green: 155/255, blue: 205/255)
    
    // Service card colors
    static let opdBlue = Color(red: 90/255, green: 130/255, blue: 185/255)
    static let labGreen = Color(red: 75/255, green: 165/255, blue: 155/255)
    static let pharmacyGreen = Color(red: 85/255, green: 175/255, blue: 130/255)
}
