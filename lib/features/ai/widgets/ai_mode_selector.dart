import 'package:flutter/material.dart';

import '../../../components/core/selectable.dart';
import '../../../state/room_setup/room_setup_controller.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';

class AIModeSelector extends StatelessWidget {
  const AIModeSelector({
    super.key,
    required this.selectedMode,
    required this.onSelected,
  });

  final AIMode selectedMode;
  final ValueChanged<AIMode> onSelected;

  @override
  Widget build(BuildContext context) {
    const modes = [
      AIMode.quietHelper,
      AIMode.brainstormer,
      AIMode.translator,
      AIMode.moderatorLite,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Mode', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: OpposeSpacing.md),
        for (final mode in modes) ...[
          SelectableCard(
            title: mode.roomLabel.replaceFirst('AI ', ''),
            subtitle: mode.setupSubtitle,
            selected: selectedMode == mode,
            icon: switch (mode) {
              AIMode.quietHelper => Icons.hearing_rounded,
              AIMode.brainstormer => Icons.lightbulb_outline_rounded,
              AIMode.translator => Icons.translate_rounded,
              AIMode.moderatorLite => Icons.shield_outlined,
              AIMode.off => Icons.power_settings_new_rounded,
            },
            onTap: () => onSelected(mode),
          ),
          const SizedBox(height: OpposeSpacing.md),
        ],
      ],
    );
  }
}
