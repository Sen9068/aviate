import SwiftUI

extension View {
    /// Injects the same dependencies `AviateApp` does, for `#Preview`s.
    @MainActor
    func previewEnvironment(router: AppRouter = AppRouter()) -> some View {
        environment(router)
            .environment(\.haptics, HapticsService())
            .preferredColorScheme(.dark)
            .tint(Palette.accent)
    }
}
