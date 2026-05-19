import 'package:flutter/material.dart';

import '../../../components/core/avatar.dart';
import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';
import 'speaking_indicator.dart';

class RoomParticipantCard extends StatelessWidget {
  const RoomParticipantCard({
    super.key,
    required this.participant,
    required this.onTap,
  });

  final RoomParticipant participant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: PaperCard(
        color: participant.isAI
            ? OpposeColors.indigo.withValues(alpha: 0.08)
            : OpposeColors.paper,
        borderColor: participant.isSpeaking
            ? OpposeColors.mint
            : participant.isAI
            ? OpposeColors.indigo.withValues(alpha: 0.45)
            : OpposeColors.warmBorder,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OpposeAvatar(
              label: participant.displayName,
              imageAsset: participant.avatarAsset,
              isAI: participant.isAI,
              isSpeaking: participant.isSpeaking,
              size: 58,
            ),
            const SizedBox(height: OpposeSpacing.sm),
            Text(
              participant.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: OpposeSpacing.xs),
            Text(
              participant.isMuted
                  ? '${participant.role} - muted'
                  : participant.role,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: OpposeSpacing.sm),
            SpeakingIndicator(isSpeaking: participant.isSpeaking),
            if (participant.isAI) ...[
              const SizedBox(height: OpposeSpacing.sm),
              const StatusPill(
                label: 'AI participant',
                icon: Icons.smart_toy_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
