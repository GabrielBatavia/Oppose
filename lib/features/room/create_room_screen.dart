import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/selectable.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../theme/oppose_spacing.dart';
import '../shared/feature_stub_screen.dart';

class CreateRoomScreen extends StatelessWidget {
  const CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureStubScreen(
      title: 'Create a room',
      subtitle: 'Set topic, invite friends, and choose AI boundaries.',
      sprintLabel: 'Sprint 5 target',
      showBottomNavigation: true,
      hero: const StickerImage(asset: OpposeAssets.bimaCreateRoom, size: 110),
      bullets: const [
        'Room topic input and room type cards.',
        'Invite friend row using real avatar components.',
        'Explicit AI mode and summary privacy selectors.',
      ],
      actions: [
        const OpposeTextInput(
          label: 'Room topic',
          hintText: 'Is remote work good for the future?',
        ),
        SelectableCard(
          title: 'Daily Debate',
          subtitle: 'A focused room around today\'s question.',
          selected: true,
          icon: Icons.wb_sunny_rounded,
          onTap: () {},
        ),
        Row(
          children: [
            for (final friend in MockOpposeData.friends.take(3)) ...[
              OpposeAvatar(label: friend.displayName),
              const SizedBox(width: OpposeSpacing.sm),
            ],
          ],
        ),
        SelectableCard(
          title: 'AI Quiet Helper',
          subtitle: 'Responds only when asked.',
          selected: true,
          icon: Icons.smart_toy_rounded,
          onTap: () {},
        ),
        SelectableCard(
          title: 'Private summary',
          subtitle: 'Only you can see this summary unless you share it.',
          selected: true,
          icon: Icons.lock_outline_rounded,
          onTap: () {},
        ),
        PrimaryButton(
          label: 'Start room',
          onPressed: () => context.go(AppRoutes.roomLobby),
        ),
      ],
    );
  }
}
