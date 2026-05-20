# Oppose Sprint 12 Backend Foundation And Contracts Report

Date: 2026-05-19

## Sprint Goal

Start moving Oppose from a polished frontend/mock MVP toward a real backend-backed app by adding a backend service foundation, PostgreSQL/Prisma schema draft, API contracts, database docs, and Flutter migration plan.

This sprint did not connect the Flutter app to the backend yet. The app remains stable on its current mock/local state while backend foundations are prepared.

## Build Split

### Sprint 12a: Backend Service Skeleton

Added `Oppose/backend` as an Oppose-specific backend foundation.

Stack:

- TypeScript
- Fastify
- PostgreSQL
- Prisma
- Docker Compose

Built:

- `backend/package.json`
- `backend/tsconfig.json`
- `backend/.env.example`
- `backend/src/config.ts`
- `backend/src/server.ts`
- `backend/src/index.ts`
- `backend/README.md`

Endpoints:

- `GET /health`
- `GET /version`

### Sprint 12b: Local Database Foundation

Added PostgreSQL Docker Compose config.

Built:

- `backend/docker-compose.yml`
- local Postgres service config
- healthcheck
- named volume

### Sprint 12c: Prisma Schema Draft

Added first production schema draft.

Built:

- `backend/prisma/schema.prisma`

Schema areas:

- users
- interests
- friendships
- blocks
- mutes
- conversations
- messages
- rooms
- room participants
- room invites
- AI requests
- room summaries
- reports
- moderation actions
- device tokens

### Sprint 12d: Real-App Contract Docs

Added backend transition docs.

Built:

- `docs/API_CONTRACTS_V1.txt`
- `docs/DATABASE_SCHEMA_V1.txt`
- `docs/FLUTTER_BACKEND_MIGRATION_PLAN.txt`

These docs define endpoint drafts, database intent, access rules, and the step-by-step migration plan from current mock controllers to repository-backed services.

### Sprint 12e: Project Hygiene

Updated `.gitignore` for backend artifacts:

- `node_modules/`
- `dist/`
- `.env`
- local database folders

Generated:

- `backend/package-lock.json`

## Important Files Changed

- `.gitignore`
- `backend/package.json`
- `backend/package-lock.json`
- `backend/tsconfig.json`
- `backend/.env.example`
- `backend/docker-compose.yml`
- `backend/README.md`
- `backend/src/config.ts`
- `backend/src/server.ts`
- `backend/src/index.ts`
- `backend/prisma/schema.prisma`
- `docs/API_CONTRACTS_V1.txt`
- `docs/DATABASE_SCHEMA_V1.txt`
- `docs/FLUTTER_BACKEND_MIGRATION_PLAN.txt`
- `docs/SPRINT_12_REAL_APP_BACKEND_PLANNING.txt`
- `docs/SPRINT_12_BACKEND_FOUNDATION_REPORT.md`
- `README.md`

## Acceptance Criteria Status

- `Oppose/backend` exists: done.
- TypeScript Fastify service exists: done.
- Health endpoint exists: done.
- Version endpoint exists: done.
- PostgreSQL Docker Compose exists: done.
- Prisma schema draft exists: done.
- API contracts doc exists: done.
- Database schema doc exists: done.
- Flutter backend migration plan exists: done.
- Backend TypeScript check passes: done.
- Backend build passes: done.
- Prisma schema validates: done.
- Docker Compose config validates: done.
- Flutter analyze still passes: done.
- Flutter tests still pass: done.
- Android debug APK build status documented: done.

## Backend Verification

Commands run from `Oppose/backend/`:

```bash
npm install
npx prisma validate
npm run check
npm run build
docker compose config
node dist/index.js
```

Results:

- `npm install`: passed, 0 vulnerabilities.
- `npx prisma validate`: passed with `DATABASE_URL` supplied from `.env.example` value.
- `npm run check`: passed.
- `npm run build`: passed.
- `docker compose config`: passed.
- `GET /health`: returned `{ "ok": true, "service": "oppose-backend" }`.
- `npm run prisma:generate`: passed.

## Flutter Verification

Commands run from `Oppose/`:

```bash
dart format lib test
flutter analyze
flutter test
```

Results:

- `dart format lib test`: completed, no source changes required.
- `flutter analyze`: passed with no issues.
- `flutter test`: passed, 23 tests.

## Android Debug Build Status

Command run from `Oppose/`:

```bash
flutter build apk --debug
```

Result: failed due malformed local Android NDK install, same as Sprint 11.

Error:

```text
[CXX1101] NDK at C:\Users\GabrielBatavia\AppData\Local\Android\Sdk\ndk\28.2.13676358 did not have a source.properties file
```

Flutter suggested deleting the local malformed NDK folder and allowing Android Gradle Plugin to re-download it:

```text
C:\Users\GabrielBatavia\AppData\Local\Android\Sdk\ndk\28.2.13676358
```

No deletion was performed during this sprint because that is an external local toolchain folder outside the project workspace.

## Known Limitations

- Backend is a skeleton only.
- Flutter app is not connected to backend yet.
- No auth provider is configured yet.
- No migrations have been applied to a real database yet.
- No LiveKit integration yet.
- No AI provider integration yet.
- No moderation dashboard yet.
- Android debug APK build remains blocked by malformed local NDK install.

## Next Sprint Recommendation

Start Sprint 13: Auth And Profile Persistence.

Recommended scope:

- Decide auth provider.
- Add auth middleware to backend.
- Implement `/me`, profile update, interests update, username availability, and AI consent endpoints.
- Add seed/dev user flow if auth provider is not finalized.
- Add Flutter repository interfaces and mock/API boundary for onboarding/profile.
- Keep all existing Flutter widget tests passing.

Alternative first task before Sprint 13:

- Fix local Android NDK installation and verify `flutter build apk --debug` succeeds.
