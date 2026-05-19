import 'package:flutter/material.dart';

import '../../../components/core/paper_card.dart';
import '../../../state/room_setup/room_setup_controller.dart';
import '../../../theme/oppose_spacing.dart';

class AudioRouteSelector extends StatelessWidget {
  const AudioRouteSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final AudioRouteOption value;
  final ValueChanged<AudioRouteOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Row(
        children: [
          const Icon(Icons.volume_up_rounded),
          const SizedBox(width: OpposeSpacing.md),
          Expanded(
            child: DropdownButtonFormField<AudioRouteOption>(
              initialValue: value,
              decoration: const InputDecoration(labelText: 'Audio route'),
              items: [
                for (final option in AudioRouteOption.values)
                  DropdownMenuItem(value: option, child: Text(option.label)),
              ],
              onChanged: (option) {
                if (option != null) onChanged(option);
              },
            ),
          ),
        ],
      ),
    );
  }
}
