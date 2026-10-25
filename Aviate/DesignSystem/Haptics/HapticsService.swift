import CoreHaptics
import SwiftUI
import UIKit

/// All haptics in Aviate go through this service, so the user's "Haptics" setting can
/// switch them off in one place. Inject it with `.environment(\.haptics, ...)`.
@MainActor
final class HapticsService {
    var isEnabled = true

    private var engine: CHHapticEngine?

    nonisolated init() {}

    // MARK: Simple feedback (taps, selection changes)

    func tap(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    func selection() {
        guard isEnabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }

    // MARK: Signature patterns

    /// Correct answer / lesson complete: main gear, nose gear, then a short roll-out rumble.
    func touchdown() { play(.touchdown, fallback: .success) }

    /// Wrong answer: two sharp taps.
    func error() { play(.doubleTap, fallback: .error) }

    /// Level-up and rank-up: a rumble that builds in intensity.
    func levelUp() { play(.risingRumble, fallback: .success) }

    // MARK: Engine

    private func play(_ pattern: HapticPattern, fallback: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        guard let engine = runningEngine() else {
            UINotificationFeedbackGenerator().notificationOccurred(fallback)
            return
        }
        do {
            let player = try engine.makePlayer(with: pattern.make())
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            UINotificationFeedbackGenerator().notificationOccurred(fallback)
        }
    }

    /// Lazily creates the engine. The engine auto-shuts down when idle, so it's restarted before every pattern.
    private func runningEngine() -> CHHapticEngine? {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return nil }
        if engine == nil {
            engine = try? CHHapticEngine()
            engine?.isAutoShutdownEnabled = true
        }
        do {
            try engine?.start()
        } catch {
            engine = nil
        }
        return engine
    }
}

private enum HapticPattern {
    case touchdown, doubleTap, risingRumble

    func make() throws -> CHHapticPattern {
        switch self {
        case .touchdown:
            return try CHHapticPattern(events: [
                .transient(at: 0, intensity: 0.7, sharpness: 0.35),
                .transient(at: 0.12, intensity: 0.5, sharpness: 0.25),
                .continuous(at: 0.14, duration: 0.25, intensity: 0.3, sharpness: 0.1),
            ], parameters: [])

        case .doubleTap:
            return try CHHapticPattern(events: [
                .transient(at: 0, intensity: 0.9, sharpness: 0.8),
                .transient(at: 0.11, intensity: 0.9, sharpness: 0.8),
            ], parameters: [])

        case .risingRumble:
            let duration = 0.9
            let ramp = CHHapticParameterCurve(
                parameterID: .hapticIntensityControl,
                controlPoints: [
                    .init(relativeTime: 0, value: 0.15),
                    .init(relativeTime: duration, value: 1.0),
                ],
                relativeTime: 0
            )
            return try CHHapticPattern(
                events: [
                    .continuous(at: 0, duration: duration, intensity: 1, sharpness: 0.2),
                    .transient(at: duration, intensity: 1, sharpness: 0.6),
                ],
                parameterCurves: [ramp]
            )
        }
    }
}

private extension CHHapticEvent {
    static func transient(at time: TimeInterval, intensity: Float, sharpness: Float) -> CHHapticEvent {
        CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
            ],
            relativeTime: time
        )
    }

    static func continuous(at time: TimeInterval, duration: TimeInterval, intensity: Float, sharpness: Float) -> CHHapticEvent {
        CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
            ],
            relativeTime: time,
            duration: duration
        )
    }
}

extension EnvironmentValues {
    @Entry var haptics: HapticsService = HapticsService()
}
