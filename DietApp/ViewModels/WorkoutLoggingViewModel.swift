import Foundation
import SwiftData
import Observation

@Observable
@MainActor
public final class WorkoutLoggingViewModel {
    public var entries: [WorkoutDiaryEntry] = []

    public func fetch(context: ModelContext, dayID: Int) {
        let descriptor = FetchDescriptor<WorkoutDiaryEntry>(
            predicate: #Predicate { $0.dayID == dayID },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        entries = (try? context.fetch(descriptor)) ?? []
    }

    public var totalBurned: Double {
        entries.reduce(0) { $0 + $1.caloriesBurned }
    }

    public func addEntry(workout: Workout, portionAmount: Double, dayID: Int, context: ModelContext) {
        let scale = workout.portionSize > 0 ? portionAmount / workout.portionSize : 1
        let entry = WorkoutDiaryEntry(
            workoutName: workout.name,
            caloriesBurned: workout.caloriesBurned * scale,
            portionAmount: portionAmount,
            dayID: dayID
        )
        context.insert(entry)
        try? context.save()
        fetch(context: context, dayID: dayID)
    }

    public func delete(_ entry: WorkoutDiaryEntry, dayID: Int, context: ModelContext) {
        context.delete(entry)
        try? context.save()
        fetch(context: context, dayID: dayID)
    }
}
