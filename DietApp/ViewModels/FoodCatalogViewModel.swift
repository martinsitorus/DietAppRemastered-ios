import Foundation
import SwiftData
import Observation

@Observable
@MainActor
public final class FoodCatalogViewModel {
    public var foods: [Food] = []
    public var searchText: String = ""
    public var errorMessage: String?

    public var filteredFoods: [Food] {
        let sorted = foods.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        guard !searchText.isEmpty else { return sorted }
        return sorted.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    public func fetch(context: ModelContext) {
        let descriptor = FetchDescriptor<Food>()
        foods = (try? context.fetch(descriptor)) ?? []
    }

    @discardableResult
    public func addFood(name: String, calories: Double, portionSize: Double, portionUnit: String, context: ModelContext) -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              calories > 0, portionSize > 0,
              !portionUnit.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "All fields are required and must be valid."
            return false
        }
        errorMessage = nil
        let food = Food(name: name, calories: calories, portionSize: portionSize, portionUnit: portionUnit, isCustom: true)
        context.insert(food)
        try? context.save()
        fetch(context: context)
        return true
    }

    public func delete(_ food: Food, context: ModelContext) {
        context.delete(food)
        try? context.save()
        fetch(context: context)
    }

    // MARK: Seeding

    public struct SeedFood: Codable {
        public var name: String
        public var calories: Double
        public var portionSize: Double
        public var portionUnit: String
    }

    public func seedIfEmpty(context: ModelContext) {
        fetch(context: context)
        guard foods.isEmpty else { return }
        guard let url = Bundle.main.url(forResource: "foods", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let seed = try? JSONDecoder().decode([SeedFood].self, from: data) else { return }
        for item in seed {
            context.insert(Food(name: item.name, calories: item.calories, portionSize: item.portionSize, portionUnit: item.portionUnit))
        }
        try? context.save()
        fetch(context: context)
    }

    // MARK: Test helper — pure search/sort without SwiftData
    public static func filterFoods(_ foods: [(name: String, calories: Double)], query: String) -> [(name: String, calories: Double)] {
        let sorted = foods.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        guard !query.isEmpty else { return sorted }
        return sorted.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
}
