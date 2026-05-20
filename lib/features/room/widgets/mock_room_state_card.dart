import 'package:flutter/material.dart';

import '../../../components/core/paper_card.dart';
import '../../../state/live_room/live_room_controller.dart';
import '../../../theme/oppose_spacing.dart';

class MockRoomStateCard extends StatelessWidget {
  const MockRoomStateCard({
    super.key,
    required this.connectionState,
    required this.onSelectConnectionState,
  });

  final LiveConnectionState connectionState;
  final ValueChanged<LiveConnectionState> onSelectConnectionState;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo room controls',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: OpposeSpacing.xs),
          const Text(
            'Local demo controls: tap a participant to change the active speaker.',
          ),
          const SizedBox(height: OpposeSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final state in LiveConnectionState.values)
                ChoiceChip(
                  label: Text(state.label),
                  selected: connectionState == state,
                  onSelected: (_) => onSelectConnectionState(state),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
