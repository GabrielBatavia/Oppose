import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/oppose_bottom_sheet.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';
import '../ai/ai_control_drawer.dart';

class LiveVoiceRoomScreen extends StatefulWidget {
  const LiveVoiceRoomScreen({super.key});

  @override
  State<LiveVoiceRoomScreen> createState() => _LiveVoiceRoomScreenState();
}

class _LiveVoiceRoomScreenState extends State<LiveVoiceRoomScreen> {
  bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    final room = MockOpposeData.room;

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        OpposeHeader(
          title: room.title,
          subtitle: 'Friends only room with transparent AI controls.',
          trailing: const AIStatusPill(status: AIStatusValue.listening),
        ),
        const SizedBox(height: OpposeSpacing.md),
        const StatusPill(
          label: 'Good connection',
          icon: Icons.wifi_rounded,
          color: OpposeColors.success,
        ),
        const SizedBox(height: OpposeSpacing.xl),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: OpposeSpacing.md,
          mainAxisSpacing: OpposeSpacing.md,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final participant in room.participants)
              PaperCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OpposeAvatar(
                      label: participant.displayName,
                      isAI: participant.isAI,
                      isSpeaking: participant.isSpeaking,
                    ),
                    const SizedBox(height: OpposeSpacing.md),
                    Text(
                      participant.displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(participant.role),
                    if (participant.isAI)
                      const StatusPill(
                        label: 'AI',
                        icon: Icons.smart_toy_rounded,
                      ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Topic', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: OpposeSpacing.sm),
              Text(room.topic),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: Icon(isMuted ? Icons.mic_off_rounded : Icons.mic_rounded),
              label: Text(isMuted ? 'Muted' : 'Mute'),
              onPressed: () => setState(() => isMuted = !isMuted),
            ),
            ActionChip(
              avatar: const Icon(Icons.chat_bubble_rounded),
              label: const Text('Chat'),
              onPressed: () {},
            ),
            ActionChip(
              avatar: const Icon(Icons.smart_toy_rounded),
              label: const Text('Ask AI'),
              onPressed: () => showOpposeBottomSheet(
                context: context,
                child: const AIControlDrawer(),
              ),
            ),
            ActionChip(
              avatar: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Invite'),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.lg),
        DangerButton(
          label: 'Leave room',
          onPressed: () => context.go(AppRoutes.roomSummary),
        ),
      ],
    );
  }
}
