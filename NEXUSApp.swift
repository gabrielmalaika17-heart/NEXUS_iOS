import SwiftUI
import SwiftData

@main
struct NEXUSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [TaskItem.self, SleepEntry.self, FocusSession.self])
    }
}
