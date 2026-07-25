import SwiftUI

@main
struct PhoneWatchTestWatchApp: App {
    @StateObject private var store = WatchHabitStore()

    var body: some Scene {
        WindowGroup {
            WatchHabitListView()
                .environmentObject(store)
        }
    }
}

