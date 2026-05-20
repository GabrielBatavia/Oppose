import '../backend_api_client.dart';
import '../user/user_dto_mapper.dart';
import '../../types/domain_models.dart';
import 'auth_repository.dart';

class BackendAuthRepository implements AuthRepository {
  const BackendAuthRepository({required this.client});

  final BackendApiClient client;

  @override
  Future<OpposeUser?> loadCurrentUser() async {
    final json = await client.get('/me', requiresDevAuth: true);
    return opposeUserFromJson(json);
  }

  @override
  Future<OpposeUser> signUp({
    required String emailOrPhone,
    required String password,
  }) async {
    final user = await loadCurrentUser();
    if (user == null) throw StateError('Development user is unavailable.');
    return user;
  }

  @override
  Future<OpposeUser> logIn({
    required String emailOrPhone,
    required String password,
  }) async {
    final user = await loadCurrentUser();
    if (user == null) throw StateError('Development user is unavailable.');
    return user;
  }

  @override
  Future<void> signOut() async {}
}
