## Context

DietProject is a 2015 Android calorie counter being remastered as an iOS app. The original ran on Android 4.0+ with Java, SQLite, and a flat Activity-based UI. No iOS codebase exists yet — this is a ground-up reimplementation targeting modern iOS (17+).

The app is a single-user, offline-first calorie tracker. Core loop: user enters profile, sees daily calorie budget, logs food and workouts, watches the remaining number change. Simple domain, but the data model has real relationships (foods -> diary entries, days -> snapshots).

## Goals / Non-Goals

**Goals:**
- Clean, modern iOS architecture using SwiftUI and SwiftData
- Faithfully reproduce all 7 capabilities from the thesis specs
- Single-user, offline-first — no accounts, no cloud sync
- Pre-seeded food database so the app is useful immediately
- Smooth day-to-day transition with no data loss

**Non-Goals:**
- Cloud sync or multi-device support (thesis future work, not this phase)
- Social features (thesis future work, not this phase)
- Barcode scanning or USDA API integration (future enhancement)
- HealthKit integration (future enhancement)
- Unit conversion (metric only, matching original)
- iPad-specific layouts (iPhone-first)

## Decisions

### 1. SwiftData over Core Data

**Choice:** SwiftData (iOS 17+)

**Why:** SwiftData is Apple's modern persistence layer — declarative, SwiftUI-native, and requires far less boilerplate than Core Data. The data model is simple enough (6 entity types) that SwiftData's limitations (no cloud sync, less mature migration tooling) don't matter.

**Alternatives considered:**
- Core Data: More mature, better migration support, but massive boilerplate for a simple domain. Overkill.
- Realm: Third-party dependency, adds weight for no real gain in a single-user offline app.
- SQLite directly: What the original used. Repeating that in Swift would be pointless — we'd rebuild an ORM by hand.

### 2. SwiftUI with MVVM-lite architecture

**Choice:** SwiftUI views with lightweight ViewModel classes (no protocol abstractions, no DI container)

**Why:** The app has ~7 screens. Full VIPER or Clean Architecture would be cargo-cult complexity. SwiftUI's `@Observable` macro gives us reactive data flow with almost zero ceremony. ViewModels own business logic (BMR calc, calorie math), Views own layout.

**Alternatives considered:**
- TCA (The Composable Architecture): Powerful but heavy. This app has no complex async flows or undo/redo needs.
- VIPER: Massive overhead for 7 screens.
- Pure SwiftUI (no ViewModels): Tempting, but BMR calculation and calorie aggregation logic shouldn't live in Views.

### 3. Tab-based navigation

**Choice:** Bottom tab bar with 3 tabs: Dashboard, Food Log, Workout Log

```
+-----------------------------------------+
| [Dashboard]  [Food Log]  [Workout Log]  |
|                                         |
|          (tab content here)             |
|                                         |
|  +--------+  +-------+  +----------+   |
|  |  Home  |  | Food  |  | Workout  |   |
|  +--------+  +-------+  +----------+   |
+-----------------------------------------+
```

**Why:** Matches the original's flow (Main Activity -> Add Activity -> meal/workout). The "Add Activity" button from the original becomes a tab, eliminating one navigation layer. Profile is accessed via gear icon on Dashboard.

**Alternatives considered:**
- NavigationStack-only (no tabs): Would require deeper navigation hierarchies, worse for the daily-loop use case.
- 5 tabs (one per meal): Too many tabs, the original consolidated meals under "Add Activity" for a reason.

### 4. Pre-seeded food database

**Choice:** Bundle a JSON file with ~200-300 common Indonesian foods (from the original invive.com source) and import into SwiftData on first launch

**Why:** The original pulled from invive.com. We preserve that data by bundling it. Users can still add custom foods, but the app is immediately useful without manual entry.

**Alternatives considered:**
- Empty database: Bad UX, users have to enter everything from scratch.
- USDA API: Requires internet, adds API key management, overkill for offline-first app.

### 5. Day tracking via calendar comparison

**Choice:** Store last-opened date in UserDefaults. On each app launch, compare to today. If different day, increment day ID and snapshot previous day's totals.

**Why:** Matches the original's SharedPreferences approach exactly. Simple, reliable, no background processing needed.

**Alternatives considered:**
- Background tasks / BGTaskScheduler: Overkill. The original only checked on foreground launch.
- CloudKit date sync: Non-goal (no cloud).

## Risks / Trade-offs

- **SwiftData migration stability** → SwiftData is still evolving. Mitigate by keeping the schema simple (no complex relationships) and being prepared to write manual migrations if Apple changes the framework.

- **Food database staleness** → Bundled data is frozen at release time. Mitigate by making user-added foods easy to create, and noting this as a future enhancement area (API sync).

- **No cross-device sync** → Single-device only, data lost on phone replacement. Mitigate by noting this as explicit future work (per thesis recommendations). Could add iCloud sync later without changing specs.

- **iOS 17+ minimum** → SwiftData requires iOS 17. This excludes ~5-10% of active devices. Acceptable for a personal project; would be a problem for mass-market app.
