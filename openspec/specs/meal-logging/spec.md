# meal-logging Specification

## Purpose

Lets users log food consumption organized by meal category (breakfast, lunch, dinner, snack), tracking what they ate each day.

## Requirements

### Requirement: Log food to a meal category
The system SHALL allow users to add a food item to one of four meal categories: breakfast, lunch, dinner, or snack. Each log entry SHALL record the food name, calorie amount, portion amount, and the meal category.

#### Scenario: Add food to breakfast
- **WHEN** the user selects a food from the catalog while on the breakfast activity page
- **THEN** the system SHALL prompt for portion amount and save the entry under today's breakfast diary

#### Scenario: Add food to lunch
- **WHEN** the user selects a food from the catalog while on the lunch activity page
- **THEN** the system SHALL prompt for portion amount and save the entry under today's lunch diary

#### Scenario: Add food to dinner
- **WHEN** the user selects a food from the catalog while on the dinner activity page
- **THEN** the system SHALL prompt for portion amount and save the entry under today's dinner diary

#### Scenario: Add food to snack
- **WHEN** the user selects a food from the catalog while on the snack activity page
- **THEN** the system SHALL prompt for portion amount and save the entry under today's snack diary

### Requirement: View food diary entries by meal category
The system SHALL display all food entries for the current day, grouped by meal category, showing each entry's food name and calorie amount.

#### Scenario: View today's breakfast entries
- **WHEN** the user navigates to the breakfast activity page
- **THEN** the system SHALL display all breakfast food entries logged today with name and calorie count

#### Scenario: No entries for a meal category
- **WHEN** the user opens a meal category with no logged entries
- **THEN** the system SHALL display an empty list or "no entries" indicator

### Requirement: Delete food diary entries
The system SHALL allow users to remove a food entry from a meal category by confirming the deletion.

#### Scenario: Delete a breakfast entry
- **WHEN** the user taps a breakfast entry and confirms deletion
- **THEN** the entry SHALL be removed from the breakfast diary and the calorie total for that meal SHALL update accordingly

### Requirement: Calculate total calories per meal category
The system SHALL compute and display the sum of calories for all food entries within each meal category for the current day.

#### Scenario: Total calories after adding multiple breakfast items
- **WHEN** the user has logged "Oatmeal" (150 kcal) and "Orange Juice" (110 kcal) for breakfast
- **THEN** the system SHALL display breakfast total = 260 kcal
