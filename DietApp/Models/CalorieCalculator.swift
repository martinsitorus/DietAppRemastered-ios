import Foundation

/// Pure business logic for calorie math (Mifflin-St Jeor).
/// Kept free of SwiftUI/SwiftData imports so it is unit-testable.
public enum Gender: String, CaseIterable, Codable {
    case male
    case female
}

public enum ActivityLevel: String, CaseIterable, Codable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    case extraActive = "Extra Active"

    public var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .lightlyActive: return 1.375
        case .moderatelyActive: return 1.55
        case .veryActive: return 1.725
        case .extraActive: return 1.9
        }
    }
}

public enum WeightGoal: String, CaseIterable, Codable {
    case lose1kg = "Lose 1kg/week"
    case lose05kg = "Lose 0.5kg/week"
    case maintain = "Maintain weight"
    case gain05kg = "Gain 0.5kg/week"
    case gain1kg = "Gain 1kg/week"

    public var offset: Double {
        switch self {
        case .lose1kg: return -1000
        case .lose05kg: return -500
        case .maintain: return 0
        case .gain05kg: return 500
        case .gain1kg: return 1000
        }
    }
}

public enum MealCategory: String, CaseIterable, Codable {
    case breakfast
    case lunch
    case dinner
    case snack
}

public struct CalorieCalculator {
    public static func bmr(weightKg: Double, heightCm: Double, age: Int, gender: Gender) -> Double {
        switch gender {
        case .male:
            return 10 * weightKg + 6.25 * heightCm - 5 * Double(age) + 5
        case .female:
            return 10 * weightKg + 6.25 * heightCm - 5 * Double(age) - 161
        }
    }

    public static func dailyNeeds(bmr: Double, activity: ActivityLevel) -> Double {
        bmr * activity.multiplier
    }

    public static func calorieTarget(needs: Double, goal: WeightGoal) -> Double {
        needs + goal.offset
    }

    /// Remaining = Target + Burned - Consumed (spec: daily-dashboard)
    public static func remaining(target: Double, consumed: Double, burned: Double) -> Double {
        target + burned - consumed
    }
}
