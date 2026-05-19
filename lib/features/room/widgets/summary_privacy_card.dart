import 'package:flutter/material.dart';

import '../../../components/core/selectable.dart';
import '../../../state/room_setup/room_setup_controller.dart';
import '../../../types/domain_models.dart';

class SummaryPrivacyCard extends StatelessWidget {
  const SummaryPrivacyCard({
    super.key,
    required this.setting,
    required this.selected,
    required this.onTap,
  });

  final SummarySetting setting;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SelectableCard(
      title: setting.roomLabel,
      subtitle: setting.setupSubtitle,
      selected: selected,
      icon: switch (setting) {
        SummarySetting.off => Icons.do_not_disturb_on_outlined,
        SummarySetting.privateToMe => Icons.lock_outline_rounded,
        SummarySetting.sharedWithRoom => Icons.groups_rounded,
      },
      onTap: onTap,
    );
  }
}
