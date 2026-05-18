import 'package:flutter/material.dart';

import '../../../components/core/paper_card.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';

class ConsentInfoCard extends StatelessWidget {
  const ConsentInfoCard({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: OpposeColors.mint.withValues(alpha: 0.28),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: OpposeColors.maroon),
          ),
          const SizedBox(width: OpposeSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: OpposeSpacing.xs),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
