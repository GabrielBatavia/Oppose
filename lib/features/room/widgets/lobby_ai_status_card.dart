import 'package:flutter/material.dart';

import '../../../assets/oppose_assets.dart';
import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../components/stickers/sticker_image.dart';
import '../../../state/room_setup/room_setup_controller.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';

class LobbyAIStatusCard extends StatelessWidget {
  const LobbyAIStatusCard({
    super.key,
    required this.mode,
    required this.summarySetting,
    required this.onChangeSettings,
  });

  final AIMode mode;
  final SummarySetting summarySetting;
  final VoidCallback onChangeSettings;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StickerImage(
                asset: OpposeAssets.lobbyAIQuietHelper,
                size: 54,
              ),
              const SizedBox(width: OpposeSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.roomLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: OpposeSpacing.xs),
                    const AIStatusPill(status: AIStatusValue.notListening),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.md),
          const Text(
            'AI is not listening before you join. You can change or turn it off anytime.',
          ),
          const SizedBox(height: OpposeSpacing.sm),
          Text('Summary: ${summarySetting.roomLabel}'),
          const SizedBox(height: OpposeSpacing.md),
          OutlinedButton.icon(
            onPressed: onChangeSettings,
            icon: const Icon(Icons.tune_rounded),
            label: const Text('Change AI settings'),
          ),
        ],
      ),
    );
  }
}
