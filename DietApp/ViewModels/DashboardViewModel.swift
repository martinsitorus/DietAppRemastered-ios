import Foundation
import Observation

@Observable
@MainActor
public final class DashboardViewModel {
    public var target: Double = 0
    public var consumed: Double = 0
    public var burned: Double = 0

    public var remaining: Double {
        CalorieCalculator.remaining(target: target, consumed: consumed, burned: burned)
    }

    public func update(target: Double, consumed: Double, burned: Double) {
        self.target = target
        self.consumed = consumed
        self.burned = burned
    }

    public static func computeRemaining(target: Double, consumed: Double, burned: Double) -> Double {
        CalorieCalculator.remaining(target: target, consumed: consumed, burned: burned)
    }
}
