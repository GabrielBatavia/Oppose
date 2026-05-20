import '../../state/mock_data/mock_oppose_data.dart';
import '../../types/domain_models.dart';
import 'user_repository.dart';

class MockUserRepository implements UserRepository {
  MockUserRepository({OpposeUser? initialUser})
    : _currentUser = initialUser ?? MockOpposeData.currentUser;

  OpposeUser _currentUser;
  bool _aiConsentAccepted = MockOpposeData.aiState.consentAccepted;
  String? _aiConsentVersion;

  bool get aiConsentAccepted => _aiConsentAccepted;
  String? get aiConsentVersion => _aiConsentVersion;

  @override
  Future<OpposeUser> getCurrentUser() async => _currentUser;

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    final normalized = username.trim().toLowerCase();
    if (normalized == _currentUser.username.toLowerCase()) return true;
    return !MockOpposeData.friends.any(
      (friend) => friend.username.toLowerCase() == normalized,
    );
  }

  @override
  Future<OpposeUser> updateProfile({
    String? displayName,
    String? username,
    String? avatarAsset,
    String? language,
  }) async {
    _currentUser = OpposeUser(
      id: _currentUser.id,
      username: username ?? _currentUser.username,
      displayName: displayName ?? _currentUser.displayName,
      avatarAsset: avatarAsset ?? _currentUser.avatarAsset,
      language: language ?? _currentUser.language,
      interests: _currentUser.interests,
    );
    return _currentUser;
  }

  @override
  Future<OpposeUser> updateInterests(List<String> interests) async {
    _currentUser = OpposeUser(
      id: _currentUser.id,
      username: _currentUser.username,
      displayName: _currentUser.displayName,
      avatarAsset: _currentUser.avatarAsset,
      language: _currentUser.language,
      interests: List.unmodifiable(interests),
    );
    return _currentUser;
  }

  @override
  Future<void> acceptAIConsent({required String version}) async {
    _aiConsentAccepted = true;
    _aiConsentVersion = version;
  }
}
