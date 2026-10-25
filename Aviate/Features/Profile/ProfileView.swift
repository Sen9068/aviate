import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Pilot licence",
                systemImage: "person.text.rectangle",
                description: Text("Your licence card, stats, achievements and settings will appear here.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Palette.sheet)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", role: .confirm) { dismiss() }
                }
            }
        }
        .presentationBackground(Palette.sheet)
    }
}

#Preview {
    ProfileView()
        .previewEnvironment()
}
