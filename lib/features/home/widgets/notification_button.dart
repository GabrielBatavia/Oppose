import 'package:flutter/material.dart';

import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton.filledTonal(
          tooltip: 'Notifications',
          onPressed: onPressed,
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: OpposeColors.sunflower,
              borderRadius: BorderRadius.circular(OpposeRadius.pill),
              border: Border.all(color: OpposeColors.paper, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
