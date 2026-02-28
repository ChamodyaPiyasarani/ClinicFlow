//
//  PrimaryButton.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import SwiftUI

/// Reusable primary action button with rounded corners and brand styling.
struct PrimaryButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.poppins(.semiBold, size: 17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.brandBlue)
                .cornerRadius(14)
        }
    }
}

#Preview {
    PrimaryButton(title: "Send OTP") { }
        .padding(.horizontal, 28)
}
