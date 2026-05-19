import 'package:flutter/material.dart';

import '../../../assets/oppose_assets.dart';
import '../../../components/core/paper_card.dart';
import '../../../components/stickers/sticker_image.dart';
import '../../../theme/oppose_spacing.dart';

class RoomRuleCard extends StatelessWidget {
  const RoomRuleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Row(
        children: [
          const StickerImage(asset: OpposeAssets.lobbyRespectRule, size: 52),
          const SizedBox(width: OpposeSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room rule',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: OpposeSpacing.xs),
                const Text('Challenge ideas, not people.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
