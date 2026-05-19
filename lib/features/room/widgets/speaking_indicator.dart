import 'package:flutter/material.dart';

import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';

class SpeakingIndicator extends StatelessWidget {
  const SpeakingIndicator({super.key, required this.isSpeaking});

  final bool isSpeaking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpposeSpacing.sm,
        vertical: OpposeSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isSpeaking
            ? OpposeColors.mint.withValues(alpha: 0.35)
            : OpposeColors.warmBorder.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(OpposeRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSpeaking ? Icons.graphic_eq_rounded : Icons.volume_off_outlined,
            size: 14,
            color: isSpeaking ? OpposeColors.success : OpposeColors.mutedGray,
          ),
          const SizedBox(width: OpposeSpacing.xs),
          Text(
            isSpeaking ? 'Speaking' : 'Quiet',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
