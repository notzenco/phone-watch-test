import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: HabitStore

    @State private var name = ""
    @State private var symbol = "checkmark"
    @State private var tint = HabitTint.blue

    private let symbols = [
        "checkmark",
        "drop.fill",
        "figure.run",
        "book.fill",
        "brain.head.profile",
        "leaf.fill"
    ]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit name", text: $name)

                Picker("Icon", selection: $symbol) {
                    ForEach(symbols, id: \.self) { symbol in
                        Label(symbol.replacingOccurrences(of: ".fill", with: ""), systemImage: symbol)
                            .tag(symbol)
                    }
                }

                Picker("Colour", selection: $tint) {
                    ForEach(HabitTint.allCases) { tint in
                        Label(tint.rawValue.capitalized, systemImage: "circle.fill")
                            .foregroundStyle(tint.color)
                            .tag(tint)
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        store.add(name: name, symbol: symbol, tint: tint)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

