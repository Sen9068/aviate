import SwiftUI

@main
struct AviateApp: App {
    @State private var router = AppRouter()
    private let haptics = HapticsService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .environment(\.haptics, haptics)
                .preferredColorScheme(.dark)
                .tint(Palette.accent)
        }
    }
}
