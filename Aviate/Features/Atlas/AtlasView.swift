import SwiftUI

struct AtlasView: View {
    @State private var query = ""

    var body: some View {
        HomeBaseTabScreen(title: "Atlas") {
            SearchField(text: $query, prompt: "Search the glossary…")

            ContentUnavailableView(
                "Reference library",
                systemImage: "rectangle.stack",
                description: Text("ICAO alphabet, phraseology, METAR decoder, airspace and aircraft profiles.")
            )
        }
    }
}

#Preview {
    AtlasView()
        .previewEnvironment()
}
