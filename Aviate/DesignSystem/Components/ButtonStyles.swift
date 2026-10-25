import SwiftUI

/// Subtle press feedback for custom tappable surfaces (rows, cards, avatar).
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}

/// Full-width blue capsule used for "Continue", "Check", "Start".
struct AviatePrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(isEnabled ? Palette.textPrimary : Palette.textSecondary)
            .frame(maxWidth: .infinity, minHeight: Metrics.buttonHeight)
            .background(isEnabled ? Palette.accent : Palette.divider, in: .capsule)
            .shadow(color: Palette.accent.opacity(isEnabled ? 0.35 : 0), radius: 12, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle { .init() }
}

extension ButtonStyle where Self == AviatePrimaryButtonStyle {
    static var aviatePrimary: AviatePrimaryButtonStyle { .init() }
}

extension View {
    /// The grouped-surface look: #2A2B30 with continuous 28pt corners.
    func cardBackground(cornerRadius: CGFloat = Metrics.cardCornerRadius) -> some View {
        background(Palette.card, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
