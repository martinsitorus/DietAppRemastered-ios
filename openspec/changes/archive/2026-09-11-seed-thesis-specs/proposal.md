## Why

DietProject is a 2015 Android calorie counter and diet planner built as a Bachelor's thesis. The codebase is being remastered for iOS but has no formal specs documenting its behavior. Seeding OpenSpec capabilities from the thesis establishes a single source of truth for what the app does, before any iOS reimplementation begins.

## What Changes

- Create initial capability specs derived from the original thesis requirements, use cases, and implementation details
- Document the app's core behaviors: BMR/calorie calculations, food & workout catalogs, daily diary logging, and dashboard display
- Establish a baseline that the iOS remaster can evolve against

## Capabilities

### New Capabilities

- `user-profile`: User profile input (height, weight, age, gender, activity level), BMR calculation via Mifflin-St Jeor equation, daily calorie needs computation, and calorie target setting (lose/maintain/gain)
- `food-catalog`: Food database with CRUD operations, search by name, user-added custom foods with name/calorie/portion/portionsize
- `workout-catalog`: Workout type database with CRUD operations, user-added custom workout types with name/calorie/portion/portionsize
- `meal-logging`: Daily food diary entries organized by meal category (breakfast, lunch, dinner, snack), add/delete food entries with portion amounts
- `workout-logging`: Daily workout diary entries, add/delete workout entries with portion amounts
- `daily-dashboard`: Main screen displaying calorie target, calories consumed, calories burned, and remaining calories for the current day
- `day-tracking`: Automatic day progression based on date comparison, day ID management, daily progress snapshots stored for historical tracking

### Modified Capabilities

(none — no existing specs)

## Impact

- No existing code affected (iOS app not yet implemented)
- Spec files will be created under `openspec/specs/`
- Provides foundation for iOS implementation planning and task breakdown
