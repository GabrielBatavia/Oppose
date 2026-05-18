import 'package:flutter/material.dart';

import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';

class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.label,
  });

  final int currentStep;
  final int totalSteps;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label, step $currentStep of $totalSteps',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: OpposeSpacing.sm),
          Row(
            children: [
              for (var index = 1; index <= totalSteps; index++) ...[
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: index <= currentStep
                          ? OpposeColors.maroon
                          : OpposeColors.warmBorder,
                      borderRadius: BorderRadius.circular(OpposeRadius.pill),
                    ),
                  ),
                ),
                if (index != totalSteps)
                  const SizedBox(width: OpposeSpacing.xs),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
