import SwiftUI

/// A compact language switcher that displays the current language letter in a circle.
/// Tapping opens a system menu to pick from the available languages.
struct LanguageSwitcher: View {
    @Environment(LanguageManager.self) var languageManager

    /// Icon text size. Defaults to 16.
    var fontSize: CGFloat = 16

    /// Whether to show the circular background. Defaults to true.
    var showBackground: Bool = true

    var body: some View {
        Menu {
            ForEach(AppLanguage.allCases) { language in
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        languageManager.setLanguage(language)
                    }
                }) {
                    if language == languageManager.currentLanguage {
                        Label(
                            "\(language.letterIcon)  \(language.displayName)",
                            systemImage: "checkmark"
                        )
                    } else {
                        Text("\(language.letterIcon)  \(language.displayName)")
                    }
                }
            }
        } label: {
            if showBackground {
                ZStack {
                    Circle()
                        .fill(AppColors.darkBlue.opacity(0.08))
                        .frame(width: 44, height: 44)

                    Text(languageManager.currentLanguage.letterIcon)
                        .font(.system(size: fontSize, weight: .semibold))
                        .foregroundColor(AppColors.darkBlue)
                }
            } else {
                Text(languageManager.currentLanguage.letterIcon)
                    .font(.system(size: fontSize, weight: .semibold))
                    .foregroundColor(AppColors.darkBlue)
                    .frame(minWidth: 44, minHeight: 44)
            }
        }
        .accessibilityLabel("Language: \(languageManager.currentLanguage.displayName)")
    }
}
