import SwiftUI

/// Full-screen lesson shell. The exercise engine fills this in during the lesson-engine step.
struct LessonView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.haptics) private var haptics

    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 16) {
                Button {
                    haptics.tap()
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Palette.textSecondary)
                        .frame(width: Metrics.iconButtonSize, height: Metrics.iconButtonSize)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close lesson")

                ProgressView(value: 0.1)
                    .tint(Palette.accent)

                Label("5", systemImage: "fuelpump.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.error)
                    .accessibilityLabel("Fuel: 5")
            }

            Spacer()

            ContentUnavailableView(
                "Cleared for takeoff",
                systemImage: "airplane.departure",
                description: Text("Exercises arrive with the lesson engine.")
            )

            Spacer()

            Button("Check") {
                haptics.touchdown()
            }
            .buttonStyle(.aviatePrimary)
        }
        .padding(.horizontal, Metrics.screenPadding)
        .padding(.vertical, 12)
        .background(Palette.sheet.ignoresSafeArea())
    }
}

#Preview {
    LessonView()
        .previewEnvironment()
}
