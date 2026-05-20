import cors from '@fastify/cors';
import helmet from '@fastify/helmet';
import Fastify from 'fastify';

import { config } from './config.js';
import { disconnectPrisma } from './db/prisma.js';
import { registerUserRoutes } from './routes/users.js';

export function buildServer() {
  const server = Fastify({
    logger: {
      level: config.LOG_LEVEL,
    },
  });

  server.register(helmet);
  server.register(cors, {
    origin: config.CORS_ORIGIN === '*' ? true : config.CORS_ORIGIN,
  });

  server.get('/health', async () => {
    return {
      ok: true,
      service: 'oppose-backend',
      environment: config.NODE_ENV,
      timestamp: new Date().toISOString(),
    };
  });

  server.get('/version', async () => {
    return {
      name: 'oppose-backend',
      version: '0.1.0',
      sprint: 13,
    };
  });

  server.register(registerUserRoutes);

  server.addHook('onClose', async () => {
    await disconnectPrisma();
  });

  return server;
}
