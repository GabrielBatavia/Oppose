import 'package:flutter/material.dart';

import '../../../components/buttons/oppose_buttons.dart';
import '../../../state/mock_data/mock_oppose_data.dart';
import '../../../state/room_setup/room_setup_controller.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';
import 'ai_mode_card.dart';
import 'invite_friend_selector.dart';

class InviteFriendsSheet extends StatelessWidget {
  const InviteFriendsSheet({super.key, required this.setup});

  final RoomSetupController setup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Invite friends', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: OpposeSpacing.sm),
        const Text('Toggle who should see this mock invite.'),
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

class LobbyAISettingsSheet extends StatelessWidget {
  const LobbyAISettingsSheet({super.key, required this.setup});

  final RoomSetupController setup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('AI settings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: OpposeSpacing.sm),
        const Text('AI is not listening yet. Choose the mode before joining.'),
        const SizedBox(height: OpposeSpacing.lg),
        for (final mode in const [
          AIMode.off,
          AIMode.quietHelper,
          AIMode.brainstormer,
          AIMode.moderatorLite,
        ]) ...[
          AIModeCard(
            mode: mode,
            selected: setup.selectedAIMode == mode,
            onTap: () => setup.selectAIMode(mode, source: 'lobby'),
          ),
          const SizedBox(height: OpposeSpacing.md),
        ],
        PrimaryButton(
          label: 'Save AI settings',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
