import 'package:flutter/material.dart';

import '../../theme/oppose_colors.dart';
import '../../theme/oppose_radius.dart';
import '../../theme/oppose_shadows.dart';
import '../../theme/oppose_spacing.dart';

class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(OpposeSpacing.lg),
    this.color = OpposeColors.paper,
    this.borderColor = OpposeColors.warmBorder,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(OpposeRadius.lg),
        border: Border.all(color: borderColor),
        boxShadow: OpposeShadows.card,
      ),
      child: child,
    );
  }
}

class TornPaperCard extends StatelessWidget {
  const TornPaperCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.paper,
      child: Stack(
        children: [
          Positioned(
            top: -4,
            left: 18,
            right: 18,
            child: Container(height: 8, color: OpposeColors.sunflower),
          ),
          child,
        ],
      ),
    );
  }
}
