import Foundation
import SwiftData
import Observation

@Observable
@MainActor
public final class MealLoggingViewModel {
    public var entries: [FoodDiaryEntry] = []

    public func fetch(context: ModelContext, dayID: Int) {
        let descriptor = FetchDescriptor<FoodDiaryEntry>(
            predicate: #Predicate { $0.dayID == dayID },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        entries = (try? context.fetch(descriptor)) ?? []
    }

    public func entries(for category: MealCategory) -> [FoodDiaryEntry] {
        entries.filter { $0.mealCategoryRaw == category.rawValue }
    }

    public func totalCalories(for category: MealCategory) -> Double {
        entries(for: category).reduce(0) { $0 + $1.calories }
    }

    public var totalConsumed: Double {
        entries.reduce(0) { $0 + $1.calories }
    }

    public func addEntry(food: Food, portionAmount: Double, category: MealCategory, dayID: Int, context: ModelContext) {
        let scale = food.portionSize > 0 ? portionAmount / food.portionSize : 1
        let entry = FoodDiaryEntry(
            foodName: food.name,
            calories: food.calories * scale,
            portionAmount: portionAmount,
            mealCategory: category,
            dayID: dayID
        )
        context.insert(entry)
        try? context.save()
        fetch(context: context, dayID: dayID)
    }

    public func delete(_ entry: FoodDiaryEntry, dayID: Int, context: ModelContext) {
        context.delete(entry)
        try? context.save()
        fetch(context: context, dayID: dayID)
    }
}
