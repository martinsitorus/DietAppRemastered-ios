import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [UserProfile]
    @State private var profileVM = UserProfileViewModel()
    @State private var foodCatalogVM = FoodCatalogViewModel()
    @State private var workoutCatalogVM = WorkoutCatalogViewModel()
    @State private var mealVM = MealLoggingViewModel()
    @State private var workoutLogVM = WorkoutLoggingViewModel()
    @State private var dashboardVM = DashboardViewModel()
    @State private var dayVM = DayTrackingViewModel()

    var body: some View {
        Group {
            if profiles.isEmpty {
                ProfileView()
            } else {
                TabView {
                    DashboardView()
                        .tabItem { Label("Dashboard", systemImage: "house") }
                    FoodLogView()
                        .tabItem { Label("Food Log", systemImage: "fork.knife") }
                    WorkoutLogView()
                        .tabItem { Label("Workout Log", systemImage: "figure.run") }
                }
            }
        }
        .onAppear {
            profileVM.configure(context: context)
            foodCatalogVM.seedIfEmpty(context: context)
            workoutCatalogVM.seedIfEmpty(context: context)
            foodCatalogVM.fetch(context: context)
            workoutCatalogVM.fetch(context: context)
            let rolledOver = dayVM.checkDayRollover(context: context) {
                let target = profiles.first?.calorieTarget ?? 0
                return (target, mealVM.totalConsumed, workoutLogVM.totalBurned)
            }
            mealVM.fetch(context: context, dayID: dayVM.currentDayID)
            workoutLogVM.fetch(context: context, dayID: dayVM.currentDayID)
            _ = rolledOver
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [UserProfile.self, Food.self, Workout.self, FoodDiaryEntry.self, WorkoutDiaryEntry.self, DayProgress.self], inMemory: true)
}
