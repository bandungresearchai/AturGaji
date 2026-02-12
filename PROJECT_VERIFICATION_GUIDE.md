# Project Verification & Testing Guide

This guide explains how to use the comprehensive verification system for the Nabung Challenge project. It includes linting, unit testing, and security analysis tools.

## Overview

The project includes four main checking tools:

1. **verify_project.sh** - Comprehensive project verification (Flutter/Dart)
2. **security_check.sh** - Detailed security analysis
3. **run_all_checks.sh** - Master verification script (Flutter/Dart)
4. **static_analysis.py** - Static code analysis (Python, no Flutter required)

## Installation & Setup

### Prerequisites

For Bash scripts:
- Flutter SDK installed and in PATH
- Dart SDK installed (comes with Flutter)
- Bash shell

For Python analysis:
- Python 3.6+
- No Flutter/Dart required

### Permissions

Make the scripts executable:

```bash
chmod +x scripts/*.sh
chmod +x scripts/static_analysis.py
```

## Usage

### Option 1: Python Static Analysis (Fastest)

No dependencies required. Runs immediately.

```bash
# Basic analysis
python3 scripts/static_analysis.py

# Verbose output showing affected files
python3 scripts/static_analysis.py --verbose

# Export results to JSON
python3 scripts/static_analysis.py --json results.json

# Different project directory
python3 scripts/static_analysis.py --project /path/to/project
```

**Output Example:**
```
🔍 Running static code analysis...

📋 Security
------
  ✓ Hardcoded Secrets: No obvious hardcoded secrets detected
  ✓ SQL Injection Prevention: No obvious SQL concatenation detected
  ✓ Secure Connections: No insecure HTTP connections detected
  ✓ Input Validation: Input validation patterns found in 5 file(s)

📋 Code Quality
------
  ✓ Debug Statements: No debug print statements found
  ✓ Code Style: Code style looks good

📋 Structure
------
  ✓ Project Structure: Required directories present
  ⚠ Test Coverage: No test files found

📋 Dependencies
------
  ✓ Essential Packages: Essential packages configured

SUMMARY
======
  Total Checks:    10
  ✓ Passed:        9
  ✗ Failed:        0
  ⚠ Warnings:      1
  Pass Rate:       90.0%
```

### Option 2: Comprehensive Flutter Verification

Requires Flutter installed. Includes actual linting, testing, and more.

```bash
# Run all checks with report generation
./scripts/run_all_checks.sh

# This will generate: verification_report.txt
```

**Report Example:**
```
═══════════════════════════════════════════════════════════════
NABUNG CHALLENGE - PROJECT VERIFICATION REPORT
Generated: Wed Feb 12 10:30:45 UTC 2026
═══════════════════════════════════════════════════════════════

CHECK 1: ENVIRONMENT SETUP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Flutter installed: Flutter 3.10.0 • channel stable
✓ Dart installed: Dart SDK version: 3.10.0

[... more checks ...]
```

### Option 3: Focused Verification Scripts

You can run individual checks:

```bash
# Project verification only
./scripts/verify_project.sh

# Security checks only
./scripts/security_check.sh
```

## Check Categories

### Security Analysis

The system checks for:

- **Hardcoded Secrets**: API keys, passwords, tokens
- **SQL Injection**: String concatenation in queries
- **Insecure Connections**: HTTP vs HTTPS
- **Input Validation**: Presence of validation patterns
- **File System Access**: Proper secure storage
- **Authentication**: Session management, storage
- **WebView Security**: JavaScript restrictions
- **Dependency Vulnerabilities**: Known vulnerable packages
- **Logging**: Debug statements in production code
- **Code Obfuscation**: Release build configuration

### Code Quality Checks

- **Dart Linting**: flutter analyze
- **Code Formatting**: dart format validation
- **Debug Statements**: Identification of leftover prints
- **Code Style**: Spacing, indentation, structure
- **Project Structure**: Required directories
- **Documentation**: README, guides presence

### Testing Checks

- **Unit Tests**: Test file discovery and execution
- **Test Coverage**: Coverage validation
- **Model Tests**: Model serialization/deserialization
- **Widget Tests**: UI component tests

### Dependency Checks

- **pubspec.yaml**: Configuration validation
- **pubspec.lock**: Dependency lock verification
- **Outdated Packages**: Version checking
- **Known Vulnerabilities**: CVE scanning (with Snyk)

## Unit Tests

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/saving_goal_test.dart

# Run with coverage
flutter test --coverage

# Run without coverage (faster)
flutter test --no-coverage
```

### Test Files

The project includes comprehensive tests:

- **test/models/saving_goal_test.dart** - SavingGoal model tests
- **test/models/transaction_test.dart** - Transaction model tests
- **test/models/challenge_test.dart** - Challenge model tests

Each test file includes:
- Initialization tests
- Calculation tests
- Serialization/deserialization tests
- Equality and hash code tests
- Edge case tests

### Writing New Tests

Test template:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nabung_challenge/models/your_model.dart';

void main() {
  group('YourModel Tests', () {
    test('Should do something', () {
      final item = YourModel(/* ... */);
      expect(item.property, equals(expectedValue));
    });
  });
}
```

## Security Best Practices

### Secrets Management

❌ **Don't:**
```dart
const String API_KEY = 'your-secret-key-here';
```

✅ **Do:**
```dart
// Use environment variables or secure storage
final apiKey = Platform.environment['API_KEY'];
// Or use flutter_secure_storage package
```

### Database Security

❌ **Don't:**
```dart
'SELECT * FROM users WHERE id = ' + id.toString();
```

✅ **Do:**
```dart
database.query('users', where: 'id = ?', whereArgs: [id]);
```

### HTTPS

❌ **Don't:**
```dart
final response = await http.get(Uri.parse('http://api.example.com/data'));
```

✅ **Do:**
```dart
final response = await http.get(Uri.parse('https://api.example.com/data'));
```

### Input Validation

✅ **Do:**
```dart
if (email.isEmpty || !email.contains('@')) {
  throw ValidationException('Invalid email');
}
```

## Continuous Integration

### GitHub Actions Example

```yaml
name: Project Verification

on: [push, pull_request]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: ./scripts/run_all_checks.sh
      - run: python3 scripts/static_analysis.py --json results.json

      - name: Upload Results
        uses: actions/upload-artifact@v2
        with:
          name: verification-report
          path: verification_report.txt
```

## Troubleshooting

### "flutter: command not found"

**Solution**: Install Flutter from https://flutter.dev/docs/get-started/install

```bash
# Verify installation
flutter --version
dart --version
```

### "No test files found"

**Solution**: Create test files in the `test/` directory

```bash
# Create test directory
mkdir -p test/models

# Add test files with *_test.dart suffix
touch test/models/my_model_test.dart
```

### Python script not executable

**Solution**: Make it executable

```bash
chmod +x scripts/static_analysis.py
python3 scripts/static_analysis.py
```

### Tests fail with "package not found"

**Solution**: Get dependencies

```bash
flutter pub get
flutter pub upgrade
```

## Performance Tips

- **Fast check**: Use Python static analysis (`static_analysis.py`)
- **Development cycle**: Use `flutter analyze` only
- **Pre-commit**: Run Python analysis + specific tests
- **CI/CD**: Run full verification suite

## Reports & Outputs

### Verification Report

Generated: `verification_report.txt`

Contains:
- Environment details
- All check results
- File counts and metrics
- Summary statistics

### JSON Export

```bash
python3 scripts/static_analysis.py --json results.json
```

Output format:
```json
{
  "timestamp": "2026-02-12T10:30:45.123456",
  "total_checks": 10,
  "passed": 9,
  "failed": 0,
  "warnings": 1,
  "results": [
    {
      "category": "Security",
      "check_name": "Hardcoded Secrets",
      "status": "pass",
      "message": "No obvious hardcoded secrets detected",
      "files_affected": null,
      "severity": "critical"
    }
  ]
}
```

## Exit Codes

- **0**: All checks passed
- **1**: Some checks failed
- **2**: Configuration error (e.g., Flutter not found)

## Additional Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Dart Security Guidelines](https://dart.dev/guides/security)
- [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/)
- [Flutter Security Best Practices](https://flutter.dev/docs/development/security)

## Contributing

To add new checks:

1. **For Python analysis**: Add method to `CodeAnalyzer` class in `static_analysis.py`
2. **For Bash verification**: Add function to appropriate script
3. **For tests**: Create test file in `test/` with `*_test.dart` suffix

Example Python check:

```python
def check_your_issue(self):
    """Check for your specific issue"""
    files_with_issues = []

    for dart_file in self.find_dart_files():
        content = self.read_file_content(dart_file)
        if re.search(r'your_pattern', content):
            files_with_issues.append(str(dart_file.relative_to(self.project_root)))

    if files_with_issues:
        self.add_result(CheckResult(
            category='Category',
            check_name='Check Name',
            status='fail',  # or 'warn'
            message='Your message',
            files_affected=files_with_issues
        ))
    else:
        self.add_result(CheckResult(
            category='Category',
            check_name='Check Name',
            status='pass',
            message='All good'
        ))
```

## Contact & Support

For issues or feature requests related to these tools, please refer to the project's development guide.
