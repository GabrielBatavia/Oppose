import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const devUserId = '00000000-0000-4000-8000-000000000001';

async function main() {
  const user = await prisma.user.upsert({
    where: { id: devUserId },
    update: {
      username: 'thinkwithbima',
      displayName: "Bima's Friend",
      language: 'en',
      aiConsentAccepted: true,
      aiConsentVersion: '2026-05-19-dev',
    },
    create: {
      id: devUserId,
      authProviderId: 'dev:thinkwithbima',
      email: 'friend@example.com',
      username: 'thinkwithbima',
      displayName: "Bima's Friend",
      language: 'en',
      aiConsentAccepted: true,
      aiConsentVersion: '2026-05-19-dev',
    },
  });

  await prisma.userInterest.deleteMany({ where: { userId: user.id } });
  await prisma.userInterest.createMany({
    data: ['Technology', 'Friendship', 'Food'].map((interest) => ({
      userId: user.id,
      interest,
    })),
  });

  console.log(`Seeded Oppose dev user: ${user.id}`);
  console.log('Use header: x-dev-user-id: 00000000-0000-4000-8000-000000000001');
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
