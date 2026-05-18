import 'package:flutter/material.dart';

import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/selectable.dart';
import '../../components/core/status_pill.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';

class AIControlDrawer extends StatelessWidget {
  const AIControlDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('AI Helper', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            const AIStatusPill(status: AIStatusValue.listening),
          ],
        ),
        const SizedBox(height: OpposeSpacing.lg),
        SelectableCard(
          title: 'Quiet Helper',
          subtitle: 'Responds only when asked.',
          selected: true,
          icon: Icons.hearing_rounded,
          onTap: () {},
        ),
        const SizedBox(height: OpposeSpacing.md),
        SelectableCard(
          title: 'Memory is off',
          subtitle: 'AI will not save this conversation for future chats.',
          selected: true,
          icon: Icons.lock_outline_rounded,
          onTap: () {},
        ),
        const SizedBox(height: OpposeSpacing.lg),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            Chip(label: Text('Summarize so far')),
            Chip(label: Text('Suggest question')),
            Chip(label: Text('Explain both sides')),
            Chip(label: Text('Translate')),
          ],
        ),
        const SizedBox(height: OpposeSpacing.lg),
        const OpposeTextInput(label: 'Ask AI', hintText: 'Ask something...'),
        const SizedBox(height: OpposeSpacing.md),
        PrimaryButton(
          label: 'Ask AI',
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: OpposeSpacing.md),
        DangerButton(
          label: 'Turn off AI',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
