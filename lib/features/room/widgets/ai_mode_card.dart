import 'package:flutter/material.dart';

import '../../../components/core/selectable.dart';
import '../../../state/room_setup/room_setup_controller.dart';
import '../../../types/domain_models.dart';

class AIModeCard extends StatelessWidget {
  const AIModeCard({
    super.key,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final AIMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SelectableCard(
      title: mode.roomLabel,
      subtitle: mode.setupSubtitle,
      selected: selected,
      icon: switch (mode) {
        AIMode.off => Icons.power_settings_new_rounded,
        AIMode.quietHelper => Icons.hearing_rounded,
        AIMode.brainstormer => Icons.lightbulb_outline_rounded,
        AIMode.translator => Icons.translate_rounded,
        AIMode.moderatorLite => Icons.shield_outlined,
      },
      onTap: onTap,
    );
  }
}
