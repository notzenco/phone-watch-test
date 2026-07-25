import XCTest
@testable import PhoneWatchTest

final class HabitTests: XCTestCase {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    func testToggleMarksAndUnmarksDay() throws {
        var habit = Habit(name: "Read", symbol: "book", tint: .purple)
        let date = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 7, day: 25)))

        habit.toggle(on: date, calendar: calendar)
        XCTAssertTrue(habit.isCompleted(on: date, calendar: calendar))

        habit.toggle(on: date, calendar: calendar)
        XCTAssertFalse(habit.isCompleted(on: date, calendar: calendar))
    }

    func testCurrentStreakCountsConsecutiveDays() throws {
        var habit = Habit(name: "Move", symbol: "figure.run", tint: .orange)
        let today = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 7, day: 25)))
        let yesterday = try XCTUnwrap(calendar.date(byAdding: .day, value: -1, to: today))
        let twoDaysAgo = try XCTUnwrap(calendar.date(byAdding: .day, value: -2, to: today))

        habit.toggle(on: today, calendar: calendar)
        habit.toggle(on: yesterday, calendar: calendar)
        habit.toggle(on: twoDaysAgo, calendar: calendar)

        XCTAssertEqual(habit.currentStreak(on: today, calendar: calendar), 3)
    }

    func testCodecRoundTripPreservesHabits() throws {
        var habit = Habit(name: "Hydrate", symbol: "drop.fill", tint: .blue)
        habit.toggle()

        let encoded = try HabitCodec.encode([habit])
        let decoded = try HabitCodec.decode(encoded)

        XCTAssertEqual(decoded, [habit])
    }
}

