import SwiftUI

/// Streak · fuel · coins · XP chips shown under the top bar.
struct StatRow: View {
    let streak: Int
    let fuel: Int
    let maxFuel: Int
    let coins: Int
    let xp: Int

    var body: some View {
        HStack(spacing: 8) {
            StatChip(systemImage: "flame.fill", tint: Palette.warning,
                     value: streak.formatted(), label: "Day streak")
            StatChip(systemImage: "fuelpump.fill", tint: Palette.error,
                     value: "\(fuel)/\(maxFuel)", label: "Fuel")
            StatChip(systemImage: "dollarsign.circle.fill", tint: Palette.success,
                     value: coins.formatted(), label: "Fuel coins")
            StatChip(systemImage: "bolt.fill", tint: Palette.xpGold,
                     value: xp.formatted(), label: "Total XP")
        }
    }
}

struct StatChip: View {
    let systemImage: String
    let tint: Color
    let value: String
    let label: LocalizedStringKey

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: systemImage)
                .foregroundStyle(tint)
            Text(value)
                .foregroundStyle(Palette.textPrimary)
                .monospacedDigit()
                .contentTransition(.numericText())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .font(.subheadline.weight(.semibold))
        .frame(maxWidth: .infinity, minHeight: 34)
        .background(Palette.card, in: .capsule)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(value)
    }
}

#Preview {
    StatRow(streak: 23, fuel: 4, maxFuel: 5, coins: 340, xp: 1240)
        .padding()
        .background(Palette.sheet)
}
