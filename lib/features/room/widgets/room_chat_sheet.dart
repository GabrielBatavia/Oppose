import 'package:flutter/material.dart';

import '../../../components/buttons/oppose_buttons.dart';
import '../../../components/core/paper_card.dart';
import '../../../components/inputs/oppose_text_input.dart';
import '../../../theme/oppose_spacing.dart';

class RoomChatSheet extends StatelessWidget {
  const RoomChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Room chat', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: OpposeSpacing.md),
        const PaperCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.info_outline_rounded),
            title: Text('Room chat will connect to live room messages later.'),
            subtitle: Text('For now, this is a safe placeholder.'),
          ),
        ),
        const SizedBox(height: OpposeSpacing.lg),
        const OpposeTextInput(
          label: 'Room message',
          hintText: 'Live room chat is coming soon.',
          enabled: false,
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
