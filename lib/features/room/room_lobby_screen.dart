import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';

class RoomLobbyScreen extends StatelessWidget {
  const RoomLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        const OpposeHeader(
          title: 'Daily Debate Room',
          subtitle: 'Before you join, check mic and AI status.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3 friends are here',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: OpposeSpacing.md),
              AvatarGroup(
                labels: MockOpposeData.friends
                    .map((friend) => friend.displayName)
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        const PaperCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.mic_rounded),
            title: Text('Mic ready'),
            subtitle: Text('Audio route: Phone speaker'),
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        const PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AIStatusPill(status: AIStatusValue.notListening),
              SizedBox(height: OpposeSpacing.sm),
              Text('AI Quiet Helper is in the room but not listening yet.'),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        const PaperCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.handshake_rounded),
            title: Text('Room rule'),
            subtitle: Text('Challenge ideas, not people.'),
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'Join room',
          onPressed: () => context.go(AppRoutes.liveRoom),
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(label: 'Invite friends', onPressed: () {}),
      ],
    );
  }
}
