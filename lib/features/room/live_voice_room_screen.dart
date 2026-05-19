import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../components/core/oppose_bottom_sheet.dart';
import '../../components/core/status_pill.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/ai_interaction/ai_interaction_scope.dart';
import '../../state/live_room/live_room_scope.dart';
import '../../state/room_setup/room_setup_controller.dart';
import '../../state/room_setup/room_setup_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';
import '../ai/ai_control_drawer.dart';
import 'widgets/connection_status_pill.dart';
import 'widgets/leave_room_sheet.dart';
import 'widgets/mock_room_state_card.dart';
import 'widgets/room_chat_sheet.dart';
import 'widgets/room_control_bar.dart';
import 'widgets/room_invite_sheet.dart';
import 'widgets/room_participant_card.dart';
import 'widgets/room_privacy_pill.dart';
import 'widgets/room_topic_card.dart';

class LiveVoiceRoomScreen extends StatefulWidget {
  const LiveVoiceRoomScreen({super.key});

  @override
  State<LiveVoiceRoomScreen> createState() => _LiveVoiceRoomScreenState();
}

class _LiveVoiceRoomScreenState extends State<LiveVoiceRoomScreen> {
  bool _enteredTracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_enteredTracked) {
      _enteredTracked = true;
      final setup = RoomSetupScope.read(context);
      final ai = AIInteractionScope.read(context);
      final aiMode = setup.selectedAIMode;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ai.syncWithRoomMode(aiMode);
      });
      LiveRoomScope.read(context).trackEnteredOnce(setup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = RoomSetupScope.watch(context);
    final liveRoom = LiveRoomScope.watch(context);
    final ai = AIInteractionScope.watch(context);
    final participants = liveRoom.participantsFor(setup, aiStatus: ai.status);
    final aiActive = setup.selectedAIMode != AIMode.off && !ai.isOff;

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        OpposeHeader(
          title: setup.roomTitle,
          subtitle: 'Friends only room with transparent AI controls.',
          trailing: AIStatusPill(
            status: aiActive ? ai.status : AIStatusValue.off,
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const RoomPrivacyPill(),
            ConnectionStatusPill(state: liveRoom.connectionState),
            StatusPill(
              label: setup.selectedAIMode.roomLabel,
              icon: aiActive
                  ? Icons.smart_toy_rounded
                  : Icons.power_settings_new_rounded,
              color: aiActive ? OpposeColors.indigo : OpposeColors.mutedGray,
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: OpposeSpacing.md,
          mainAxisSpacing: OpposeSpacing.md,
          childAspectRatio: 0.82,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final participant in participants)
              RoomParticipantCard(
                participant: participant,
                onTap: () => liveRoom.setActiveSpeaker(participant.id),
              ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        RoomTopicCard(
          topic: setup.effectiveTopic,
          roomTypeLabel: setup.selectedRoomType.label,
        ),
        const SizedBox(height: OpposeSpacing.xl),
        MockRoomStateCard(
          connectionState: liveRoom.connectionState,
          onSelectConnectionState: liveRoom.setConnectionState,
        ),
        const SizedBox(height: OpposeSpacing.xl),
        RoomControlBar(
          isMuted: liveRoom.isMuted,
          aiMode: aiActive ? setup.selectedAIMode : AIMode.off,
          onMute: liveRoom.toggleMute,
          onChat: () {
            liveRoom.trackRoomChatOpened();
            showOpposeBottomSheet(
              context: context,
              child: const RoomChatSheet(),
            );
          },
          onAskAI: () {
            liveRoom.trackAIDrawerOpened();
            showOpposeBottomSheet(
              context: context,
              child: const AIControlDrawer(),
            );
          },
          onInvite: () {
            liveRoom.trackInviteClicked();
            showOpposeBottomSheet(
              context: context,
              child: RoomInviteSheet(setup: setup),
            );
          },
          onLeave: () {
            liveRoom.trackLeaveConfirmationViewed();
            showOpposeBottomSheet(
              context: context,
              child: LeaveRoomSheet(
                onLeave: () {
                  liveRoom.leaveRoom();
                  context.go(AppRoutes.roomSummary);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
