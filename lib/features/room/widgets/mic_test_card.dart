import 'package:flutter/material.dart';

import '../../../assets/oppose_assets.dart';
import '../../../components/core/paper_card.dart';
import '../../../components/stickers/sticker_image.dart';
import '../../../state/room_setup/room_setup_controller.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_spacing.dart';

class MicTestCard extends StatelessWidget {
  const MicTestCard({
    super.key,
    required this.micState,
    required this.onToggleMicState,
  });

  final MicState micState;
  final VoidCallback onToggleMicState;

  @override
  Widget build(BuildContext context) {
    final denied = micState == MicState.permissionDenied;

    return PaperCard(
      borderColor: denied ? OpposeColors.danger : OpposeColors.warmBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StickerImage(asset: OpposeAssets.lobbyMicReady, size: 54),
          const SizedBox(width: OpposeSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  micState.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: OpposeSpacing.xs),
                Text(
                  denied
                      ? 'You can still review the lobby, but audio may not work until permission is fixed.'
                      : 'Your microphone looks ready for the room.',
                ),
                const SizedBox(height: OpposeSpacing.md),
                OutlinedButton.icon(
                  onPressed: onToggleMicState,
                  icon: Icon(
                    denied ? Icons.mic_rounded : Icons.mic_off_rounded,
                  ),
                  label: Text(
                    denied ? 'Mock mic ready' : 'Mock permission denied',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
