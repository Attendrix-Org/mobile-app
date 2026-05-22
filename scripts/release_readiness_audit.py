#!/usr/bin/env python3
"""
release_readiness_audit.py

Aggregates results from all QA checks and produces a structured release-readiness
report. Returns exit code 1 if any critical finding is detected.

Critical findings (exit 1):
  - Exposed secrets detected by audit_secrets.py
  - flutter analyze reports errors
  - flutter test reports failures
  - Branch coverage below threshold on critical modules
  - Known CVE in any locked dependency (dependency_audit.py)

Usage:
  python3 scripts/release_readiness_audit.py [--skip-tests] [--skip-deps]
"""
import json
import os
import subprocess
import sys
import textwrap
from dataclasses import dataclass, field
from datetime import datetime, timezone

SKIP_TESTS = '--skip-tests' in sys.argv
SKIP_DEPS = '--skip-deps' in sys.argv

# Branch coverage threshold on critical modules (0.0–1.0)
# Each module path maps to its minimum required branch coverage ratio.
BRANCH_COVERAGE_THRESHOLDS = {
    'lib/features/apod/presentation/providers/apod_providers.dart': 0.80,
    'lib/features/apod/data/repositories/apod_repository_impl.dart': 0.80,
    'lib/features/apod/data/datasources/apod_local_datasource.dart': 0.75,
    'lib/features/apod/data/datasources/apod_remote_datasource.dart': 0.75,
}


@dataclass
class Finding:
    severity: str  # 'CRITICAL' | 'WARNING' | 'INFO'
    category: str
    message: str


@dataclass
class AuditReport:
    findings: list = field(default_factory=list)
    checks_run: list = field(default_factory=list)

    def add(self, severity: str, category: str, message: str):
        self.findings.append(Finding(severity=severity, category=category, message=message))

    def critical(self, category: str, message: str):
        self.add('CRITICAL', category, message)

    def warning(self, category: str, message: str):
        self.add('WARNING', category, message)

    def info(self, category: str, message: str):
        self.add('INFO', category, message)

    @property
    def has_critical(self):
        return any(f.severity == 'CRITICAL' for f in self.findings)


def run_cmd(cmd, timeout=120, cwd=None):
    """Runs a subprocess and returns (returncode, stdout, stderr)."""
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=timeout,
            cwd=cwd or os.getcwd(),
        )
        return result.returncode, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return -1, '', f'Command timed out after {timeout}s: {" ".join(cmd)}'
    except FileNotFoundError as e:
        return -1, '', f'Command not found: {e}'


def check_secrets(report: AuditReport):
    """Runs audit_secrets.py and captures findings."""
    print('\n[1/6] 🔐 Secret Scan...')
    report.checks_run.append('Secret Scan')

    if not os.path.exists('scripts/audit_secrets.py'):
        report.warning('Secret Scan', 'scripts/audit_secrets.py not found — skipping.')
        return

    code, stdout, stderr = run_cmd(['python3', 'scripts/audit_secrets.py'])
    if code != 0:
        report.critical('Secret Scan', f'Secrets detected in repository:\n{stdout}\n{stderr}')
    else:
        report.info('Secret Scan', 'No secrets found in tracked files.')
    print(stdout or stderr)


def check_static_analysis(report: AuditReport):
    """Runs flutter analyze and checks for errors."""
    print('\n[2/6] 🔍 Static Analysis (flutter analyze)...')
    report.checks_run.append('Static Analysis')

    code, stdout, stderr = run_cmd(['flutter', 'analyze'], timeout=120)
    if code != 0:
        report.critical('Static Analysis', f'flutter analyze reported errors:\n{stdout}')
    else:
        report.info('Static Analysis', 'No analysis issues found.')
    print(stdout[:2000] if stdout else stderr[:2000])


def check_tests(report: AuditReport):
    """Runs flutter test and checks for failures."""
    print('\n[3/6] 🧪 Unit & Widget Tests (flutter test)...')
    report.checks_run.append('Unit & Widget Tests')

    if SKIP_TESTS:
        report.info('Unit & Widget Tests', 'Skipped via --skip-tests flag.')
        return

    code, stdout, stderr = run_cmd(
        ['flutter', 'test', '--reporter=compact'],
        timeout=300,
    )
    if code != 0:
        report.critical('Unit & Widget Tests', f'Test failures detected:\n{stdout[-2000:]}')
    else:
        # Count passed tests
        lines = stdout.splitlines()
        passed_line = next((l for l in reversed(lines) if 'passed' in l.lower()), None)
        report.info('Unit & Widget Tests', f'All tests passed. {passed_line or ""}')
    print(stdout[-2000:] if stdout else stderr[-1000:])


def check_coverage(report: AuditReport):
    """Runs flutter test --coverage and evaluates branch coverage on critical modules."""
    print('\n[4/6] 📊 Coverage Analysis...')
    report.checks_run.append('Coverage Analysis')

    if SKIP_TESTS:
        report.info('Coverage Analysis', 'Skipped via --skip-tests flag.')
        return

    code, stdout, stderr = run_cmd(
        ['flutter', 'test', '--coverage', '--reporter=compact'],
        timeout=300,
    )

    lcov_path = os.path.join('coverage', 'lcov.info')
    if not os.path.exists(lcov_path):
        report.warning('Coverage Analysis', 'coverage/lcov.info not found — coverage not measured.')
        return

    # Parse lcov.info for branch coverage per file
    with open(lcov_path) as f:
        content = f.read()

    current_file = None
    branch_found_total = 0
    branch_hit_total = 0
    file_coverage = {}

    for line in content.splitlines():
        if line.startswith('SF:'):
            current_file = line[3:].strip()
            file_coverage[current_file] = {'bf': 0, 'bh': 0}
        elif line.startswith('BRF:') and current_file:
            file_coverage[current_file]['bf'] = int(line[4:])
        elif line.startswith('BRH:') and current_file:
            file_coverage[current_file]['bh'] = int(line[4:])
        elif line.startswith('end_of_record'):
            current_file = None

    # Evaluate thresholds
    for rel_path, threshold in BRANCH_COVERAGE_THRESHOLDS.items():
        abs_path = os.path.abspath(rel_path)
        matched = file_coverage.get(abs_path) or file_coverage.get(rel_path)
        if matched is None:
            report.warning(
                'Coverage Analysis',
                f'No coverage data for critical module: {rel_path}',
            )
            continue
        bf = matched['bf']
        bh = matched['bh']
        if bf == 0:
            ratio = 1.0
        else:
            ratio = bh / bf

        if ratio < threshold:
            report.critical(
                'Coverage Analysis',
                f'Branch coverage below threshold for {rel_path}: '
                f'{ratio:.0%} < {threshold:.0%} required '
                f'({bh}/{bf} branches covered)',
            )
        else:
            report.info(
                'Coverage Analysis',
                f'{rel_path}: branch coverage {ratio:.0%} ✅ (threshold: {threshold:.0%})',
            )


def check_dependencies(report: AuditReport):
    """Runs dependency_audit.py."""
    print('\n[5/6] 📦 Dependency Audit...')
    report.checks_run.append('Dependency Audit')

    if SKIP_DEPS:
        report.info('Dependency Audit', 'Skipped via --skip-deps flag.')
        return

    if not os.path.exists('scripts/dependency_audit.py'):
        report.warning('Dependency Audit', 'scripts/dependency_audit.py not found — skipping.')
        return

    code, stdout, stderr = run_cmd(['python3', 'scripts/dependency_audit.py'], timeout=120)
    if code != 0:
        report.critical('Dependency Audit', f'Dependency audit failed:\n{stdout}\n{stderr}')
    else:
        report.info('Dependency Audit', 'Dependency audit passed.')
    print(stdout[:2000] if stdout else stderr[:1000])


def check_manifest(report: AuditReport):
    """Audits AndroidManifest.xml for critical security attributes."""
    print('\n[6/6] 📋 Manifest Audit...')
    report.checks_run.append('Manifest Audit')

    manifest_path = 'android/app/src/main/AndroidManifest.xml'
    if not os.path.exists(manifest_path):
        report.warning('Manifest Audit', f'{manifest_path} not found.')
        return

    with open(manifest_path) as f:
        content = f.read()

    # Check key security attributes
    if 'android:allowBackup="true"' in content:
        report.critical('Manifest Audit', 'android:allowBackup="true" is set — production apps must disable backup.')
    elif 'android:allowBackup="false"' in content:
        report.info('Manifest Audit', 'android:allowBackup="false" ✅')
    else:
        report.warning('Manifest Audit', 'android:allowBackup not explicitly set.')

    if 'android:usesCleartextTraffic="true"' in content:
        report.critical('Manifest Audit', 'android:usesCleartextTraffic="true" — cleartext is not allowed in production.')
    elif 'android:usesCleartextTraffic="false"' in content:
        report.info('Manifest Audit', 'android:usesCleartextTraffic="false" ✅')

    # Check that we have the INTERNET permission
    if 'android.permission.INTERNET' in content:
        report.info('Manifest Audit', 'INTERNET permission present ✅')
    else:
        report.warning('Manifest Audit', 'INTERNET permission not found — network calls may fail.')

    # Check that no debug-only permissions leaked to main manifest
    debug_perms = ['android.permission.READ_LOGS', 'WRITE_SECURE_SETTINGS']
    for perm in debug_perms:
        if perm in content:
            report.critical('Manifest Audit', f'Debug-only permission found in main manifest: {perm}')

    # Verify attendrix package name
    if 'com.attendrix.app' not in content and 'com.example' in content:
        report.critical('Manifest Audit', 'Legacy package name com.example found in manifest.')
    elif 'com.attendrix.app' in content:
        report.info('Manifest Audit', 'Package name com.attendrix.app verified ✅')


def print_report(report: AuditReport):
    """Prints a structured release-readiness report."""
    timestamp = datetime.now(timezone.utc).isoformat()
    divider = '=' * 70

    print(f'\n{divider}')
    print(' ATTENDRIX APP — RELEASE READINESS REPORT')
    print(f' Generated: {timestamp}')
    print(divider)

    print(f'\nChecks Run: {", ".join(report.checks_run)}')

    criticals = [f for f in report.findings if f.severity == 'CRITICAL']
    warnings = [f for f in report.findings if f.severity == 'WARNING']
    infos = [f for f in report.findings if f.severity == 'INFO']

    if infos:
        print(f'\n✅ PASSED ({len(infos)}):')
        for f in infos:
            print(f'   [{f.category}] {f.message}')

    if warnings:
        print(f'\n⚠️  WARNINGS ({len(warnings)}):')
        for f in warnings:
            for line in textwrap.wrap(f.message, 80, initial_indent='   [{}] '.format(f.category), subsequent_indent='       '):
                print(line)

    if criticals:
        print(f'\n❌ CRITICAL FAILURES ({len(criticals)}):')
        for f in criticals:
            print(f'   [{f.category}]')
            for line in textwrap.wrap(f.message, 80, initial_indent='   ', subsequent_indent='     '):
                print(line)

    print(f'\n{divider}')
    if report.has_critical:
        print(' VERDICT: ❌ NOT RELEASE READY — Resolve all critical findings.')
    else:
        print(' VERDICT: ✅ RELEASE READY — All critical checks passed.')
    print(divider)


def main():
    print('🚀 Attendrix Release Readiness Audit')
    print('   Running all pre-release checks...')

    report = AuditReport()

    check_secrets(report)
    check_static_analysis(report)
    check_tests(report)
    check_coverage(report)
    check_dependencies(report)
    check_manifest(report)

    print_report(report)

    # Exit 1 if any critical finding
    sys.exit(1 if report.has_critical else 0)


if __name__ == '__main__':
    main()
