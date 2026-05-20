import 'package:flutter/material.dart';

import '../../../components/buttons/oppose_buttons.dart';
import '../../../state/room_setup/room_setup_controller.dart';
import '../../../state/safety/safety_scope.dart';
import '../../../state/social/social_scope.dart';
import '../../../theme/oppose_spacing.dart';
import 'invite_friend_selector.dart';

class RoomInviteSheet extends StatelessWidget {
  const RoomInviteSheet({super.key, required this.setup});

  final RoomSetupController setup;

  @override
  Widget build(BuildContext context) {
    final social = SocialScope.watch(context);
    final safety = SafetyScope.watch(context);
    final blockedInvited = safety.blockedUserIds.intersection(
      setup.invitedFriendIds,
    );
    if (blockedInvited.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setup.removeInvitedFriends(blockedInvited);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Invite to live room',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OpposeSpacing.sm),
        const Text('Invites are local demo state for now.'),
        const SizedBox(height: OpposeSpacing.lg),
        InviteFriendSelector(
          friends: social.friends,
          selectedFriendIds: setup.invitedFriendIds,
          onToggleFriend: setup.toggleFriend,
          disabledFriendIds: safety.blockedUserIds,
          onAddMore: () {},
        ),
        const SizedBox(height: OpposeSpacing.lg),
        PrimaryButton(
          label: 'Done',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
