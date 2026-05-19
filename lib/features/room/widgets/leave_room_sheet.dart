import 'package:flutter/material.dart';

import '../../../components/buttons/oppose_buttons.dart';
import '../../../theme/oppose_spacing.dart';

class LeaveRoomSheet extends StatelessWidget {
  const LeaveRoomSheet({super.key, required this.onLeave});

  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Leave room?', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: OpposeSpacing.md),
        const Text('You can return from Home or review the summary.'),
        const SizedBox(height: OpposeSpacing.lg),
        DangerButton(label: 'Leave and see summary', onPressed: onLeave),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'Stay in room',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
