import SwiftUI

/// The four tabs available in the bottom navigation bar.
enum BottomTab: CaseIterable {
    case home
    case map
    case appointment
    case account

    /// Localization key for each tab label.
    var localizationKey: String {
        switch self {
        case .home:        return "tab_home"
        case .map:         return "tab_map"
        case .appointment: return "tab_appointment"
        case .account:     return "tab_account"
        }
    }

    /// SF Symbol name for each tab.
    var icon: String {
        switch self {
        case .home:        return "house.fill"
        case .map:         return "map.fill"
        case .appointment: return "calendar"
        case .account:     return "person.circle"
        }
    }
}

/// Reusable bottom navigation bar component with localized labels.
struct BottomNavBar: View {
    @Environment(LanguageManager.self) var languageManager
    @Binding var selectedTab: BottomTab
    
    @State private var pressedTab: BottomTab? = nil

    var body: some View {
        HStack(spacing: 0) {
            ForEach(BottomTab.allCases, id: \.self) { tab in
                Button(action: {
                    // Haptic feedback for better UX
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 24, weight: .medium))
                            .frame(height: 28)
                        
                        Text(languageManager.localized(tab.localizationKey))
                            .font(.poppins(.medium, size: 11))
                            .lineLimit(1)
                    }
                    .foregroundColor(selectedTab == tab ? AppColors.darkBlue : Color.gray.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .contentShape(Rectangle())
                    .scaleEffect(pressedTab == tab ? 0.9 : 1.0)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            pressedTab = tab
                        }
                        .onEnded { _ in
                            pressedTab = nil
                        }
                )
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            ZStack {
                // Frosted glass effect (iOS standard)
                Color.white.opacity(0.9)
                
                // Material blur for iOS feel
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -2)
            .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    @Previewable @State var tab: BottomTab = .home
    BottomNavBar(selectedTab: $tab)
        .environment(LanguageManager.shared)
}
