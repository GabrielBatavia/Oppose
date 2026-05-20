import 'dotenv/config';

import { z } from 'zod';

const configSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  HOST: z.string().default('0.0.0.0'),
  PORT: z.coerce.number().int().positive().default(4000),
  LOG_LEVEL: z.string().default('info'),
  DATABASE_URL: z.string().min(1).optional(),
  CORS_ORIGIN: z.string().default('*'),
});

export const config = configSchema.parse(process.env);
