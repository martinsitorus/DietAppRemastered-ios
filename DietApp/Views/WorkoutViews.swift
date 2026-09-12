import SwiftUI
import SwiftData

struct WorkoutLogView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Workout.name, order: .forward) private var workouts: [Workout]
    @State private var showingAdd = false
    @State private var workoutToDelete: Workout?
    @State private var showingDeleteConfirm = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(workouts) { workout in
                    VStack(alignment: .leading) {
                        Text(workout.name).font(.headline)
                        Text("\(Int(workout.caloriesBurned)) kcal per \(workout.portionSize, specifier: "%.1f") \(workout.portionUnit)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            workoutToDelete = workout
                            showingDeleteConfirm = true
                        } label: { Label("Delete", systemImage: "trash") }
                    }
                }
            }
            .navigationTitle("Workout Catalog")
            .toolbar {
                Button { showingAdd = true } label: { Image(systemName: "plus") }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack { AddWorkoutView() }
            }
            .confirmationDialog("Delete this workout?", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let w = workoutToDelete {
                        context.delete(w)
                        try? context.save()
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var calories = ""
    @State private var portion = ""
    @State private var unit = "minutes"
    @State private var errorMessage: String?

    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Calories burned (kcal)", text: $calories).keyboardType(.decimalPad)
            TextField("Portion size", text: $portion).keyboardType(.decimalPad)
            TextField("Unit (e.g. minutes, sets)", text: $unit)
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }
            Button("Save") {
                guard !name.isEmpty,
                      let cal = Double(calories), cal > 0,
                      let por = Double(portion), por > 0,
                      !unit.isEmpty else {
                    errorMessage = "All fields are required and must be valid."
                    return
                }
                context.insert(Workout(name: name, caloriesBurned: cal, portionSize: por, portionUnit: unit, isCustom: true))
                try? context.save()
                dismiss()
            }
        }
        .navigationTitle("Add Workout")
    }
}

#Preview {
    WorkoutLogView()
        .modelContainer(for: [Workout.self], inMemory: true)
}
