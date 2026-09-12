import Foundation
import SwiftData
import Observation

@Observable
@MainActor
public final class DayTrackingViewModel {
    private static let dayIDKey = "dietapp.dayID"
    private static let lastDateKey = "dietapp.lastDate"

    public private(set) var currentDayID: Int = 1
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.currentDayID = defaults.integer(forKey: Self.dayIDKey)
        if self.currentDayID < 1 { self.currentDayID = 1 }
    }

    public var lastRecordedDate: Date? {
        defaults.object(forKey: Self.lastDateKey) as? Date
    }

    /// Called on every app launch. Returns true if a rollover happened.
    @discardableResult
    public func checkDayRollover(
        now: Date = Date(),
        context: ModelContext,
        snapshotProvider: () -> (target: Double, consumed: Double, burned: Double)
    ) -> Bool {
        // First launch: initialise day 1 + start date.
        guard let last = lastRecordedDate else {
            currentDayID = 1
            defaults.set(currentDayID, forKey: Self.dayIDKey)
            defaults.set(now, forKey: Self.lastDateKey)
            return false
        }
        // Same calendar day -> no increment.
        if Calendar.current.isDate(last, inSameDayAs: now) {
            return false
        }
        // New day: snapshot previous day, then increment.
        let snapshot = snapshotProvider()
        let completedDayID = currentDayID
        let snapshotRecord = DayProgress(
            dayID: completedDayID,
            date: last,
            calorieTarget: snapshot.target,
            totalConsumed: snapshot.consumed,
            totalBurned: snapshot.burned
        )
        context.insert(snapshotRecord)
        try? context.save()

        currentDayID += 1
        defaults.set(currentDayID, forKey: Self.dayIDKey)
        defaults.set(now, forKey: Self.lastDateKey)
        return true
    }

    public func snapshotForDay(_ dayID: Int, context: ModelContext) -> DayProgress? {
        let descriptor = FetchDescriptor<DayProgress>(predicate: #Predicate { $0.dayID == dayID })
        return try? context.fetch(descriptor).first
    }

    // MARK: - Test helpers (pure date logic)

    public static func isNewDay(last: Date?, now: Date) -> Bool {
        guard let last else { return true }
        return !Calendar.current.isDate(last, inSameDayAs: now)
    }
}
