import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/oppose_bottom_sheet.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/room_setup/room_setup_controller.dart';
import '../../state/room_setup/room_setup_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import 'widgets/audio_route_selector.dart';
import 'widgets/lobby_ai_status_card.dart';
import 'widgets/lobby_friend_preview.dart';
import 'widgets/lobby_sheets.dart';
import 'widgets/mic_test_card.dart';
import 'widgets/room_rule_card.dart';

class RoomLobbyScreen extends StatefulWidget {
  const RoomLobbyScreen({super.key});

  @override
  State<RoomLobbyScreen> createState() => _RoomLobbyScreenState();
}

class _RoomLobbyScreenState extends State<RoomLobbyScreen> {
  bool _viewTracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_viewTracked) {
      _viewTracked = true;
      RoomSetupScope.read(context).trackLobbyViewedOnce();
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = RoomSetupScope.watch(context);

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        OpposeHeader(
          title: setup.roomTitle,
          subtitle: 'Before you join, check friends, mic, and AI status.',
          trailing: const StatusPill(
            label: 'Before you join',
            icon: Icons.checklist_rounded,
            color: OpposeColors.indigo,
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          color: OpposeColors.sunflower.withValues(alpha: 0.14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Topic', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: OpposeSpacing.sm),
              Text(
                setup.effectiveTopic,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: OpposeSpacing.md),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusPill(
                    label: setup.selectedRoomType.label,
                    icon: Icons.style_rounded,
                    color: OpposeColors.maroon,
                  ),
                  StatusPill(
                    label: setup.summaryLabel,
                    icon: Icons.summarize_rounded,
                    color: OpposeColors.indigo,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        LobbyFriendPreview(
          friends: setup.invitedFriends,
          onInviteMore: () {
            setup.trackInviteClicked();
            showOpposeBottomSheet(
              context: context,
              child: InviteFriendsSheet(setup: setup),
            );
          },
        ),
        const SizedBox(height: OpposeSpacing.md),
        MicTestCard(
          micState: setup.micState,
          onToggleMicState: setup.toggleMicState,
        ),
        const SizedBox(height: OpposeSpacing.md),
        AudioRouteSelector(
          value: setup.audioRoute,
          onChanged: setup.selectAudioRoute,
        ),
        const SizedBox(height: OpposeSpacing.md),
        LobbyAIStatusCard(
          mode: setup.selectedAIMode,
          summarySetting: setup.selectedSummarySetting,
          onChangeSettings: () => showOpposeBottomSheet(
            context: context,
            child: LobbyAISettingsSheet(setup: setup),
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        const RoomRuleCard(),
        if (setup.micState == MicState.permissionDenied) ...[
          const SizedBox(height: OpposeSpacing.md),
          const StatusPill(
            label: 'You can join, but mic may not work yet.',
            icon: Icons.warning_amber_rounded,
            color: OpposeColors.danger,
          ),
        ],
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'Join room',
          onPressed: () {
            setup.joinRoom();
            context.go(AppRoutes.liveRoom);
          },
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'Invite friends',
          onPressed: () {
            setup.trackInviteClicked();
            showOpposeBottomSheet(
              context: context,
              child: InviteFriendsSheet(setup: setup),
            );
          },
        ),
      ],
    );
  }
}
