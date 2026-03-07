import SwiftUI

/// Reusable styled text field with a rounded border.
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(placeholder, text: $text)
            .font(.poppins(.regular, size: 15))
            .keyboardType(keyboardType)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomTextField(placeholder: "User Name", text: .constant(""))
        CustomTextField(placeholder: "Contact Number", text: .constant(""), keyboardType: .phonePad)
    }
    .padding()
    .background(AppColors.background)
}
