import 'package:flutter/material.dart';

import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';

class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Semantics(
      label: '$count unread messages',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: OpposeSpacing.sm,
          vertical: OpposeSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: OpposeColors.maroon,
          borderRadius: BorderRadius.circular(OpposeRadius.pill),
        ),
        child: Text(
          '$count',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
