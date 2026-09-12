## Purpose

Maintains a searchable catalog of food items with their calorie information, allowing users to look up existing foods or add custom entries.

## ADDED Requirements

### Requirement: Store food items with calorie data
The system SHALL store each food item with: name (unique identifier), calorie amount (kcal), portion size (numeric), and portion unit name (text, e.g. "piece", "gram", "cup").

#### Scenario: Food item contains all required fields
- **WHEN** a food item is created
- **THEN** it SHALL have a name, calorie value, portion quantity, and portion unit name — all non-empty

### Requirement: List all foods sorted alphabetically
The system SHALL provide a view of all stored foods sorted alphabetically by name (case-insensitive), showing each food's name and calorie amount.

#### Scenario: Browse food catalog
- **WHEN** the user opens the food selection list
- **THEN** the system SHALL display all foods in alphabetical order with name and calorie count visible

### Requirement: Search foods by name
The system SHALL allow users to search the food catalog by name, returning matching entries (case-insensitive partial match).

#### Scenario: Search returns matching foods
- **WHEN** the user searches for "rice"
- **THEN** the system SHALL return all foods whose name contains "rice" (e.g. "White Rice", "Fried Rice")

#### Scenario: Search with no results
- **WHEN** the user searches for a term that matches no foods
- **THEN** the system SHALL display an empty result set or a "no results" indicator

### Requirement: Add custom food items
The system SHALL allow users to create new food entries by providing a name, calorie amount, portion size, and portion unit name.

#### Scenario: Successfully add a custom food
- **WHEN** the user fills in all required food fields and saves
- **THEN** the new food SHALL be persisted in the catalog and available for selection in meal logging

#### Scenario: Attempt to add food with missing fields
- **WHEN** the user tries to save a food item with any required field empty or invalid
- **THEN** the system SHALL display a validation error and SHALL NOT save the entry

### Requirement: Delete food items
The system SHALL allow users to delete food entries from the catalog.

#### Scenario: Delete an existing food
- **WHEN** the user confirms deletion of a food item
- **THEN** the food SHALL be removed from the catalog and SHALL no longer appear in search results or selection lists
