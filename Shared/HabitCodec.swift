import Foundation

enum HabitCodec {
    static func encode(_ habits: [Habit]) throws -> Data {
        try JSONEncoder().encode(habits)
    }

    static func decode(_ data: Data) throws -> [Habit] {
        try JSONDecoder().decode([Habit].self, from: data)
    }
}

