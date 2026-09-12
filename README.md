# DietApp Remastered — iOS

A native iOS diet and calorie tracking app built with SwiftUI + SwiftData.

This is an updated recreation and modernization of a previous undergraduate thesis project originally built for Android. The core diet-planning concept, calorie math, and food/workout tracking flows are preserved, then rebuilt from scratch with a modern iOS stack, cleaner architecture, and persistent local storage.

Original thesis documents (abstract, chapters I–VII) are archived under `Overview/` for reference.

## Features

- **User profile & calorie target**
  - Weight, height, age, gender, activity level, weight goal
  - BMR via Mifflin-St Jeor, daily needs via activity multiplier, target via goal offset
- **Food catalog**
  - Preloaded `foods.json` + custom foods
  - Search, add, edit
- **Meal logging**
  - Log by meal category: breakfast / lunch / dinner / snack
  - Portion-based calorie scaling
- **Workout catalog & logging**
  - Preloaded workouts + custom entries
  - Calories burned tracking
- **Daily dashboard**
  - Target vs. consumed vs. burned
  - Remaining = Target + Burned − Consumed
  - Day-by-day progress history
- **Local persistence**
  - SwiftData models: `UserProfile`, `Food`, `Workout`, `FoodDiaryEntry`, `WorkoutDiaryEntry`, `DayProgress`

## Tech Stack

- SwiftUI
- SwiftData
- Swift 5 / Xcode 15+
- iOS 17+ target
- Pure-logic `CalorieCalculator` (unit-testable, no UI dependencies)

## Project Structure

```
DietApp/
  DietAppApp.swift          # App entry + ModelContainer
  Models/
    Models.swift            # SwiftData models
    CalorieCalculator.swift # BMR / TDEE / target logic, enums
  ViewModels/
    DashboardViewModel.swift
    DayTrackingViewModel.swift
    FoodCatalogViewModel.swift
    MealLoggingViewModel.swift
    WorkoutCatalogViewModel.swift
    WorkoutLoggingViewModel.swift
    UserProfileViewModel.swift
  Views/
    ContentView.swift
    DashboardView.swift
    FoodViews.swift
    MealLogViews.swift
    WorkoutViews.swift
    WorkoutDiaryViews.swift
    ProfileView.swift
  Resources/
    foods.json
    Assets.xcassets
  Tests/
    CalorieCalculationTests.swift
Overview/                   # Original Android thesis PDFs
```

## Calorie Math

- Male BMR: `10 × weightKg + 6.25 × heightCm − 5 × age + 5`
- Female BMR: `10 × weightKg + 6.25 × heightCm − 5 × age − 161`
- Daily needs: `BMR × activity multiplier` (1.2 – 1.9)
- Target: `needs + goal offset` (−1000 to +1000)
- Remaining: `target + burned − consumed`

## Getting Started

1. Clone:
   ```bash
   git clone https://github.com/martinsitorus/DietAppRemastered-ios.git
   ```
2. Open `DietApp.xcodeproj` in Xcode.
3. Select an iPhone simulator (iOS 17+).
4. Run with `Cmd + R`.

No API keys, no backend, no CocoaPods/SPM dependencies required.

## Thesis Background

The original Android version was developed as a thesis project covering diet theory, system design, and implementation (see `Overview/CHAPTER I.pdf` through `CHAPTER VII.pdf`). This iOS remaster keeps the same problem domain — helping users plan and track daily calories — while updating:

- Java/XML Android UI → declarative SwiftUI
- SQLite/manual DB → SwiftData
- Legacy structure → MVVM with isolated ViewModels
- Hard-coded logic → tested `CalorieCalculator` + `CalorieCalculationTests`

## Status

Active re-development. Profile, food/workout logging, and dashboard flows are implemented; polish, charts, and HealthKit integration are future work.
