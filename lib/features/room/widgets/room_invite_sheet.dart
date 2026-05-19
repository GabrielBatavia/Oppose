import 'package:flutter/material.dart';

import '../../../components/buttons/oppose_buttons.dart';
import '../../../state/mock_data/mock_oppose_data.dart';
import '../../../state/room_setup/room_setup_controller.dart';
import '../../../theme/oppose_spacing.dart';
import 'invite_friend_selector.dart';

class RoomInviteSheet extends StatelessWidget {
  const RoomInviteSheet({super.key, required this.setup});

  final RoomSetupController setup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Invite to live room',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OpposeSpacing.sm),
        const Text('Invites are local mock state for now.'),
        const SizedBox(height: OpposeSpacing.lg),
        InviteFriendSelector(
          friends: MockOpposeData.friends,
          selectedFriendIds: setup.invitedFriendIds,
          onToggleFriend: setup.toggleFriend,
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
