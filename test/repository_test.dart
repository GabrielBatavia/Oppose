import 'package:flutter_test/flutter_test.dart';
import 'package:oppose/repositories/auth/mock_auth_repository.dart';
import 'package:oppose/repositories/user/mock_user_repository.dart';

void main() {
  test('mock auth repository keeps the local current user session', () async {
    final repository = MockAuthRepository();

    expect((await repository.loadCurrentUser())?.username, 'thinkwithbima');

    await repository.signOut();
    expect(await repository.loadCurrentUser(), isNull);

    final user = await repository.logIn(
      emailOrPhone: 'friend@example.com',
      password: 'password',
    );
    expect(user.displayName, "Bima's Friend");
  });

  test('mock user repository updates profile and interests locally', () async {
    final repository = MockUserRepository();

    expect(await repository.checkUsernameAvailability('mayaTalks'), isFalse);
    expect(await repository.checkUsernameAvailability('thinkwithbima'), isTrue);

    final profile = await repository.updateProfile(
      displayName: 'Friendly Bima',
      username: 'friendly_bima',
    );
    expect(profile.displayName, 'Friendly Bima');
    expect(profile.username, 'friendly_bima');

    final updated = await repository.updateInterests(['Music', 'Culture']);
    expect(updated.interests, ['Music', 'Culture']);

    await repository.acceptAIConsent(version: '2026-05-19-dev');
    expect(repository.aiConsentAccepted, isTrue);
    expect(repository.aiConsentVersion, '2026-05-19-dev');
  });
}
