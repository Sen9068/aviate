import MapKit
import SwiftUI

/// The learning path drawn on the map: flown legs solid blue, upcoming legs dashed gray.
struct RouteMapContent: MapContent {
    let stops: [RouteStop]

    /// Index of the furthest unlocked stop: the boundary between flown and upcoming legs.
    private var lastReachedIndex: Int? {
        stops.lastIndex { $0.status != .locked } ?? stops.indices.first
    }

    private var flownCoordinates: [CLLocationCoordinate2D] {
        guard let index = lastReachedIndex else { return [] }
        return stops[...index].map(\.coordinate)
    }

    private var upcomingCoordinates: [CLLocationCoordinate2D] {
        guard let index = lastReachedIndex else { return [] }
        return stops[index...].map(\.coordinate)
    }

    var body: some MapContent {
        MapPolyline(coordinates: upcomingCoordinates, contourStyle: .geodesic)
            .stroke(Palette.textSecondary.opacity(0.8), style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [6, 6]))

        MapPolyline(coordinates: flownCoordinates, contourStyle: .geodesic)
            .stroke(Palette.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))

        ForEach(stops) { stop in
            Annotation(stop.id, coordinate: stop.coordinate) {
                AirportNode(status: stop.status)
                    .accessibilityLabel(Text("\(stop.id), \(stop.unitTitle)"))
            }
        }
    }
}

/// Airport marker. The current unit pulses and carries the pilot's plane.
struct AirportNode: View {
    let status: RouteStop.Status

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            if status == .current && !reduceMotion {
                Circle()
                    .stroke(Palette.accent, lineWidth: 2)
                    .frame(width: 34, height: 34)
                    .scaleEffect(isPulsing ? 1.8 : 1)
                    .opacity(isPulsing ? 0 : 0.9)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.6).repeatForever(autoreverses: false)) {
                            isPulsing = true
                        }
                    }
            }

            Circle()
                .fill(fill)
                .frame(width: status == .current ? 34 : 26, height: status == .current ? 34 : 26)
                .overlay(Circle().stroke(.white.opacity(status == .locked ? 0.3 : 0.9), lineWidth: 2))

            Image(systemName: symbol)
                .font(.system(size: status == .current ? 15 : 11, weight: .bold))
                .foregroundStyle(status == .locked ? Palette.textSecondary : .white)
        }
        .frame(width: 64, height: 64)
    }

    private var fill: Color {
        status == .locked ? Palette.divider : Palette.accent
    }

    private var symbol: String {
        switch status {
        case .completed: "checkmark"
        case .current: "airplane"
        case .locked: "lock.fill"
        }
    }
}
