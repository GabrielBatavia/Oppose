import assert from 'node:assert/strict';
import { afterEach, beforeEach, describe, test } from 'node:test';

import type { FastifyInstance } from 'fastify';

import { prisma } from '../db/prisma.js';
import { buildServer } from '../server.js';

const devUserId = '00000000-0000-4000-8000-000000000001';
const conflictUserId = '00000000-0000-4000-8000-000000000002';

const devAuthHeaders = {
  'x-dev-user-id': devUserId,
};

const isDatabaseAvailable = await canReachDatabase();

test('system endpoints respond without auth', async () => {
  const server = buildServer();
  await server.ready();

  try {
    const health = await server.inject({ method: 'GET', url: '/health' });
    assert.equal(health.statusCode, 200);
    assert.equal(parseJson(health.body).service, 'oppose-backend');

    const version = await server.inject({ method: 'GET', url: '/version' });
    assert.equal(version.statusCode, 200);
    assert.equal(parseJson(version.body).sprint, 13);
  } finally {
    await server.close();
  }
});

test('GET /me requires development auth before database lookup', async () => {
  const server = buildServer();
  await server.ready();

  try {
    const response = await server.inject({ method: 'GET', url: '/me' });
    const body = parseJson(response.body);

    assert.equal(response.statusCode, 401);
    assert.equal(body.error.code, 'DEV_AUTH_REQUIRED');
  } finally {
    await server.close();
  }
});

describe(
  'database-backed user and profile routes',
  { skip: isDatabaseAvailable ? false : 'Postgres is not reachable' },
  () => {
    let server: FastifyInstance;

    beforeEach(async () => {
      await seedUsers();
      server = buildServer();
      await server.ready();
    });

    afterEach(async () => {
      await server.close();
    });

    test('GET /me returns the seeded current user', async () => {
      const response = await server.inject({
        method: 'GET',
        url: '/me',
        headers: devAuthHeaders,
      });
      const body = parseJson(response.body);

      assert.equal(response.statusCode, 200);
      assert.equal(body.id, devUserId);
      assert.equal(body.username, 'thinkwithbima');
      assert.equal(body.displayName, "Bima's Friend");
      assert.deepEqual(body.interests, ['Technology', 'Friendship', 'Food']);
      assert.equal(body.aiConsentAccepted, true);
    });

    test('username availability validates input and detects conflicts', async () => {
      const invalid = await server.inject({
        method: 'GET',
        url: '/users/check-username?username=Nope!',
      });
      assert.equal(invalid.statusCode, 400);

      const available = await server.inject({
        method: 'GET',
        url: '/users/check-username?username=fresh_name',
      });
      assert.equal(available.statusCode, 200);
      assert.equal(parseJson(available.body).available, true);

      const taken = await server.inject({
        method: 'GET',
        url: '/users/check-username?username=taken_name',
      });
      assert.equal(taken.statusCode, 200);
      assert.equal(parseJson(taken.body).available, false);
    });

    test('PATCH /me/profile rejects username conflicts', async () => {
      const response = await server.inject({
        method: 'PATCH',
        url: '/me/profile',
        headers: devAuthHeaders,
        payload: { username: 'taken_name' },
      });
      const body = parseJson(response.body);

      assert.equal(response.statusCode, 409);
      assert.equal(body.error.code, 'USERNAME_TAKEN');
    });

    test('profile, interests, and AI consent updates persist', async () => {
      const profile = await server.inject({
        method: 'PATCH',
        url: '/me/profile',
        headers: devAuthHeaders,
        payload: {
          displayName: 'Friendly Bima',
          username: 'friendly_bima',
          language: 'en-US',
        },
      });
      const profileBody = parseJson(profile.body);

      assert.equal(profile.statusCode, 200);
      assert.equal(profileBody.displayName, 'Friendly Bima');
      assert.equal(profileBody.username, 'friendly_bima');
      assert.equal(profileBody.language, 'en-US');

      const interests = await server.inject({
        method: 'PATCH',
        url: '/me/interests',
        headers: devAuthHeaders,
        payload: { interests: ['Music', 'Culture', 'Music'] },
      });
      const interestsBody = parseJson(interests.body);

      assert.equal(interests.statusCode, 200);
      assert.deepEqual(interestsBody.interests, ['Music', 'Culture']);

      const consent = await server.inject({
        method: 'POST',
        url: '/me/ai-consent',
        headers: devAuthHeaders,
        payload: { accepted: true, version: '2026-05-20-test' },
      });
      const consentBody = parseJson(consent.body);

      assert.equal(consent.statusCode, 200);
      assert.equal(consentBody.aiConsentAccepted, true);
      assert.equal(consentBody.aiConsentVersion, '2026-05-20-test');

      const current = await server.inject({
        method: 'GET',
        url: '/me',
        headers: devAuthHeaders,
      });
      const currentBody = parseJson(current.body);

      assert.equal(current.statusCode, 200);
      assert.equal(currentBody.username, 'friendly_bima');
      assert.deepEqual(currentBody.interests, ['Music', 'Culture']);
      assert.equal(currentBody.aiConsentVersion, '2026-05-20-test');
    });
  },
);

async function canReachDatabase() {
  try {
    await prisma.$queryRaw`SELECT 1`;
    return true;
  } catch {
    return false;
  }
}

async function seedUsers() {
  await prisma.user.upsert({
    where: { id: devUserId },
    update: {
      username: 'thinkwithbima',
      displayName: "Bima's Friend",
      language: 'en',
      aiConsentAccepted: true,
      aiConsentVersion: '2026-05-20-test',
    },
    create: {
      id: devUserId,
      authProviderId: 'test:thinkwithbima',
      email: 'friend-test@example.com',
      username: 'thinkwithbima',
      displayName: "Bima's Friend",
      language: 'en',
      aiConsentAccepted: true,
      aiConsentVersion: '2026-05-20-test',
    },
  });

  await prisma.user.upsert({
    where: { id: conflictUserId },
    update: {
      username: 'taken_name',
      displayName: 'Taken Name',
    },
    create: {
      id: conflictUserId,
      authProviderId: 'test:taken_name',
      email: 'taken-test@example.com',
      username: 'taken_name',
      displayName: 'Taken Name',
    },
  });

  await prisma.userInterest.deleteMany({ where: { userId: devUserId } });
  await prisma.userInterest.createMany({
    data: ['Technology', 'Friendship', 'Food'].map((interest) => ({
      userId: devUserId,
      interest,
    })),
  });
}

function parseJson(body: string) {
  return JSON.parse(body) as Record<string, any>;
}
