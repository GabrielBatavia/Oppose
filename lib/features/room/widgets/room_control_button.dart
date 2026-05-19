import 'package:flutter/material.dart';

import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';

class RoomControlButton extends StatelessWidget {
  const RoomControlButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isDanger = false,
    this.isSelected = false,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDanger;
  final bool isSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = isDanger
        ? OpposeColors.danger
        : isSelected
        ? OpposeColors.maroon
        : OpposeColors.softInk;

    return Semantics(
      button: true,
      enabled: enabled,
      selected: isSelected,
      child: InkWell(
        borderRadius: BorderRadius.circular(OpposeRadius.lg),
        onTap: enabled ? onPressed : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.48,
          child: Container(
            width: 72,
            padding: const EdgeInsets.symmetric(
              horizontal: OpposeSpacing.xs,
              vertical: OpposeSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? OpposeColors.mint.withValues(alpha: 0.25)
                  : OpposeColors.paper,
              borderRadius: BorderRadius.circular(OpposeRadius.lg),
              border: Border.all(
                color: isDanger
                    ? OpposeColors.danger
                    : isSelected
                    ? OpposeColors.mint
                    : OpposeColors.warmBorder,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color),
                const SizedBox(height: OpposeSpacing.xs),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
