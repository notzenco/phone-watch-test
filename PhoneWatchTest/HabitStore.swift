import Combine
import Foundation

@MainActor
final class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit]

    private let storageKey = "phone-watch-test.habits"
    private let connectivity = PhoneConnectivityController()

    init(defaults: UserDefaults = .standard) {
        if let data = defaults.data(forKey: storageKey),
           let saved = try? HabitCodec.decode(data) {
            habits = saved
        } else {
            habits = Habit.starterHabits
        }

        connectivity.onToggle = { [weak self] id in
            Task { @MainActor in
                self?.toggle(id: id)
            }
        }
        connectivity.activate()
        synchronize()
    }

    func add(name: String, symbol: String, tint: HabitTint) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        habits.append(Habit(name: trimmed, symbol: symbol, tint: tint))
        saveAndSynchronize()
    }

    func delete(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
        saveAndSynchronize()
    }

    func toggle(id: UUID, on date: Date = .now) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index].toggle(on: date)
        saveAndSynchronize()
    }

    var completedToday: Int {
        habits.filter { $0.isCompleted() }.count
    }

    var completionFraction: Double {
        guard !habits.isEmpty else { return 0 }
        return Double(completedToday) / Double(habits.count)
    }

    private func saveAndSynchronize(defaults: UserDefaults = .standard) {
        if let data = try? HabitCodec.encode(habits) {
            defaults.set(data, forKey: storageKey)
        }
        synchronize()
    }

    private func synchronize() {
        connectivity.send(habits: habits)
    }
}

