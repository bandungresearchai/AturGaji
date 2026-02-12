#!/bin/bash

# Nabung Challenge - Master Verification Script
# Runs all checks: linting, tests, and security analysis
# Generates a comprehensive report

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNINGS_COUNT=0

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Report file
REPORT_FILE="$PROJECT_ROOT/verification_report.txt"

# Helper functions
print_title() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} $1"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED_CHECKS++))
    ((TOTAL_CHECKS++))
}

print_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED_CHECKS++))
    ((TOTAL_CHECKS++))
}

print_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS_COUNT++))
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Append to report
report() {
    echo "$1" >> "$REPORT_FILE"
}

# Initialize report
: > "$REPORT_FILE"
report "═══════════════════════════════════════════════════════════════"
report "NABUNG CHALLENGE - PROJECT VERIFICATION REPORT"
report "Generated: $(date)"
report "═══════════════════════════════════════════════════════════════"
report ""

print_title "NABUNG CHALLENGE - PROJECT VERIFICATION"
print_info "Starting comprehensive project verification..."
print_info "Report will be saved to: $REPORT_FILE"

# ============================================================================
# CHECK 1: Environment Setup
# ============================================================================
print_section "CHECK 1: Environment Setup"
report ""
report "CHECK 1: ENVIRONMENT SETUP"
report "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd "$PROJECT_ROOT"

if ! command -v flutter &> /dev/null; then
    print_fail "Flutter is not installed"
    report "✗ Flutter is not installed"
    report "  Install from: https://flutter.dev/docs/get-started/install"
else
    flutter_version=$(flutter --version | head -n 1)
    print_pass "Flutter is installed: $flutter_version"
    report "✓ Flutter installed: $flutter_version"
fi

if ! command -v dart &> /dev/null; then
    print_fail "Dart is not installed"
    report "✗ Dart is not installed"
else
    dart_version=$(dart --version 2>&1 | head -n 1)
    print_pass "Dart is installed: $dart_version"
    report "✓ Dart installed: $dart_version"
fi

# ============================================================================
# CHECK 2: Project Configuration
# ============================================================================
print_section "CHECK 2: Project Configuration"
report ""
report "CHECK 2: PROJECT CONFIGURATION"
report "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ ! -f "pubspec.yaml" ]; then
    print_fail "pubspec.yaml not found"
    report "✗ pubspec.yaml not found"
else
    print_pass "pubspec.yaml exists"
    report "✓ pubspec.yaml found"

    # Extract version
    app_version=$(grep "version:" pubspec.yaml | head -n 1 | awk '{print $2}')
    print_info "App version: $app_version"
    report "  App version: $app_version"
fi

# ============================================================================
# CHECK 3: Dart Linting Analysis
# ============================================================================
print_section "CHECK 3: Code Quality (Dart Analysis)"
report ""
report "CHECK 3: DART LINTING ANALYSIS"
report "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

print_info "Running Flutter analyze..."
if flutter analyze > /tmp/analyze.log 2>&1; then
    print_pass "No critical linting issues found"
    report "✓ No critical linting issues"
else
    # Check if issues are warnings or errors
    error_count=$(grep -c "error:" /tmp/analyze.log || true)
    warning_count=$(grep -c "warning:" /tmp/analyze.log || true)

    if [ "$error_count" -gt 0 ]; then
        print_fail "Found $error_count linting errors"
        report "✗ Found $error_count linting errors"
        head -5 /tmp/analyze.log | while IFS= read -r line; do
            report "  $line"
        done
    fi

    if [ "$warning_count" -gt 0 ]; then
        print_warn "Found $warning_count linting warnings"
        report "⚠ Found $warning_count linting warnings"
    fi
fi

# ============================================================================
# CHECK 4: Dependencies
# ============================================================================
print_section "CHECK 4: Dependencies"
report ""
report "CHECK 4: DEPENDENCIES"
report "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

print_info "Checking dependencies..."
if [ -f "pubspec.lock" ]; then
    print_pass "pubspec.lock exists"
    report "✓ pubspec.lock found"

    # Count dependencies
    dep_count=$(grep "^  " pubspec.lock | wc -l || true)
    print_info "Total dependencies: ~$((dep_count / 3))"
    report "  Total dependencies: ~$((dep_count / 3))"
else
    print_fail "pubspec.lock not found"
    report "✗ pubspec.lock not found"
    report "  Run: flutter pub get"
fi

# ============================================================================
# CHECK 5: Unit Tests
# ============================================================================
print_section "CHECK 5: Unit Tests"
report ""
report "CHECK 5: UNIT TESTS"
report "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ ! -d "test" ]; then
    print_warn "No 'test' directory found"
    report "⚠ No 'test' directory found"
else
    test_count=$(find test -name "*_test.dart" 2>/dev/null | wc -l)
    print_info "Found $test_count test file(s)"
    report "  Found $test_count test file(s):"

    find test -name "*_test.dart" 2>/dev/null | sort | while read -r test_file; do
        report "    - ${test_file#test/}"
    done

    # Run tests if flutter is available
    if command -v flutter &> /dev/null; then
        print_info "Running tests..."
        if flutter test --no-coverage 2>&1 | tee /tmp/test_output.log > /dev/null; then
            print_pass "All tests passed"
            report "✓ All tests passed"
            test_passed=$(grep -c "✓" /tmp/test_output.log || true)
            print_info "Test results: $test_passed tests executed"
            report "  $test_passed tests executed successfully"
        else
            print_fail "Some tests failed"
            report "✗ Some tests failed"
            grep -i "fail\|error" /tmp/test_output.log | head -3 | while IFS= read -r line; do
                report "  $line"
            done
        fi
    fi
fi

# ============================================================================
# CHECK 6: Security Checks
# ============================================================================
print_section "CHECK 6: Security Analysis"
report ""
report "CHECK 6: SECURITY ANALYSIS"
report "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Hardcoded secrets check
print_info "Checking for hardcoded secrets..."
if grep -r "api.key\|apiKey\|API_KEY" lib --include="*.dart" 2>/dev/null | grep -v "const\|//" > /dev/null; then
    print_fail "Possible hardcoded API keys detected"
    report "✗ Possible hardcoded API keys detected"
else
    print_pass "No obvious hardcoded API keys"
    report "✓ No obvious hardcoded API keys"
fi

# SQL injection check
print_info "Checking for SQL injection vulnerabilities..."
if grep -r "sql.*+\|query.*+" lib --include="*.dart" 2>/dev/null | grep -i "select\|insert" > /dev/null; then
    print_warn "Potential SQL concatenation found"
    report "⚠ Potential SQL concatenation patterns found"
else
    print_pass "No obvious SQL concatenation patterns"
    report "✓ No obvious SQL concatenation patterns"
fi

# HTTPS check
print_info "Checking for secure connections..."
if grep -r "http://" lib --include="*.dart" 2>/dev/null | grep -v "https\|//" > /dev/null; then
    print_warn "Found insecure HTTP connections"
    report "⚠ Found insecure HTTP connections"
else
    print_pass "No obvious insecure HTTP connections"
    report "✓ No obvious insecure HTTP connections"
fi

# Input validation
print_info "Checking for input validation..."
if grep -r "validate\|validators" lib --include="*.dart" > /dev/null; then
    print_pass "Input validation patterns detected"
    report "✓ Input validation patterns detected"
else
    print_warn "No obvious input validation patterns"
    report "⚠ No obvious input validation patterns"
fi

# ============================================================================
# CHECK 7: Code Structure
# ============================================================================
print_section "CHECK 7: Project Structure"
report ""
report "CHECK 7: PROJECT STRUCTURE"
report "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

required_dirs=("lib" "lib/models" "lib/services" "lib/widgets" "lib/screens")
missing_dirs=0

for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        file_count=$(find "$dir" -name "*.dart" 2>/dev/null | wc -l)
        print_pass "✓ $dir/ ($file_count Dart files)"
        report "✓ $dir/ ($file_count Dart files)"
    else
        print_fail "$dir/ missing"
        report "✗ $dir/ missing"
        ((missing_dirs++))
    fi
done

if [ "$missing_dirs" -eq 0 ]; then
    print_pass "All required directories present"
    report "✓ All required directories present"
fi

# ============================================================================
# CHECK 8: Documentation
# ============================================================================
print_section "CHECK 8: Documentation"
report ""
report "CHECK 8: DOCUMENTATION"
report "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

docs=("README.md" "ARCHITECTURE.md" "DEVELOPMENT_GUIDE.md")
for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        lines=$(wc -l < "$doc")
        print_pass "$doc ($lines lines)"
        report "✓ $doc ($lines lines)"
    else
        print_warn "$doc not found"
        report "⚠ $doc not found"
    fi
done

# ============================================================================
# Summary Report
# ============================================================================
print_section "VERIFICATION SUMMARY"
report ""
report "═══════════════════════════════════════════════════════════════"
report "VERIFICATION SUMMARY"
report "═══════════════════════════════════════════════════════════════"
report ""

# Calculate pass rate
if [ "$TOTAL_CHECKS" -gt 0 ]; then
    pass_rate=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))
else
    pass_rate=0
fi

echo ""
echo -e "${BLUE}Total Checks:${NC}        $TOTAL_CHECKS"
echo -e "${GREEN}Passed:${NC}           $PASSED_CHECKS"
echo -e "${RED}Failed:${NC}           $FAILED_CHECKS"
echo -e "${YELLOW}Warnings:${NC}         $WARNINGS_COUNT"
echo -e "${MAGENTA}Pass Rate:${NC}        ${pass_rate}%"
echo ""

report ""
report "Total Checks:        $TOTAL_CHECKS"
report "Passed:              $PASSED_CHECKS"
report "Failed:              $FAILED_CHECKS"
report "Warnings:            $WARNINGS_COUNT"
report "Pass Rate:           ${pass_rate}%"
report ""

# Final status
if [ "$FAILED_CHECKS" -eq 0 ] && [ "$WARNINGS_COUNT" -eq 0 ]; then
    print_title "✓ VERIFICATION SUCCESSFUL"
    report "═══════════════════════════════════════════════════════════════"
    report "✓ VERIFICATION SUCCESSFUL - All checks passed!"
    report "═══════════════════════════════════════════════════════════════"
    exit_code=0
elif [ "$FAILED_CHECKS" -eq 0 ]; then
    print_title "⚠ VERIFICATION COMPLETED WITH WARNINGS"
    report "═══════════════════════════════════════════════════════════════"
    report "⚠ Verification completed with $WARNINGS_COUNT warnings"
    report "═══════════════════════════════════════════════════════════════"
    exit_code=0
else
    print_title "✗ VERIFICATION FAILED"
    report "═══════════════════════════════════════════════════════════════"
    report "✗ Verification failed with $FAILED_CHECKS issues"
    report "═══════════════════════════════════════════════════════════════"
    exit_code=1
fi

echo ""
print_info "Full report saved to: $REPORT_FILE"
report ""
report "Report generated: $(date)"

exit "$exit_code"
