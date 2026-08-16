# Survey Management Polish Design

## Overview

Polish the mobile owner experience from the survey list into survey summary,
collectors, and analysis. Preserve the current BLoC/Cubit, repository, routing,
and blue Material 3 design system while making every visible action truthful and
usable.

## User Stories

- As a survey owner, I can scan, filter, sort, and open surveys without guessing
  what each control does.
- As a survey owner, I can move predictably between the summary, editor,
  collectors, and analysis views.
- As a survey owner, I can understand collector status and safely delete a
  collector with real persistence feedback.
- As a survey owner, I see useful analysis only when supported by response data,
  with honest empty and unavailable states otherwise.

## Clean Architecture

### Domain and Data Layers

- Keep `SurveyEntity`, `CollectorEntity`, and `SurveyRepository` as the source of
  business data.
- Use existing repository methods for loading and deleting collectors.
- Do not add fake device, time-series, export, or collector-status data when the
  backend contract does not provide it.

### Presentation Layer

- Keep `ManageMySurveysCubit` responsible for list filtering and sorting.
- Keep `NewSurveyCubit` responsible for survey-detail navigation and collector
  lifecycle state.
- Use responsive constraints, semantic Material controls, 48dp touch targets,
  localized labels, and the existing blue theme tokens.
- Use compact cards on phones and progressively richer layouts on wider screens.

## Data Flow

1. Survey list actions route to `NewSurveyView` with the appropriate
   `SurveyAction`.
2. `NewSurveyCubit` loads the selected survey and exposes summary, editor,
   collectors, and analysis destinations.
3. Collector refresh and delete operations emit explicit loading, success, and
   failure state, then reconcile the visible collector list.
4. Analysis derives only distributions and counts supported by loaded questions,
   submissions, and collectors.

## Interaction Design

- Survey cards have one primary open action, a compact metrics row, and a menu
  for edit, preview, collect, analyse, and delete.
- Survey details use a contextual header and a compact destination switcher for
  existing surveys.
- Summary uses flexible stat tiles and clear action cards instead of fixed aspect
  ratios and inert controls.
- Collectors use responsive cards, copy/share actions, a persistent add action,
  and confirmation before real deletion.
- Analysis uses compact tabs and metrics, expandable response cards, and
  question charts separated from the overview; CSV sharing is the only export
  action shown because it is the only implemented format.

## Testing Plan

- Cubit tests for collector loading/deletion and page navigation.
- Widget tests for survey-card actions, summary navigation, collector states,
  and phone-width analysis overview, response, and chart presentation.
- Existing golden tests remain stable or receive deliberate updated baselines.
- Run formatting, `flutter analyze`, the full Flutter test suite, localization
  JSON validation, and `git diff --check`.

## Dependencies

No new packages or backend endpoints.
