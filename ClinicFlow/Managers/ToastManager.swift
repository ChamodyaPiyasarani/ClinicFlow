import SwiftUI
import Observation

// MARK: - Toast Type

enum ToastType {
    case success
    case error
    case info
    case warning

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error:   return "xmark.circle.fill"
        case .info:    return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return Color(red: 50/255, green: 180/255, blue: 100/255)
        case .error:   return Color(red: 230/255, green: 75/255, blue: 60/255)
        case .info:    return AppColors.brandBlue
        case .warning: return Color(red: 245/255, green: 170/255, blue: 50/255)
        }
    }
}

// MARK: - Toast Item

struct ToastItem: Identifiable, Equatable {
    let id = UUID()
    let type: ToastType
    let messageKey: String
    let duration: Double

    static func == (lhs: ToastItem, rhs: ToastItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Toast Manager

@Observable
class ToastManager {
    static let shared = ToastManager()

    var currentToast: ToastItem?

    private var dismissTask: DispatchWorkItem?

    func show(_ type: ToastType, message key: String, duration: Double = 2.5) {
        dismissTask?.cancel()

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentToast = ToastItem(type: type, messageKey: key, duration: duration)
        }

        let task = DispatchWorkItem { [weak self] in
            withAnimation(.easeOut(duration: 0.3)) {
                self?.currentToast = nil
            }
        }
        dismissTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }

    func dismiss() {
        dismissTask?.cancel()
        withAnimation(.easeOut(duration: 0.25)) {
            currentToast = nil
        }
    }
}
