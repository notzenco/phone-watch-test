import Foundation

struct Habit: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var symbol: String
    var tint: HabitTint
    private(set) var completedDays: Set<String>

    init(
        id: UUID = UUID(),
        name: String,
        symbol: String,
        tint: HabitTint,
        completedDays: Set<String> = []
    ) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.tint = tint
        self.completedDays = completedDays
    }

    func isCompleted(on date: Date = .now, calendar: Calendar = .current) -> Bool {
        completedDays.contains(Self.dayKey(for: date, calendar: calendar))
    }

    mutating func toggle(on date: Date = .now, calendar: Calendar = .current) {
        let key = Self.dayKey(for: date, calendar: calendar)
        if completedDays.contains(key) {
            completedDays.remove(key)
        } else {
            completedDays.insert(key)
        }
    }

    func currentStreak(on date: Date = .now, calendar: Calendar = .current) -> Int {
        var streak = 0
        var cursor = calendar.startOfDay(for: date)

        while completedDays.contains(Self.dayKey(for: cursor, calendar: calendar)) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }
            cursor = previous
        }

        return streak
    }

    static func dayKey(for date: Date, calendar: Calendar = .current) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return String(
            format: "%04d-%02d-%02d",
            components.year ?? 0,
            components.month ?? 0,
            components.day ?? 0
        )
    }

    static let starterHabits: [Habit] = [
        Habit(name: "Drink water", symbol: "drop.fill", tint: .blue),
        Habit(name: "Move for 20 minutes", symbol: "figure.run", tint: .orange),
        Habit(name: "Read ten pages", symbol: "book.fill", tint: .purple)
    ]
}

enum HabitTint: String, Codable, CaseIterable, Identifiable {
    case blue
    case green
    case orange
    case pink
    case purple

    var id: String { rawValue }
}

