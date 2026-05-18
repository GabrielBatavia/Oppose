import 'package:flutter/material.dart';

import '../../types/domain_models.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_radius.dart';
import '../../theme/oppose_spacing.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.icon,
    this.color = OpposeColors.indigo,
  });

  final String label;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpposeSpacing.md,
        vertical: OpposeSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(OpposeRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: OpposeSpacing.xs),
          ],
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class AIStatusPill extends StatelessWidget {
  const AIStatusPill({super.key, required this.status});

  final AIStatusValue status;

  @override
  Widget build(BuildContext context) {
    return StatusPill(
      label: status.label,
      icon: status.icon,
      color: status.color,
    );
  }
}

extension AIStatusValuePresentation on AIStatusValue {
  String get label => switch (this) {
    AIStatusValue.off => 'AI Off',
    AIStatusValue.notListening => 'Not listening yet',
    AIStatusValue.listening => 'AI Listening',
    AIStatusValue.thinking => 'AI Thinking',
    AIStatusValue.speaking => 'AI Speaking',
    AIStatusValue.summarizing => 'Summarizing',
    AIStatusValue.memoryOff => 'Memory Off',
  };

  IconData get icon => switch (this) {
    AIStatusValue.off => Icons.power_settings_new_rounded,
    AIStatusValue.notListening => Icons.hearing_disabled_rounded,
    AIStatusValue.listening => Icons.graphic_eq_rounded,
    AIStatusValue.thinking => Icons.psychology_rounded,
    AIStatusValue.speaking => Icons.record_voice_over_rounded,
    AIStatusValue.summarizing => Icons.summarize_rounded,
    AIStatusValue.memoryOff => Icons.lock_outline_rounded,
  };

  Color get color => switch (this) {
    AIStatusValue.off => OpposeColors.mutedGray,
    AIStatusValue.notListening => OpposeColors.indigo,
    AIStatusValue.listening => OpposeColors.success,
    AIStatusValue.thinking => OpposeColors.indigo,
    AIStatusValue.speaking => OpposeColors.maroon,
    AIStatusValue.summarizing => OpposeColors.indigo,
    AIStatusValue.memoryOff => OpposeColors.mutedGray,
  };
}
