# Oppose Backend

Sprint 12 backend foundation for turning the Flutter mock MVP into a real backend-backed app.

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
npm run dev
```

Health check:

```bash
curl http://localhost:4000/health
```

## Validation

```bash
npm run check
npm run build
```

## Notes

- This backend is a foundation only. It exposes a health endpoint and schema/contracts for future implementation.
- Do not commit `.env` or real secrets.
- AI providers and LiveKit admin keys must stay server-side.
