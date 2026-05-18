import 'package:flutter/material.dart';

import '../../../assets/oppose_assets.dart';
import '../../../components/core/avatar.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';

class DirectChatHeader extends StatelessWidget {
  const DirectChatHeader({
    super.key,
    required this.conversation,
    required this.onBack,
    required this.onStartCall,
  });

  final Conversation conversation;
  final VoidCallback onBack;
  final VoidCallback onStartCall;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back to chats',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        OpposeAvatar(
          label: conversation.title,
          imageAsset: conversation.id == 'maya_direct'
              ? OpposeAssets.avatarMaya
              : null,
          size: 52,
        ),
        const SizedBox(width: OpposeSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversation.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: OpposeSpacing.xs),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: OpposeColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: OpposeSpacing.xs),
                  Text('Online', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Start room call',
          onPressed: onStartCall,
          icon: const Icon(Icons.call_rounded),
        ),
      ],
    );
  }
}
