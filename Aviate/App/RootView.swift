import SwiftUI

/// Native iOS 26 Liquid Glass tab bar: four tabs plus the separate circular Search button.
struct RootView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.haptics) private var haptics

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            Tab("Learn", systemImage: "airplane", value: AppTab.learn) {
                LearnView()
            }
            Tab("Hangar", systemImage: "wrench.and.screwdriver", value: AppTab.hangar) {
                HangarView()
            }
            Tab("Inbox", systemImage: "tray", value: AppTab.inbox) {
                InboxView()
            }
            .badge(router.inboxBadgeCount)
            Tab("Atlas", systemImage: "rectangle.stack", value: AppTab.atlas) {
                AtlasView()
            }
            Tab(value: AppTab.search, role: .search) {
                SearchView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .onChange(of: router.selectedTab) {
            haptics.selection()
        }
        .sheet(isPresented: $router.isProfilePresented) {
            ProfileView()
        }
        .fullScreenCover(isPresented: $router.isLessonPresented) {
            LessonView()
        }
    }
}

#Preview {
    RootView()
        .previewEnvironment()
}
