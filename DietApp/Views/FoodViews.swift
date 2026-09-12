import SwiftUI
import SwiftData

struct FoodLogView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Food.name, order: .forward) private var foods: [Food]
    @State private var searchText = ""
    @State private var showingAdd = false

    var filtered: [Food] {
        guard !searchText.isEmpty else { return foods }
        return foods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered) { food in
                    VStack(alignment: .leading) {
                        Text(food.name).font(.headline)
                        Text("\(Int(food.calories)) kcal per \(food.portionSize, specifier: "%.1f") \(food.portionUnit)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(filtered[index])
                    }
                    try? context.save()
                }
            }
            .searchable(text: $searchText, prompt: "Search foods")
            .overlay {
                if filtered.isEmpty {
                    ContentUnavailableView("No results", systemImage: "magnifyingglass")
                }
            }
            .navigationTitle("Food Catalog")
            .toolbar {
                Button { showingAdd = true } label: { Image(systemName: "plus") }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack { AddFoodView() }
            }
            .alert("Delete?", isPresented: .constant(false)) { }
        }
    }
}

struct AddFoodView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var calories = ""
    @State private var portion = ""
    @State private var unit = ""
    @State private var errorMessage: String?
    @State private var showingDeleteConfirm = false

    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Calories (kcal)", text: $calories).keyboardType(.decimalPad)
            TextField("Portion size", text: $portion).keyboardType(.decimalPad)
            TextField("Portion unit (e.g. gram, piece)", text: $unit)
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
                context.insert(Food(name: name, calories: cal, portionSize: por, portionUnit: unit, isCustom: true))
                try? context.save()
                dismiss()
            }
        }
        .navigationTitle("Add Food")
    }
}

#Preview {
    FoodLogView()
        .modelContainer(for: [Food.self], inMemory: true)
}
