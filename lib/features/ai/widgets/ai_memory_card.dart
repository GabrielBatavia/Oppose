import 'package:flutter/material.dart';

import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';

class AIMemoryCard extends StatefulWidget {
  const AIMemoryCard({super.key, required this.onViewed});

  final VoidCallback onViewed;

  @override
  State<AIMemoryCard> createState() => _AIMemoryCardState();
}

class _AIMemoryCardState extends State<AIMemoryCard> {
  @override
  void initState() {
    super.initState();
    widget.onViewed();
  }

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.mint.withValues(alpha: 0.12),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusPill(
            label: 'Memory Off',
            icon: Icons.lock_outline_rounded,
            color: OpposeColors.mutedGray,
          ),
          SizedBox(height: OpposeSpacing.md),
          Text('AI will not save this conversation for future chats.'),
        ],
      ),
    );
  }
}
