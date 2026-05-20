# Oppose Sprint 14a Backend DB Smoke Report

Date: 2026-05-20

## Sprint Goal

Prove the Sprint 13 backend auth/profile routes with repeatable backend tests and prepare the local Postgres migration/seed smoke path.

## Completed

### Backend Integration Test Script

Added a backend test command:

```bash
npm run test
```

Implemented with Node's built-in test runner and `tsx`.

Updated:

- `backend/package.json`
- `backend/README.md`

### Route Tests

Added:

- `backend/src/routes/users.integration.test.ts`

Coverage:

- `GET /health` responds without auth.
- `GET /version` responds without auth.
- `GET /me` without `x-dev-user-id` returns `401 DEV_AUTH_REQUIRED` before database lookup.
- Database-backed suite for local Postgres:
  - seeded user can fetch `GET /me`
  - username validation rejects invalid input
  - username availability detects free/taken names
  - username conflict returns `409 USERNAME_TAKEN`
  - profile update persists
  - interests update persists and de-duplicates
  - AI consent update persists

The database-backed suite automatically skips only when Postgres is not reachable. If Postgres is reachable but schema/migration is wrong, the tests fail.

## Validation Run

Commands run from `Oppose/backend/`:

```bash
docker compose up -d postgres
npm run prisma:migrate:dev -- --name init
npm run db:seed
npm run check
npm run build
npm run test
npx prisma validate
docker compose config
npm run prisma:generate
```

Results:

- `docker compose up -d postgres`: passed after moving the host port to `5433`.
- `npm run prisma:migrate:dev -- --name init`: passed and created `backend/prisma/migrations/20260520033324_init/migration.sql`.
- `npm run db:seed`: passed.
- `npm run check`: passed.
- `npm run build`: passed.
- `npm run test`: passed with 6 backend tests, including database-backed profile route coverage.
- `npx prisma validate`: passed.
- `docker compose config`: passed.
- `npm run prisma:generate`: passed.

## Docker/Postgres Status

Initial issue:

```bash
docker compose up -d postgres
```

Docker Desktop was initially not running. It was launched successfully, then Postgres started.

A second issue appeared: host port `5432` was already used by a local `postgres.exe`, so Prisma authenticated against the wrong service.

Fix applied:

- `backend/docker-compose.yml` now maps `5433:5432`.
- `backend/.env.example` now uses `localhost:5433`.
- `docs/DATABASE_SCHEMA_V1.txt` documents the local host port.

Original Docker engine error:

```text
open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.
```

Original port-conflict symptom:

```text
P1000: Authentication failed against database server, the provided database credentials for `oppose` are not valid.
```

## Endpoint Smoke

Smoked against the built backend server with:

```text
DATABASE_URL=postgresql://oppose:oppose_dev_password@127.0.0.1:5433/oppose_dev?schema=public
x-dev-user-id: 00000000-0000-4000-8000-000000000001
```

Endpoints passed:

- `GET /health`
- `GET /version`
- `GET /me`
- `GET /users/check-username?username=thinkwithbima`
- `PATCH /me/profile`
- `PATCH /me/interests`
- `POST /me/ai-consent`

After smoke/tests, `npm run db:seed` was rerun to restore the dev user to the canonical mock identity.

## Current Local Commands

Run from `Oppose/backend/`:

```bash
docker compose up -d postgres
npm run prisma:migrate:dev
npm run db:seed
npm run test
```

## Next Action

Sprint 14b can now add the real Flutter backend repository implementations for auth/profile and wire onboarding/profile controllers through repository interfaces.
