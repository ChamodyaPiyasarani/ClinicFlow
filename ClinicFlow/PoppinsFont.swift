//
//  PoppinsFont.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-25.
//

import SwiftUI

enum PoppinsFont: String {
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case semiBold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
    case extraBold = "Poppins-ExtraBold"
    case black = "Poppins-Black"
    case light = "Poppins-Light"
}

extension Font {
    static func poppins(_ weight: PoppinsFont = .regular, size: CGFloat) -> Font {
        return .custom(weight.rawValue, size: size)
    }
}

extension View {
    func poppinsFont(_ weight: PoppinsFont = .regular, size: CGFloat) -> some View {
        self.font(.poppins(weight, size: size))
    }
}
