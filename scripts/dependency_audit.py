#!/usr/bin/env python3
"""
dependency_audit.py

Audits Flutter/Dart dependencies in pubspec.lock against:
  1. flutter pub outdated --json — detects resolvable major-version upgrades.
  2. OSV (Open Source Vulnerability) database — detects packages with known CVEs.

Exit codes:
  0 — All checks passed (no critical findings).
  1 — Critical finding: outdated major version or known CVE detected.

Usage:
  python3 scripts/dependency_audit.py
  python3 scripts/dependency_audit.py --fail-on-outdated   (also fail on major upgrades)
"""
import json
import os
import subprocess
import sys
import urllib.request
import urllib.error

FAIL_ON_OUTDATED = "--fail-on-outdated" in sys.argv


def run_flutter_outdated():
    """Runs 'flutter pub outdated --json' and returns parsed output."""
    print("📦 Running flutter pub outdated --json ...")
    try:
        result = subprocess.run(
            ["flutter", "pub", "outdated", "--json"],
            capture_output=True,
            text=True,
            timeout=120,
        )
        if result.returncode not in (0, 1):  # pub outdated exits 1 when upgrades exist
            print(f"  [WARN] flutter pub outdated exited with {result.returncode}")
            print(result.stderr[:500])
            return None
        return json.loads(result.stdout)
    except (subprocess.TimeoutExpired, json.JSONDecodeError, FileNotFoundError) as e:
        print(f"  [ERROR] Failed to run flutter pub outdated: {e}")
        return None


def extract_major_upgrades(outdated_data):
    """Returns list of packages with available major-version upgrades."""
    upgrades = []
    if not outdated_data:
        return upgrades
    for pkg in outdated_data.get("packages", []):
        name = pkg.get("package", "")
        current = pkg.get("current", {}).get("version") or ""
        upgradable = pkg.get("upgradable", {}).get("version") or ""
        resolvable = pkg.get("resolvable", {}).get("version") or ""

        # Determine if there is a major version jump
        best_version = resolvable or upgradable
        if best_version and current:
            try:
                cur_major = int(current.split(".")[0])
                new_major = int(best_version.split(".")[0])
                if new_major > cur_major:
                    upgrades.append({
                        "package": name,
                        "current": current,
                        "available": best_version,
                    })
            except (ValueError, IndexError):
                pass
    return upgrades


def load_pubspec_lock_packages():
    """Parses pubspec.lock and returns a dict of {name: version}."""
    lock_path = os.path.join(os.getcwd(), "pubspec.lock")
    if not os.path.exists(lock_path):
        print("  [WARN] pubspec.lock not found, skipping CVE scan.")
        return {}

    packages = {}
    try:
        with open(lock_path, "r") as f:
            content = f.read()

        # Simple YAML parsing for packages section (avoids needing PyYAML)
        in_packages = False
        current_pkg = None
        for line in content.splitlines():
            stripped = line.strip()
            if stripped == "packages:":
                in_packages = True
                continue
            if not in_packages:
                continue
            if line.startswith("  ") and not line.startswith("    ") and stripped.endswith(":"):
                current_pkg = stripped[:-1]
            elif current_pkg and "version:" in stripped:
                version = stripped.replace("version:", "").strip().strip('"')
                packages[current_pkg] = version

    except Exception as e:
        print(f"  [WARN] Could not parse pubspec.lock: {e}")
    return packages


def query_osv(package_name, version, ecosystem="Pub"):
    """Queries OSV API for vulnerabilities for a specific package + version."""
    url = "https://api.osv.dev/v1/query"
    payload = json.dumps({
        "version": version,
        "package": {"name": package_name, "ecosystem": ecosystem},
    }).encode()
    req = urllib.request.Request(
        url,
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            data = json.loads(response.read())
            return data.get("vulns", [])
    except (urllib.error.URLError, json.JSONDecodeError):
        return []


def run_cve_scan(packages):
    """Checks all locked packages against OSV for known CVEs."""
    print(f"\n🔍 Scanning {len(packages)} locked packages against OSV vulnerability database...")
    findings = []
    for name, version in packages.items():
        vulns = query_osv(name, version)
        if vulns:
            for v in vulns:
                findings.append({
                    "package": name,
                    "version": version,
                    "cve_id": v.get("id", "unknown"),
                    "summary": v.get("summary", "No summary available"),
                    "severity": v.get("database_specific", {}).get("severity", "UNKNOWN"),
                })
    return findings


def main():
    critical_failures = []

    # --- Step 1: flutter pub outdated ---
    outdated_data = run_flutter_outdated()
    major_upgrades = extract_major_upgrades(outdated_data)

    if major_upgrades:
        print(f"\n⚠️  Major version upgrades available ({len(major_upgrades)} packages):")
        for pkg in major_upgrades:
            print(f"   - {pkg['package']}: {pkg['current']} → {pkg['available']}")
        if FAIL_ON_OUTDATED:
            critical_failures.extend(major_upgrades)
    else:
        print("  ✅ No major version upgrades detected.")

    # --- Step 2: OSV CVE Scan ---
    packages = load_pubspec_lock_packages()
    cve_findings = run_cve_scan(packages)

    if cve_findings:
        print(f"\n🚨 CVE findings ({len(cve_findings)}):")
        for finding in cve_findings:
            print(
                f"   - [{finding['severity']}] {finding['package']}@{finding['version']}"
                f" — {finding['cve_id']}: {finding['summary']}"
            )
        critical_failures.extend(cve_findings)
    else:
        print("  ✅ No known CVEs detected in locked dependencies.")

    # --- Summary ---
    print("\n=== Dependency Audit Summary ===")
    if critical_failures:
        print(f"❌ AUDIT FAILED: {len(critical_failures)} critical finding(s). Resolve before release.")
        sys.exit(1)
    else:
        print("✅ AUDIT PASSED: All dependency checks clear.")
        sys.exit(0)


if __name__ == "__main__":
    main()
