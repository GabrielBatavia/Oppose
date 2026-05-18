import '../../types/domain_models.dart';

abstract class FriendService {
  Future<List<Friend>> getFriends();

  Future<List<Friend>> searchFriends(String query);

  Future<void> sendFriendRequest(String userId);

  Future<void> acceptFriendRequest(String requestId);

  Future<void> blockUser(String userId);
}
