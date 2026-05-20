# Oppose Backend

Sprint 13 backend foundation for turning the Flutter mock MVP into a real backend-backed app.

## Stack

- TypeScript
- Fastify
- PostgreSQL
- Prisma

## Setup

```bash
npm install
Copy-Item .env.example .env
docker compose up -d postgres
npm run prisma:generate
npm run prisma:migrate:dev
npm run db:seed
npm run dev
```

Health check:

```bash
curl http://localhost:4000/health
```

Current user smoke check after seeding:

```bash
curl -H "x-dev-user-id: 00000000-0000-4000-8000-000000000001" http://localhost:4000/me
```

## Development Auth

Sprint 13 uses development-only auth so profile persistence can move forward before choosing Supabase, Firebase, Clerk, or a custom auth provider.

Protected endpoints require this header:

```text
x-dev-user-id: 00000000-0000-4000-8000-000000000001
```

The seeded dev user matches the Flutter mock identity:

- username: `thinkwithbima`
- display name: `Bima's Friend`
- interests: `Technology`, `Friendship`, `Food`
- AI consent: accepted

Do not use `x-dev-user-id` as a production auth pattern. Production auth must derive current user from a verified provider token/session.

## Local Database Port

Docker maps Postgres container port `5432` to host port `5433`:

```text
postgresql://oppose:oppose_dev_password@localhost:5433/oppose_dev?schema=public
```

This avoids conflicts with local PostgreSQL services that may already use host port `5432`.

## Sprint 13 Endpoints

- `GET /users/check-username?username=thinkwithbima`
- `GET /me`
- `PATCH /me/profile`
- `PATCH /me/interests`
- `POST /me/ai-consent`

## Validation

```bash
npm run check
npm run build
npm run test
npx prisma validate
docker compose config
```

`npm run test` uses Node's built-in test runner. Database-backed tests run when local Postgres is reachable and are skipped only when Docker/Postgres is unavailable.

## Notes

- This backend is still a foundation. Sprint 13 adds development auth and profile persistence endpoints only.
- Do not commit `.env` or real secrets.
- AI providers and LiveKit admin keys must stay server-side.
