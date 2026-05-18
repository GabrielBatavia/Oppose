import 'package:flutter/material.dart';

import '../../../assets/oppose_assets.dart';
import '../../../components/buttons/oppose_buttons.dart';
import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../components/stickers/sticker_image.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';

class AIMessageCard extends StatelessWidget {
  const AIMessageCard({
    super.key,
    required this.onAskAI,
    required this.onStartRoom,
  });

  final VoidCallback onAskAI;
  final VoidCallback onStartRoom;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.indigo.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StickerImage(asset: OpposeAssets.aiDrawerRobot, size: 58),
              const SizedBox(width: OpposeSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Helper',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: OpposeSpacing.xs),
                    const Text(
                      'AI responds only when asked. It is not listening in this chat.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.md),
          const AIStatusPill(status: AIStatusValue.notListening),
          const SizedBox(height: OpposeSpacing.md),
          const Text('AI can suggest a balanced question when you ask.'),
          const SizedBox(height: OpposeSpacing.md),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(label: 'Ask AI', onPressed: onAskAI),
              ),
              const SizedBox(width: OpposeSpacing.md),
              Expanded(
                child: SecondaryButton(
                  label: 'Start room',
                  onPressed: onStartRoom,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
