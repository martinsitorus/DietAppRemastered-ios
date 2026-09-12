import Foundation
import SwiftData

@Model
public final class UserProfile {
    public var weightKg: Double
    public var heightCm: Double
    public var age: Int
    public var genderRaw: String
    public var activityLevelRaw: String
    public var weightGoalRaw: String
    public var bmr: Double
    public var dailyNeeds: Double
    public var calorieTarget: Double
    public var createdAt: Date

    public init(
        weightKg: Double, heightCm: Double, age: Int,
        gender: Gender, activityLevel: ActivityLevel, weightGoal: WeightGoal
    ) {
        self.weightKg = weightKg
        self.heightCm = heightCm
        self.age = age
        self.genderRaw = gender.rawValue
        self.activityLevelRaw = activityLevel.rawValue
        self.weightGoalRaw = weightGoal.rawValue
        let bmrValue = CalorieCalculator.bmr(weightKg: weightKg, heightCm: heightCm, age: age, gender: gender)
        let needs = CalorieCalculator.dailyNeeds(bmr: bmrValue, activity: activityLevel)
        let target = CalorieCalculator.calorieTarget(needs: needs, goal: weightGoal)
        self.bmr = bmrValue
        self.dailyNeeds = needs
        self.calorieTarget = target
        self.createdAt = Date()
    }

    public var gender: Gender { Gender(rawValue: genderRaw) ?? .male }
    public var activityLevel: ActivityLevel { ActivityLevel(rawValue: activityLevelRaw) ?? .sedentary }
    public var weightGoal: WeightGoal { WeightGoal(rawValue: weightGoalRaw) ?? .maintain }

    public func recalculate() {
        let bmrValue = CalorieCalculator.bmr(weightKg: weightKg, heightCm: heightCm, age: age, gender: gender)
        let needs = CalorieCalculator.dailyNeeds(bmr: bmrValue, activity: activityLevel)
        let target = CalorieCalculator.calorieTarget(needs: needs, goal: weightGoal)
        self.bmr = bmrValue
        self.dailyNeeds = needs
        self.calorieTarget = target
    }
}

@Model
public final class Food {
    @Attribute(.unique) public var name: String
    public var calories: Double
    public var portionSize: Double
    public var portionUnit: String
    public var isCustom: Bool
    public var createdAt: Date

    public init(name: String, calories: Double, portionSize: Double, portionUnit: String, isCustom: Bool = false) {
        self.name = name
        self.calories = calories
        self.portionSize = portionSize
        self.portionUnit = portionUnit
        self.isCustom = isCustom
        self.createdAt = Date()
    }
}

@Model
public final class Workout {
    @Attribute(.unique) public var name: String
    public var caloriesBurned: Double
    public var portionSize: Double
    public var portionUnit: String
    public var isCustom: Bool
    public var createdAt: Date

    public init(name: String, caloriesBurned: Double, portionSize: Double, portionUnit: String, isCustom: Bool = false) {
        self.name = name
        self.caloriesBurned = caloriesBurned
        self.portionSize = portionSize
        self.portionUnit = portionUnit
        self.isCustom = isCustom
        self.createdAt = Date()
    }
}

@Model
public final class FoodDiaryEntry {
    public var foodName: String
    public var calories: Double
    public var portionAmount: Double
    public var mealCategoryRaw: String
    public var dayID: Int
    public var createdAt: Date

    public init(foodName: String, calories: Double, portionAmount: Double, mealCategory: MealCategory, dayID: Int, date: Date = Date()) {
        self.foodName = foodName
        self.calories = calories
        self.portionAmount = portionAmount
        self.mealCategoryRaw = mealCategory.rawValue
        self.dayID = dayID
        self.createdAt = date
    }

    public var mealCategory: MealCategory { MealCategory(rawValue: mealCategoryRaw) ?? .snack }
}

@Model
public final class WorkoutDiaryEntry {
    public var workoutName: String
    public var caloriesBurned: Double
    public var portionAmount: Double
    public var dayID: Int
    public var createdAt: Date

    public init(workoutName: String, caloriesBurned: Double, portionAmount: Double, dayID: Int, date: Date = Date()) {
        self.workoutName = workoutName
        self.caloriesBurned = caloriesBurned
        self.portionAmount = portionAmount
        self.dayID = dayID
        self.createdAt = date
    }
}

@Model
public final class DayProgress {
    @Attribute(.unique) public var dayID: Int
    public var date: Date
    public var calorieTarget: Double
    public var totalConsumed: Double
    public var totalBurned: Double

    public init(dayID: Int, date: Date, calorieTarget: Double, totalConsumed: Double, totalBurned: Double) {
        self.dayID = dayID
        self.date = date
        self.calorieTarget = calorieTarget
        self.totalConsumed = totalConsumed
        self.totalBurned = totalBurned
    }
}
