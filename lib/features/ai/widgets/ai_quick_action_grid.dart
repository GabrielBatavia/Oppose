import 'package:flutter/material.dart';

class AIQuickActionGrid extends StatelessWidget {
  const AIQuickActionGrid({
    super.key,
    required this.enabled,
    required this.onAction,
  });

  final bool enabled;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    const actions = [
      ('Summarize so far', Icons.summarize_rounded),
      ('Suggest a better question', Icons.help_outline_rounded),
      ('Explain both sides', Icons.balance_rounded),
      ('Translate', Icons.translate_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick actions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final action in actions)
              ActionChip(
                avatar: Icon(action.$2),
                label: Text(action.$1),
                onPressed: enabled ? () => onAction(action.$1) : null,
              ),
          ],
        ),
      ],
    );
  }
}
