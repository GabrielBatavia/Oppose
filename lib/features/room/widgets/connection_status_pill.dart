import 'package:flutter/material.dart';

import '../../../components/core/status_pill.dart';
import '../../../state/live_room/live_room_controller.dart';
import '../../../theme/oppose_colors.dart';

class ConnectionStatusPill extends StatelessWidget {
  const ConnectionStatusPill({super.key, required this.state});

  final LiveConnectionState state;

  @override
  Widget build(BuildContext context) {
    return StatusPill(
      label: state.label,
      icon: switch (state) {
        LiveConnectionState.stable => Icons.wifi_rounded,
        LiveConnectionState.reconnecting => Icons.sync_rounded,
        LiveConnectionState.poor => Icons.wifi_off_rounded,
      },
      color: switch (state) {
        LiveConnectionState.stable => OpposeColors.success,
        LiveConnectionState.reconnecting => OpposeColors.indigo,
        LiveConnectionState.poor => OpposeColors.danger,
      },
    );
  }
}
