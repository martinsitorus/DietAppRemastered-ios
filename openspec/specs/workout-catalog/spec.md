# workout-catalog Specification

## Purpose

Maintains a catalog of workout and exercise types with their calorie burn values, allowing users to look up existing workouts or add custom entries.

## Requirements

### Requirement: Store workout types with calorie burn data
The system SHALL store each workout type with: name (unique identifier), calorie burn amount (kcal), duration/portionsize (numeric), and duration unit name (text, e.g. "minutes", "sets", "reps").

#### Scenario: Workout type contains all required fields
- **WHEN** a workout type is created
- **THEN** it SHALL have a name, calorie burn value, portion quantity, and portion unit name — all non-empty

### Requirement: List all workout types
The system SHALL provide a view of all stored workout types, showing each workout's name and calorie burn amount.

#### Scenario: Browse workout catalog
- **WHEN** the user opens the workout selection list
- **THEN** the system SHALL display all workout types with name and calorie count visible

### Requirement: Add custom workout types
The system SHALL allow users to create new workout entries by providing a name, calorie burn amount, portion size, and portion unit name.

#### Scenario: Successfully add a custom workout type
- **WHEN** the user fills in all required workout fields and saves
- **THEN** the new workout type SHALL be persisted in the catalog and available for selection in workout logging

#### Scenario: Attempt to add workout with missing fields
- **WHEN** the user tries to save a workout type with any required field empty or invalid
- **THEN** the system SHALL display a validation error and SHALL NOT save the entry

### Requirement: Delete workout types
The system SHALL allow users to delete workout entries from the catalog.

#### Scenario: Delete an existing workout type
- **WHEN** the user confirms deletion of a workout type
- **THEN** the workout type SHALL be removed from the catalog and SHALL no longer appear in selection lists
