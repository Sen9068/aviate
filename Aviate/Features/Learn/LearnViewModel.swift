import MapKit
import Observation

@MainActor
@Observable
final class LearnViewModel {
    var segment: LearnSegment = .path
    var sheetDetent: SheetDetent = .medium
    var historyLayout: HistoryLayout = .list
    var camera: MapCameraPosition = .automatic

    // Sample data; replaced by SwiftData-backed repositories in later steps.
    let route = RouteStop.samples
    let history = LessonHistoryItem.samples
    let streak = 23
    let fuel = 4
    let maxFuel = 5
    let coins = 340
    let totalXP = 1_240
    let dailyQuestCount = 3
}
