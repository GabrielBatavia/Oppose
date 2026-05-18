import 'package:flutter/material.dart';

import '../../theme/oppose_spacing.dart';
import '../buttons/oppose_buttons.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.chat_bubble_outline_rounded,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 42),
        const SizedBox(height: OpposeSpacing.md),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: OpposeSpacing.sm),
        Text(message, textAlign: TextAlign.center),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: OpposeSpacing.lg),
          PrimaryButton(label: actionLabel!, onPressed: onAction),
        ],
      ],
    );
  }
}
