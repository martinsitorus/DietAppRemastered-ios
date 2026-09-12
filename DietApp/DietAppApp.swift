import SwiftUI
import SwiftData

@main
struct DietAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self, Food.self, Workout.self,
            FoodDiaryEntry.self, WorkoutDiaryEntry.self, DayProgress.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
