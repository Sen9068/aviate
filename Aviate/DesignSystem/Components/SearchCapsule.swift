import SwiftUI

var defaultSearchPrompt: LocalizedStringKey { "Search topics, terms, aircraft…" }

/// Editable search capsule, for screens that filter their own content (Atlas).
struct SearchField: View {
    @Binding var text: String
    var prompt: LocalizedStringKey = defaultSearchPrompt

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Palette.textSecondary)
                .accessibilityHidden(true)

            TextField("", text: $text, prompt: Text(prompt).foregroundStyle(Palette.textSecondary))
                .foregroundStyle(Palette.textPrimary)
                .submitLabel(.search)
                .autocorrectionDisabled()

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Palette.textSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .searchCapsuleStyle()
    }
}

/// Non-editable search capsule that hands off to the global Search tab.
struct SearchCapsuleButton: View {
    private let prompt: LocalizedStringKey
    private let action: @MainActor () -> Void

    @Environment(\.haptics) private var haptics

    init(prompt: LocalizedStringKey = defaultSearchPrompt, action: @escaping @MainActor () -> Void) {
        self.prompt = prompt
        self.action = action
    }

    var body: some View {
        Button {
            haptics.tap()
            action()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                Text(prompt)
                    .lineLimit(1)
                Spacer(minLength: 0)
            }
            .foregroundStyle(Palette.textSecondary)
            .searchCapsuleStyle()
        }
        .buttonStyle(.pressable)
        .accessibilityLabel("Search")
        .accessibilityHint(Text(prompt))
    }
}

private extension View {
    func searchCapsuleStyle() -> some View {
        font(.body)
            .padding(.horizontal, 14)
            .frame(minHeight: Metrics.controlHeight)
            .background(Palette.card, in: .capsule)
    }
}

#Preview {
    @Previewable @State var text = ""
    VStack(spacing: 16) {
        SearchField(text: $text)
        SearchCapsuleButton {}
    }
    .padding()
    .background(Palette.sheet)
}
