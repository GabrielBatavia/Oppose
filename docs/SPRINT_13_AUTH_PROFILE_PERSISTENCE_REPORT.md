# Oppose Sprint 13 Auth And Profile Persistence Report

Date: 2026-05-20

## Sprint Goal

Start backend-backed auth/profile persistence without choosing a production auth vendor yet, while keeping the Flutter app stable on mock/local behavior.

## Scope Completed

### Backend Dev Auth

Added development-only auth middleware using `x-dev-user-id`.

Built:

- `backend/src/auth/dev-auth.ts`
- `backend/src/types/fastify.ts`

Behavior:

- Protected routes require a UUID in `x-dev-user-id`.
- Missing or invalid header returns `401 DEV_AUTH_REQUIRED`.
- Unknown dev user returns `401 DEV_USER_NOT_FOUND`.
- Production auth remains out of scope and must replace this with provider token/session verification later.

### Backend User/Profile Routes

Added Sprint 13 profile endpoints.

Built:

- `backend/src/db/prisma.ts`
- `backend/src/routes/users.ts`
- updated `backend/src/server.ts`

Endpoints:

- `GET /users/check-username?username=...`
- `GET /me`
- `PATCH /me/profile`
- `PATCH /me/interests`
- `POST /me/ai-consent`

Validation:

- username: lowercase letters, numbers, underscores, 3-24 chars
- display name: 2-40 chars
- language: simple `en` / `en-US` style code
- interests: up to 10 values, each 1-40 chars
- AI consent: accepted must be true, version required

### Seed Script

Added a local development seed script.

Built:

- `backend/prisma/seed.ts`
- `npm run db:seed`

Seeded dev user:

- id: `00000000-0000-4000-8000-000000000001`
- username: `thinkwithbima`
- display name: `Bima's Friend`
- interests: `Technology`, `Friendship`, `Food`
- AI consent accepted: true

### Flutter Repository Boundary

Added repository seams for auth/profile migration without changing UI behavior.

Built:

- `lib/repositories/backend_api_client.dart`
- `lib/repositories/auth/auth_repository.dart`
- `lib/repositories/auth/mock_auth_repository.dart`
- `lib/repositories/user/user_repository.dart`
- `lib/repositories/user/mock_user_repository.dart`
- `test/repository_test.dart`

Current Flutter behavior remains mock/local by default. Screens and controllers were not rewired to HTTP in this sprint.

### Documentation

Updated:

- `backend/README.md`
- `docs/API_CONTRACTS_V1.txt`
- `docs/DATABASE_SCHEMA_V1.txt`
- `docs/FLUTTER_BACKEND_MIGRATION_PLAN.txt`
- `README.md`

## Acceptance Criteria Status

- Dev auth middleware exists: done.
- Protected profile routes use dev auth: done.
- Username availability endpoint exists: done.
- Current user endpoint exists: done.
- Profile update endpoint exists: done.
- Interests update endpoint exists: done.
- AI consent endpoint exists: done.
- Prisma client module exists: done.
- Seed script exists: done.
- Backend README documents dev auth and seed flow: done.
- Flutter auth/user repository interfaces exist: done.
- Flutter mock repository implementations exist: done.
- Flutter app remains mock/local by default: done.
- API and migration docs updated: done.

## Backend Verification

Commands run from `Oppose/backend/`:

```bash
npm run check
npm run build
npx prisma validate
docker compose config
npm run prisma:generate
```

Results:

- `npm run check`: passed.
- `npm run build`: passed.
- `npx prisma validate`: passed with `DATABASE_URL` supplied from `.env.example` value.
- `docker compose config`: passed.
- `npm run prisma:generate`: passed after rerun.

HTTP smoke run against built server:

- `GET /health`: passed.
- `GET /version`: passed.
- `GET /me` without dev auth: returned expected `401 DEV_AUTH_REQUIRED`.

Database-backed smoke checks were blocked because Docker Desktop was not running:

```text
unable to get image 'postgres:16-alpine': error during connect: open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.
```

Because Postgres could not start, these were not run:

- `npm run prisma:migrate:dev`
- `npm run db:seed`
- `GET /me` with seeded `x-dev-user-id`
- username availability check against seeded database

## Flutter Verification

Commands run from `Oppose/`:

```bash
dart format lib test
flutter analyze
flutter test
```

Results:

- `dart format lib test`: completed, 0 files changed.
- `flutter analyze`: passed with no issues.
- `flutter test`: passed, 25 tests.

## Known Limitations

- Flutter is not connected to backend endpoints yet.
- Dev auth is for local development only.
- Production auth provider is not selected yet.
- Database migration/seed smoke requires Docker Desktop running locally.
- Chats, rooms, social graph, reports, LiveKit, and AI provider calls remain mock/planned.
- Android debug APK build remains separately blocked by the malformed local NDK install documented in earlier sprint reports.

## Next Sprint Recommendation

Start Sprint 14 with one narrow integration path:

1. Run Docker Desktop, apply Prisma migration, seed the dev user, and smoke database-backed Sprint 13 endpoints.
2. Add a real Flutter backend API client implementation for auth/profile DTOs.
3. Wire onboarding/profile controllers to repositories with loading and error states, keeping mock repositories available for tests/demo mode.
