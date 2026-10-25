import SwiftUI

struct InboxView: View {
    var body: some View {
        HomeBaseTabScreen(title: "Inbox") {
            ContentUnavailableView(
                "No messages yet",
                systemImage: "tray",
                description: Text("League results, high-fives and rewards to claim will land here.")
            )
        }
    }
}

#Preview {
    InboxView()
        .previewEnvironment()
}
