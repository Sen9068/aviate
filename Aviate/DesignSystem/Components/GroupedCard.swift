import SwiftUI

/// Rounded 28pt card that stacks its rows and draws inset dividers between them.
struct GroupedCard<Content: View>: View {
    private let dividerInset: CGFloat
    private let content: Content

    /// - Parameter dividerInset: leading inset of the dividers; the default lines them up
    ///   with the text of a `CardActionRow`.
    init(dividerInset: CGFloat = CardActionRow.textLeadingInset, @ViewBuilder content: () -> Content) {
        self.dividerInset = dividerInset
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            Group(subviews: content) { rows in
                ForEach(rows) { row in
                    row
                    if row.id != rows.last?.id {
                        Rectangle()
                            .fill(Palette.divider)
                            .frame(height: 0.5)
                            .padding(.leading, dividerInset)
                    }
                }
            }
        }
        .cardBackground()
    }
}

/// Icon + large blue label row ("Add a flight" style).
struct CardActionRow: View {
    static let textLeadingInset: CGFloat = 20 + 32 + 16

    private let title: LocalizedStringKey
    private let systemImage: String
    private let badge: Int?
    private let action: @MainActor () -> Void

    @Environment(\.haptics) private var haptics

    init(_ title: LocalizedStringKey, systemImage: String, badge: Int? = nil, action: @escaping @MainActor () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.badge = badge
        self.action = action
    }

    var body: some View {
        Button {
            haptics.tap()
            action()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .font(.system(size: 22))
                    .frame(width: 32)
                    .accessibilityHidden(true)

                Text(title)
                    .textStyle(.largeAction)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Spacer(minLength: 0)

                if let badge, badge > 0 {
                    BadgeView(count: badge)
                }
            }
            .foregroundStyle(Palette.accent)
            .padding(.horizontal, 20)
            .frame(minHeight: 64)
            .contentShape(.rect)
        }
        .buttonStyle(.pressable)
    }
}

/// Red count badge.
struct BadgeView: View {
    let count: Int

    var body: some View {
        Text(count, format: .number)
            .font(.footnote.weight(.bold))
            .monospacedDigit()
            .foregroundStyle(.white)
            .padding(.horizontal, 7)
            .frame(minWidth: 22, minHeight: 22)
            .background(Palette.error, in: .capsule)
            .accessibilityLabel(Text("\(count) new"))
    }
}

#Preview {
    GroupedCard {
        CardActionRow("Continue lesson", systemImage: "play.circle") {}
        CardActionRow("Daily quests", systemImage: "checklist", badge: 3) {}
    }
    .padding()
    .background(Palette.sheet)
}
