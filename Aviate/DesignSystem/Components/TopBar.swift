import SwiftUI

struct TopBarAction: Identifiable {
    let systemImage: String
    let label: LocalizedStringKey
    let handler: @MainActor () -> Void

    var id: String { systemImage }
}

/// Liquid Glass capsule of icon buttons on the left, a centered title, and the avatar on the right.
struct TopBar: View {
    private let title: LocalizedStringKey
    private let actions: [TopBarAction]
    private let avatarInitial: String
    private let showsNotificationDot: Bool
    private let onAvatarTap: @MainActor () -> Void

    @Environment(\.haptics) private var haptics

    init(
        title: LocalizedStringKey,
        actions: [TopBarAction],
        avatarInitial: String,
        showsNotificationDot: Bool = false,
        onAvatarTap: @escaping @MainActor () -> Void
    ) {
        self.title = title
        self.actions = actions
        self.avatarInitial = avatarInitial
        self.showsNotificationDot = showsNotificationDot
        self.onAvatarTap = onAvatarTap
    }

    var body: some View {
        ZStack {
            Text(title)
                .textStyle(.screenTitle)
                .foregroundStyle(Palette.textPrimary)
                .lineLimit(1)
                .accessibilityAddTraits(.isHeader)

            HStack {
                HStack(spacing: 2) {
                    ForEach(actions) { action in
                        Button {
                            haptics.tap()
                            action.handler()
                        } label: {
                            Image(systemName: action.systemImage)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(Palette.textPrimary)
                                .frame(width: Metrics.iconButtonSize, height: Metrics.iconButtonSize)
                                .contentShape(.circle)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(action.label)
                    }
                }
                .padding(3)
                .glassEffect(.regular.interactive(), in: .capsule)

                Spacer(minLength: 0)

                AvatarButton(initial: avatarInitial, showsNotificationDot: showsNotificationDot, action: onAvatarTap)
            }
        }
        .padding(.horizontal, Metrics.stackSpacing)
    }
}

struct AvatarButton: View {
    private let initial: String
    private let showsNotificationDot: Bool
    private let action: @MainActor () -> Void

    @Environment(\.haptics) private var haptics

    init(initial: String, showsNotificationDot: Bool = false, action: @escaping @MainActor () -> Void) {
        self.initial = initial
        self.showsNotificationDot = showsNotificationDot
        self.action = action
    }

    var body: some View {
        Button {
            haptics.tap()
            action()
        } label: {
            Text(initial)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(Palette.textPrimary)
                .frame(width: Metrics.controlHeight, height: Metrics.controlHeight)
                .background(Palette.accent, in: .circle)
                .overlay(alignment: .topTrailing) {
                    if showsNotificationDot {
                        Circle()
                            .fill(Palette.error)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Palette.sheet, lineWidth: 2))
                            .offset(x: 1, y: -1)
                    }
                }
        }
        .buttonStyle(.pressable)
        .accessibilityLabel("Profile")
        .accessibilityValue(showsNotificationDot ? Text("New notifications") : Text(""))
    }
}

#Preview {
    TopBar(
        title: "Learn",
        actions: [
            TopBarAction(systemImage: "plus", label: "Start next lesson") {},
            TopBarAction(systemImage: "airplane", label: "Hangar") {},
        ],
        avatarInitial: "A",
        showsNotificationDot: true
    ) {}
    .padding(.vertical)
    .background(Palette.sheet)
}
