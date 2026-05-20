import '../../state/mock_data/mock_oppose_data.dart';
import '../../types/domain_models.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({OpposeUser? initialUser})
    : _currentUser = initialUser ?? MockOpposeData.currentUser;

  OpposeUser? _currentUser;

  @override
  Future<OpposeUser?> loadCurrentUser() async => _currentUser;

  @override
  Future<OpposeUser> signUp({
    required String emailOrPhone,
    required String password,
  }) async {
    _currentUser = MockOpposeData.currentUser;
    return _currentUser!;
  }

  @override
  Future<OpposeUser> logIn({
    required String emailOrPhone,
    required String password,
  }) async {
    _currentUser = MockOpposeData.currentUser;
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
