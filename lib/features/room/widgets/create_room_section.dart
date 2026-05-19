import 'package:flutter/material.dart';

import '../../../theme/oppose_spacing.dart';

class CreateRoomSection extends StatelessWidget {
  const CreateRoomSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (subtitle != null) ...[
          const SizedBox(height: OpposeSpacing.xs),
          Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
        ],
        const SizedBox(height: OpposeSpacing.md),
        child,
      ],
    );
  }
}
