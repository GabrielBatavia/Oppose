import 'package:flutter/material.dart';

import '../../../components/core/status_pill.dart';
import '../../../theme/oppose_colors.dart';
import '../../../types/domain_models.dart';

class ConversationTypePill extends StatelessWidget {
  const ConversationTypePill({super.key, required this.type});

  final ConversationType type;

  @override
  Widget build(BuildContext context) {
    return StatusPill(
      label: switch (type) {
        ConversationType.direct => 'Direct',
        ConversationType.group => 'Group',
        ConversationType.room => 'Room',
      },
      icon: switch (type) {
        ConversationType.direct => Icons.person_outline_rounded,
        ConversationType.group => Icons.groups_rounded,
        ConversationType.room => Icons.graphic_eq_rounded,
      },
      color: switch (type) {
        ConversationType.direct => OpposeColors.maroon,
        ConversationType.group => OpposeColors.indigo,
        ConversationType.room => OpposeColors.success,
      },
    );
  }
}
