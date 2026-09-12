## Purpose

Provides the main screen that displays a daily summary of calorie target, calories consumed, calories burned, and remaining calories for the current day.

## ADDED Requirements

### Requirement: Display daily calorie summary on main dashboard
The system SHALL display the following four values on the main dashboard:
1. Calorie Target (user's daily goal)
2. Calories Consumed (total from all meals today)
3. Calories Burned (total from all workouts today)
4. Calories Remaining (Target + Burned - Consumed)

#### Scenario: Dashboard with typical daily data
- **WHEN** the user's calorie target is 2000 kcal, they have consumed 1200 kcal, and burned 300 kcal
- **THEN** the dashboard SHALL display: Target=2000 kcal, Consumed=1200 kcal, Burned=300 kcal, Remaining=1100 kcal

#### Scenario: Dashboard on fresh day with no entries
- **WHEN** the user opens the app on a new day with no food or workout entries
- **THEN** the dashboard SHALL display: Target=(user's target), Consumed=0 kcal, Burned=0 kcal, Remaining=Target kcal

#### Scenario: Dashboard with excess calories consumed
- **WHEN** the user's calorie target is 2000 kcal, consumed=2500 kcal, burned=0 kcal
- **THEN** the dashboard SHALL display Remaining = -500 kcal (negative value to indicate overage)

### Requirement: Recalculate dashboard in real time
The system SHALL update the dashboard values immediately when a food or workout entry is added or deleted, without requiring a manual refresh.

#### Scenario: Dashboard updates after logging food
- **WHEN** the user adds a 400 kcal food entry
- **THEN** Calories Consumed and Calories Remaining SHALL update immediately on the dashboard

#### Scenario: Dashboard updates after deleting a workout
- **WHEN** the user deletes a 300 kcal workout entry
- **THEN** Calories Burned and Calories Remaining SHALL update immediately on the dashboard

### Requirement: Provide navigation to add activity and update profile
The system SHALL provide buttons or navigation on the main dashboard to: (1) Add Activity (which leads to meal/workout selection), and (2) Update User Data (which leads to the profile editing screen).

#### Scenario: Navigate to add activity
- **WHEN** the user taps "Add Activity" on the dashboard
- **THEN** the system SHALL navigate to the activity selection screen (breakfast, lunch, dinner, snack, workout)

#### Scenario: Navigate to update profile
- **WHEN** the user taps "Update User Data" on the dashboard
- **THEN** the system SHALL navigate to the profile editing screen with current values pre-filled
