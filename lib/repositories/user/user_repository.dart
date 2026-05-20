import '../../types/domain_models.dart';

abstract class UserRepository {
  Future<OpposeUser> getCurrentUser();

  Future<bool> checkUsernameAvailability(String username);

  Future<OpposeUser> updateProfile({
    String? displayName,
    String? username,
    String? avatarAsset,
    String? language,
  });

  Future<OpposeUser> updateInterests(List<String> interests);

  Future<void> acceptAIConsent({required String version});
}
