import SwiftUI
import SwiftData

struct WorkoutDiaryHomeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \WorkoutDiaryEntry.createdAt, order: .forward) private var entries: [WorkoutDiaryEntry]
    @State private var showingPicker = false
    @State private var entryToDelete: WorkoutDiaryEntry?
    @State private var showingDeleteConfirm = false

    private var total: Double { entries.reduce(0) { $0 + $1.caloriesBurned } }

    var body: some View {
        NavigationStack {
            List {
                Section("Total burned: \(Int(total)) kcal") {
                    if entries.isEmpty {
                        Text("No entries").foregroundStyle(.secondary)
                    } else {
                        ForEach(entries) { entry in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(entry.workoutName).font(.headline)
                                    Text("\(Int(entry.caloriesBurned)) kcal").font(.subheadline)
                                }
                                Spacer()
                                Button(role: .destructive) {
                                    entryToDelete = entry
                                    showingDeleteConfirm = true
                                } label: { Image(systemName: "trash") }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Workout Diary")
            .toolbar {
                Button { showingPicker = true } label: { Image(systemName: "plus") }
            }
            .sheet(isPresented: $showingPicker) {
                NavigationStack { WorkoutSelectionView() }
            }
            .confirmationDialog("Delete this entry?", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let e = entryToDelete {
                        context.delete(e)
                        try? context.save()
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

struct WorkoutSelectionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Workout.name, order: .forward) private var workouts: [Workout]
    @State private var selected: Workout?
    @State private var portion = ""

    var body: some View {
        Form {
            Picker("Workout", selection: $selected) {
                Text("Select…").tag(nil as Workout?)
                ForEach(workouts) { w in
                    Text("\(w.name) (\(Int(w.caloriesBurned)) kcal)").tag(w as Workout?)
                }
            }
            TextField("Portion amount", text: $portion)
                .keyboardType(.decimalPad)
            Button("Save entry") {
                guard let w = selected, let amount = Double(portion), amount > 0 else { return }
                let dayID = max(UserDefaults.standard.integer(forKey: "dietapp.dayID"), 1)
                let scale = w.portionSize > 0 ? amount / w.portionSize : 1
                let entry = WorkoutDiaryEntry(
                    workoutName: w.name,
                    caloriesBurned: w.caloriesBurned * scale,
                    portionAmount: amount,
                    dayID: dayID
                )
                context.insert(entry)
                try? context.save()
                dismiss()
            }
        }
        .navigationTitle("Log Workout")
    }
}
