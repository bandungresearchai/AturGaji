# Quick Reference - Project Verification Tools

## TL;DR - Quick Start

```bash
# Fastest (Python, no Flutter needed) - 5 seconds
python3 scripts/static_analysis.py

# Comprehensive (needs Flutter) - 30+ seconds
./scripts/run_all_checks.sh

# Run tests only
flutter test

# Run lint only
flutter analyze
```

## Tools Summary

| Tool | Time | Requirements | Output | Best For |
|------|------|--------------|--------|----------|
| `static_analysis.py` | 5s | Python 3.6+ | Analysis report + JSON | Quick checks, CI/CD |
| `verify_project.sh` | 30s | Flutter SDK | Console report | Development |
| `security_check.sh` | 15s | Bash | Security report | Security audit |
| `run_all_checks.sh` | 60s | Flutter SDK | Full report file | Pre-commit, releases |
| Unit tests | 30s | Flutter SDK | Test results | Development cycle |

## Common Commands

### Development Workflow

```bash
# Before committing
python3 scripts/static_analysis.py         # Quick check
flutter test --no-coverage                # Run tests
flutter analyze                           # Lint check

# Before pushing
./scripts/run_all_checks.sh               # Full verification
```

### Continuous Integration

```bash
# CI/CD pipeline
python3 scripts/static_analysis.py --json ci-results.json
flutter test --no-coverage
flutter analyze
```

### Generating Reports

```bash
# Text report
./scripts/run_all_checks.sh
cat verification_report.txt

# JSON report
python3 scripts/static_analysis.py --json results.json
cat results.json

# Verbose output
python3 scripts/static_analysis.py --verbose
```

## Test Coverage

### Test Files
- ✓ Models: `test/models/saving_goal_test.dart`
- ✓ Models: `test/models/transaction_test.dart`
- ✓ Models: `test/models/challenge_test.dart`
- ✓ 50+ test cases

### Running Tests
```bash
flutter test                    # All tests
flutter test test/models/      # Specific directory
flutter test --coverage        # With coverage
```

## What Gets Checked

### 🔒 Security (9 checks)
- Hardcoded secrets/API keys ✓
- SQL injection patterns ✓
- Insecure HTTP connections ✓
- Input validation ✓
- File system access ✓
- Session management ✓
- WebView security ✓
- Dependency vulnerabilities ✓
- Debug logging ✓

### 📋 Code Quality (6 checks)
- Dart linting ✓
- Code formatting ✓
- Debug statements ✓
- Code style ✓
- Project structure ✓
- Documentation ✓

### ✅ Testing (2 checks)
- Unit test files ✓
- Test execution ✓

### 📦 Dependencies (2 checks)
- pubspec.yaml config ✓
- Essential packages ✓

**Total: 19 automated checks**

## Key Findings from First Run

Status: **77.8% Pass Rate** (7/9 checks passed)

### Issues Found:
1. **Code Style Issues** (20 files) - Minor formatting inconsistencies
2. **Insecure HTTP Connection** (1 file) - Should use HTTPS

### Passed Checks:
- ✓ No hardcoded secrets
- ✓ No SQL injection patterns
- ✓ No debug print statements
- ✓ Input validation present
- ✓ Essential packages configured
- ✓ 3 unit test files
- ✓ Required directories present

## File Structure

```
scripts/
├── verify_project.sh         # Basic verification
├── security_check.sh         # Security audit
├── run_all_checks.sh         # Comprehensive check
├── static_analysis.py        # Python static analysis
└── requirements.txt          # (Python dependencies)

test/
├── models/
│   ├── saving_goal_test.dart
│   ├── transaction_test.dart
│   └── challenge_test.dart

docs/
└── PROJECT_VERIFICATION_GUIDE.md  # Detailed guide
```

## Performance by Phase

| Phase | Time | Command |
|-------|------|---------|
| 1. Quick Static Check | 5s | `python3 scripts/static_analysis.py` |
| 2. Unit Tests | 30s | `flutter test --no-coverage` |
| 3. Lint Analysis | 5s | `flutter analyze` |
| 4. Full Report | 60s | `./scripts/run_all_checks.sh` |
| **Total Development** | **40s** | 1 + 2 + 3 |
| **Total CI/CD** | **90s** | 1 + 2 + 3 + 4 |

## Exit Codes

```bash
python3 scripts/static_analysis.py
echo $?  # 0 = success, 1 = failed
```

- `0` = All checks passed
- `1` = Issues found
- `2` = Configuration error

## Next Steps

1. **Fix Code Style Issues**
   ```bash
   dart format lib test
   ```

2. **Fix Insecure Connections**
   - Review insecure HTTP URLs in code
   - Switch to HTTPS

3. **Add More Tests**
   - Services testing
   - Widget testing
   - Integration testing

4. **Set Up Pre-Commit Hook**
   ```bash
   # Create .git/hooks/pre-commit
   ```

5. **Set Up CI/CD**
   - GitHub Actions
   - GitLab CI
   - Or other CI system

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `python: command not found` | Use `python3` instead |
| `flutter: command not found` | Install Flutter SDK |
| `Permission denied` | Run `chmod +x scripts/*.sh` |
| Tests not found | Create `test/` directory with `*_test.dart` files |
| Script fails silently | Check file permissions and paths |

## Resources

- [PROJECT_VERIFICATION_GUIDE.md](./PROJECT_VERIFICATION_GUIDE.md) - Full documentation
- [Flutter Testing Docs](https://flutter.dev/docs/testing)
- [Dart Security Guide](https://dart.dev/guides/security)
- [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/)

## Summary

You now have a complete verification system:

✅ **3 Bash Scripts** - Comprehensive Flutter verification
✅ **1 Python Script** - Fast static analysis (no Flutter needed)
✅ **3 Test Files** - 50+ unit tests for core models
✅ **1 Comprehensive Guide** - Full documentation
✅ **This Quick Reference** - Get started in minutes

**Start with:**
```bash
python3 scripts/static_analysis.py
```

Then add to your workflow!
