import Foundation
import SwiftData
import Observation

@Observable
@MainActor
public final class WorkoutCatalogViewModel {
    public var workouts: [Workout] = []
    public var errorMessage: String?

    public var sortedWorkouts: [Workout] {
        workouts.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    public func fetch(context: ModelContext) {
        let descriptor = FetchDescriptor<Workout>()
        workouts = (try? context.fetch(descriptor)) ?? []
    }

    @discardableResult
    public func addWorkout(name: String, caloriesBurned: Double, portionSize: Double, portionUnit: String, context: ModelContext) -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              caloriesBurned > 0, portionSize > 0,
              !portionUnit.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "All fields are required and must be valid."
            return false
        }
        errorMessage = nil
        context.insert(Workout(name: name, caloriesBurned: caloriesBurned, portionSize: portionSize, portionUnit: portionUnit, isCustom: true))
        try? context.save()
        fetch(context: context)
        return true
    }

    public func delete(_ workout: Workout, context: ModelContext) {
        context.delete(workout)
        try? context.save()
        fetch(context: context)
    }

    public func seedIfEmpty(context: ModelContext) {
        fetch(context: context)
        guard workouts.isEmpty else { return }
        let defaults: [(String, Double, Double, String)] = [
            ("Running", 300, 30, "minutes"),
            ("Cycling", 250, 30, "minutes"),
            ("Swimming", 280, 30, "minutes"),
            ("Push-ups", 100, 3, "sets"),
            ("Walking", 120, 30, "minutes"),
            ("Yoga", 90, 30, "minutes"),
        ]
        for (name, cal, portion, unit) in defaults {
            context.insert(Workout(name: name, caloriesBurned: cal, portionSize: portion, portionUnit: unit))
        }
        try? context.save()
        fetch(context: context)
    }
}
