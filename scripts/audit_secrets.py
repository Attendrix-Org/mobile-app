#!/usr/bin/env python3
import sys
import os
import re
import subprocess

# Patterns to scan for.
# Each value is a compiled regex that must match an ACTUAL secret, not incidental hex strings.
SECRET_PATTERNS = {
    # Supabase publishable/anon keys start with a recognisable prefix.
    "Supabase Anon Key": re.compile(r"sb_publishable_[a-zA-Z0-9_\-]{10,}"),

    # NASA API keys are 40-char alphanumeric strings, but only flag them when
    # they appear immediately after a recognised key-name context to avoid
    # matching git SHAs, certificate fingerprints, or other hex blobs.
    "NASA API Key": re.compile(
        r"(?:api[_-]?key|NASA_API_KEY|apiKey|DEMO_KEY)\s*[=:\"' ]+\s*([a-zA-Z0-9]{40})\b",
        re.IGNORECASE,
    ),
}

# Files and path prefixes to skip entirely (IDE state, generated files, lockfiles).
IGNORE_PREFIXES = (
    ".idea/",
    ".dart_tool/",
    ".flutter-plugins",
    "build/",
    "ios/",
    "macos/",
    "windows/",
    "linux/",
)

# Exact filenames to skip.
IGNORE_FILES = {
    "scripts/audit_secrets.py",
    ".metadata",
    "README.md",
    "implementation_plan.md",
    "pubspec.lock",
}

def get_git_tracked_files():
    try:
        output = subprocess.check_output(["git", "ls-files"], text=True)
        return [f.strip() for f in output.splitlines() if f.strip()]
    except Exception as e:
        print(f"Error getting git tracked files: {e}")
        # Fallback to recursively scanning directories if not in git repo
        files = []
        for root, _, filenames in os.walk("."):
            if ".git" in root or ".dart_tool" in root or "build" in root:
                continue
            for f in filenames:
                path = os.path.relpath(os.path.join(root, f), ".")
                if not path.startswith(".env"):
                    files.append(path)
        return files

def scan_file(filepath):
    # Skip by exact filename
    if filepath in IGNORE_FILES:
        return []
    # Skip by path prefix (IDE dirs, build output, platform dirs)
    if any(filepath.startswith(prefix) for prefix in IGNORE_PREFIXES):
        return []
    # Skip binary file extensions
    binary_exts = (".png", ".jpg", ".jpeg", ".webp", ".lock",
                   ".gif", ".ico", ".svg", ".xml", ".pbxproj",
                   ".gradle", ".class", ".jar", ".aar")
    if any(filepath.endswith(ext) for ext in binary_exts):
        return []

    findings = []
    try:
        with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
            for line_no, line in enumerate(f, 1):
                # Don't flag comments explaining patterns
                if "SECRET_PATTERNS" in line or "re.compile" in line:
                    continue
                for name, pattern in SECRET_PATTERNS.items():
                    matches = pattern.findall(line)
                    for m in matches:
                        # Exclude DEMO_KEY or mock/test strings
                        if "DEMO_KEY" in m or m.lower().startswith("example"):
                            continue
                        findings.append({
                            "file": filepath,
                            "line": line_no,
                            "type": name,
                            "snippet": line.strip()[:60] + "..." if len(line) > 60 else line.strip()
                        })
    except Exception as e:
        # Ignore read errors
        pass
    return findings

def main():
    print("=== Commencing Git Tracked Secrets Scan ===")
    tracked_files = get_git_tracked_files()
    
    # Also verify that no .env files are tracked
    env_files_tracked = [f for f in tracked_files if ".env" in f and not f.endswith(".example")]
    
    all_findings = []
    if env_files_tracked:
        for f in env_files_tracked:
            all_findings.append({
                "file": f,
                "line": 0,
                "type": "Tracked Env File",
                "snippet": f"The environment file '{f}' is tracked by git! This violates secure secret storage."
            })

    for filepath in tracked_files:
        findings = scan_file(filepath)
        all_findings.extend(findings)

    if all_findings:
        print("\n[!] CRITICAL SECURITY AUDIT FAILED: Secrets detected in git index:")
        for f in all_findings:
            print(f"  - File: {f['file']}:{f['line']} | Type: {f['type']}")
            print(f"    Content: {f['snippet']}")
        print("\nAction Required: Remove the secret immediately and run 'git reset' on the file.")
        sys.exit(1)
    else:
        print("[+] Security Scan Passed: No secrets or environment files tracked in git repository.")
        sys.exit(0)

if __name__ == "__main__":
    main()
