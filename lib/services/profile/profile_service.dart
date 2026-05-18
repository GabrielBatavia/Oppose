import '../../types/domain_models.dart';

abstract class ProfileService {
  Future<OpposeUser> updateProfile(OpposeUser profile);

  Future<bool> checkUsername(String username);

  Future<List<String>> updateInterests(List<String> interests);

  Future<OpposeUser> getProfile(String userId);
}
