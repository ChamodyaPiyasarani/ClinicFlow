//
//  AppNameText.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-03-03.
//

import SwiftUI

/// Reusable app name component displaying "CLINIC" in dark blue and "FLOW" in lighter blue.
struct AppNameText: View {
    var fontSize: CGFloat = 28
    
    var body: some View {
        HStack(spacing: 0) {
            Text("CLINIC")
                .font(.poppins(.extraBold, size: fontSize))
                .foregroundColor(AppColors.darkBlue)
            
            Text("FLOW")
                .font(.poppins(.bold, size: fontSize))
                .foregroundColor(AppColors.brandBlue)
        }
        .tracking(2)
    }
}

#Preview {
    AppNameText()
}
