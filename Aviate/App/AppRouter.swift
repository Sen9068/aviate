import Observation

enum AppTab: Hashable {
    case learn, hangar, inbox, atlas, search
}

/// App-wide navigation state, injected through the environment.
@MainActor
@Observable
final class AppRouter {
    var selectedTab: AppTab = .learn
    var isProfilePresented = false
    var isLessonPresented = false

    // Placeholders until the auth and gamification steps provide real data.
    var pilotDisplayName = "Aviator"
    var inboxBadgeCount = 3

    var pilotInitial: String {
        pilotDisplayName.first.map { String($0).uppercased() } ?? "?"
    }
}
