import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockOpposeData.currentUser;

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        OpposeHeader(
          title: 'Hi, ${user.displayName}',
          subtitle: 'Ready for a different take today?',
          trailing: const StatusPill(
            label: 'Daily',
            icon: Icons.wb_sunny_rounded,
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          color: OpposeColors.sunflower.withValues(alpha: 0.22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const StickerImage(asset: OpposeAssets.bimaHome, size: 88),
                  const SizedBox(width: OpposeSpacing.md),
                  Expanded(
                    child: Text(
                      'Is remote work good for the future?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OpposeSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(label: 'Agree', onPressed: () {}),
                  ),
                  const SizedBox(width: OpposeSpacing.md),
                  Expanded(
                    child: SecondaryButton(label: 'Oppose', onPressed: () {}),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        Text('Live friends', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: OpposeSpacing.md),
        Row(
          children: [
            for (final friend in MockOpposeData.friends) ...[
              Column(
                children: [
                  OpposeAvatar(
                    label: friend.displayName,
                    isSpeaking: friend.status == FriendStatus.inRoom,
                  ),
                  const SizedBox(height: OpposeSpacing.xs),
                  Text(friend.displayName),
                ],
              ),
              const SizedBox(width: OpposeSpacing.md),
            ],
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        Text('Recent chats', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: OpposeSpacing.md),
        for (final conversation in MockOpposeData.conversations.take(2)) ...[
          PaperCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(conversation.title),
              subtitle: Text(conversation.lastMessage),
              trailing: conversation.unreadCount > 0
                  ? StatusPill(label: '${conversation.unreadCount}')
                  : Text(conversation.updatedLabel),
              onTap: () => context.go(AppRoutes.directChat),
            ),
          ),
          const SizedBox(height: OpposeSpacing.md),
        ],
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start a room',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: OpposeSpacing.sm),
              const Text(
                'Invite friends, choose AI mode, and keep the talk respectful.',
              ),
              const SizedBox(height: OpposeSpacing.lg),
              PrimaryButton(
                label: 'Create room',
                onPressed: () => context.go(AppRoutes.createRoom),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
