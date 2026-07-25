import SwiftUI

struct WatchHabitListView: View {
    @EnvironmentObject private var store: WatchHabitStore

    var body: some View {
        List {
            Section {
                Text("\(completedCount) of \(store.habits.count) complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(store.habits) { habit in
                Button {
                    withAnimation(.snappy) {
                        store.toggle(id: habit.id)
                    }
                } label: {
                    HStack {
                        Image(systemName: habit.symbol)
                            .foregroundStyle(habit.tint.color)
                        Text(habit.name)
                            .lineLimit(2)
                        Spacer(minLength: 4)
                        Image(systemName: habit.isCompleted() ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(habit.isCompleted() ? habit.tint.color : .secondary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Habits")
    }

    private var completedCount: Int {
        store.habits.filter { $0.isCompleted() }.count
    }
}

