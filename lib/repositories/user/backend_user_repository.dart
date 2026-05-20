import '../backend_api_client.dart';
import '../../types/domain_models.dart';
import 'user_dto_mapper.dart';
import 'user_repository.dart';

class BackendUserRepository implements UserRepository {
  const BackendUserRepository({required this.client});

  final BackendApiClient client;

  @override
  Future<OpposeUser> getCurrentUser() async {
    final json = await client.get('/me', requiresDevAuth: true);
    return opposeUserFromJson(json);
  }

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    final normalized = Uri.encodeQueryComponent(username.trim().toLowerCase());
    final json = await client.get('/users/check-username?username=$normalized');
    return json['available'] as bool;
  }

  @override
  Future<OpposeUser> updateProfile({
    String? displayName,
    String? username,
    String? avatarAsset,
    String? language,
  }) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['displayName'] = displayName;
    if (username != null) body['username'] = username;
    if (avatarAsset != null) body['avatarUrl'] = avatarAsset;
    if (language != null) body['language'] = language;
    final json = await client.patch(
      '/me/profile',
      body: body,
      requiresDevAuth: true,
    );
    return opposeUserFromJson(json);
  }

  @override
  Future<OpposeUser> updateInterests(List<String> interests) async {
    final json = await client.patch(
      '/me/interests',
      body: {'interests': interests},
      requiresDevAuth: true,
    );
    return opposeUserFromJson(json);
  }

  @override
  Future<void> acceptAIConsent({required String version}) async {
    await client.post(
      '/me/ai-consent',
      body: {'accepted': true, 'version': version},
      requiresDevAuth: true,
    );
  }
}
