import SwiftUI

struct ContentView: View {
    @Environment(LanguageManager.self) var languageManager
    @Environment(AppRouter.self) var router

    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            Group {
                switch router.selectedTab {
                case .home:
                    HomeView()
                case .map:
                    MapView()
                case .appointment:
                    AppointmentsView()
                case .account:
                    AccountView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Bottom Navigation Bar
            BottomNavBar()
        }
        .background(AppColors.background)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
        .environment(LanguageManager.shared)
        .environment(AppRouter())
}
