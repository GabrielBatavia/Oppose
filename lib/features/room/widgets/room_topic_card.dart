import 'package:flutter/material.dart';

import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';

class RoomTopicCard extends StatelessWidget {
  const RoomTopicCard({
    super.key,
    required this.topic,
    required this.roomTypeLabel,
  });

  final String topic;
  final String roomTypeLabel;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.sunflower.withValues(alpha: 0.14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusPill(
            label: roomTypeLabel,
            icon: Icons.style_rounded,
            color: OpposeColors.maroon,
          ),
          const SizedBox(height: OpposeSpacing.md),
          Text('Topic', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: OpposeSpacing.sm),
          Text(topic, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
