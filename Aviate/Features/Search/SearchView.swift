import SwiftUI

/// Global search across lessons, terms and aircraft (the tab bar's separate search button).
struct SearchView: View {
    @State private var query = ""

    var body: some View {
        NavigationStack {
            Group {
                if query.isEmpty {
                    ContentUnavailableView(
                        "Search Aviate",
                        systemImage: "magnifyingglass",
                        description: Text("Find lessons, phraseology, terms and aircraft.")
                    )
                } else {
                    ContentUnavailableView.search(text: query)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Palette.sheet)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $query, prompt: defaultSearchPrompt)
    }
}

#Preview {
    SearchView()
        .previewEnvironment()
}
