# PathPilot Development Log

> Living document for development progress, architectural decisions, and lessons learned.  
> Updated at the end of each development session.

---

## Project Overview

**PathPilot** is a local-first iOS career transition companion built with SwiftUI. It helps early-career professionals and career switchers build a personalized roadmap, track skills and certifications, and manage job applications — all from a single structured dashboard.

### Target Users

- **Primary persona:** "The Career Switcher" — e.g. a recent graduate pivoting into tech or cloud security
- Overwhelmed by scattered advice (bootcamps, certs, portfolios, networking)
- Currently tracking progress across Notes, spreadsheets, and bookmarks
- Values clarity, visible progress, and privacy (local data is a feature, not a limitation)

### Main Purpose

PathPilot connects *where you are → where you're going → what to do next*. The MVP delivers a 5-step onboarding that produces a personalized dashboard roadmap, with ongoing trackers for skills, certifications, and job applications.

**Source documents:** [PRODUCT_PLAN.md](PRODUCT_PLAN.md) · [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md)

---

## Technical Stack

| Technology | Role |
|---|---|
| **SwiftUI** | Declarative UI framework for all views and navigation |
| **MVVM** | Separation of view logic (`@Observable` ViewModels) from presentation (Views) |
| **SwiftData** | Local persistence for user profile, goals, skills, milestones, and future trackers |
| **iOS 17+** | Minimum deployment target; enables `@Observable`, modern SwiftData APIs |
| **Local-only storage** | No auth, no CloudKit for V1 — data stays on device |

---

## Architecture Overview

### App Structure

Feature-based folder layout under `PathPilot/`:

```
PathPilot/
├── App/              PathPilotApp.swift — entry point, ModelContainer
├── Models/           SwiftData @Model types and shared enums
├── ViewModels/       @Observable state and business logic (added incrementally)
├── Views/            Feature screens (Dashboard, Skills, Onboarding, etc.)
├── Components/       Reusable UI (CareerCard, EmptyStateView, …)
├── Services/         Shared logic (ProgressCalculator — Day 3+)
└── Extensions/       Color+Theme and other extensions
```

### Navigation Flow

```
PathPilotApp
    └── RootView
            ├── [Day 2+] OnboardingContainerView (first launch)
            └── MainTabView (returning users / post-onboarding)
                    ├── Dashboard
                    ├── Skills
                    ├── Certifications
                    ├── Applications
                    └── Profile
```

**Day 1 state:** `RootView` routes directly to `MainTabView`. Day 2 adds an `@AppStorage("hasCompletedOnboarding")` gate.

### Data Model Approach

- SwiftData `@Model` classes for persisted entities
- Shared enums in `Enums.swift` (incrementally extended on feature days)
- Models registered incrementally in `ModelContainer` — only what the app currently uses
- V1 assumes a single user profile and one active career goal

### How SwiftData Is Used

| Concern | Approach |
|---|---|
| **Registration** | `.modelContainer(for: [...])` on the `WindowGroup` in `PathPilotApp` |
| **Reads** | `@Query` in views (Day 3+) for live, reactive lists |
| **Writes** | `@Environment(\.modelContext)` + `context.save()` after inserts/updates |
| **Onboarding gate** | `@AppStorage` for routing; SwiftData for actual user data |
| **Previews** | `.modelContainer(for: [...])` on `#Preview` blocks that need persisted data |

**Registered models:** `UserProfile`, `CareerGoal`, `Milestone` (Day 1) · `Skill` (Day 2 Task 1)

---

## Development Milestones

### Day 1 — Foundation Setup

**Branch:** merged to `main`  
**Commit message:** `feat: project foundation, theme, tabs, SwiftData models`

#### Completed Work

| Area | Details |
|---|---|
| **Theme system** | `Extensions/Color+Theme.swift` — `pathPilotPrimary`, `pathPilotAccent`, `pathPilotBackground`, `pathPilotCard` |
| **AccentColor** | `Assets.xcassets/AccentColor.colorset` aligned with `pathPilotAccent` |
| **SwiftData models** | `UserProfile`, `CareerGoal`, `Milestone`, partial `Enums` (`SkillCategory`, `SkillStatus`) |
| **ModelContainer** | Wired in `PathPilotApp.swift` for Day 1 models |
| **Navigation shell** | `RootView` → `MainTabView` with five placeholder tab views |
| **Tab bar** | Dashboard, Skills, Certifications, Applications, Profile — `.tint(.pathPilotAccent)` |
| **Components** | `CareerCard`, `EmptyStateView` in `Components/` |
| **Housekeeping** | Day 1 work merged to `main`; `Components/` folder casing normalized for Xcode |

#### Files Created or Modified

- `App/PathPilotApp.swift`
- `Extensions/Color+Theme.swift`
- `Models/UserProfile.swift`, `CareerGoal.swift`, `Milestone.swift`, `Enums.swift`
- `Views/RootView.swift`, `MainTabView.swift`
- `Views/Dashboard/DashboardView.swift` (+ Skills, Certifications, Applications, Profile placeholders)
- `Components/CareerCard.swift`, `EmptyStateView.swift`
- `Assets.xcassets/AccentColor.colorset`

#### Checkpoint Verified

- [x] App launches with five tabs; each tab switches correctly
- [x] Theme colors render in `#Preview`
- [x] Build succeeds with `ModelContainer` registered

---

### Day 2 — Onboarding Flow

**Branch:** `cursor/day2-onboarding`  
**Status:** In progress (Tasks 1–2 complete)  
**Goal:** First-time users complete a 5-step onboarding wizard; data persists to SwiftData; relaunch skips onboarding.

#### Objectives

- [x] Create `Skill.swift` and register in `ModelContainer`
- [x] Create `OnboardingViewModel` (`@Observable`) with step navigation and validation
- [ ] Build 5 onboarding views + `OnboardingContainerView` (step indicator, Back/Next)
- [ ] Add `@AppStorage("hasCompletedOnboarding")` gate in `RootView`
- [ ] On finish: insert `UserProfile`, `CareerGoal`, `Skill` records, `Milestone`; call `context.save()`

#### Tasks Completed

| Task | Status | Notes |
|---|---|---|
| `Skill.swift` + ModelContainer registration | ✅ Done | Commit `02b43fd` |
| `OnboardingViewModel.swift` | ✅ Done | `@Observable`, validation, `completeOnboarding(context:)` |
| Onboarding views (6 files) | ☐ Pending | Task 3 |
| `RootView` onboarding gate | ☐ Pending | Task 4 |
| Persistence on complete | ☐ Pending | Wired in ViewModel; gate + UI in Tasks 3–4 |

#### Files Changed

| File | Action | Purpose |
|---|---|---|
| `Models/Skill.swift` | Created | SwiftData model for current / to-learn skills |
| `App/PathPilotApp.swift` | Modified | Registered `Skill.self` in ModelContainer |
| `ViewModels/OnboardingViewModel.swift` | Created | Step state, validation, SwiftData save on complete |

#### Architectural Decisions

| Decision | Rationale | Alternatives Considered |
|---|---|---|
| Skills optional on Step 3 | V1 plan allows skipping; user can add skills on Day 4 | Require at least one skill |
| `completeOnboarding` in ViewModel | Keeps views thin; single save path for onboarding data | Inline save logic in container view |
| `@AppStorage` set in view (Task 4) | Plan specifies AppStorage as routing gate, separate from SwiftData | Infer completion from `@Query` |

#### Issues Encountered

| Issue | Resolution |
|---|---|
| Xcode `?` badge on new `Skill.swift` | Untracked Git file — resolved after `git add` / commit |

#### Lessons Learned

- Register SwiftData models before building features that insert them — catches container issues early.
- `@Observable` ViewModels need no `@Published`; views hold `@State private var viewModel = …`.

#### Checkpoint (target)

- [ ] Fresh install → onboarding shows
- [ ] Cannot advance with empty required fields
- [ ] Complete onboarding → lands on dashboard with persisted data
- [ ] Force-quit + relaunch → skips onboarding
- [ ] Git commit: `feat: onboarding wizard with SwiftData persistence`

---

## Engineering Decisions

Decisions documented here support interview discussions and future refactors.

### Why SwiftUI + SwiftData (not UIKit + Core Data)

| Factor | Choice |
|---|---|
| **SwiftUI** | Declarative UI, `@Query` integration, faster iteration for a solo MVP |
| **SwiftData** | Native Swift models (`@Model`), less boilerplate than Core Data for V1 scope |
| **Tradeoff** | SwiftData is newer; fewer Stack Overflow answers, but sufficient for local-only MVP |

### Why MVVM with `@Observable`

- **ViewModels** for onboarding and dashboard keep views thin and testable
- **`@Observable`** (iOS 17+) replaces `ObservableObject` / `@Published` with simpler observation
- **Pragmatic V1 rule:** Skills, Certs, and Applications may use `@Query` + `modelContext` directly in views; extract ViewModels in V2 if complexity grows

### Why Local-Only (No Auth / CloudKit)

- MVP goal is portfolio-quality UX, not multi-device sync
- Removes auth, backend, and privacy-policy overhead
- `@AppStorage` + SwiftData covers first-launch routing and persistent profile data
- CloudKit sync deferred to V2 ([PRODUCT_PLAN.md](PRODUCT_PLAN.md))

### Incremental Model Registration

Models are added to `ModelContainer` only when a feature needs them:

| Day | Models registered |
|---|---|
| 1 | `UserProfile`, `CareerGoal`, `Milestone` |
| 2 | `Skill` |
| 5 | `Certification` |
| 6 | `JobApplication` |

**Rationale:** Reduces Day 1–2 SwiftData debugging surface; each feature day validates one save path.

### Theme: Semantic Colors

- Brand colors (`pathPilotPrimary`, `pathPilotAccent`) are fixed RGB
- Surfaces (`pathPilotBackground`, `pathPilotCard`) use UIKit semantic colors for automatic Light/Dark Mode support

---

## Future Improvements

### Features Planned (V2+)

- Sign in with Apple / CloudKit sync
- Multiple career goals
- Career transition templates
- Profile editing (edit sheets)
- Milestone due dates and local notifications
- Skill detail view with notes
- Grouped application list sections
- Full weighted progress calculator (40/30/20/10)
- Analytics protocol and event tracking
- Custom app icon and full accessibility audit

### Technical Improvements

- Extract ViewModels for Skills, Certifications, and Applications if CRUD logic grows
- Unit tests for `ProgressCalculator` and onboarding validation
- Preview fixtures with realistic demo data
- `.gitignore` and CI (Day 7)

### Refactoring Opportunities

- Shared form sheet pattern across Skills, Certs, and Applications
- Centralized onboarding → SwiftData mapping in a small persistence helper
- Consolidate status badge styling once `StatusBadge` exists (Day 5)

---

## Development Notes

Running journal of development sessions. Newest entries at the top.

---

### Session — 2026-08-01 (Day 2 Tasks 1–2)

**Focus:** Skill model + OnboardingViewModel  
**Branch:** `cursor/day2-onboarding`

**Activities:**
- Created `Skill.swift` and registered in ModelContainer (Task 1)
- Created `OnboardingViewModel` with step navigation, `canProceed` validation, and `completeOnboarding(context:)` (Task 2)
- Pushed Task 1 to GitHub; Task 2 and development log committed separately

**Next session:**
- Task 3: `OnboardingContainerView` + five step views

---

### Session — 2026-07-31 (Day 2 prep)

**Focus:** Project documentation; Day 2 planning  
**Branch:** `cursor/day2-onboarding`

**Activities:**
- Reviewed [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md) Day 2 objectives
- Created `DEVELOPMENT_LOG.md` to track milestones, decisions, and session notes
- Day 1 work confirmed complete on `main`; Day 2 implementation not yet started

**Next session:**
- Task 1: `Skill.swift` + `ModelContainer` registration

---

### Session — 2026-07-31 (Day 1 complete)

**Focus:** Foundation — theme, tabs, core SwiftData models, reusable components  
**Branch:** merged to `main`

**Activities:**
- Established feature-based folder structure
- Implemented theme system and semantic colors
- Created core SwiftData models and wired `ModelContainer`
- Built `MainTabView` with five placeholder tabs
- Added `CareerCard` and `EmptyStateView` components
- Resolved `Components/` folder casing for Xcode compatibility

**Outcome:** App launches to a navigable 5-tab shell with SwiftData ready for onboarding data.

---

*Last updated: 2026-08-01*
