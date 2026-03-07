import SwiftUI

/// Reusable card component for selecting a language.
struct LanguageOptionCard: View {
    let language: AppLanguage
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Letter icon
                ZStack {
                    Circle()
                        .fill(isSelected ? AppColors.brandBlue : AppColors.brandBlue.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Text(language.letterIcon)
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(isSelected ? .white : AppColors.brandBlue)
                }

                // Language name + subtitle
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.displayName)
                        .font(.poppins(.semiBold, size: 16))
                        .foregroundColor(.black)

                    Text(language.subtitleName)
                        .font(.poppins(.regular, size: 12))
                        .foregroundColor(.gray)
                }

                Spacer()

                // Radio indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? AppColors.brandBlue : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(AppColors.brandBlue)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(
                        color: isSelected ? AppColors.brandBlue.opacity(0.18) : Color.black.opacity(0.04),
                        radius: isSelected ? 8 : 4, x: 0, y: 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? AppColors.brandBlue.opacity(0.5) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        LanguageOptionCard(language: .english, isSelected: true) {}
        LanguageOptionCard(language: .sinhala, isSelected: false) {}
        LanguageOptionCard(language: .tamil, isSelected: false) {}
    }
    .padding()
}
