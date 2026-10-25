import SwiftUI

/// Completed lessons, as a grouped list or a horizontal row of cards.
struct HistorySection: View {
    let items: [LessonHistoryItem]
    let layout: HistoryLayout

    var body: some View {
        switch layout {
        case .list:
            GroupedCard {
                ForEach(items) { item in
                    HistoryRow(item: item)
                }
            }
        case .cards:
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        HistoryCard(item: item)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
}

private struct HistoryRow: View {
    let item: LessonHistoryItem

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.systemImage)
                .font(.title3)
                .foregroundStyle(Palette.accent)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Palette.textPrimary)
                Text(item.date, format: .relative(presentation: .named))
                    .font(.subheadline)
                    .foregroundStyle(Palette.textSecondary)
            }

            Spacer(minLength: 8)

            HistoryScore(item: item, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .accessibilityElement(children: .combine)
    }
}

private struct HistoryCard: View {
    let item: LessonHistoryItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: item.systemImage)
                .font(.title2)
                .foregroundStyle(Palette.accent)
            Text(item.title)
                .font(.headline)
                .foregroundStyle(Palette.textPrimary)
                .lineLimit(2, reservesSpace: true)
            Text(item.date, format: .dateTime.month().day())
                .font(.subheadline)
                .foregroundStyle(Palette.textSecondary)
            HistoryScore(item: item, alignment: .leading)
        }
        .padding(16)
        .frame(width: 168, alignment: .leading)
        .cardBackground(cornerRadius: 24)
        .accessibilityElement(children: .combine)
    }
}

private struct HistoryScore: View {
    let item: LessonHistoryItem
    let alignment: HorizontalAlignment

    var body: some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(item.accuracy, format: .percent.precision(.fractionLength(0)))
                .font(.body.weight(.semibold))
                .foregroundStyle(item.accuracy >= 0.9 ? Palette.success : Palette.warning)
            Text("+\(item.xpEarned) XP")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Palette.xpGold)
        }
        .monospacedDigit()
    }
}
