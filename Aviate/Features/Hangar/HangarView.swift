import SwiftUI

struct HangarView: View {
    var body: some View {
        HomeBaseTabScreen(title: "Hangar") {
            ContentUnavailableView(
                "Your hangar is being built",
                systemImage: "wrench.and.screwdriver",
                description: Text("Your aircraft, upgrades and liveries will live here.")
            )
        }
    }
}

#Preview {
    HangarView()
        .previewEnvironment()
}
