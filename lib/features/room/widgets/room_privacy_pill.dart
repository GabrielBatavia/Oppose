import 'package:flutter/material.dart';

import '../../../components/core/status_pill.dart';
import '../../../theme/oppose_colors.dart';

class RoomPrivacyPill extends StatelessWidget {
  const RoomPrivacyPill({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatusPill(
      label: 'Friends only',
      icon: Icons.lock_outline_rounded,
      color: OpposeColors.maroon,
    );
  }
}
