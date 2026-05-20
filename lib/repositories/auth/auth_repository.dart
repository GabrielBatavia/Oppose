import '../../types/domain_models.dart';

abstract class AuthRepository {
  Future<OpposeUser?> loadCurrentUser();

  Future<OpposeUser> signUp({
    required String emailOrPhone,
    required String password,
  });

  Future<OpposeUser> logIn({
    required String emailOrPhone,
    required String password,
  });

  Future<void> signOut();
}
