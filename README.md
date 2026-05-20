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

Sprint 3 polished Home into the daily dashboard with typed Home state, Daily Debate selection, live friends, recent chats, Start Room CTA, stable bottom navigation, and Home navigation tests. Sprint 4 should focus on Messaging MVP.

Sprint 4 implemented the Messaging MVP with searchable chats, reusable chat list items, direct chat bubbles, local message sending, AI helper responses, and chat-to-room routing. Sprint 5 should focus on Create Room and Room Lobby.

Sprint 5 implemented Create Room and Room Lobby with shared room setup state, room type/friend/AI/summary selection, mic and audio-route mock states, lobby AI settings, and state carry-through into Live Voice Room. Sprint 6 should focus on Live Voice Room UI alpha.

Sprint 6 implemented the Live Voice Room UI alpha with shared live-room state, participant cards, speaking indicators, mute state, connection states, chat/invite/leave sheets, AI drawer access, and AI-off handling.

Sprint 7 implemented the AI Drawer and AI interaction alpha with shared AI state, consent-aware controls, mode selection, Memory Off visibility, quick actions, prompt-based mock responses, status transitions, and Turn off AI behavior that updates Live Room immediately.

Sprint 8 implemented the Room Summary MVP with shared summary state, dynamic recap content from room setup, summary privacy handling, Save/Share/Delete actions, Summary Off behavior, and post-room widget coverage.

Sprint 9 implemented the Safety/Reporting MVP with shared safety state, enum-backed report reasons, confirmation flow, Direct Chat block handling, Chats blocked indicators, Live Room safety sheet with participant mute/report actions, and a lightweight Profile Safety Center.

Sprint 10 implemented the Profile and Social Graph MVP with shared social state, dynamic profile editing, friend search/management, mock friend requests, blocked/muted management from Profile, and room invite blocked-state handling.

Sprint 11 completed MVP polish and demo readiness with route smoke coverage for every MVP route, clearer local/demo copy, alpha control labels, `MVP_DEMO_CHECKLIST.md`, `MVP_KNOWN_LIMITATIONS.md`, and 23 passing widget tests. Optional Android debug APK build is currently blocked by a malformed local NDK install missing `source.properties`.

Sprint 12 planning has started in `docs/SPRINT_12_REAL_APP_BACKEND_PLANNING.txt`. It defines the recommended backend architecture, data model, API boundaries, realtime voice plan, AI orchestration plan, moderation plan, and migration path from mock MVP to a real backend-backed app.

Sprint 12 implemented the backend foundation and contracts: `backend/` TypeScript Fastify service, `/health` and `/version`, PostgreSQL Docker Compose, Prisma schema draft, API/database/migration docs, and backend validation. Flutter remains stable with 23 passing tests. Android debug APK build is still blocked by the malformed local NDK install documented in `docs/SPRINT_12_BACKEND_FOUNDATION_REPORT.md`.

Sprint 13 added backend dev-auth and profile persistence foundations: `x-dev-user-id` middleware, Prisma client module, `/me` profile routes, username availability, AI consent persistence, a local seed script, backend README/docs updates, and Flutter auth/user repository interfaces with mock implementations. Flutter remains mock/local by default and now has 25 passing tests. Database-backed smoke checks require Docker Desktop running locally; Docker was not running during this validation pass.

Sprint 14a completed backend DB smoke hardening by adding `npm run test`, moving local Docker Postgres to host port `5433` to avoid a local PostgreSQL conflict, creating/applying the initial Prisma migration, seeding the dev user, passing database-backed backend tests, and smoking the Sprint 13 profile endpoints against the built server. See `docs/SPRINT_14A_BACKEND_DB_SMOKE_REPORT.md`.

Sprint 14b added Flutter backend-mode profile wiring: JSON backend API client, backend auth/user repositories, DTO mapping, repository injection in `OpposeApp`, repository-backed onboarding username/profile/interests/AI consent saves, repository-backed Profile display/edit state, backend repository tests, and 27 passing Flutter tests. Mock mode remains the default; backend mode is enabled with `--dart-define=OPPOSE_USE_BACKEND=true`. See `docs/SPRINT_14B_FLUTTER_BACKEND_PROFILE_WIRING_REPORT.md`.
