# 📐 Nabung Challenge - Architecture Overview

## Project Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    NABUNG CHALLENGE APP                  │
│                    (Flutter Mobile)                       │
└─────────────────────────────────────────────────────────┘
                            │
                ┌───────────┴───────────┐
                │                       │
         ┌──────▼─────┐         ┌──────▼─────┐
         │   UI Layer  │         │ State Mgmt  │
         │  (Screens)  │         │ (Provider)  │
         └──────┬─────┘         └──────┬─────┘
                │                       │
         ┌──────▼─────────────────────▼──────┐
         │                                    │
         │     Widgets & Components Layer     │
         │ (GoalCard, ProgressJar, etc.)     │
         └──────┬─────────────────────┬──────┘
                │                     │
         ┌──────▼───────┐      ┌─────▼──────┐
         │ Validators    │      │  Helpers   │
         │  & Constants  │      │  & Utilities│
         └──────┬────────┘      └──────┬─────┘
                │                      │
         ┌──────▼──────────────────────▼──────┐
         │                                    │
         │        Services Layer               │
         │  (Business Logic)                  │
         │                                    │
         └──────┬────────────────┬────────┬──┘
                │                │        │
         ┌──────▼────┐   ┌──────▼────┐  │
         │ Database   │   │Notification│  │
         │ Service    │   │ Service    │  │
         └──────┬────┘   └────────────┘  │
                │                        │
         ┌──────▼─────────────────────┬──▼─┐
         │                            │    │
         │    Data Models             │    │ SharedPrefs
         │  (SavingGoal, etc.)        │    │ Service
         │                            │    │
         └─────┬──────────────────────┴────┘
               │
         ┌─────▼─────────────────┐
         │   Data Layer           │
         │  - SQLite Database     │
         │  - Shared Preferences  │
         │  - File System         │
         └────────────────────────┘
```

---

## Data Flow Architecture

### Goal Creation Flow (Example)

```
User Input (Create Goal Screen)
         │
         ▼
    [Form Validation]  ◄─── AppValidators
         │
         ├─ Valid ───▼──────────────────┐
         │                              │
         └─ Invalid ──► Show Error      │
                         Message        │
                                        │
                                   ┌────▼─────────────┐
                                   │ GoalProvider      │
                                   │(State Management) │
                                   └──────┬────────────┘
                                          │
                                          ▼
                                   [Create Goal]
                                          │
                                          ▼
                                   DatabaseService
                                          │
                                   ┌──────┴───────┐
                                   │              │
                                ┌──▼────┐    ┌───▼──┐
                                │ Insert │    │Create│
                                │  Goal  │    │Table │
                                └────────┘    │Entry │
                                              └──────┘
                                   │
                                   ▼
                            [SQLite Database]
                                   │
                                   ▼
                         [Notify Listeners]
                                   │
                    ┌──────────────┴──────────────┐
                    │                             │
                    ▼                             ▼
            [Update Home Screen]        [Navigate to Detail]
                    │                             │
                    ▼                             ▼
              [Display New Goal]       [Show Goal Details]
```

---

## Screen Navigation Flow

```
                        ┌──────────────────┐
                        │  Splash Screen   │
                        │  (2 seconds)     │
                        └────────┬─────────┘
                                 │
                                 ▼
                        ┌──────────────────┐
                        │  Home Screen     │◄───┐
                        │  (Dashboard)     │    │
                        └────────┬─────────┘    │
                                 │              │
                    ┌────────────┼───────────┐  │
                    │            │           │  │
            ┌───────▼─────┐ ┌────▼────┐ ┌──▼──┘
        FAB │Create Goal  │ │Edit Goal │ │ Settings
            │   Screen    │ │  Screen  │ │  Screen
            └───────┬─────┘ └────┬────┘ └──────┘
                    │            │
                    │      ┌──────┘
                    │      │
                    ▼      ▼
            ┌──────────────────────┐
            │ Goal Detail Screen   │
            │ (View & Edit)        │
            └──────────────────────┘
                    │
                    ├─► Add Transaction Dialog
                    ├─► Edit Goal
                    └─► Delete Goal (with confirmation)
```

---

## State Management Structure

```
┌────────────────────────────────────────────────────────────────┐
│                        Provider Pattern                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────┐                           │
│  │     GoalProvider (TODO)          │                           │
│  ├─────────────────────────────────┤                           │
│  │ State:                           │                           │
│  │ - goals: List<SavingGoal>        │                           │
│  │ - isLoading: bool                │                           │
│  │ - selectedGoal: SavingGoal?      │                           │
│  │                                  │                           │
│  │ Methods:                         │                           │
│  │ - loadGoals()                    │                           │
│  │ - createGoal(goal)               │                           │
│  │ - updateGoal(goal)               │                           │
│  │ - deleteGoal(id)                 │                           │
│  │ - addTransaction(id, amount)     │                           │
│  └──────────┬───────────────────────┘                           │
│             │                                                   │
│             ├──► DatabaseService (creates/reads/updates)       │
│             └──► notifyListeners() (updates UI)                │
│                                                                 │
│  ┌─────────────────────────────────┐                           │
│  │   SettingsProvider (TODO)        │                           │
│  ├─────────────────────────────────┤                           │
│  │ State:                           │                           │
│  │ - isPremium: bool                │                           │
│  │ - language: String               │                           │
│  │ - theme: String                  │                           │
│  │ - notificationsEnabled: bool     │                           │
│  │                                  │                           │
│  │ Methods:                         │                           │
│  │ - loadSettings()                 │                           │
│  │ - updateSetting(key, value)      │                           │
│  │ - enableNotifications()          │                           │
│  │ - setPremium(bool)               │                           │
│  └──────────┬───────────────────────┘                           │
│             │                                                   │
│             ├──► SharedPrefsService                             │
│             └──► notifyListeners()                              │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## Database Schema

```
┌──────────────────────────────────────┐
│         SAVING_GOALS TABLE           │
├──────────────────────────────────────┤
│ id (PRIMARY KEY, INT)                │
│ name (TEXT, NOT NULL)                │
│ targetAmount (REAL, NOT NULL)        │
│ currentAmount (REAL, DEFAULT 0)      │
│ category (TEXT, NOT NULL)            │
│ startDate (TEXT, NOT NULL)           │
│ targetDate (TEXT, NULLABLE)          │
│ imageUrl (TEXT)                      │
│ isCompleted (INT, DEFAULT 0)         │
│ completedDate (TEXT, NULLABLE)       │
│ createdAt (TEXT, NOT NULL)           │
│ updatedAt (TEXT, NOT NULL)           │
└──────────────────────────────────────┘
           │
           │ 1──► N
           │
┌──────────────────────────────────────┐
│      TRANSACTIONS TABLE              │
├──────────────────────────────────────┤
│ id (PRIMARY KEY, INT)                │
│ goalId (INT, FOREIGN KEY)            │
│ amount (REAL, NOT NULL)              │
│ date (TEXT, NOT NULL)                │
│ note (TEXT, NULLABLE)                │
│ createdAt (TEXT, NOT NULL)           │
│                                      │
│ INDEX: idx_transactions_goalId       │
└──────────────────────────────────────┘

Relationship:
  1 SavingGoal : N Transactions (One-to-Many)
  
  When goal is deleted, all transactions cascade delete
```

---

## File Structure with Dependencies

```
main.dart
  ├─ imports: flutter, Provider, Screens
  │
  ├─ screens/
  │  ├─ splash_screen.dart
  │  │  └─ imports: flutter
  │  │
  │  ├─ home_screen.dart
  │  │  ├─ imports: Provider, models, widgets, utils
  │  │  └─ depends: GoalProvider (TODO), database_service
  │  │
  │  ├─ create_goal_screen.dart
  │  │  ├─ imports: models, validators, utils
  │  │  └─ depends: GoalProvider (TODO), database_service
  │  │
  │  ├─ goal_detail_screen.dart
  │  │  ├─ imports: models, widgets, utils
  │  │  └─ depends: GoalProvider (TODO), database_service
  │  │
  │  └─ settings_screen.dart
  │     ├─ imports: services
  │     └─ depends: SharedPrefsService
  │
  ├─ models/
  │  ├─ saving_goal.dart (✅ Complete)
  │  ├─ transaction.dart (✅ Complete)
  │  └─ challenge.dart (✅ Complete)
  │
  ├─ services/
  │  ├─ database_service.dart (✅ Complete)
  │  │  └─ uses: sqflite, path_provider
  │  │
  │  ├─ notification_service.dart (✅ Complete)
  │  │  └─ uses: flutter_local_notifications, timezone
  │  │
  │  └─ shared_prefs_service.dart (✅ Complete)
  │     └─ uses: shared_preferences
  │
  ├─ providers/ (TODO)
  │  ├─ goal_provider.dart (TODO)
  │  │  ├─ uses: ChangeNotifier, database_service
  │  │  └─ used by: all screens
  │  │
  │  └─ settings_provider.dart (TODO)
  │     ├─ uses: ChangeNotifier, shared_prefs_service
  │     └─ used by: all screens
  │
  ├─ widgets/
  │  ├─ goal_card.dart (✅ Complete)
  │  │  └─ uses: models, utils
  │  │
  │  ├─ progress_jar.dart (✅ Complete)
  │  │  └─ uses: CustomPaint, animations
  │  │
  │  ├─ transaction_item.dart (✅ Complete)
  │  │  └─ uses: models, utils
  │  │
  │  ├─ empty_state.dart (✅ Complete)
  │  │  └─ uses: flutter
  │  │
  │  └─ challenge_button.dart (✅ Complete)
  │     └─ uses: models
  │
  └─ utils/
     ├─ constants.dart (✅ Complete)
     │  └─ provides: colors, styles, strings, constants
     │
     ├─ helpers.dart (✅ Complete)
     │  └─ provides: formatting, calculations, validation helpers
     │
     └─ validators.dart (✅ Complete)
        └─ provides: form field validators
```

---

## Development Phases Dependencies

```
Phase 1: Foundation (Week 1-2)
  ├─ ✅ Project structure
  ├─ ✅ Models & databases
  └─ ⏳ Provider setup (TODO)

Phase 2: Core Development (Week 3-5)
  ├─ ⏳ Navigation (depends: Phase 1)
  ├─ ⏳ Database integration (depends: Phase 1)
  └─ ⏳ UI implementation (depends: Phase 1, 2.1, 2.2)

Phase 3: Polish & Features (Week 6-7)
  ├─ ⏳ Advanced features (depends: Phase 2)
  └─ ⏳ Monetization (depends: Phase 2)

Phase 4: Testing & Launch (Week 8-10)
  ├─ ⏳ Testing (depends: Phase 3)
  └─ ⏳ Store preparation (depends: Phase 3)
```

---

## Component Interaction Example: Adding a Savings Transaction

```
┌─────────────────────────────────────────────────────────────────┐
│ User: Tap "Add Savings" button on Goal Detail Screen            │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ Add Savings Dialog Opens     │
        │ (User enters: amount, note) │
        └──────────┬──────────────────┘
                   │
                   ▼
        ┌──────────────────────────────┐
        │ User taps "Save" button      │
        └──────────┬───────────────────┘
                   │
                   ▼
      ┌────────────────────────────────┐
      │ Validators.validateAmount()    │
      │ (Check: > 0, < max, numeric)  │
      └──────────┬─────────┬───────────┘
                 │         │
            Valid│         │Invalid
                 ▼         ▼
            [Continue]  [Show Error]
                 │       (back to dialog)
                 │
                 ▼
      ┌─────────────────────────────────┐
      │ GoalProvider.addTransaction()   │ (TODO)
      │ - Create Transaction object     │
      │ - Call DatabaseService         │
      └──────────┬────────────────────┘
                 │
                 ▼
      ┌──────────────────────────────────┐
      │ DatabaseService.addTransaction() │ (✅)
      │ - Insert into TRANSACTIONS table│
      │ - Get new currentAmount           │
      └──────────┬─────────────────────┘
                 │
                 ▼
      ┌──────────────────────────┐
      │ DatabaseService          │
      │ .updateGoal(goal with    │
      │  new currentAmount)      │
      └──────────┬───────────────┘
                 │
                 ▼
      ┌──────────────────────────────┐
      │ SQLite Database              │
      │ [TRANSACTIONS] + record      │
      │ [SAVING_GOALS] update amount │
      └──────────┬──────────────────┘
                 │
                 ▼
      ┌──────────────────────────────┐
      │ notifyListeners()            │
      │ (GoalProvider updates UI)    │
      └──────────┬──────────────────┘
                 │
                 ├─ Dialog closes      ─┐
                 │                     │
                 ├─ Home screen        │ UI Updates
                 │  refreshes          │
                 │                     │
                 └─ Goal detail        ─┘
                    shows new total
                    & transaction
```

---

## Testing Strategy (Planned for Phase 4)

```
┌────────────────────────────────────────────┐
│         Type of Testing                    │
├────────────────────────────────────────────┤
│                                            │
│  Unit Tests                                │
│  ├─ Model methods (progress calc, etc.)  │
│  ├─ Helper functions                     │
│  └─ Validators                           │
│                                            │
│  Widget Tests                              │
│  ├─ Individual widgets render correctly  │
│  ├─ User interactions work                │
│  └─ State changes reflect in UI          │
│                                            │
│  Integration Tests                        │
│  ├─ Full user flows                       │
│  ├─ Database operations                   │
│  └─ Provider state management             │
│                                            │
│  E2E Tests (Optional)                     │
│  ├─ Real device testing                   │
│  └─ User acceptance testing               │
│                                            │
└────────────────────────────────────────────┘
```

---

## Performance Considerations

```
┌─────────────────────────────────────────────────┐
│ Performance Optimization Points                 │
├─────────────────────────────────────────────────┤
│                                                 │
│ 1. Database Queries                             │
│    - Add indexes on frequently queried columns │
│    - Limit query results with LIMIT clause    │
│    - Use pagination for large lists            │
│                                                 │
│ 2. Widget Rendering                            │
│    - Use const constructors where possible     │
│    - Implement RepaintBoundary for animations  │
│    - Limit rebuild frequency                   │
│                                                 │
│ 3. State Management                            │
│    - Use Selector to rebuild only needed parts│
│    - Avoid rebuilding entire app on changes   │
│    - Lazy load data                            │
│                                                 │
│ 4. Memory Management                           │
│    - Properly dispose resources                │
│    - Cancel subscriptions & timers             │
│    - Cache data appropriately                  │
│                                                 │
│ 5. Network/Async                               │
│    - Debounce search queries                   │
│    - Cancel in-flight requests when navigating │
│    - Handle timeouts gracefully                │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Error Handling Strategy

```
┌──────────────────────────────────────────────┐
│ Error Handling Layers                        │
├──────────────────────────────────────────────┤
│                                              │
│ UI Layer                                     │
│ ├─ Validation errors                        │
│ ├─ User feedback (SnackBar/Dialog)         │
│ └─ Graceful degradation                     │
│                                              │
│ Business Logic Layer                        │
│ ├─ Provider error state management          │
│ ├─ Try-catch around database calls         │
│ └─ Fallback data/defaults                   │
│                                              │
│ Data Layer                                   │
│ ├─ Database error handling                  │
│ ├─ Connection failures                      │
│ └─ Data corruption recovery                 │
│                                              │
│ Global Error Handler (TODO)                 │
│ ├─ Catch unhandled exceptions               │
│ ├─ Log errors for debugging                 │
│ └─ Show user-friendly messages              │
│                                              │
└──────────────────────────────────────────────┘
```

---

This architecture provides a scalable, maintainable structure for the Nabung Challenge app with clear separation of concerns and easy extensibility for future features.

**Status:** ✅ Architecture defined and scaffolded  
**Next:** Implement TODO items (Providers) in Week 1-2
