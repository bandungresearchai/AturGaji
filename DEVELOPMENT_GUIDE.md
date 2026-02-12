# 🛠️ Nabung Challenge - Development Guide

This document provides guidance for developing the Nabung Challenge Flutter app following the comprehensive 8-10 week development plan.

## 📚 Table of Contents

1. [Getting Started](#getting-started)
2. [Project Structure](#project-structure)
3. [Development Phases](#development-phases)
4. [Coding Standards](#coding-standards)
5. [Git Workflow](#git-workflow)
6. [Debugging & Testing](#debugging--testing)
7. [Common Tasks](#common-tasks)

## Getting Started

### Prerequisites

- Flutter 3.0+ installed
- Android SDK 24 (Android 7.0) or higher
- Android Studio or VS Code with Flutter extension
- Git for version control

### Installation

```bash
# Clone the repository
git clone https://github.com/bandungresearchai/AturGaji.git
cd AturGaji

# Get dependencies
flutter pub get

# Generate necessary files
flutter pub run build_runner build

# Run the app
flutter run
```

### First Run

```bash
# Create default device/emulator
flutter emulators --create --name "Pixel5"

# Launch the app
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── screens/                     # Screen widgets
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── create_goal_screen.dart
│   ├── goal_detail_screen.dart
│   ├── settings_screen.dart
│   └── index.dart              # Exports
├── models/                      # Data models
│   ├── saving_goal.dart
│   ├── transaction.dart
│   ├── challenge.dart
│   └── index.dart
├── services/                    # Business logic
│   ├── database_service.dart
│   ├── notification_service.dart
│   ├── shared_prefs_service.dart
│   └── index.dart
├── widgets/                     # Reusable widgets
│   ├── goal_card.dart
│   ├── progress_jar.dart
│   ├── transaction_item.dart
│   ├── empty_state.dart
│   ├── challenge_button.dart
│   └── index.dart
├── providers/                   # State management (Provider)
│   ├── goal_provider.dart      # TODO
│   ├── settings_provider.dart  # TODO
│   └── index.dart
├── utils/                       # Utilities
│   ├── constants.dart          # App constants
│   ├── helpers.dart            # Helper functions
│   ├── validators.dart         # Form validators
│   └── index.dart
└── assets/                      # Static assets
    ├── images/
    ├── icons/
    ├── illustrations/
    ├── fonts/
    └── splash/
```

## Development Phases

### Phase 1: Foundation (Week 1-2)
**Status:** ✅ Partially Complete

**Current Work:**
- [x] Project setup and structure
- [x] Base models and services
- [x] Screens scaffolding
- [ ] Provider state management
- [ ] Learn Dart & Flutter advanced concepts

**Next Steps:**
1. Study state management with Provider
2. Create GoalProvider for goal operations
3. Create SettingsProvider for app settings
4. Implement proper lifecycle management

**Resources:**
- [Provider Package](https://pub.dev/packages/provider)
- [State Management Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)

---

### Phase 2: Core Development (Week 3-5)
**Status:** ⏳ Starting

#### Week 3: App Structure & Navigation

**Tasks:**
- [ ] Implement Provider-based state management
- [ ] Add named route navigation
- [ ] Setup proper navigation between screens
- [ ] Implement deep linking support (optional)

**Key Files to Update:**
- `lib/main.dart` - Add route definitions
- `lib/providers/goal_provider.dart` - Create (NEW)
- `lib/screens/home_screen.dart` - Connect to provider

**Example:**
```dart
// In main.dart
routes: {
  '/': (context) => const HomeScreen(),
  '/create-goal': (context) => const CreateGoalScreen(),
  '/goal-detail': (context) => GoalDetailScreen(
    goalId: settings['goalId'] as int,
  ),
},
```

#### Week 4: Database Implementation

**Tasks:**
- [ ] Complete database_service implementation
- [ ] Add database initialization in main.dart
- [ ] Implement CRUD operations
- [ ] Add database migrations setup
- [ ] Test with sample data

**Key Operations:**
1. Create goals
2. Update current amount
3. Add transactions
4. Delete goals
5. Query goals by category/status

**Testing:**
```bash
# View database (Android Studio)
Device File Explorer > /data/data/com.example.nabung_challenge/databases/

# Print debug info
flutter logs | grep "Database:"
```

#### Week 5: UI Implementation

**Screens to Complete:**
1. Home Screen
   - [ ] Display all active goals
   - [ ] Show total savings summary
   - [ ] Add empty state
   - [ ] Implement floating action button

2. Create Goal Screen
   - [ ] Build form with validation
   - [ ] Add category selector
   - [ ] Implement date picker
   - [ ] Add image selection

3. Goal Detail Screen
   - [ ] Display goal information
   - [ ] Implement progress jar widget
   - [ ] Show transactions list
   - [ ] Add savings button

4. Add Savings Dialog
   - [ ] Quick add buttons
   - [ ] Transaction history
   - [ ] Optional notes

**Testing Checklist:**
- [ ] All forms validate correctly
- [ ] UI responsive on different screen sizes
- [ ] Smooth animations and transitions

---

### Phase 3: Polish & Features (Week 6-7)
**Status:** ⏳ Not Started

#### Week 6: Advanced Features

**Focus:** Gamification and engagement

- [ ] Challenges system
- [ ] Jar animation enhancements
- [ ] Notifications implementation
- [ ] Motivational quotes display
- [ ] Achievement/milestone system

#### Week 7: Monetization

**Focus:** Revenue generation

- [ ] AdMob integration
- [ ] In-app purchase setup
- [ ] Premium feature restrictions
- [ ] Settings for premium features

---

### Phase 4: Testing & Launch (Week 8-10)
**Status:** ⏳ Not Started

#### Week 8: Quality Assurance

- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests
- [ ] User acceptance testing

#### Week 9: App Store Preparation

- [ ] Generate app icons
- [ ] Create splash screen
- [ ] Write store listing
- [ ] Prepare privacy policy

#### Week 10: Launch

- [ ] Production build
- [ ] Store submission
- [ ] Launch announcement
- [ ] Marketing

## Coding Standards

### Dart/Flutter Style Guide

We follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart).

#### Naming Conventions

```dart
// Classes: PascalCase
class SavingGoal { }

// Functions/Variables: camelCase
void calculateProgress() { }
var currentAmount = 0.0;

// Constants: camelCase
const maxGoalAmount = 999999999;

// Private: Leading underscore
void _calculateProgress() { }

// Files: snake_case
goal_detail_screen.dart
```

#### Comments & Documentation

```dart
/// This is a documentation comment (shown in IDE)
/// 
/// [param] description
/// Returns: description
/// 
/// Example:
/// ```dart
/// myFunction(args);
/// ```
void myFunction() {
  // This is a regular comment
}
```

#### Code Organization

```dart
class MyWidget extends StatefulWidget {
  // Properties
  final String title;
  
  // Constructor
  const MyWidget({required this.title});
  
  // Public methods
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // Private fields
  late TextEditingController _controller;
  
  // Lifecycle methods
  @override
  void initState() { }
  
  @override
  void dispose() { }
  
  // Build method
  @override
  Widget build(BuildContext context) { }
  
  // Private methods
  void _privateMethod() { }
}
```

### Error Handling

```dart
// Proper error handling
try {
  final goals = await _dbService.getAllGoals();
} on DatabaseException catch (e) {
  print('Database error: $e');
  // Show user-friendly error message
} catch (e) {
  print('Unexpected error: $e');
  rethrow;
}
```

## Git Workflow

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:** feat, fix, docs, style, refactor, test, chore

**Examples:**
```
feat(home): add total savings summary
fix(database): handle null values in transaction
docs(readme): update setup instructions
refactor(providers): simplify goal state management
```

### Branch Strategy

```bash
# Main branch (always stable)
git checkout main

# Create feature branch
git checkout -b feature/goal-creation

# Create bugfix branch
git checkout -b fix/database-crash

# Commit changes
git commit -m "feat(goals): implement goal creation"

# Push to remote
git push origin feature/goal-creation

# Create pull request on GitHub
```

### Common Commands

```bash
# Check status
git status

# View changes
git diff

# Stage changes
git add .

# Commit
git commit -m "message"

# Push
git push origin branch-name

# Pull latest
git pull origin main

# View history
git log --oneline
```

## Debugging & Testing

### Hot Reload

```bash
# Start with hot reload enabled
flutter run

# In console, press 'r' to hot reload
# Press 'R' to hot restart
```

### Debugging

```bash
# Enable dart debugging
flutter run -v

# View logs
flutter logs

# Filter logs
flutter logs | grep "Goal"
```

### Device Testing

```bash
# List devices
flutter devices

# Run on specific device
flutter run -d device_id

# Run on all devices
flutter run

# Test on Android emulator
emulator -avd Pixel5

# Test on physical device
# Connect device via USB, enable developer mode
flutter run
```

### Common Issues & Solutions

**Issue: Hot reload not working**
```bash
# Solution: Use hot restart
# Press 'R' in the console
# Or: flutter run --host-vmservice-port 0
```

**Issue: Database locked**
```bash
# Solution: Restart app
# Or: Delete database file and re-run
adb shell rm /data/data/com.example.nabung_challenge/databases/nabung_challenge.db
```

**Issue: Notifications not showing**
```bash
# Check notification permissions
# Ensure sound is enabled on device
# Verify notification channel is correctly configured
```

## Common Tasks

### Add a New Screen

1. Create file: `lib/screens/my_new_screen.dart`
2. Implement StatelessWidget or StatefulWidget
3. Add route in `main.dart`
4. Export from `lib/screens/index.dart`

```dart
// my_new_screen.dart
class MyNewScreen extends StatefulWidget {
  const MyNewScreen({Key? key}) : super(key: key);
  
  static const routeName = '/my-new-screen';
  
  @override
  State<MyNewScreen> createState() => _MyNewScreenState();
}

class _MyNewScreenState extends State<MyNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: const Center(child: Text('Content here')),
    );
  }
}
```

### Add a New Widget

1. Create: `lib/widgets/my_widget.dart`
2. Implement widget
3. Export from `lib/widgets/index.dart`

### Add a New Provider

1. Create: `lib/providers/my_provider.dart`
2. Extend ChangeNotifier
3. Add to providers index
4. Use in screens with `Provider.of<MyProvider>(context)`

```dart
class MyProvider extends ChangeNotifier {
  String _value = '';
  
  String get value => _value;
  
  void setValue(String val) {
    _value = val;
    notifyListeners();
  }
}
```

### Add Database Table

1. Update schema in `database_service.dart`
2. Increment database version
3. Update `_createTables` method
4. Add migration in `_upgradeTables` method

### Format & Analyze Code

```bash
# Format code
dart format .
dart format lib/

# Analyze code
flutter analyze

# Fix analysis issues
dart fix --apply
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [SQLite in Flutter](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)

## Support & Questions

- **Documentation:** Check existing comments and main README
- **Errors:** Use `flutter analyze` and read error messages carefully
- **Community:** Search Flutter communities (Reddit, Stack Overflow, GitHub Issues)

---

**Happy coding! 🚀**

Remember: Small, consistent commits with clear messages make it easier to track progress and debug issues.
