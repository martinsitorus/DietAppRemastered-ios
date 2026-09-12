import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [UserProfile]
    @Query private var foodEntries: [FoodDiaryEntry]
    @Query private var workoutEntries: [WorkoutDiaryEntry]
    @State private var showingProfile = false

    private var target: Double { profiles.first?.calorieTarget ?? 0 }
    private var consumed: Double { foodEntries.reduce(0) { $0 + $1.calories } }
    private var burned: Double { workoutEntries.reduce(0) { $0 + $1.caloriesBurned } }
    private var remaining: Double { CalorieCalculator.remaining(target: target, consumed: consumed, burned: burned) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(title: "Target", value: target)
                    StatCard(title: "Consumed", value: consumed)
                    StatCard(title: "Burned", value: burned)
                    StatCard(title: "Remaining", value: remaining, highlightNegative: true)
                }
                .padding()

                NavigationLink("Add Activity") {
                    MealCategoryView()
                }
                .buttonStyle(.borderedProminent)

                Button("Update Profile") { showingProfile = true }
                    .buttonStyle(.bordered)

                Spacer()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingProfile = true } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("Update profile")
                }
            }
            .sheet(isPresented: $showingProfile) {
                NavigationStack { ProfileView(isEditing: true) }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: Double
    var highlightNegative: Bool = false

    var body: some View {
        VStack {
            Text(title).font(.headline)
            Text("\(Int(value)) kcal")
                .font(.title2)
                .foregroundStyle(highlightNegative && value < 0 ? .red : .primary)
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .background(.thinMaterial)
        .cornerRadius(12)
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [UserProfile.self, FoodDiaryEntry.self, WorkoutDiaryEntry.self], inMemory: true)
}
