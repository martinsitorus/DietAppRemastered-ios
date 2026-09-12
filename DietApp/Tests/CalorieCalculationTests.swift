import XCTest
@testable import DietApp

final class CalorieCalculationTests: XCTestCase {
    func testMaleBMR() {
        let bmr = CalorieCalculator.bmr(weightKg: 80, heightCm: 175, age: 30, gender: .male)
        XCTAssertEqual(bmr, 1748.75, accuracy: 0.01)
    }

    func testFemaleBMRFormula() {
        // Mifflin-St Jeor: 10*65 + 6.25*160 - 5*25 - 161 = 1364
        let bmr = CalorieCalculator.bmr(weightKg: 65, heightCm: 160, age: 25, gender: .female)
        XCTAssertEqual(bmr, 1364, accuracy: 0.01)
    }

    func testSedentaryNeeds() {
        XCTAssertEqual(CalorieCalculator.dailyNeeds(bmr: 1748.75, activity: .sedentary), 2098.5, accuracy: 0.01)
    }

    func testVeryActiveNeeds() {
        XCTAssertEqual(CalorieCalculator.dailyNeeds(bmr: 1748.75, activity: .veryActive), 3016.59, accuracy: 0.1)
    }

    func testAllActivityMultipliers() {
        let bmr = 1748.75
        XCTAssertEqual(CalorieCalculator.dailyNeeds(bmr: bmr, activity: .lightlyActive), bmr * 1.375, accuracy: 0.01)
        XCTAssertEqual(CalorieCalculator.dailyNeeds(bmr: bmr, activity: .moderatelyActive), bmr * 1.55, accuracy: 0.01)
        XCTAssertEqual(CalorieCalculator.dailyNeeds(bmr: bmr, activity: .extraActive), bmr * 1.9, accuracy: 0.01)
    }

    func testTargetLose05() {
        XCTAssertEqual(CalorieCalculator.calorieTarget(needs: 2098.5, goal: .lose05kg), 1598.5, accuracy: 0.01)
    }

    func testTargetMaintain() {
        XCTAssertEqual(CalorieCalculator.calorieTarget(needs: 2098.5, goal: .maintain), 2098.5, accuracy: 0.01)
    }

    func testAllGoalOffsets() {
        XCTAssertEqual(CalorieCalculator.calorieTarget(needs: 2098.5, goal: .lose1kg), 1098.5, accuracy: 0.01)
        XCTAssertEqual(CalorieCalculator.calorieTarget(needs: 2098.5, goal: .gain05kg), 2598.5, accuracy: 0.01)
        XCTAssertEqual(CalorieCalculator.calorieTarget(needs: 2098.5, goal: .gain1kg), 3098.5, accuracy: 0.01)
    }

    func testDashboardRemaining() {
        XCTAssertEqual(CalorieCalculator.remaining(target: 2000, consumed: 1200, burned: 300), 1100, accuracy: 0.01)
    }

    func testDashboardNegativeRemaining() {
        XCTAssertEqual(CalorieCalculator.remaining(target: 2000, consumed: 2500, burned: 0), -500, accuracy: 0.01)
    }

    func testDashboardFreshDay() {
        XCTAssertEqual(CalorieCalculator.remaining(target: 2000, consumed: 0, burned: 0), 2000, accuracy: 0.01)
    }

    func testFoodFilter() {
        let foods = [(name: "White Rice", calories: 204.0), (name: "Fried Rice", calories: 333.0), (name: "Apple", calories: 95.0)]
        let result = FoodCatalogViewModel.filterFoods(foods, query: "rice")
        XCTAssertEqual(result.count, 2)
        // alphabetical, case-insensitive sort
        XCTAssertEqual(result.map(\.name), ["Fried Rice", "White Rice"])
    }

    func testDayTrackingNewDay() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        XCTAssertTrue(DayTrackingViewModel.isNewDay(last: yesterday, now: Date()))
        XCTAssertFalse(DayTrackingViewModel.isNewDay(last: Date(), now: Date()))
    }
}
