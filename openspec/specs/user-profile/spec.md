# user-profile Specification

## Purpose

Manages user profile data and calculates BMR, daily calorie needs, and calorie targets to guide weight management goals.

## Requirements

### Requirement: Collect user profile data
The system SHALL collect the following user profile fields: weight (kg), height (cm), age (years), gender (male/female), activity level, and weight target goal.

#### Scenario: First-time user provides profile data
- **WHEN** the user launches the app for the first time
- **THEN** the system SHALL display a profile form requesting weight, height, age, gender, activity level, and target goal, and SHALL NOT proceed to the main dashboard until all required fields are saved

#### Scenario: Existing user updates profile data
- **WHEN** the user navigates to the update profile screen
- **THEN** the system SHALL pre-fill the form with the most recently saved profile values and allow the user to modify and save any field

### Requirement: Calculate Basal Metabolic Rate (BMR)
The system SHALL calculate BMR using the Mifflin-St Jeor equation:
- Men: BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age(years) + 5
- Women: BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age(years) - 161

#### Scenario: Calculate BMR for male user
- **WHEN** a male user with weight=80kg, height=175cm, age=30 saves profile data
- **THEN** the system SHALL compute BMR = 10*80 + 6.25*175 - 5*30 + 5 = 1748.75 kcal/day

#### Scenario: Calculate BMR for female user
- **WHEN** a female user with weight=65kg, height=160cm, age=25 saves profile data
- **THEN** the system SHALL compute BMR = 10*65 + 6.25*160 - 5*25 - 161 = 1379 kcal/day

### Requirement: Calculate daily calorie needs
The system SHALL compute daily calorie needs by multiplying BMR by an activity level factor:
- Sedentary: BMR * 1.2
- Lightly Active: BMR * 1.375
- Moderately Active: BMR * 1.55
- Very Active: BMR * 1.725
- Extra Active: BMR * 1.9

#### Scenario: Calculate needs for sedentary user
- **WHEN** a user with BMR=1748.75 selects "Sedentary" activity level
- **THEN** the system SHALL compute daily calorie needs = 1748.75 * 1.2 = 2098.5 kcal/day

#### Scenario: Calculate needs for very active user
- **WHEN** a user with BMR=1748.75 selects "Very Active" activity level
- **THEN** the system SHALL compute daily calorie needs = 1748.75 * 1.725 = 3016.6 kcal/day

### Requirement: Set calorie target based on weight goal
The system SHALL compute the daily calorie target by applying a goal offset to daily calorie needs:
- Lose 1kg/week: Needs - 1000 kcal
- Lose 0.5kg/week: Needs - 500 kcal
- Maintain weight: Needs (no offset)
- Gain 0.5kg/week: Needs + 500 kcal
- Gain 1kg/week: Needs + 1000 kcal

#### Scenario: Target for losing 0.5kg per week
- **WHEN** a user with daily calorie needs=2098.5 selects "Lose 0.5kg/week" target
- **THEN** the system SHALL set calorie target = 2098.5 - 500 = 1598.5 kcal/day

#### Scenario: Target for maintaining weight
- **WHEN** a user with daily calorie needs=2098.5 selects "Maintain weight" target
- **THEN** the system SHALL set calorie target = 2098.5 kcal/day (no offset applied)

### Requirement: Persist profile data locally
The system SHALL store the user profile, BMR, daily calorie needs, and calorie target in local device storage, and SHALL make these values available to other capabilities (dashboard, day tracking) without requiring re-entry.

#### Scenario: Profile data survives app restart
- **WHEN** the user saves profile data and restarts the app
- **THEN** the system SHALL retain all profile fields, BMR, calorie needs, and calorie target, and display them when the user returns to the profile screen
