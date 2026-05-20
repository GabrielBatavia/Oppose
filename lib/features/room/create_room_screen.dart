import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/paper_card.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/room_setup/room_setup_controller.dart';
import '../../state/room_setup/room_setup_scope.dart';
import '../../state/safety/safety_scope.dart';
import '../../state/social/social_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';
import 'widgets/ai_mode_card.dart';
import 'widgets/create_room_section.dart';
import 'widgets/invite_friend_selector.dart';
import 'widgets/room_type_card.dart';
import 'widgets/summary_privacy_card.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  bool _viewTracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_viewTracked) {
      _viewTracked = true;
      RoomSetupScope.read(context).trackCreateViewedOnce();
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = RoomSetupScope.watch(context);
    final social = SocialScope.watch(context);
    final safety = SafetyScope.watch(context);
    final blockedInvited = safety.blockedUserIds.intersection(
      setup.invitedFriendIds,
    );
    if (blockedInvited.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setup.removeInvitedFriends(blockedInvited);
      });
    }
    final selectedCount = setup.invitedFriendIds
        .difference(safety.blockedUserIds)
        .length;

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        const OpposeHeader(
          title: 'Create a room',
          subtitle: 'Set topic, invite friends, and choose AI boundaries.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          color: OpposeColors.sunflower.withValues(alpha: 0.16),
          child: Row(
            children: [
              const StickerImage(asset: OpposeAssets.bimaCreateRoom, size: 104),
              const SizedBox(width: OpposeSpacing.md),
              Expanded(
                child: Text(
                  'Rooms are friend-first. AI stays quiet unless you ask.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        CreateRoomSection(
          title: 'Room topic',
          subtitle:
              'Optional. We will use a friendly default if you leave it blank.',
          child: OpposeTextInput(
            label: 'Room topic',
            hintText: setup.selectedRoomType.defaultTopic,
            prefixIcon: const Icon(Icons.chat_bubble_outline_rounded),
            textCapitalization: TextCapitalization.sentences,
            onChanged: setup.setTopic,
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        CreateRoomSection(
          title: 'Room type',
          child: Column(
            children: [
              for (final type in RoomSetupType.values) ...[
                RoomTypeCard(
                  type: type,
                  selected: setup.selectedRoomType == type,
                  onTap: () => setup.selectRoomType(type),
                ),
                const SizedBox(height: OpposeSpacing.md),
              ],
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        CreateRoomSection(
          title: 'Invite friends',
          subtitle: '$selectedCount selected',
          child: InviteFriendSelector(
            friends: social.friends,
            selectedFriendIds: setup.invitedFriendIds,
            onToggleFriend: setup.toggleFriend,
            disabledFriendIds: safety.blockedUserIds,
            onAddMore: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Friend picker is coming soon.')),
            ),
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        CreateRoomSection(
          title: 'AI mode',
          subtitle: 'AI mode must be explicit before a room starts.',
          child: Column(
            children: [
              for (final mode in const [
                AIMode.off,
                AIMode.quietHelper,
                AIMode.brainstormer,
                AIMode.moderatorLite,
              ]) ...[
                AIModeCard(
                  mode: mode,
                  selected: setup.selectedAIMode == mode,
                  onTap: () => setup.selectAIMode(mode),
                ),
                const SizedBox(height: OpposeSpacing.md),
              ],
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        CreateRoomSection(
          title: 'Summary privacy',
          subtitle: 'Summaries are optional and deletable.',
          child: Column(
            children: [
              for (final setting in SummarySetting.values) ...[
                SummaryPrivacyCard(
                  setting: setting,
                  selected: setup.selectedSummarySetting == setting,
                  onTap: () => setup.selectSummarySetting(setting),
                ),
                const SizedBox(height: OpposeSpacing.md),
              ],
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.lg),
        PrimaryButton(
          label: 'Start room',
          onPressed: () {
            setup.createRoom();
            context.go(AppRoutes.roomLobby);
          },
        ),
      ],
    );
  }
}
