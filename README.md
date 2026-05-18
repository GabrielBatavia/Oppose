# Oppose

Oppose is a Flutter mobile app for daily social AI-assisted debate with friends.

Core line: **Different take, better talk.**

This repo currently contains the Flutter app foundation plus the product/design references in `docs/`.

## Getting Started

Run from this directory:

```bash
flutter pub get
flutter run
```

Useful checks:

```bash
flutter analyze
flutter test
```

## Build Context

- `docs/AI_AGENT_REFERENCE_CONTEXT.txt` explains the Oppose product, visual system, safety rules, and page requirements.
- `docs/OPPOSE_AI_AGENT_BUILD_GUIDE_AND_SPRINT_PLAN.txt` is the implementation guide and sprint plan.
- `docs/refrences/pages/` contains screen references. The folder is intentionally spelled `refrences` in the source material.
- `docs/refrences/assets/` contains reusable brand illustrations and decorative assets.

## Current Status

Sprint 0 created the Flutter project foundation and documented the route/component plan.

Sprint 1 added the Oppose app shell, theme tokens, navigation stubs, core components, mock data, service boundaries, and asset registration.

Sprint 2 implemented the onboarding flow from Welcome through AI Consent into Home, including validation, mock onboarding state, username availability, interest selection, AI consent copy, and a full-flow widget test. Sprint 3 should focus on Home and main navigation polish.
