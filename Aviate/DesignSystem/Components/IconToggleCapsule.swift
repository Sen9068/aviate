import SwiftUI

/// Small capsule of icon buttons (e.g. card view / list view) with a blue selected state.
struct IconToggleCapsule<Value: Hashable>: View {
    @Binding private var selection: Value
    private let options: [Value]
    private let systemImage: (Value) -> String
    private let label: (Value) -> LocalizedStringKey

    @Environment(\.haptics) private var haptics

    init(
        selection: Binding<Value>,
        options: [Value],
        systemImage: @escaping (Value) -> String,
        label: @escaping (Value) -> LocalizedStringKey
    ) {
        _selection = selection
        self.options = options
        self.systemImage = systemImage
        self.label = label
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(options, id: \.self) { option in
                let isSelected = option == selection
                Button {
                    guard !isSelected else { return }
                    haptics.selection()
                    withAnimation(.snappy(duration: 0.25)) { selection = option }
                } label: {
                    Image(systemName: systemImage(option))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(isSelected ? Palette.textPrimary : Palette.textSecondary)
                        .frame(width: 38, height: 30)
                        .background(isSelected ? Palette.accent : .clear, in: .capsule)
                        .contentShape(.capsule)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(label(option))
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(3)
        .background(Palette.card, in: .capsule)
    }
}

#Preview {
    @Previewable @State var selection = 0
    IconToggleCapsule(selection: $selection, options: [0, 1]) {
        $0 == 0 ? "rectangle.grid.1x2" : "list.bullet"
    } label: {
        $0 == 0 ? "Card view" : "List view"
    }
    .padding()
    .background(Palette.sheet)
}
