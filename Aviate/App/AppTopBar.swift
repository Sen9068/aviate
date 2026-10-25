import SwiftUI

/// The standard top bar wired to app navigation: [+ start lesson][✈︎ Hangar] · title · avatar.
struct AppTopBar: View {
    let title: LocalizedStringKey

    @Environment(AppRouter.self) private var router

    var body: some View {
        TopBar(
            title: title,
            actions: [
                TopBarAction(systemImage: "plus", label: "Start next lesson") {
                    router.isLessonPresented = true
                },
                TopBarAction(systemImage: "airplane", label: "Hangar") {
                    router.selectedTab = .hangar
                },
            ],
            avatarInitial: router.pilotInitial,
            showsNotificationDot: router.inboxBadgeCount > 0
        ) {
            router.isProfilePresented = true
        }
    }
}
