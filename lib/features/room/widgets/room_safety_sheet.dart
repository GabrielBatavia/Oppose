import 'package:flutter/material.dart';

import '../../../components/buttons/oppose_buttons.dart';
import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../state/safety/safety_scope.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';

class RoomSafetySheet extends StatelessWidget {
  const RoomSafetySheet({
    super.key,
    required this.participants,
    required this.onReportRoom,
    required this.onReportParticipant,
  });

  final List<RoomParticipant> participants;
  final VoidCallback onReportRoom;
  final ValueChanged<RoomParticipant> onReportParticipant;

  @override
  Widget build(BuildContext context) {
    final safety = SafetyScope.watch(context);
    final reportableParticipants = participants
        .where((participant) => participant.id != 'you')
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Room safety', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: OpposeSpacing.sm),
        const Text(
          'Mute locally, prepare a private mock report, or leave whenever you need.',
        ),
        const SizedBox(height: OpposeSpacing.lg),
        DangerButton(label: 'Report room', onPressed: onReportRoom),
        const SizedBox(height: OpposeSpacing.lg),
        Text('People here', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: OpposeSpacing.md),
        for (final participant in reportableParticipants) ...[
          _ParticipantSafetyCard(
            participant: participant,
            isMuted: safety.isMuted(participant.id),
            isBlocked: safety.isBlocked(participant.id),
            onToggleMute: () => safety.toggleMuted(participant.id),
            onReport: () => onReportParticipant(participant),
          ),
          const SizedBox(height: OpposeSpacing.md),
        ],
        const PaperCard(
          color: OpposeColors.paper,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusPill(
                label: 'Local mock safety',
                icon: Icons.info_outline_rounded,
                color: OpposeColors.indigo,
              ),
              SizedBox(height: OpposeSpacing.md),
              Text(
                'Demo safety actions update this device only until backend moderation exists.',
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.lg),
        SecondaryButton(
          label: 'Close',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _ParticipantSafetyCard extends StatelessWidget {
  const _ParticipantSafetyCard({
    required this.participant,
    required this.isMuted,
    required this.isBlocked,
    required this.onToggleMute,
    required this.onReport,
  });

  final RoomParticipant participant;
  final bool isMuted;
  final bool isBlocked;
  final VoidCallback onToggleMute;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: isMuted
          ? OpposeColors.mint.withValues(alpha: 0.12)
          : OpposeColors.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  participant.displayName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (isMuted)
                const StatusPill(
                  label: 'Muted',
                  icon: Icons.volume_off_rounded,
                  color: OpposeColors.indigo,
                ),
              if (isBlocked)
                const StatusPill(
                  label: 'Blocked',
                  icon: Icons.block_rounded,
                  color: OpposeColors.maroon,
                ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.xs),
          Text(participant.role),
          const SizedBox(height: OpposeSpacing.md),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: isMuted
                      ? 'Unmute ${participant.displayName}'
                      : 'Mute ${participant.displayName}',
                  onPressed: onToggleMute,
                ),
              ),
              const SizedBox(width: OpposeSpacing.md),
              Expanded(
                child: DangerButton(
                  label: 'Report ${participant.displayName}',
                  onPressed: onReport,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
