import 'package:flutter/material.dart';

import '../../../components/core/avatar.dart';
import '../../../components/core/empty_state.dart';
import '../../../types/domain_models.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';

class LiveFriendsRow extends StatelessWidget {
  const LiveFriendsRow({super.key, required this.friends});

  final List<Friend> friends;

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return const EmptyState(
        title: 'No friends live yet',
        message: 'Start a room and invite someone into the conversation.',
        icon: Icons.people_outline_rounded,
      );
    }

    return SizedBox(
      height: 126,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: friends.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: OpposeSpacing.md),
        itemBuilder: (context, index) {
          final friend = friends[index];
          return _LiveFriendAvatar(friend: friend);
        },
      ),
    );
  }
}

class _LiveFriendAvatar extends StatelessWidget {
  const _LiveFriendAvatar({required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    final isInRoom = friend.status == FriendStatus.inRoom;
    return Container(
      width: 92,
      padding: const EdgeInsets.all(OpposeSpacing.sm),
      decoration: BoxDecoration(
        color: OpposeColors.paper,
        borderRadius: BorderRadius.circular(OpposeRadius.lg),
        border: Border.all(color: OpposeColors.warmBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OpposeAvatar(
            label: friend.displayName,
            imageAsset: friend.avatarAsset,
            isSpeaking: isInRoom,
          ),
          const SizedBox(height: OpposeSpacing.sm),
          Text(
            friend.displayName,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: OpposeSpacing.xs),
          Text(
            _statusLabel(friend.status),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isInRoom ? OpposeColors.maroon : OpposeColors.mutedGray,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(FriendStatus status) => switch (status) {
    FriendStatus.online => 'Online',
    FriendStatus.offline => 'Offline',
    FriendStatus.inRoom => 'In room',
    FriendStatus.typing => 'Typing',
  };
}
