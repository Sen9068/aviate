import MapKit
import SwiftUI

/// Map + sheet + top bar + scrolling content, for tabs whose map just shows home base.
struct HomeBaseTabScreen<Content: View>: View {
    private let title: LocalizedStringKey
    private let content: Content

    @State private var detent: SheetDetent = .medium
    @State private var camera = HomeBase.camera

    init(title: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        MapSheetScaffold(detent: $detent) {
            MapBackground(position: $camera) {
                HomeBaseMapContent()
            }
        } header: {
            AppTopBar(title: title)
        } content: {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    content
                }
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
    }
}
