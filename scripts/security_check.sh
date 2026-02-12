#!/bin/bash

# Security and Best Practices Checker for Flutter/Dart Projects
# Checks for common vulnerabilities and security issues

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SECURITY_ISSUES=0
SECURITY_PASSED=0

print_header() {
    echo ""
    echo "=================================================="
    echo -e "${BLUE}$1${NC}"
    echo "=================================================="
    echo ""
}

print_issue() {
    echo -e "${RED}✗ $1${NC}"
    ((SECURITY_ISSUES++))
}

print_pass() {
    echo -e "${GREEN}✓ $1${NC}"
    ((SECURITY_PASSED++))
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_detail() {
    echo "  → $1"
}

# Security Check 1: Sensitive Data in Code
print_header "Security Check 1: Sensitive Data"

has_secrets=0

# Check for hardcoded API keys
if grep -r "api_key\s*=\|apiKey\s*=\|API_KEY\s*=" lib --include="*.dart" 2>/dev/null | grep -v "const\|final" > /tmp/secrets.txt 2>&1; then
    print_issue "Possible hardcoded API keys found"
    print_detail "Location: Check .apiKey or .api_key assignments in lib/"
    ((has_secrets++))
else
    print_pass "No obvious hardcoded API keys detected"
fi

# Check for hardcoded passwords
if grep -r "password\s*=\|pwd\s*=.*['\"]" lib --include="*.dart" 2>/dev/null | grep -v "// " | grep -v "const" > /dev/null; then
    print_issue "Possible hardcoded passwords found"
    print_detail "Location: Check password variable assignments"
    ((has_secrets++))
else
    print_pass "No obvious hardcoded passwords detected"
fi

# Check for database credentials
if grep -r "username.*=\|password.*=" lib --include="*.dart" 2>/dev/null | grep -v "// " | grep -v "user_id" > /dev/null; then
    print_warning "Found credential-like patterns - verify none are hardcoded"
else
    print_pass "No obvious database credentials in code"
fi

# Security Check 2: SQL Injection Prevention
print_header "Security Check 2: SQL Injection Prevention"

# Check for string concatenation in queries
if grep -r "sql.*+\|query.*+\|'.*'\s*+\s*" lib --include="*.dart" 2>/dev/null | grep -i "select\|insert\|update\|delete" > /tmp/sql_concat.txt 2>&1; then
    if [ -s /tmp/sql_concat.txt ]; then
        print_issue "Found potential SQL concatenation (string +)"
        print_detail "Use parameterized queries instead: query('SELECT * FROM table WHERE id = ?', [id])"
    fi
else
    print_pass "No obvious SQL concatenation patterns"
fi

# Check for proper parameterized queries in sqflite
if grep -r "sqflite\|Database\|rawQuery\|query" lib --include="*.dart" > /dev/null 2>&1; then
    if grep -r "query(\|rawQuery(" lib --include="*.dart" | grep "?" > /dev/null; then
        print_pass "Using parameterized queries (placeholders detected)"
    else
        print_warning "Verify that all database queries use parameterized queries with ?"
    fi
fi

# Security Check 3: Authentication & Session Management
print_header "Security Check 3: Authentication & Security"

if grep -r "SharedPreferences" lib --include="*.dart" > /dev/null; then
    print_warning "SharedPreferences used - ensure tokens are encrypted"
    print_detail "Consider: Use secure_storage package for sensitive data"
fi

if grep -r "http.get\|http.post\|http.put\|http.delete" lib --include="*.dart" > /dev/null 2>&1; then
    if grep -r "https://" lib --include="*.dart" > /dev/null; then
        print_pass "HTTPS connections detected"
    else
        print_warning "Found HTTP requests - verify all external API calls use HTTPS"
    fi
fi

# Security Check 4: Input Validation
print_header "Security Check 4: Input Validation"

# Check if validators are being used
if grep -r "validators\|validate\|isEmpty\|isValid" lib --include="*.dart" > /dev/null; then
    print_pass "Input validation patterns detected"

    # Check for specific validators
    if grep -r "@required\|required:" lib --include="*.dart" > /dev/null; then
        print_pass "Required field validation detected"
    fi
else
    print_warning "No obvious input validation detected"
    print_detail "Ensure all user inputs are validated before use"
fi

# Security Check 5: XSS Prevention (if using WebView)
print_header "Security Check 5: WebView Security"

if grep -r "WebView\|webview_flutter" lib pubspec.yaml --include="*.dart" > /dev/null 2>&1; then
    print_warning "WebView detected - ensure content is sanitized"
    print_detail "Check: Use WebViewController with proper security settings"

    if grep -r "javascriptMode.*unrestricted" lib --include="*.dart" > /dev/null; then
        print_issue "WebView running in unrestricted JavaScript mode"
        print_detail "Consider disabling JavaScript or restricting to trusted content only"
    fi
fi

# Security Check 6: Dependency Vulnerabilities
print_header "Security Check 6: Dependency Analysis"

print_detail "Checking pubspec.yaml for common vulnerable packages..."

# List of known problematic packages (example)
dangerous_packages=("eval" "dynamic_loader" "dart_eval")

for package in "${dangerous_packages[@]}"; do
    if grep -q "$package" pubspec.yaml 2>/dev/null; then
        print_issue "Found potentially dangerous package: $package"
    fi
done

# Check if flutter_lints is in dev_dependencies
if grep -q "flutter_lints" pubspec.yaml; then
    print_pass "flutter_lints configured for code quality"
else
    print_warning "flutter_lints not found - add for better code quality"
fi

# Security Check 7: File System Access
print_header "Security Check 7: File System & Permissions"

if grep -r "path_provider\|getApplicationDocumentsDirectory\|getTemporaryDirectory" lib --include="*.dart" > /dev/null; then
    print_pass "Path provider usage detected"
    print_warning "Ensure sensitive files are stored in app-specific directories"
fi

if grep -r "File\|read\|write\|delete" lib --include="*.dart" > /dev/null; then
    print_warning "File operations detected - verify secure file permissions"
fi

# Security Check 8: Platform Channel Security
print_header "Security Check 8: Native Channel Security"

if grep -r "platform\|MethodChannel\|EventChannel" lib --include="*.dart" > /dev/null; then
    print_warning "Platform channels detected - validate all native code input"
    print_detail "Security consideration: Validate data passed between Dart and native code"
fi

# Security Check 9: Logging & Debugging
print_header "Security Check 9: Logging & Debugging"

# Check for debug prints
if grep -r "print(\|debugPrint(\|log(" lib --include="*.dart" > /tmp/debug_logs.txt 2>&1; then
    log_count=$(wc -l < /tmp/debug_logs.txt)
    if [ "$log_count" -gt 5 ]; then
        print_warning "Found $log_count debug statements - consider using logger package"
        print_detail "Remove debug logs in production or use a proper logging framework"
    fi
fi

# Check for assert statements
if grep -r "assert(" lib --include="*.dart" > /dev/null; then
    print_pass "Assert statements found for debug validation"
fi

# Check for kDebugMode usage
if grep -r "kDebugMode\|kReleaseMode" lib --include="*.dart" > /dev/null; then
    print_pass "Proper debug/release mode detection used"
fi

# Security Check 10: Third-Party Integration
print_header "Security Check 10: Third-Party Integrations"

# Check for AdMob
if grep -r "google_mobile_ads\|AdMobBanner\|InterstitialAd" lib --include="*.dart" > /dev/null; then
    print_warning "Google Mobile Ads integrated - verify app ID is properly configured"
    print_detail "Check: AndroidManifest.xml and Info.plist have correct Ad IDs"
fi

# Check for analytics
if grep -r "firebase\|analytics\|mixpanel" lib pubspec.yaml --include="*.dart" > /dev/null 2>&1; then
    print_warning "Analytics integration detected - ensure user privacy compliance"
    print_detail "Check: Terms of service and privacy policy mention data collection"
fi

# Security Check 11: Code Obfuscation
print_header "Security Check 11: Code Obfuscation"

if grep -q "shrinkResources\|minifyEnabled\|obfuscate" pubspec.yaml 2>/dev/null; then
    print_pass "Code obfuscation enabled in release builds"
else
    print_warning "Code obfuscation may not be enabled"
    print_detail "Add to build.gradle: minifyEnabled true, shrinkResources true"
fi

# Security Check 12: Certificate Pinning
print_header "Security Check 12: Certificate Pinning"

if grep -r "certificate_pinning\|pin.*certificate\|ssl_pinning" lib pubspec.yaml --include="*.dart" > /dev/null 2>&1; then
    print_pass "Certificate pinning implementation detected"
else
    print_warning "No certificate pinning detected for API calls"
    print_detail "Consider adding certificate pinning for sensitive API endpoints"
fi

# Final Security Report
print_header "SECURITY REPORT"

echo -e "${GREEN}Passed Security Checks: $SECURITY_PASSED${NC}"
echo -e "${RED}Security Issues Found: $SECURITY_ISSUES${NC}"
echo ""

if [ $SECURITY_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ Security assessment completed with no critical issues!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠ Security assessment found issues that should be reviewed.${NC}"
    exit 0
fi
