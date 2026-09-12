# day-tracking Specification

## Purpose

Tracks daily progression by managing day IDs, detecting date rollovers, and recording daily progress snapshots for historical review.

## Requirements

### Requirement: Auto-detect new day and increment day ID
The system SHALL maintain a day counter (day ID) that starts at 1 on first launch and increments by 1 each time a new calendar day is detected, based on comparing the current date to the last recorded date.

#### Scenario: First app launch initializes day tracking
- **WHEN** the user launches the app for the first time
- **THEN** the system SHALL set day ID = 1 and record the current date as the start date

#### Scenario: Day rollover on next calendar day
- **WHEN** the user opens the app on a new calendar day (at least 24 hours since last recorded date)
- **THEN** the system SHALL increment the day ID by 1 and record the new date

#### Scenario: Same day re-open does not increment
- **WHEN** the user opens the app again on the same calendar day
- **THEN** the system SHALL NOT increment the day ID

### Requirement: Record daily progress snapshots
The system SHALL save a daily progress record at the end of each day (or on next app open) containing: day ID, calorie target, total calories consumed, and total calories burned.

#### Scenario: Save progress for completed day
- **WHEN** a new day is detected and the day ID increments
- **THEN** the system SHALL persist a snapshot of the previous day's data (day ID, target, consumed, burned) for historical tracking

#### Scenario: Progress snapshot captures all daily totals
- **WHEN** the day ID increments from day 5 to day 6
- **THEN** the system SHALL save: day=5, target=(user's target), consumed=(total food calories on day 5), burned=(total workout calories on day 5)

### Requirement: Store day tracking data locally
The system SHALL persist the current day ID, last recorded date, and all daily progress snapshots in local device storage.

#### Scenario: Day tracking survives app restart
- **WHEN** the user restarts the app
- **THEN** the system SHALL retain the current day ID and last recorded date, and correctly detect whether a new day has started

### Requirement: Provide historical progress data
The system SHALL make stored daily progress snapshots queryable by day ID, enabling other capabilities (future features) to retrieve past daily totals.

#### Scenario: Query a specific day's progress
- **WHEN** the system is asked for progress data for day ID 5
- **THEN** it SHALL return the calorie target, consumed, and burned values recorded for that day
