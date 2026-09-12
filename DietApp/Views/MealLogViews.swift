import SwiftUI
import SwiftData

struct MealCategoryView: View {
    var body: some View {
        List(MealCategory.allCases, id: \.self) { category in
            NavigationLink(category.rawValue.capitalized) {
                MealDiaryView(category: category)
            }
        }
        .navigationTitle("Add Activity")
    }
}

struct MealDiaryView: View {
    @Environment(\.modelContext) private var context
    let category: MealCategory
    @Query private var allEntries: [FoodDiaryEntry]
    @State private var showingPicker = false
    @State private var entryToDelete: FoodDiaryEntry?
    @State private var showingDeleteConfirm = false

    private var entries: [FoodDiaryEntry] {
        allEntries.filter { $0.mealCategoryRaw == category.rawValue }
    }

    private var total: Double { entries.reduce(0) { $0 + $1.calories } }

    var body: some View {
        List {
            Section("Total: \(Int(total)) kcal") {
                if entries.isEmpty {
                    Text("No entries").foregroundStyle(.secondary)
                } else {
                    ForEach(entries) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(entry.foodName).font(.headline)
                                Text("\(Int(entry.calories)) kcal").font(.subheadline)
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
        .navigationTitle(category.rawValue.capitalized)
        .toolbar {
            Button { showingPicker = true } label: { Image(systemName: "plus") }
        }
        .sheet(isPresented: $showingPicker) {
            NavigationStack { FoodSelectionView(category: category) }
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

struct FoodSelectionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Food.name, order: .forward) private var foods: [Food]
    let category: MealCategory
    @State private var searchText = ""
    @State private var selectedFood: Food?
    @State private var portion = ""

    var filtered: [Food] {
        guard !searchText.isEmpty else { return foods }
        return foods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        Form {
            Section("Pick food") {
                TextField("Search", text: $searchText)
                Picker("Food", selection: $selectedFood) {
                    Text("Select…").tag(nil as Food?)
                    ForEach(filtered) { food in
                        Text("\(food.name) (\(Int(food.calories)) kcal)").tag(food as Food?)
                    }
                }
            }
            Section("Portion") {
                TextField("Portion amount", text: $portion)
                    .keyboardType(.decimalPad)
            }
            Button("Save entry") {
                guard let food = selectedFood, let amount = Double(portion), amount > 0 else { return }
                let dayID = UserDefaults.standard.integer(forKey: "dietapp.dayID")
                let currentDay = max(dayID, 1)
                let scale = food.portionSize > 0 ? amount / food.portionSize : 1
                let entry = FoodDiaryEntry(
                    foodName: food.name,
                    calories: food.calories * scale,
                    portionAmount: amount,
                    mealCategory: category,
                    dayID: currentDay
                )
                context.insert(entry)
                try? context.save()
                dismiss()
            }
        }
        .navigationTitle("Log \(category.rawValue.capitalized)")
    }
}

#Preview {
    NavigationStack { MealCategoryView() }
        .modelContainer(for: [Food.self, FoodDiaryEntry.self], inMemory: true)
}
