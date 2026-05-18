import 'package:flutter/material.dart';

import '../../../assets/oppose_assets.dart';
import '../../../components/buttons/oppose_buttons.dart';
import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../components/stickers/sticker_image.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';

class StartRoomCard extends StatelessWidget {
  const StartRoomCard({
    super.key,
    required this.title,
    required this.body,
    required this.onStartRoom,
  });

  final String title;
  final String body;
  final VoidCallback onStartRoom;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.mint.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusPill(
                      label: 'Quick room',
                      icon: Icons.graphic_eq_rounded,
                      color: OpposeColors.success,
                    ),
                    const SizedBox(height: OpposeSpacing.md),
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: OpposeSpacing.sm),
                    Text(body, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              const SizedBox(width: OpposeSpacing.md),
              const StickerImage(
                asset: OpposeAssets.homeStartRoomMug,
                size: 86,
              ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.lg),
          PrimaryButton(label: 'Create room', onPressed: onStartRoom),
        ],
      ),
    );
  }
}
