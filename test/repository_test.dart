import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:oppose/repositories/backend_api_client.dart';
import 'package:oppose/repositories/auth/mock_auth_repository.dart';
import 'package:oppose/repositories/user/backend_user_repository.dart';
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

  test('backend user repository maps profile endpoints', () async {
    final requests = <BackendApiRequest>[];
    final repository = BackendUserRepository(
      client: BackendApiClient(
        baseUrl: 'http://api.test/',
        devUserId: '00000000-0000-4000-8000-000000000001',
        transport: (request) async {
          requests.add(request);
          if (request.uri.path == '/users/check-username') {
            return BackendApiResponse(
              statusCode: 200,
              body: jsonEncode({'username': 'fresh_name', 'available': true}),
            );
          }
          return BackendApiResponse(
            statusCode: 200,
            body: jsonEncode(_userDto),
          );
        },
      ),
    );

    final current = await repository.getCurrentUser();
    expect(current.username, 'thinkwithbima');
    expect(requests.last.headers['x-dev-user-id'], isNotEmpty);

    expect(await repository.checkUsernameAvailability('fresh_name'), isTrue);
    expect(requests.last.uri.queryParameters['username'], 'fresh_name');

    await repository.updateProfile(displayName: 'Friendly Bima');
    expect(requests.last.method, 'PATCH');
    expect(requests.last.uri.path, '/me/profile');
    expect(requests.last.body, {'displayName': 'Friendly Bima'});

    await repository.updateInterests(['Music']);
    expect(requests.last.uri.path, '/me/interests');
    expect(requests.last.body, {
      'interests': ['Music'],
    });

    await repository.acceptAIConsent(version: '2026-05-20-dev');
    expect(requests.last.uri.path, '/me/ai-consent');
    expect(requests.last.body, {'accepted': true, 'version': '2026-05-20-dev'});
  });

  test('backend api client throws structured errors', () async {
    final client = BackendApiClient(
      transport: (_) async => BackendApiResponse(
        statusCode: 409,
        body: jsonEncode({
          'error': {
            'code': 'USERNAME_TAKEN',
            'message': 'That username is already taken.',
          },
        }),
      ),
    );

    expect(
      () => client.patch('/me/profile', body: {'username': 'taken'}),
      throwsA(
        isA<BackendApiException>()
            .having((error) => error.statusCode, 'statusCode', 409)
            .having((error) => error.code, 'code', 'USERNAME_TAKEN'),
      ),
    );
  });
}

const _userDto = <String, Object?>{
  'id': '00000000-0000-4000-8000-000000000001',
  'username': 'thinkwithbima',
  'displayName': "Bima's Friend",
  'avatarUrl': null,
  'language': 'en',
  'interests': ['Technology', 'Friendship', 'Food'],
  'aiConsentAccepted': true,
  'aiConsentVersion': '2026-05-20-dev',
  'createdAt': '2026-05-20T00:00:00.000Z',
  'updatedAt': '2026-05-20T00:00:00.000Z',
};
