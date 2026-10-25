import CoreLocation
import Foundation

/// A unit on the learning route, drawn as an airport on the map.
struct RouteStop: Identifiable, Hashable {
    enum Status: Hashable { case completed, current, locked }

    let id: String          // ICAO code, e.g. "KPAO"
    let unitTitle: String
    let latitude: Double
    let longitude: Double
    let status: Status

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum LearnSegment: CaseIterable, Hashable {
    case path, review, practice
}

enum HistoryLayout: CaseIterable, Hashable {
    case cards, list

    var systemImage: String {
        switch self {
        case .cards: "rectangle.grid.1x2"
        case .list: "list.bullet"
        }
    }
}

struct LessonHistoryItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let systemImage: String
    let date: Date
    let accuracy: Double     // 0...1
    let xpEarned: Int
}

// MARK: - Sample data
// Stand-ins until the content and progress layers exist (onboarding & lesson-engine steps).

extension RouteStop {
    static let samples: [RouteStop] = [
        RouteStop(id: "KPAO", unitTitle: "Phonetic Alphabet", latitude: 37.4611, longitude: -122.1150, status: .completed),
        RouteStop(id: "KSQL", unitTitle: "Radio Basics", latitude: 37.5119, longitude: -122.2495, status: .completed),
        RouteStop(id: "KHAF", unitTitle: "Four Forces", latitude: 37.5134, longitude: -122.5011, status: .current),
        RouteStop(id: "KSFO", unitTitle: "Clearance Delivery", latitude: 37.6188, longitude: -122.3750, status: .locked),
        RouteStop(id: "KOAK", unitTitle: "Angle of Attack", latitude: 37.7213, longitude: -122.2208, status: .locked),
    ]
}

extension LessonHistoryItem {
    static let samples: [LessonHistoryItem] = [
        LessonHistoryItem(id: UUID(), title: "Radio Basics 3", systemImage: "antenna.radiowaves.left.and.right",
                          date: .now.addingTimeInterval(-3_600), accuracy: 1.0, xpEarned: 18),
        LessonHistoryItem(id: UUID(), title: "Radio Basics 2", systemImage: "antenna.radiowaves.left.and.right",
                          date: .now.addingTimeInterval(-90_000), accuracy: 0.86, xpEarned: 12),
        LessonHistoryItem(id: UUID(), title: "Numbers", systemImage: "number",
                          date: .now.addingTimeInterval(-180_000), accuracy: 0.92, xpEarned: 14),
    ]
}
