import SwiftUI

struct HabitListView: View {
    @EnvironmentObject private var store: HabitStore
    @State private var isAddingHabit = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ProgressCard(
                        completed: store.completedToday,
                        total: store.habits.count,
                        fraction: store.completionFraction
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                Section("Today") {
                    ForEach(store.habits) { habit in
                        HabitRow(habit: habit) {
                            withAnimation(.snappy) {
                                store.toggle(id: habit.id)
                            }
                        }
                    }
                    .onDelete(perform: store.delete)
                }
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAddingHabit = true
                    } label: {
                        Label("Add habit", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingHabit) {
                AddHabitView()
                    .environmentObject(store)
            }
        }
    }
}

private struct ProgressCard: View {
    let completed: Int
    let total: Int
    let fraction: Double

    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(.quaternary, lineWidth: 10)
                Circle()
                    .trim(from: 0, to: fraction)
                    .stroke(
                        Color.accentColor,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                Text("\(completed)/\(total)")
                    .font(.headline.monospacedDigit())
            }
            .frame(width: 78, height: 78)

            VStack(alignment: .leading, spacing: 5) {
                Text(completed == total && total > 0 ? "Day complete" : "Keep the rhythm")
                    .font(.title3.bold())
                Text("\(completed) of \(total) habits completed today")
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

private struct HabitRow: View {
    let habit: Habit
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            HStack(spacing: 14) {
                Image(systemName: habit.symbol)
                    .font(.title3)
                    .foregroundStyle(habit.tint.color)
                    .frame(width: 34, height: 34)
                    .background(habit.tint.color.opacity(0.14), in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text(habit.name)
                        .foregroundStyle(.primary)
                    Text("\(habit.currentStreak()) day streak")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: habit.isCompleted() ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(habit.isCompleted() ? habit.tint.color : .secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(habit.name)
        .accessibilityValue(habit.isCompleted() ? "Completed" : "Not completed")
    }
}

extension HabitTint {
    var color: Color {
        switch self {
        case .blue: .blue
        case .green: .green
        case .orange: .orange
        case .pink: .pink
        case .purple: .purple
        }
    }
}

