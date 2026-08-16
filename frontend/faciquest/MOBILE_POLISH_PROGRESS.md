# FaciQuest Mobile Polish Progress

Last updated: 2026-08-16

## Scope

This ledger covers only `frontend/faciquest`, the Flutter mobile app. The
dashboard, backend, iOS configuration, API URLs, lockfile changes, and unrelated
workspace files that were already modified before this pass are outside scope.

## Audit Snapshot

- 255 Dart source files reviewed through structure, static analysis, and pattern searches.
- 54 primary view, page, and modal files inventoried.
- Existing architecture: feature-first presentation with BLoC/Cubit and separated domain/data layers.
- Largest maintainability hotspots:
  - `manage_my_surveys_view.dart` (about 1,888 lines)
  - `collect_responses_page.dart` (about 1,522 lines)
  - `survey_view.dart` (about 1,194 lines)
  - `analyse_results_page.dart` (about 1,090 lines)
  - `home_view.dart` (about 1,024 lines)
- Baseline `flutter analyze`: 380 diagnostics.
- Main UX risks found: fixed auth layouts, duplicated theming/components,
  undersized gesture-only links, long entrance animations, missing reduced-motion
  handling, inconsistent dark/light tokens, and weak large-screen constraints.

## Completed

- [x] Added a centralized Material 3 theme with accessible brand colors,
  semantic component styles, consistent 14-16dp radii, visible dark-mode
  dividers, floating snackbars, and 48-52dp interactive controls.
- [x] Restored the FaciQuest primary identity to an accessible blue scale
  (Blue 600/700 actions, Blue 100 containers, and dark-mode blue counterparts).
- [x] Added `AdaptivePageBody` with compact, tablet, and expanded gutters plus a
  readable maximum content width.
- [x] Added shared, semantic `AppLogo` and `AppLanguageMenu` widgets.
- [x] Rebuilt the welcome screen to scroll safely on small phones, landscape,
  tablets, RTL locales, and large text; feature cards now reflow by width.
- [x] Rebuilt sign-in around shared theme primitives, autofill, semantic buttons,
  descriptive password visibility controls, explicit loading/disabled states,
  and an adaptive content width.
- [x] Reduced non-essential entrance motion to 240ms and honor the platform's
  reduced-motion preference on the rebuilt entry screens.
- [x] Fixed theme toggling when the current mode is `ThemeMode.system`.
- [x] Removed unused animation and validation state from shared input/button code.
- [x] Applied 319 SDK-suggested cleanups in 49 mobile files: replaced every
  deprecated `withOpacity` call, added inferred return types, removed unnecessary
  imports, and removed unused optional parameters.
- [x] Migrated active sharing calls to the current `SharePlus` API.
- [x] Migrated the gender selector to the current `RadioGroup` API.
- [x] Added widget coverage for compact gutters, tablet width constraints, and
  minimum primary-action height.
- [x] Added a shared adaptive auth shell and migrated sign-up, OTP,
  forgot-password, and reset-password to it, cutting those presentation files
  from about 2,492 lines to about 1,342 lines including the shared shell.
- [x] Added autofill, localized inline validation, responsive name fields,
  keyboard-safe scrolling, semantic legal/back/resend actions, and consistent
  loading/disabled states across the migrated auth flow.
- [x] Enforced the same eight-character password minimum in sign-up and password
  reset state, and corrected password guidance in English, French, and Arabic.
- [x] Audited remaining gesture controls: rating and question-card actions now
  use 48dp semantic Material controls; the reusable press interaction now
  supplies button semantics and a 48dp minimum target. The remaining app-level
  gesture only dismisses the keyboard and is not exposed as an action.
- [x] Added shared adaptive content-width and sliver primitives, then constrained
  home, profile, personal information, survey management, survey creation,
  survey-taking, and wallet-sheet content for landscape and tablet widths.
- [x] Centralized dialog styling, added a localized logout confirmation, repaired
  the survey retry action, and added a retry state to survey creation.
- [x] Made every mobile bottom sheet opt into safe-area handling; the shared sheet
  shell now caps content at 720dp and accounts for the soft keyboard.
- [x] Extended reduced-motion handling to reusable press/slide interactions and
  the primary home and survey-management entrances.
- [x] Extended localized inline validation and keyboard focus traversal from
  auth into personal information, wallet update/cash-out/payment, survey details,
  question authoring, response fields, and collector invitation/targeting forms.
- [x] Removed remaining English validation literals from active wallet forms,
  corrected profile validation to use translation keys, and repaired the shared
  input error rendering that previously ignored `errorMessage`.
- [x] Decomposed the five largest presentation hotspots into 37 focused library
  slices while keeping their existing feature-level private boundaries. Their
  orchestration files now total 619 lines, down from about 6,908 lines.
- [x] Extracted reusable public seams for home sections, survey question
  rendering, collector loading, survey lifecycle, management failure, and
  analysis empty/failure states so they can be tested without mounting a route.
- [x] Added a reusable fake survey repository, four focused Cubit tests, two
  extracted-widget interaction tests, and five checked-in mobile golden baselines.

## Validation

- [x] `dart format` on authored/refactored files.
- [x] `flutter analyze` compiles the app after the refactor.
- [x] Analyzer diagnostics reduced from 380 to 0.
- [x] `flutter test` — 20 tests passed, including blue-theme identity, compact and
  expanded adaptive widths, short-screen, large-text, reduced-motion, RTL, and
  password-state rules, form traversal, Cubit behavior, extracted-widget
  interactions, and five golden comparisons.
- [x] Debug build launched successfully on an iPhone 17 Pro simulator; the
  polished blue sign-in screen was visually smoke-tested without overflow.
- [ ] Manual device pass at 375px portrait and landscape.
- [ ] Manual large-text, reduced-motion, RTL, and dark-mode pass on a simulator/device.

## Remaining Backlog

### P0 — correctness and accessibility

- [x] Resolve async `BuildContext` diagnostics in analysis, collector, question,
  and wallet flows, including the file-picker sheet lifecycle.
- [x] Migrate question radio groups and reorder callbacks away from deprecated
  Flutter APIs.
- [x] Audit remaining `GestureDetector` usages; replace action controls with
  semantic Material controls or add explicit semantics and touch bounds.
- [x] Extend the localized inline-validation and focus-traversal pattern now used
  by auth to profile, wallet, and survey forms.

### P1 — screen polish

- [x] Migrate sign-up, OTP, forgot-password, and reset-password screens to the
  shared adaptive auth shell and shared language controls.
- [x] Constrain home, profile, wallet, and survey content on tablets/landscape.
- [x] Standardize top-level empty, loading, failure, retry, and
  destructive-confirmation behavior.
- [x] Protect fixed survey actions and every modal with safe-area and soft-keyboard handling.

### P2 — clean-code decomposition

- [x] Split `home_view.dart` into header, survey section, cards, and state views.
- [x] Split `manage_my_surveys_view.dart` into toolbar, filters, list/grid cards,
  menus, dialogs, and pagination/state components.
- [x] Split `collect_responses_page.dart` into collector list, stats, share/QR,
  status actions, and modal orchestration.
- [x] Split `survey_view.dart` by question renderer and survey lifecycle state.
- [x] Split `analyse_results_page.dart` into filters, summaries, charts, export,
  and failure/empty states.
- [x] Add focused Cubit, widget, and golden tests for each extracted slice.

## Guardrails

- Preserve the current feature/domain/data boundaries and BLoC/Cubit state model.
- Prefer shared semantic theme tokens over per-screen colors and shapes.
- Use window constraints rather than device or orientation checks.
- Keep touch targets at least 48dp and interaction motion between 150-300ms.
- Keep all user-facing strings localized in English, French, and Arabic.
- Refactor large screens incrementally with behavior tests before moving logic.
