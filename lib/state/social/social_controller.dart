import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../repositories/user/user_repository.dart';
import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';
import '../mock_data/mock_oppose_data.dart';

class SocialController extends ChangeNotifier {
  SocialController({required this.analytics, required this.userRepository})
    : _friends = List.of(MockOpposeData.friends),
      _friendRequests = List.of(MockOpposeData.friendRequests),
      currentUser = MockOpposeData.currentUser,
      displayName = MockOpposeData.currentUser.displayName,
      tagline = 'Different take, better talk.';

  final AnalyticsService analytics;
  final UserRepository userRepository;

  final List<Friend> _friends;
  final List<FriendRequest> _friendRequests;
  final Set<String> invitedFriendIds = <String>{};

  OpposeUser currentUser;
  String displayName;
  String tagline;
  String friendSearchQuery = '';
  String? actionMessage;
  bool isLoadingProfile = false;
  bool isSavingProfile = false;

  List<Friend> get friends => List.unmodifiable(_friends);

  List<FriendRequest> get pendingRequests => _friendRequests
      .where((request) => request.status == FriendRequestStatus.pending)
      .toList(growable: false);

  List<Friend> get filteredFriends {
    final query = friendSearchQuery.trim().toLowerCase();
    if (query.isEmpty) return friends;

    return _friends
        .where((friend) {
          final searchable = [
            friend.displayName,
            friend.username,
            friend.status.name,
          ].join(' ').toLowerCase();
          return searchable.contains(query);
        })
        .toList(growable: false);
  }

  void setFriendSearchQuery(String value) {
    friendSearchQuery = value;
    notifyListeners();
  }

  void setCurrentUser(OpposeUser user) {
    currentUser = user;
    displayName = user.displayName;
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    isLoadingProfile = true;
    notifyListeners();
    try {
      setCurrentUser(await userRepository.getCurrentUser());
    } catch (_) {
      actionMessage = 'Profile is using local demo data.';
    } finally {
      isLoadingProfile = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String newTagline,
  }) async {
    final trimmedName = name.trim();
    final trimmedTagline = newTagline.trim();
    if (trimmedName.isEmpty) return false;

    isSavingProfile = true;
    notifyListeners();
    try {
      final updated = await userRepository.updateProfile(
        displayName: trimmedName,
      );
      currentUser = updated;
      displayName = updated.displayName;
    } catch (_) {
      actionMessage = 'Could not save profile. Try again.';
      isSavingProfile = false;
      notifyListeners();
      return false;
    }

    if (trimmedTagline.isNotEmpty) tagline = trimmedTagline;
    actionMessage = 'Profile updated locally.';
    unawaited(analytics.track('profile_updated_mock', {'source': 'profile'}));
    isSavingProfile = false;
    notifyListeners();
    return true;
  }

  void inviteFriend(String friendId) {
    invitedFriendIds.add(friendId);
    final friend = friendById(friendId);
    actionMessage = friend == null
        ? 'Invite marked locally.'
        : '${friend.displayName} marked for the next room invite.';
    unawaited(
      analytics.track('social_friend_invited_mock', {'friend_id': friendId}),
    );
    notifyListeners();
  }

  void acceptRequest(String requestId) {
    final request = _friendRequests.firstWhere(
      (request) => request.id == requestId,
    );
    _friendRequests.removeWhere((request) => request.id == requestId);
    _friends.add(
      Friend(
        id: request.id,
        displayName: request.displayName,
        username: request.username,
        status: FriendStatus.online,
        avatarAsset: request.avatarAsset,
      ),
    );
    actionMessage = '${request.displayName} is now your friend.';
    unawaited(
      analytics.track('friend_request_accepted_mock', {'friend_id': requestId}),
    );
    notifyListeners();
  }

  void declineRequest(String requestId) {
    final request = _friendRequests.firstWhere(
      (request) => request.id == requestId,
    );
    _friendRequests.removeWhere((request) => request.id == requestId);
    actionMessage = '${request.displayName} request declined.';
    unawaited(
      analytics.track('friend_request_declined_mock', {'friend_id': requestId}),
    );
    notifyListeners();
  }

  Friend? friendById(String friendId) {
    for (final friend in _friends) {
      if (friend.id == friendId) return friend;
    }
    return null;
  }
}

extension FriendStatusPresentation on FriendStatus {
  String get label => switch (this) {
    FriendStatus.online => 'Online',
    FriendStatus.offline => 'Offline',
    FriendStatus.inRoom => 'In room',
    FriendStatus.typing => 'Typing',
  };
}
