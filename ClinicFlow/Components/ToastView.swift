import SwiftUI

// MARK: - Toast View (Liquid Glass Style)

struct ToastView: View {
    let toast: ToastItem
    let languageManager: LanguageManager
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            // Icon with glass effect
            ZStack {
                // Icon glow
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 38, height: 38)
                    .blur(radius: 4)
                
                // Glass circle
                Circle()
                    .fill(.regularMaterial)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.7),
                                        Color.white.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                Image(systemName: toast.type.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
            }

            // Message
            Text(languageManager.localized(toast.messageKey))
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 4)

            // Dismiss button with glass effect
            Button {
                onDismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(.regularMaterial)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            ZStack {
                // Base glass material
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                // Color tint layer (semi-transparent)
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                toast.type.color.opacity(0.85),
                                toast.type.color.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Light highlight layer (bends light around edges)
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.clear,
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Top edge highlight
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.2),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
        )
        .overlay(
            // Outer border for definition
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
        )
        .shadow(color: toast.type.color.opacity(0.3), radius: 16, x: 0, y: 8)
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
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
