import 'package:flutter/material.dart';

import '../../theme/oppose_colors.dart';
import '../../theme/oppose_radius.dart';
import '../../theme/oppose_spacing.dart';

class OpposeLogo extends StatelessWidget {
  const OpposeLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Oppose logo',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? OpposeSpacing.md : OpposeSpacing.lg,
          vertical: compact ? OpposeSpacing.xs : OpposeSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: OpposeColors.maroon,
          borderRadius: BorderRadius.circular(OpposeRadius.pill),
        ),
        child: Text(
          'Oppose',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            letterSpacing: -0.4,
          ),
        ),
      ),
    );
  }
}
