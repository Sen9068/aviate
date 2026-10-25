import MapKit
import SwiftUI

/// Full-bleed dark map that sits behind every tab's sheet.
struct MapBackground<Content: MapContent>: View {
    enum Style {
        /// Muted dark vector map: the default flight-tracker look.
        case muted
        /// Satellite imagery.
        case satellite
    }

    @Binding private var position: MapCameraPosition
    private let style: Style
    private let content: Content

    init(position: Binding<MapCameraPosition>, style: Style = .muted, @MapContentBuilder content: () -> Content) {
        _position = position
        self.style = style
        self.content = content()
    }

    var body: some View {
        Map(position: $position) {
            content
        }
        .mapStyle(mapStyle)
        .environment(\.colorScheme, .dark)
        .overlay(alignment: .top) {
            // Darkens the status-bar area so the sheet and system UI stay legible.
            LinearGradient(colors: [.black.opacity(0.55), .clear], startPoint: .top, endPoint: .bottom)
                .frame(height: 140)
                .allowsHitTesting(false)
        }
    }

    private var mapStyle: MapStyle {
        switch style {
        case .muted:
            .standard(elevation: .realistic, emphasis: .muted, pointsOfInterest: .excludingAll, showsTraffic: false)
        case .satellite:
            .imagery(elevation: .realistic)
        }
    }
}

/// Where the pilot's plane is parked on tabs that don't have their own map content yet.
enum HomeBase {
    static let code = "KPAO"
    static var coordinate: CLLocationCoordinate2D { .init(latitude: 37.4611, longitude: -122.1150) }
    static var camera: MapCameraPosition {
        .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000))
    }
}

struct HomeBaseMapContent: MapContent {
    var body: some MapContent {
        Annotation(HomeBase.code, coordinate: HomeBase.coordinate) {
            Image(systemName: "airplane")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(Palette.accent, in: .circle)
                .overlay(Circle().stroke(.white.opacity(0.9), lineWidth: 2))
        }
    }
}
