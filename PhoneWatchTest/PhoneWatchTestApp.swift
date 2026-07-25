import SwiftUI

@main
struct PhoneWatchTestApp: App {
    @StateObject private var store = HabitStore()

    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environmentObject(store)
        }
    }
}

