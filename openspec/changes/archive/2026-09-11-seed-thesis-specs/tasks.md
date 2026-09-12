## 1. Project Setup

- [x] 1.1 Create new Xcode project with SwiftUI app template, iOS 17+ target, and verify build succeeds
- [x] 1.2 Add SwiftData dependency and configure the main App entry point with a SwiftData model container, verify app launches without crash
- [x] 1.3 Define SwiftData @Model classes for all 6 entities (UserProfile, Food, Workout, FoodDiaryEntry, WorkoutDiaryEntry, DayProgress) and verify they compile
- [x] 1.4 Set up basic tab-based navigation structure (Dashboard, Food Log, Workout Log tabs) and verify tabs render

## 2. User Profile & Calorie Calculation

- [x] 2.1 Create UserProfileViewModel with BMR calculation (Mifflin-St Jeor) and verify with test inputs: male 80kg/175cm/30y -> BMR=1748.75
- [x] 2.2 Add daily calorie needs calculation with 5 activity level multipliers and verify: sedentary BMR=1748.75 -> needs=2098.5
- [x] 2.3 Add calorie target calculation with 5 goal offsets and verify: needs=2098.5 + lose 0.5kg -> target=1598.5
- [x] 2.4 Build profile input form (weight, height, age, gender, activity level, target) and verify all fields are editable
- [x] 2.5 Add first-launch detection (check if profile exists) and verify profile form shows on first launch, hides on subsequent launches
- [x] 2.6 Add profile persistence to SwiftData and verify data survives app restart
- [x] 2.7 Build profile update screen with pre-filled values and verify changes save correctly

## 3. Food Catalog

- [x] 3.1 Create FoodCatalogViewModel with CRUD operations and verify create/read/delete cycle in a preview
- [x] 3.2 Build food list view sorted alphabetically with name and calorie display and verify sorting works
- [x] 3.3 Add search functionality with case-insensitive matching and verify search returns correct subset
- [x] 3.4 Build add-food form (name, calorie, portion, portion unit) with validation and verify empty fields show error
- [x] 3.5 Add delete functionality with confirmation dialog and verify food is removed from list
- [x] 3.6 Create bundled JSON food database (~200 common foods) and verify import on first launch populates catalog

## 4. Workout Catalog

- [x] 4.1 Create WorkoutCatalogViewModel with CRUD operations and verify create/read/delete cycle
- [x] 4.2 Build workout type list view and verify all types display with name and calorie burn
- [x] 4.3 Build add-workout form with validation and verify save and error handling
- [x] 4.4 Add delete functionality with confirmation and verify removal

## 5. Meal Logging

- [x] 5.1 Create MealLoggingViewModel with per-category (breakfast/lunch/dinner/snack) add, delete, and total calculations and verify totals update on add/delete
- [x] 5.2 Build meal category selection screen with 4 buttons and verify navigation to each category
- [x] 5.3 Build per-category diary view showing entries with name and calorie and verify entries display correctly
- [x] 5.4 Add food selection flow: tap category -> pick food from catalog -> enter portion -> save entry and verify entry appears in diary
- [x] 5.5 Add delete-from-diary with confirmation and verify calorie total recalculates

## 6. Workout Logging

- [x] 6.1 Create WorkoutLoggingViewModel with add, delete, and daily total calculation and verify total updates on changes
- [x] 6.2 Build workout diary view showing today's entries with name and calorie burn and verify display
- [x] 6.3 Add workout selection flow: pick workout type -> enter portion -> save entry and verify entry appears in diary
- [x] 6.4 Add delete-from-diary with confirmation and verify total recalculates

## 7. Daily Dashboard

- [x] 7.1 Create DashboardViewModel that aggregates food total, workout total, and computes remaining calories and verify math: target=2000, ate=1200, burned=300 -> remaining=1100
- [x] 7.2 Build dashboard view with 4 stat cards (target, consumed, burned, remaining) and verify layout
- [x] 7.3 Add real-time updates: dashboard refreshes when food or workout entry changes and verify no manual refresh needed
- [x] 7.4 Add navigation buttons (Add Activity, Update Profile) from dashboard and verify they navigate correctly
- [x] 7.5 Add negative remaining display (overage shown as negative number) and verify: target=2000, ate=2500 -> remaining=-500

## 8. Day Tracking

- [x] 8.1 Create DayTrackingViewModel with day ID management, date comparison, and snapshot recording and verify day increments on new calendar day
- [x] 8.2 Add first-launch initialization (day ID=1, record start date) and verify via preview/debug
- [x] 8.3 Add same-day re-open handling (no increment) and verify
- [x] 8.4 Add daily snapshot persistence (day ID, target, consumed, burned) and verify data stored correctly
- [x] 8.5 Wire day tracking into app launch lifecycle and verify day rolls over correctly after manual date change

## 9. Integration & Polish

- [x] 9.1 Wire all ViewModels together: dashboard reads from meal/workout ViewModels, day tracking triggers snapshot on rollover and verify end-to-end flow
- [x] 9.2 Test full user journey: first launch -> profile entry -> dashboard shows correct target -> add food -> remaining updates -> next day rolls over -> snapshot saved and verify each step
- [x] 9.3 Add app icon and basic branding and verify it appears on home screen
- [x] 9.4 Clean up preview providers and debug code and verify clean build with no warnings
