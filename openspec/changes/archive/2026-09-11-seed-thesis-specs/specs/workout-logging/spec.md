## Purpose

Lets users log workout and exercise sessions, tracking calorie burn for physical activities performed each day.

## ADDED Requirements

### Requirement: Log a workout entry
The system SHALL allow users to add a workout type to their daily workout diary. Each log entry SHALL record the workout name, calorie burn amount, and portion amount.

#### Scenario: Add a workout entry
- **WHEN** the user selects a workout type from the catalog on the workout activity page
- **THEN** the system SHALL prompt for portion amount (e.g. duration in minutes) and save the entry under today's workout diary

### Requirement: View workout diary entries
The system SHALL display all workout entries logged for the current day, showing each entry's workout name and calorie burn amount.

#### Scenario: View today's workouts
- **WHEN** the user navigates to the workout activity page
- **THEN** the system SHALL display all workout entries logged today with name and calorie count

#### Scenario: No workouts logged today
- **WHEN** the user opens the workout page with no entries
- **THEN** the system SHALL display an empty list or "no entries" indicator

### Requirement: Delete workout diary entries
The system SHALL allow users to remove a workout entry from the daily diary by confirming the deletion.

#### Scenario: Delete a workout entry
- **WHEN** the user taps a workout entry and confirms deletion
- **THEN** the entry SHALL be removed from the workout diary and the calorie burn total SHALL update accordingly

### Requirement: Calculate total calories burned from workouts
The system SHALL compute and display the sum of calories burned across all workout entries for the current day.

#### Scenario: Total calories burned after multiple workouts
- **WHEN** the user has logged "Running" (300 kcal) and "Push-ups" (100 kcal) today
- **THEN** the system SHALL display total calories burned = 400 kcal
