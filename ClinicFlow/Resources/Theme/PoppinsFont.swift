import SwiftUI
import CoreText

// MARK: - Poppins Font Weights
// Only the weights that have matching .ttf files in Resources/Fonts/

enum PoppinsFont: String {
    case light    = "Poppins-Light"
    case regular  = "Poppins-Regular"
    case medium   = "Poppins-Medium"
    case semiBold = "Poppins-SemiBold"
    case bold     = "Poppins-Bold"
}

// MARK: - Font Extension

/// Global scale applied to every poppins() call.
/// Adjust this single constant to shift all font sizes up or down uniformly.
private let poppinsSizeScale: CGFloat = 0.88

extension Font {
    static func poppins(_ weight: PoppinsFont = .regular, size: CGFloat) -> Font {
        return .custom(weight.rawValue, size: size * poppinsSizeScale)
    }
}

// MARK: - View Extension

extension View {
    func poppinsFont(_ weight: PoppinsFont = .regular, size: CGFloat) -> some View {
        self.font(.poppins(weight, size: size))
    }
}

// MARK: - Font Registrar
// Programmatically registers all Poppins font files from the app bundle.
// This is required because the project uses GENERATE_INFOPLIST_FILE = YES
// and UIAppFonts cannot be set via Info.plist in that configuration.

enum FontRegistrar {

    static func registerAllFonts() {
        let fontNames = [
            "Poppins-Light",
            "Poppins-Regular",
            "Poppins-Medium",
            "Poppins-SemiBold",
            "Poppins-Bold"
        ]

        for name in fontNames {
            registerFont(named: name)
        }
    }

    private static func registerFont(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else {
            print("⚠️ FontRegistrar: '\(name).ttf' not found in bundle.")
            return
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)

        if success {
            print("✅ FontRegistrar: Registered \(name)")
        } else if let err = error?.takeRetainedValue() {
            let code = CFErrorGetCode(err)
            // Code 105 = already registered — safe to ignore
            if code != 105 {
                print("⚠️ FontRegistrar: Failed to register \(name): \(err)")
            }
        }
    }
}
