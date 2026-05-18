import 'package:flutter/material.dart';

import '../../theme/oppose_colors.dart';
import '../../theme/oppose_radius.dart';
import '../../theme/oppose_spacing.dart';

class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      avatar: selected
          ? const Icon(Icons.check_circle_rounded, size: 18)
          : icon == null
          ? null
          : Icon(icon, size: 18),
      selected: selected,
      onSelected: onSelected,
      selectedColor: OpposeColors.mint.withValues(alpha: 0.45),
      checkmarkColor: OpposeColors.maroon,
      side: BorderSide(
        color: selected ? OpposeColors.mint : OpposeColors.warmBorder,
      ),
    );
  }
}

class SelectableCard extends StatelessWidget {
  const SelectableCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(OpposeRadius.lg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(OpposeSpacing.lg),
        decoration: BoxDecoration(
          color: selected
              ? OpposeColors.mint.withValues(alpha: 0.22)
              : OpposeColors.paper,
          borderRadius: BorderRadius.circular(OpposeRadius.lg),
          border: Border.all(
            color: selected ? OpposeColors.mint : OpposeColors.warmBorder,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: OpposeColors.maroon),
              const SizedBox(width: OpposeSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: OpposeSpacing.xs),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: OpposeColors.maroon,
              ),
          ],
        ),
      ),
    );
  }
}
