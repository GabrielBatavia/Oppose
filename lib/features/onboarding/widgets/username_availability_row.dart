import 'package:flutter/material.dart';

import '../../../components/core/status_pill.dart';
import '../../../state/onboarding/onboarding_controller.dart';
import '../../../theme/oppose_colors.dart';

class UsernameAvailabilityRow extends StatelessWidget {
  const UsernameAvailabilityRow({super.key, required this.availability});

  final UsernameAvailability availability;

  @override
  Widget build(BuildContext context) {
    return StatusPill(
      label: switch (availability) {
        UsernameAvailability.empty => 'Choose a username',
        UsernameAvailability.invalid => 'Use 3-24 letters, numbers, or _',
        UsernameAvailability.checking => 'Checking username...',
        UsernameAvailability.available => 'Username available',
        UsernameAvailability.unavailable => 'Username already taken',
      },
      icon: switch (availability) {
        UsernameAvailability.empty => Icons.alternate_email_rounded,
        UsernameAvailability.invalid => Icons.error_outline_rounded,
        UsernameAvailability.checking => Icons.hourglass_top_rounded,
        UsernameAvailability.available => Icons.check_circle_rounded,
        UsernameAvailability.unavailable => Icons.cancel_rounded,
      },
      color: switch (availability) {
        UsernameAvailability.empty => OpposeColors.indigo,
        UsernameAvailability.invalid => OpposeColors.danger,
        UsernameAvailability.checking => OpposeColors.indigo,
        UsernameAvailability.available => OpposeColors.success,
        UsernameAvailability.unavailable => OpposeColors.danger,
      },
    );
  }
}
