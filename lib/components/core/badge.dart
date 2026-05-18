import 'package:flutter/material.dart';

import '../../theme/oppose_colors.dart';
import '../../theme/oppose_radius.dart';
import '../../theme/oppose_spacing.dart';

class OpposeBadge extends StatelessWidget {
  const OpposeBadge({
    super.key,
    required this.label,
    this.icon = Icons.workspace_premium_rounded,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpposeSpacing.md,
        vertical: OpposeSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: OpposeColors.sunflower.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(OpposeRadius.pill),
        border: Border.all(color: OpposeColors.sunflower),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: OpposeColors.maroon),
          const SizedBox(width: OpposeSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
