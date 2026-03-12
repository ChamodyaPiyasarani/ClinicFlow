import SwiftUI

// MARK: - Toast View

struct ToastView: View {
    let toast: ToastItem
    let languageManager: LanguageManager
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: toast.type.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            // Message
            Text(languageManager.localized(toast.messageKey))
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.white)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 4)

            // Dismiss button
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(Color.white.opacity(0.15)))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(toast.type.color)
                .shadow(color: toast.type.color.opacity(0.35), radius: 12, x: 0, y: 6)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Toast Overlay Modifier

struct ToastOverlayModifier: ViewModifier {
    @Environment(ToastManager.self) var toastManager
    @Environment(LanguageManager.self) var languageManager

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast = toastManager.currentToast {
                    ToastView(
                        toast: toast,
                        languageManager: languageManager,
                        onDismiss: { toastManager.dismiss() }
                    )
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(999)
                    .gesture(
                        DragGesture(minimumDistance: 10)
                            .onEnded { value in
                                if value.translation.height < -10 {
                                    toastManager.dismiss()
                                }
                            }
                    )
                }
            }
    }
}

// MARK: - View Extension

extension View {
    func toastOverlay() -> some View {
        modifier(ToastOverlayModifier())
    }
}
