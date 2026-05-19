import 'package:flutter/material.dart';

import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';

class AIResponseCard extends StatelessWidget {
  const AIResponseCard({super.key, required this.response});

  final String response;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.indigo.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusPill(label: 'AI response', icon: Icons.smart_toy_rounded),
          const SizedBox(height: OpposeSpacing.md),
          Text(response, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
