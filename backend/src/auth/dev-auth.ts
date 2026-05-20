import type { FastifyReply, FastifyRequest } from 'fastify';
import { z } from 'zod';

import { prisma } from '../db/prisma.js';

const userIdSchema = z.string().uuid();

export async function requireDevUser(
  request: FastifyRequest,
  reply: FastifyReply,
) {
  const rawHeader = request.headers['x-dev-user-id'];
  const rawUserId = Array.isArray(rawHeader) ? rawHeader[0] : rawHeader;
  const parsed = userIdSchema.safeParse(rawUserId);

  if (!parsed.success) {
    return reply.status(401).send({
      error: {
        code: 'DEV_AUTH_REQUIRED',
        message:
          'Development auth required. Send x-dev-user-id with a seeded user UUID.',
      },
    });
  }

  const user = await prisma.user.findUnique({
    where: { id: parsed.data },
    select: { id: true },
  });

  if (user == null) {
    return reply.status(401).send({
      error: {
        code: 'DEV_USER_NOT_FOUND',
        message: 'No development user exists for x-dev-user-id.',
      },
    });
  }

  request.currentUserId = user.id;
}
