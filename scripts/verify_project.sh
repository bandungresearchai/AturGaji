#!/bin/bash

# Nabung Challenge - Project Verification Script
# This script checks for errors, runs tests, and performs security checks

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TOTAL_ISSUES=0
TOTAL_PASSED=0

print_header() {
    echo ""
    echo "=================================================="
    echo -e "${BLUE}$1${NC}"
    echo "=================================================="
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
    ((TOTAL_PASSED++))
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    ((TOTAL_ISSUES++))
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check 1: Ensure Flutter is available
print_header "Check 1: Environment Setup"

if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    echo "Install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi
print_success "Flutter is available"

if ! command -v dart &> /dev/null; then
    print_error "Dart is not installed or not in PATH"
    exit 1
fi
print_success "Dart is available"

# Check 2: Verify pubspec.yaml
print_header "Check 2: Project Configuration"

if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found"
    exit 1
fi
print_success "pubspec.yaml exists"

# Check 3: Dart Lint Analysis
print_header "Check 3: Code Quality Analysis"

echo "Running 'flutter analyze'..."
if flutter analyze 2>&1 | tee /tmp/analyze_output.txt; then
    print_success "No linting issues found"
else
    issues=$(grep -c "error\|warning" /tmp/analyze_output.txt || true)
    print_error "Linting issues found: Check output above"
fi

# Check 4: Verify Code Style
print_header "Check 4: Code Formatting"

echo "Checking code formatting with 'dart format'..."
unformatted_files=$(dart format --output=none lib test 2>&1 | grep -c "^lib\|^test" || true)

if [ "$unformatted_files" -eq 0 ]; then
    print_success "All code is properly formatted"
else
    print_warning "Some files need formatting. Run: dart format lib test"
fi

# Check 5: Run Unit Tests
print_header "Check 5: Unit Tests"

if [ ! -d "test" ]; then
    print_warning "No 'test' directory found. Run: flutter create . (or create manually)"
else
    echo "Running unit tests..."
    if flutter test 2>&1; then
        print_success "All unit tests passed"
    else
        print_error "Some unit tests failed"
    fi
fi

# Check 6: Security Analysis
print_header "Check 6: Security & Best Practices"

# Check for hardcoded secrets
print_warning "Scanning for potential hardcoded secrets..."
secret_patterns=0

# Check for API keys in code
if grep -r "api.key\|apiKey\|API_KEY\|secret" lib --include="*.dart" 2>/dev/null | grep -v "const String" > /dev/null; then
    print_warning "Found potential hardcoded API keys - ensure they use environment variables"
    ((secret_patterns++))
else
    print_success "No obvious hardcoded API keys detected"
fi

# Check for SQL injection vulnerabilities
echo "Checking for SQL injection patterns..."
if grep -r "sql.*\+" lib --include="*.dart" 2>/dev/null | grep -v "//" > /dev/null; then
    print_warning "Found potential SQL concatenation - use parameterized queries"
    ((secret_patterns++))
else
    print_success "No obvious SQL injection patterns detected"
fi

# Check for insecure HTTP connections
echo "Checking for insecure HTTP connections..."
if grep -r "http://" lib --include="*.dart" 2>/dev/null | grep -v "https://" | grep -v "//" > /dev/null; then
    print_warning "Found insecure HTTP URLs - consider using HTTPS"
    ((secret_patterns++))
else
    print_success "No insecure HTTP connections detected"
fi

# Check 7: Dependencies Security
print_header "Check 7: Dependencies"

echo "Checking pub.dev for outdated packages..."
if flutter pub outdated --no-dev-dependencies 2>&1 | grep -c "resolvable\|outdated" > /dev/null 2>&1; then
    print_warning "Some dependencies may be outdated - run: flutter pub upgrade"
fi

echo "Checking for known vulnerabilities..."
if command -v snyk &> /dev/null; then
    if snyk test --severity-threshold=high 2>&1 > /dev/null; then
        print_success "No high-severity vulnerabilities detected (Snyk)"
    else
        print_warning "High-severity vulnerabilities detected - run: snyk test"
    fi
else
    print_warning "Snyk not installed. For detailed vulnerability scanning, install: npm install -g snyk"
fi

# Check 8: Platform-Specific Security
print_header "Check 8: Platform Security"

if grep -r "SharedPreferences" lib --include="*.dart" > /dev/null; then
    print_warning "SharedPreferences used - ensure sensitive data is encrypted"
fi

if grep -r "sqflite" lib --include="*.dart" > /dev/null; then
    print_success "SQLite database detected - ensure parameterized queries are used"
fi

if grep -i "permission" lib --include="*.dart" > /dev/null; then
    print_success "Permissions detected in code"
fi

# Check 9: Test Coverage
print_header "Check 9: Test Coverage"

if [ ! -d "test" ] || [ -z "$(find test -name "*_test.dart" 2>/dev/null)" ]; then
    print_warning "No unit tests found - create tests in the 'test' directory"
else
    test_count=$(find test -name "*_test.dart" | wc -l)
    print_success "Found $test_count test file(s)"
fi

# Final Report
print_header "VERIFICATION REPORT"

echo -e "${GREEN}Passed Checks: $TOTAL_PASSED${NC}"
echo -e "${RED}Issues Found: $TOTAL_ISSUES${NC}"
echo ""

if [ $TOTAL_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ Project verification completed successfully!${NC}"
    exit 0
else
    echo -e "${RED}✗ Project verification found issues. Please fix them before proceeding.${NC}"
    exit 1
fi
