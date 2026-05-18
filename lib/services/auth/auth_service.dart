import '../../types/domain_models.dart';

abstract class AuthService {
  Future<OpposeUser> signUp({
    required String emailOrPhone,
    required String password,
  });

  Future<OpposeUser> logIn({
    required String emailOrPhone,
    required String password,
  });

  Future<void> logOut();

  Future<OpposeUser?> getCurrentUser();
}
