import 'package:flutter/material.dart';

import '../../../assets/oppose_assets.dart';
import '../../../components/core/avatar.dart';
import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../features/home/widgets/unread_badge.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';
import 'conversation_type_pill.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.conversation,
    required this.onTap,
    this.isBlocked = false,
  });

  final Conversation conversation;
  final VoidCallback onTap;
  final bool isBlocked;

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
              size: 56,
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
                          overflow: TextOverflow.ellipsis,
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
                  const SizedBox(height: OpposeSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ConversationTypePill(type: conversation.type),
                      if (isBlocked)
                        const StatusPill(
                          label: 'Blocked',
                          icon: Icons.block_rounded,
                          color: OpposeColors.maroon,
                        ),
                    ],
                  ),
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
