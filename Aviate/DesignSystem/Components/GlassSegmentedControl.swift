import SwiftUI

/// Full-width capsule segmented control; the selected segment sits on a lighter glass pill
/// that slides between segments.
struct GlassSegmentedControl<Value: Hashable>: View {
    @Binding private var selection: Value
    private let options: [Value]
    private let title: (Value) -> LocalizedStringKey

    @Namespace private var pill
    @Environment(\.haptics) private var haptics

    init(selection: Binding<Value>, options: [Value], title: @escaping (Value) -> LocalizedStringKey) {
        _selection = selection
        self.options = options
        self.title = title
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                let isSelected = option == selection
                Button {
                    guard !isSelected else { return }
                    haptics.selection()
                    withAnimation(.snappy(duration: 0.3)) { selection = option }
                } label: {
                    Text(title(option))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(isSelected ? Palette.textPrimary : Palette.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: .infinity, minHeight: 36)
                        .background {
                            if isSelected {
                                Capsule()
                                    .fill(.white.opacity(0.12))
                                    .glassEffect(.clear, in: .capsule)
                                    .matchedGeometryEffect(id: "selection", in: pill)
                            }
                        }
                        .contentShape(.capsule)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(4)
        .background(Palette.card, in: .capsule)
    }
}

#Preview {
    @Previewable @State var selection = "Path"
    GlassSegmentedControl(selection: $selection, options: ["Path", "Review", "Practice"]) {
        LocalizedStringKey($0)
    }
    .padding()
    .background(Palette.sheet)
}
