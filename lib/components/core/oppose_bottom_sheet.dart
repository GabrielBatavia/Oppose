import 'package:flutter/material.dart';

import '../../theme/oppose_colors.dart';
import '../../theme/oppose_radius.dart';
import '../../theme/oppose_spacing.dart';

Future<T?> showOpposeBottomSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => OpposeBottomSheet(child: child),
  );
}

class OpposeBottomSheet extends StatelessWidget {
  const OpposeBottomSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: OpposeSpacing.xl,
        right: OpposeSpacing.xl,
        top: OpposeSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + OpposeSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: OpposeColors.paper,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(OpposeRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: OpposeColors.warmBorder,
              borderRadius: BorderRadius.circular(OpposeRadius.pill),
            ),
          ),
          const SizedBox(height: OpposeSpacing.lg),
          child,
        ],
      ),
    );
  }
}
