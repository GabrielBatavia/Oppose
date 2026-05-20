import type { FastifyInstance } from 'fastify';
import { z } from 'zod';

import { requireDevUser } from '../auth/dev-auth.js';
import { prisma } from '../db/prisma.js';

const usernameSchema = z
  .string()
  .trim()
  .toLowerCase()
  .regex(/^[a-z0-9_]{3,24}$/, {
    message: 'Username must be 3-24 lowercase letters, numbers, or underscores.',
  });

const displayNameSchema = z.string().trim().min(2).max(40);
const languageSchema = z.string().trim().regex(/^[a-z]{2}(-[A-Z]{2})?$/);
const interestSchema = z.string().trim().min(1).max(40);

const checkUsernameQuerySchema = z.object({
  username: usernameSchema,
});

const updateProfileSchema = z
  .object({
    displayName: displayNameSchema.optional(),
    username: usernameSchema.optional(),
    avatarUrl: z.string().url().nullable().optional(),
    language: languageSchema.optional(),
  })
  .refine((value) => Object.keys(value).length > 0, {
    message: 'At least one profile field is required.',
  });

const updateInterestsSchema = z.object({
  interests: z.array(interestSchema).max(10),
});

const aiConsentSchema = z.object({
  accepted: z.literal(true),
  version: z.string().trim().min(1).max(40),
});

type UserWithInterests = Awaited<ReturnType<typeof findUserWithInterests>>;

export async function registerUserRoutes(server: FastifyInstance) {
  server.get('/users/check-username', async (request, reply) => {
    const parsed = checkUsernameQuerySchema.safeParse(request.query);
    if (!parsed.success) return validationError(reply, parsed.error);

    const existing = await prisma.user.findUnique({
      where: { username: parsed.data.username },
      select: { id: true },
    });

    return {
      username: parsed.data.username,
      available: existing == null,
    };
  });

  server.get('/me', { preHandler: requireDevUser }, async (request) => {
    const user = await findUserWithInterests(request.currentUserId!);
    return mapUser(user);
  });

  server.patch('/me/profile', { preHandler: requireDevUser }, async (request, reply) => {
    const parsed = updateProfileSchema.safeParse(request.body);
    if (!parsed.success) return validationError(reply, parsed.error);

    if (parsed.data.username != null) {
      const existing = await prisma.user.findUnique({
        where: { username: parsed.data.username },
        select: { id: true },
      });
      if (existing != null && existing.id !== request.currentUserId) {
        return reply.status(409).send({
          error: {
            code: 'USERNAME_TAKEN',
            message: 'That username is already taken.',
          },
        });
      }
    }

    const updated = await prisma.user.update({
      where: { id: request.currentUserId! },
      data: parsed.data,
      include: { interests: { orderBy: { createdAt: 'asc' } } },
    });

    return mapUser(updated);
  });

  server.patch('/me/interests', { preHandler: requireDevUser }, async (request, reply) => {
    const parsed = updateInterestsSchema.safeParse(request.body);
    if (!parsed.success) return validationError(reply, parsed.error);

    const uniqueInterests = [...new Set(parsed.data.interests.map((interest) => interest.trim()))];
    const user = await prisma.$transaction(async (tx) => {
      await tx.userInterest.deleteMany({
        where: { userId: request.currentUserId! },
      });
      if (uniqueInterests.length > 0) {
        await tx.userInterest.createMany({
          data: uniqueInterests.map((interest) => ({
            userId: request.currentUserId!,
            interest,
          })),
        });
      }
      return tx.user.findUniqueOrThrow({
        where: { id: request.currentUserId! },
        include: { interests: { orderBy: { createdAt: 'asc' } } },
      });
    });

    return mapUser(user);
  });

  server.post('/me/ai-consent', { preHandler: requireDevUser }, async (request, reply) => {
    const parsed = aiConsentSchema.safeParse(request.body);
    if (!parsed.success) return validationError(reply, parsed.error);

    const user = await prisma.user.update({
      where: { id: request.currentUserId! },
      data: {
        aiConsentAccepted: parsed.data.accepted,
        aiConsentVersion: parsed.data.version,
      },
      include: { interests: { orderBy: { createdAt: 'asc' } } },
    });

    return mapUser(user);
  });
}

async function findUserWithInterests(userId: string) {
  return prisma.user.findUniqueOrThrow({
    where: { id: userId },
    include: { interests: { orderBy: { createdAt: 'asc' } } },
  });
}

function mapUser(user: NonNullable<UserWithInterests>) {
  return {
    id: user.id,
    username: user.username,
    displayName: user.displayName,
    avatarUrl: user.avatarUrl,
    language: user.language,
    interests: user.interests.map((interest) => interest.interest),
    aiConsentAccepted: user.aiConsentAccepted,
    aiConsentVersion: user.aiConsentVersion,
    createdAt: user.createdAt.toISOString(),
    updatedAt: user.updatedAt.toISOString(),
  };
}

function validationError(reply: { status: (code: number) => { send: (body: unknown) => unknown } }, error: z.ZodError) {
  return reply.status(400).send({
    error: {
      code: 'VALIDATION_ERROR',
      message: 'Request validation failed.',
      details: error.flatten(),
    },
  });
}
