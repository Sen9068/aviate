import MapKit
import SwiftUI

struct LearnView: View {
    @State private var model = LearnViewModel()
    @Environment(AppRouter.self) private var router

    var body: some View {
        MapSheetScaffold(detent: $model.sheetDetent) {
            MapBackground(position: $model.camera) {
                RouteMapContent(stops: model.route)
            }
        } header: {
            VStack(spacing: Metrics.stackSpacing) {
                AppTopBar(title: "Learn")

                Group {
                    StatRow(streak: model.streak, fuel: model.fuel, maxFuel: model.maxFuel,
                            coins: model.coins, xp: model.totalXP)

                    GlassSegmentedControl(selection: $model.segment, options: LearnSegment.allCases) { segment in
                        switch segment {
                        case .path: "Path"
                        case .review: "Review"
                        case .practice: "Practice"
                        }
                    }
                }
                .padding(.horizontal, Metrics.screenPadding)
            }
        } content: {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    switch model.segment {
                    case .path:
                        pathContent
                    case .review:
                        ContentUnavailableView(
                            "No reviews due",
                            systemImage: "arrow.triangle.2.circlepath",
                            description: Text("Concepts you miss will come back here for spaced review.")
                        )
                    case .practice:
                        ContentUnavailableView(
                            "Practice mode",
                            systemImage: "dot.radiowaves.left.and.right",
                            description: Text("Free practice by topic and the ATC radio simulator, with no fuel cost.")
                        )
                    }
                }
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
    }

    @ViewBuilder
    private var pathContent: some View {
        SearchCapsuleButton {
            router.selectedTab = .search
        }

        GroupedCard {
            CardActionRow("Continue lesson", systemImage: "play.circle") {
                router.isLessonPresented = true
            }
            CardActionRow("Daily quests", systemImage: "checklist", badge: model.dailyQuestCount) {
                router.selectedTab = .inbox
            }
        }

        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("History") {
                Text("^[\(model.history.count) lesson](inflect: true)")
                    .textStyle(.helper)
                    .foregroundStyle(Palette.textSecondary)

                IconToggleCapsule(
                    selection: $model.historyLayout,
                    options: HistoryLayout.allCases,
                    systemImage: \.systemImage
                ) { layout in
                    layout == .cards ? "Card view" : "List view"
                }
            }

            HistorySection(items: model.history, layout: model.historyLayout)
        }
    }
}

#Preview {
    LearnView()
        .previewEnvironment()
}
