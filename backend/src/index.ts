import { config } from './config.js';
import { buildServer } from './server.js';

const server = buildServer();

try {
  await server.listen({ host: config.HOST, port: config.PORT });
} catch (error) {
  server.log.error(error);
  process.exit(1);
}
