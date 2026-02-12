#!/usr/bin/env python3

"""
Nabung Challenge - Static Code Analysis Tool
Performs security and code quality checks without requiring Flutter/Dart installation
"""

import os
import sys
import re
import json
from pathlib import Path
from datetime import datetime
from typing import List, Tuple, Dict
from dataclasses import dataclass, asdict
import argparse

@dataclass
class CheckResult:
    category: str
    check_name: str
    status: str  # 'pass', 'fail', 'warn'
    message: str
    files_affected: List[str] = None
    severity: str = 'medium'  # 'low', 'medium', 'high', 'critical'

    def to_dict(self):
        return asdict(self)

class CodeAnalyzer:
    """Static code analyzer for Flutter/Dart projects"""

    def __init__(self, project_root: str = "."):
        self.project_root = Path(project_root)
        self.results: List[CheckResult] = []
        self.lib_dir = self.project_root / "lib"
        self.test_dir = self.project_root / "test"

    def add_result(self, result: CheckResult):
        """Add a check result"""
        self.results.append(result)

    def find_dart_files(self, directory: Path = None) -> List[Path]:
        """Find all Dart files in directory"""
        if directory is None:
            directory = self.lib_dir
        return list(directory.rglob("*.dart")) if directory.exists() else []

    def read_file_content(self, file_path: Path) -> str:
        """Read file content safely"""
        try:
            return file_path.read_text(encoding='utf-8')
        except Exception as e:
            return ""

    # ========================================================================
    # SECURITY CHECKS
    # ========================================================================

    def check_hardcoded_secrets(self):
        """Check for hardcoded API keys and secrets"""
        patterns = [
            (r'api[_\s]*key\s*=\s*["\'][\w]+["\']', 'API Key'),
            (r'apiKey\s*=\s*["\'][\w]+["\']', 'API Key'),
            (r'API_KEY\s*=\s*["\'][\w]+["\']', 'API Key'),
            (r'password\s*=\s*["\'][\w]+["\']', 'Password'),
            (r'secret\s*=\s*["\'][\w]+["\']', 'Secret'),
            (r'token\s*=\s*["\'][\w\-\.]+["\']', 'Token'),
        ]

        files_with_issues = []
        for dart_file in self.find_dart_files():
            content = self.read_file_content(dart_file)

            # Skip comments
            content_no_comments = re.sub(r'//.*$', '', content, flags=re.MULTILINE)

            for pattern, secret_type in patterns:
                if re.search(pattern, content_no_comments, re.IGNORECASE):
                    # Verify it's not a const or final declaration
                    if not re.search(rf'const.*{secret_type}|final.*{secret_type}', content_no_comments):
                        files_with_issues.append(str(dart_file.relative_to(self.project_root)))

        if files_with_issues:
            self.add_result(CheckResult(
                category='Security',
                check_name='Hardcoded Secrets',
                status='fail',
                message=f'Found potential hardcoded secrets in {len(files_with_issues)} file(s)',
                files_affected=files_with_issues,
                severity='critical'
            ))
        else:
            self.add_result(CheckResult(
                category='Security',
                check_name='Hardcoded Secrets',
                status='pass',
                message='No obvious hardcoded secrets detected'
            ))

    def check_sql_injection(self):
        """Check for SQL injection patterns"""
        pattern = r'(query|rawQuery|execute)\s*\(\s*["\'].*["+\s\*]+.*["\']'
        files_with_issues = []

        for dart_file in self.find_dart_files():
            content = self.read_file_content(dart_file)
            content_no_comments = re.sub(r'//.*$', '', content, flags=re.MULTILINE)

            if re.search(pattern, content_no_comments, re.IGNORECASE):
                # Check if it's using parameterized queries
                if '?' not in content:
                    files_with_issues.append(str(dart_file.relative_to(self.project_root)))

        if files_with_issues:
            self.add_result(CheckResult(
                category='Security',
                check_name='SQL Injection',
                status='warn',
                message=f'Potential SQL concatenation in {len(files_with_issues)} file(s)',
                files_affected=files_with_issues,
                severity='high'
            ))
        else:
            self.add_result(CheckResult(
                category='Security',
                check_name='SQL Injection Prevention',
                status='pass',
                message='No obvious SQL concatenation detected'
            ))

    def check_insecure_connections(self):
        """Check for insecure HTTP connections"""
        files_with_issues = []

        for dart_file in self.find_dart_files():
            content = self.read_file_content(dart_file)

            # Look for http:// that's not in comments
            http_pattern = r'["\']http://[^s]'
            if re.search(http_pattern, content):
                files_with_issues.append(str(dart_file.relative_to(self.project_root)))

        if files_with_issues:
            self.add_result(CheckResult(
                category='Security',
                check_name='Insecure Connections',
                status='warn',
                message=f'Found insecure HTTP connections in {len(files_with_issues)} file(s)',
                files_affected=files_with_issues,
                severity='high'
            ))
        else:
            self.add_result(CheckResult(
                category='Security',
                check_name='Secure Connections',
                status='pass',
                message='No insecure HTTP connections detected'
            ))

    def check_input_validation(self):
        """Check for input validation patterns"""
        patterns = [
            r'validate\s*\(',
            r'validators\.',
            r'isValid',
            r'@required',
            r'required:',
        ]

        files_with_validation = []
        for dart_file in self.find_dart_files():
            content = self.read_file_content(dart_file)

            for pattern in patterns:
                if re.search(pattern, content):
                    files_with_validation.append(str(dart_file.relative_to(self.project_root)))
                    break

        if files_with_validation:
            self.add_result(CheckResult(
                category='Security',
                check_name='Input Validation',
                status='pass',
                message=f'Input validation patterns found in {len(files_with_validation)} file(s)'
            ))
        else:
            self.add_result(CheckResult(
                category='Security',
                check_name='Input Validation',
                status='warn',
                message='No obvious input validation patterns detected',
                severity='medium'
            ))

    # ========================================================================
    # CODE QUALITY CHECKS
    # ========================================================================

    def check_debug_statements(self):
        """Check for debug prints that should be removed"""
        patterns = [
            r'print\(',
            r'debugPrint\(',
        ]

        files_with_debug = []
        debug_count = 0

        for dart_file in self.find_dart_files():
            content = self.read_file_content(dart_file)
            content_no_comments = re.sub(r'//.*$', '', content, flags=re.MULTILINE)

            for pattern in patterns:
                matches = len(re.findall(pattern, content_no_comments))
                if matches > 0:
                    files_with_debug.append(str(dart_file.relative_to(self.project_root)))
                    debug_count += matches

        if debug_count > 10:
            self.add_result(CheckResult(
                category='Code Quality',
                check_name='Debug Statements',
                status='warn',
                message=f'Found {debug_count} debug print statements in {len(files_with_debug)} file(s)',
                files_affected=files_with_debug,
            ))
        elif debug_count > 0:
            self.add_result(CheckResult(
                category='Code Quality',
                check_name='Debug Statements',
                status='pass',
                message=f'Found {debug_count} debug statements (acceptable for development)'
            ))
        else:
            self.add_result(CheckResult(
                category='Code Quality',
                check_name='Debug Statements',
                status='pass',
                message='No debug print statements found'
            ))

    def check_code_style(self):
        """Check for code style issues"""
        files_with_issues = []

        for dart_file in self.find_dart_files():
            content = self.read_file_content(dart_file)

            # Check for common style issues
            issues = []
            if re.search(r'  {5,}', content):  # More than 4 spaces (tabs)
                issues.append('mixed_indentation')
            if re.search(r'[a-z]\s{2,}=', content):  # Multiple spaces before =
                issues.append('spacing')
            if re.search(r';\s*\n\s*;\n', content):  # Empty lines with just ;
                issues.append('empty_statements')

            if issues:
                files_with_issues.append(str(dart_file.relative_to(self.project_root)))

        if files_with_issues:
            self.add_result(CheckResult(
                category='Code Quality',
                check_name='Code Style',
                status='warn',
                message=f'Code style issues in {len(files_with_issues)} file(s)',
                files_affected=files_with_issues[:5],
            ))
        else:
            self.add_result(CheckResult(
                category='Code Quality',
                check_name='Code Style',
                status='pass',
                message='Code style looks good'
            ))

    # ========================================================================
    # STRUCTURE CHECKS
    # ========================================================================

    def check_project_structure(self):
        """Check if project has required directories"""
        required = ['lib', 'lib/models', 'lib/services', 'lib/screens']
        missing = [d for d in required if not (self.project_root / d).exists()]

        if missing:
            self.add_result(CheckResult(
                category='Structure',
                check_name='Project Structure',
                status='warn',
                message=f'Missing directories: {", ".join(missing)}',
                severity='low'
            ))
        else:
            self.add_result(CheckResult(
                category='Structure',
                check_name='Project Structure',
                status='pass',
                message='Required directories present'
            ))

    def check_test_coverage(self):
        """Check for test presence"""
        test_files = list(self.test_dir.rglob("*_test.dart")) if self.test_dir.exists() else []

        if len(test_files) == 0:
            self.add_result(CheckResult(
                category='Testing',
                check_name='Test Coverage',
                status='warn',
                message='No test files found',
                severity='medium'
            ))
        else:
            self.add_result(CheckResult(
                category='Testing',
                check_name='Test Coverage',
                status='pass',
                message=f'Found {len(test_files)} test file(s)'
            ))

    # ========================================================================
    # DEPENDENCY CHECKS
    # ========================================================================

    def check_pubspec(self):
        """Check pubspec.yaml configuration"""
        pubspec_path = self.project_root / 'pubspec.yaml'

        if not pubspec_path.exists():
            self.add_result(CheckResult(
                category='Dependencies',
                check_name='Pubspec Configuration',
                status='fail',
                message='pubspec.yaml not found'
            ))
            return

        content = self.read_file_content(pubspec_path)

        # Check for essential packages
        has_provider = 'provider' in content
        has_lints = 'flutter_lints' in content

        issues = []
        if not has_provider:
            issues.append('Missing state management (provider)')
        if not has_lints:
            issues.append('Missing flutter_lints')

        if issues:
            self.add_result(CheckResult(
                category='Dependencies',
                check_name='Essential Packages',
                status='warn',
                message=f'Potential issues: {", ".join(issues)}'
            ))
        else:
            self.add_result(CheckResult(
                category='Dependencies',
                check_name='Essential Packages',
                status='pass',
                message='Essential packages configured'
            ))

    # ========================================================================
    # MAIN ANALYSIS
    # ========================================================================

    def run_all_checks(self):
        """Run all analysis checks"""
        print("🔍 Running static code analysis...")
        print("")

        # Security checks
        print("  Checking for security issues...")
        self.check_hardcoded_secrets()
        self.check_sql_injection()
        self.check_insecure_connections()
        self.check_input_validation()

        # Code quality checks
        print("  Checking code quality...")
        self.check_debug_statements()
        self.check_code_style()

        # Structure checks
        print("  Checking project structure...")
        self.check_project_structure()
        self.check_test_coverage()

        # Dependency checks
        print("  Checking dependencies...")
        self.check_pubspec()

    def print_results(self, verbose: bool = False):
        """Print analysis results"""
        print("\n" + "=" * 70)
        print("CODE ANALYSIS RESULTS")
        print("=" * 70)

        # Group results by category
        categories = {}
        for result in self.results:
            if result.category not in categories:
                categories[result.category] = []
            categories[result.category].append(result)

        # Status counters
        passed = sum(1 for r in self.results if r.status == 'pass')
        failed = sum(1 for r in self.results if r.status == 'fail')
        warned = sum(1 for r in self.results if r.status == 'warn')

        # Print by category
        for category in sorted(categories.keys()):
            print(f"\n📋 {category}")
            print("-" * 70)

            for result in categories[category]:
                icon = "✓" if result.status == 'pass' else "✗" if result.status == 'fail' else "⚠"
                color = "\033[92m" if result.status == 'pass' else "\033[91m" if result.status == 'fail' else "\033[93m"
                reset = "\033[0m"

                print(f"  {color}{icon}{reset} {result.check_name}: {result.message}")

                if verbose and result.files_affected:
                    for file in result.files_affected[:3]:
                        print(f"      - {file}")
                    if len(result.files_affected) > 3:
                        print(f"      ... and {len(result.files_affected) - 3} more")

        # Summary
        print("\n" + "=" * 70)
        print("SUMMARY")
        print("=" * 70)
        total = len(self.results)
        pass_rate = (passed / total * 100) if total > 0 else 0

        print(f"  Total Checks:    {total}")
        print(f"  ✓ Passed:        {passed}")
        print(f"  ✗ Failed:        {failed}")
        print(f"  ⚠ Warnings:      {warned}")
        print(f"  Pass Rate:       {pass_rate:.1f}%")
        print("=" * 70)

        return failed == 0

    def export_json(self, output_file: str):
        """Export results to JSON"""
        data = {
            'timestamp': datetime.now().isoformat(),
            'total_checks': len(self.results),
            'passed': sum(1 for r in self.results if r.status == 'pass'),
            'failed': sum(1 for r in self.results if r.status == 'fail'),
            'warnings': sum(1 for r in self.results if r.status == 'warn'),
            'results': [r.to_dict() for r in self.results],
        }

        with open(output_file, 'w') as f:
            json.dump(data, f, indent=2)
        print(f"\n📄 Results exported to {output_file}")


def main():
    parser = argparse.ArgumentParser(
        description='Static code analyzer for Flutter/Dart projects'
    )
    parser.add_argument(
        '--project', '-p',
        default='.',
        help='Project root directory (default: current directory)'
    )
    parser.add_argument(
        '--verbose', '-v',
        action='store_true',
        help='Show verbose output with file details'
    )
    parser.add_argument(
        '--json', '-j',
        help='Export results to JSON file'
    )

    args = parser.parse_args()

    analyzer = CodeAnalyzer(args.project)
    analyzer.run_all_checks()
    success = analyzer.print_results(verbose=args.verbose)

    if args.json:
        analyzer.export_json(args.json)

    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
