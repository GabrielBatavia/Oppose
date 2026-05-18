import 'package:flutter/material.dart';

import '../../../assets/oppose_assets.dart';
import '../../../components/core/avatar.dart';
import '../../../components/core/paper_card.dart';
import '../../../types/domain_models.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';
import 'unread_badge.dart';

class RecentChatPreviewCard extends StatelessWidget {
  const RecentChatPreviewCard({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            OpposeAvatar(
              label: conversation.title,
              imageAsset: _avatarAsset(conversation),
            ),
            const SizedBox(width: OpposeSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        conversation.updatedLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: OpposeSpacing.xs),
                  Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (conversation.type == ConversationType.room) ...[
                    const SizedBox(height: OpposeSpacing.xs),
                    Text(
                      'Room chat',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: OpposeColors.indigo,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: OpposeSpacing.sm),
            UnreadBadge(count: conversation.unreadCount),
          ],
        ),
      ),
    );
  }

  String? _avatarAsset(Conversation conversation) => switch (conversation.id) {
    'maya_direct' => OpposeAssets.avatarMaya,
    'study_room' => OpposeAssets.avatarStudyRoom,
    'weekend_debate' => OpposeAssets.avatarWeekendDebate,
    _ => null,
  };
}
