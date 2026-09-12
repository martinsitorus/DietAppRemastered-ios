import Foundation
import SwiftData
import Observation

@Observable
@MainActor
public final class UserProfileViewModel {
    public var profile: UserProfile?
    private var context: ModelContext?

    public init(profile: UserProfile? = nil) {
        self.profile = profile
    }

    public func configure(context: ModelContext) {
        self.context = context
        fetchProfile(context: context)
    }

    public func fetchProfile(context: ModelContext) {
        let descriptor = FetchDescriptor<UserProfile>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        profile = (try? context.fetch(descriptor))?.first
    }

    public var hasProfile: Bool { profile != nil }

    @discardableResult
    public func saveProfile(
        weightKg: Double, heightCm: Double, age: Int,
        gender: Gender, activity: ActivityLevel, goal: WeightGoal,
        context: ModelContext
    ) -> UserProfile {
        fetchProfile(context: context)
        if let existing = profile {
            existing.weightKg = weightKg
            existing.heightCm = heightCm
            existing.age = age
            existing.genderRaw = gender.rawValue
            existing.activityLevelRaw = activity.rawValue
            existing.weightGoalRaw = goal.rawValue
            existing.recalculate()
            try? context.save()
            profile = existing
            return existing
        } else {
            let created = UserProfile(
                weightKg: weightKg, heightCm: heightCm, age: age,
                gender: gender, activityLevel: activity, weightGoal: goal
            )
            context.insert(created)
            try? context.save()
            profile = created
            return created
        }
    }

    // MARK: - Pure calculation helpers (used by tests/previews)

    public static func calculateBMR(weightKg: Double, heightCm: Double, age: Int, gender: Gender) -> Double {
        CalorieCalculator.bmr(weightKg: weightKg, heightCm: heightCm, age: age, gender: gender)
    }

    public static func calculateNeeds(bmr: Double, activity: ActivityLevel) -> Double {
        CalorieCalculator.dailyNeeds(bmr: bmr, activity: activity)
    }

    public static func calculateTarget(needs: Double, goal: WeightGoal) -> Double {
        CalorieCalculator.calorieTarget(needs: needs, goal: goal)
    }
}
