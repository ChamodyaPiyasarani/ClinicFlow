import SwiftUI

struct ContentView: View {
    @Environment(LanguageManager.self) var languageManager
    @State private var selectedTab: BottomTab = .home

    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .map:
                    VStack {
                        Spacer()
                        Text(languageManager.localized("tab_map"))
                            .font(.poppins(.regular, size: 17))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background)
                case .appointment:
                    VStack {
                        Spacer()
                        Text(languageManager.localized("tab_appointment"))
                            .font(.poppins(.regular, size: 17))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background)
                case .account:
                    VStack {
                        Spacer()
                        Text(languageManager.localized("tab_account"))
                            .font(.poppins(.regular, size: 17))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Bottom Navigation Bar
            BottomNavBar(selectedTab: $selectedTab)
        }
        .background(AppColors.background)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
        .environment(LanguageManager.shared)
}
