//
//  OTPTextField.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

import SwiftUI

/// A modern OTP input field with individual digit boxes.
struct OTPTextField: View {
    let length: Int
    @Binding var code: String
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            // Hidden TextField to capture keyboard input
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 0, height: 0)
                .opacity(0)
                .focused($isFocused)
                .onChange(of: code) { _, newValue in
                    // Limit to the specified length & digits only
                    let filtered = String(newValue.filter { $0.isNumber }.prefix(length))
                    if filtered != newValue {
                        code = filtered
                    }
                }

            // Visible digit boxes
            HStack(spacing: 12) {
                ForEach(0..<length, id: \.self) { index in
                    let digit = digitAt(index)
                    let isCurrentIndex = code.count == index
                    let isFilled = digit != nil

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)

                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isCurrentIndex && isFocused
                                    ? AppColors.brandBlue
                                    : isFilled
                                        ? AppColors.brandBlue.opacity(0.5)
                                        : Color.gray.opacity(0.25),
                                lineWidth: isCurrentIndex && isFocused ? 2 : 1
                            )

                        if let digit = digit {
                            Text(String(digit))
                                .font(.poppins(.semiBold, size: 24))
                                .foregroundColor(AppColors.darkBlue)
                        }

                        // Cursor blink for current position
                        if isCurrentIndex && isFocused {
                            RoundedRectangle(cornerRadius: 1)
                                .fill(AppColors.brandBlue)
                                .frame(width: 2, height: 24)
                                .modifier(BlinkModifier())
                        }
                    }
                    .frame(width: 50, height: 56)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
        }
    }

    private func digitAt(_ index: Int) -> Character? {
        let codeArray = Array(code)
        return index < codeArray.count ? codeArray[index] : nil
    }
}

// MARK: - Blink Animation Modifier
private struct BlinkModifier: ViewModifier {
    @State private var visible = true

    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    visible = false
                }
            }
    }
}

#Preview {
    OTPTextField(length: 4, code: .constant("12"))
        .padding()
        .background(AppColors.background)
}
