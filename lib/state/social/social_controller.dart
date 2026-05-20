import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';
import '../mock_data/mock_oppose_data.dart';

class SocialController extends ChangeNotifier {
  SocialController({required this.analytics})
    : _friends = List.of(MockOpposeData.friends),
      _friendRequests = List.of(MockOpposeData.friendRequests),
      displayName = MockOpposeData.currentUser.displayName,
      tagline = 'Different take, better talk.';

  final AnalyticsService analytics;

  final List<Friend> _friends;
  final List<FriendRequest> _friendRequests;
  final Set<String> invitedFriendIds = <String>{};

  String displayName;
  String tagline;
  String friendSearchQuery = '';
  String? actionMessage;

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

  void updateProfile({required String name, required String newTagline}) {
    final trimmedName = name.trim();
    final trimmedTagline = newTagline.trim();
    if (trimmedName.isNotEmpty) displayName = trimmedName;
    if (trimmedTagline.isNotEmpty) tagline = trimmedTagline;
    actionMessage = 'Profile updated locally.';
    unawaited(analytics.track('profile_updated_mock', {'source': 'profile'}));
    notifyListeners();
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
