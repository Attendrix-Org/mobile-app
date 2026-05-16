# Attendrix Mobile Application 

## 1. Executive Summary
This repository houses the frontend mobile application for the Attendrix academic management platform, developed utilizing the Flutter framework. This client interfaces directly with the established Supabase backend infrastructure. 

This document defines the strict engineering workflows, version control protocols, and lifecycle management standards required for contributing to the mobile application codebase. Consistent adherence is mandatory to maintain UI/UX stability, optimal client-side performance, and secure data transmission.

## 2. Development Workflow and Branching Strategy

This repository utilizes a multi-tiered branching strategy to isolate feature development, facilitate comprehensive pre-production testing across multiple devices, and protect the production application state.

### 2.1. Core Branches
* `main`: The definitive production state. Code merged into this branch must be stable, fully tested, and ready for app store compilation. Direct commits are strictly prohibited.
* `staging`: The pre-production integration and QA environment. All completed features are merged here for integration testing, performance profiling, and internal beta distribution.

### 2.2. Feature Development and Forking Protocol
Contributors must follow a standard branching workflow for all new features, bug fixes, and UI alterations:

1. **Repository Synchronization:** Ensure your local clone is up to date with the upstream `main` branch before initiating work. Run `flutter pub get` to synchronize dependencies.
2. **Branch Creation:** Create a localized working branch off of `main`. Adhere to the following nomenclature standard:
   * `feat/issue-number-brief-description` (e.g., `feat/201-implement-dashboard-ui`)
   * `fix/issue-number-brief-description` (e.g., `fix/205-resolve-calendar-render-overflow`)
   * `chore/issue-number-brief-description` (e.g., `chore/210-update-flutter-sdk-version`)
3. **Commit Standards:** Commits must be atomic, addressing a single logical change. Commit messages must use the Conventional Commits specification.

### 2.3. Staging and Integration
Once a feature is locally validated and passes isolated testing constraints (including Flutter analyzer and formatting checks):

1. **Pull Request to Staging:** Open a Pull Request (PR) targeting the `staging` branch.
2. **Peer Review:** The PR requires a minimum of one peer approval. Reviewers must specifically audit state management efficiency, widget rebuild optimization, and adherence to the design system.
3. **Staging Merge:** Upon approval, merge the feature branch into `staging`. 
4. **Integration QA:** The staging environment will be utilized to compile test builds (APK/TestFlight) to verify the feature's interactions on physical hardware.

### 2.4. Production Deployment (Merging to Main)
After stable feature integration is confirmed in the `staging` environment across targeted device profiles:

1. **Release Pull Request:** Open a PR from `staging` to `main`.
2. **Final Audit:** This PR serves as the release candidate and requires final sign-off from the technical lead.
3. **Squash and Merge:** When merging into `main`, utilize the "Squash and Merge" methodology to compile all staging commits into a clean, singular release commit.

## 3. Directory Structure Summary

The repository follows a strict feature-first architectural pattern to ensure modularity and separation of concerns.

* `android/`: Android-specific build configurations, permissions, and native code.
* `ios/`: iOS-specific build configurations, Info.plist properties, and native code.
* `assets/`: Static assets including typography, rasterized images, SVGs, and localization files.
* `lib/core/`: Application-wide configurations, routing definitions, global themes, and network client singletons.
* `lib/shared/`: Reusable UI components, generic widgets, and cross-feature utility functions.
* `lib/features/`: Isolated feature modules containing dedicated `data/`, `domain/`, and `presentation/` layers.
* `test/`: Unit, widget, and integration testing suites mapped to the `lib/` directory structure.
* `pubspec.yaml`: Dart package dependencies, SDK constraints, and asset registration.

## 4. Architectural Constraints & API Interaction

To maintain security and synchronize with the backend architecture, the following client-side rules are absolute:

### 4.1. RPC-Exclusive Communication
* **No Direct Table Queries:** The Supabase backend enforces strict Row-Level Security (RLS) that blocks direct table mutations. The Flutter client must NEVER attempt to execute direct `INSERT`, `UPDATE`, or `DELETE` queries against backend tables via the standard client methods.
* **RPC Mandate:** All data mutations and complex reads must be routed exclusively through the defined PostgreSQL Remote Procedure Calls (RPCs) using the Supabase client (e.g., `supabase.rpc('mark_absent', params)`).

### 4.2. State Management
* All business logic and application state must be abstracted from the UI layer using the project's designated state management solution.
* Stateful widgets should be utilized sparingly and only for localized, ephemeral UI state (e.g., text field controllers, localized micro-animations).

## 5. Development Regulations and Constraints

* **Strict Linting:** All code must pass the standardized `flutter analyze` constraints. Warnings are treated as errors in the CI/CD pipeline and will block PR merges.
* **UI/UX Consistency:** All visual components must utilize the predefined design tokens and standardized widgets located in `lib/shared/`. Hardcoding colors, typographies, or static padding values outside of the core theme is strictly prohibited.
* **Testing Mandate:** All critical business logic inside the `domain` and `data` layers must be accompanied by unit tests. Complex UI interactions and customized components require corresponding widget tests prior to PR submission.
