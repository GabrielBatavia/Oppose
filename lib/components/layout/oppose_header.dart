import 'package:flutter/material.dart';

import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import 'oppose_logo.dart';

class OpposeHeader extends StatelessWidget {
  const OpposeHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = true,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool showLogo;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showLogo) const OpposeLogo(),
            const Spacer(),
            ?trailing,
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        Text(title, style: textTheme.headlineMedium),
        if (subtitle != null) ...[
          const SizedBox(height: OpposeSpacing.sm),
          Text(
            subtitle!,
            style: textTheme.bodyLarge?.copyWith(color: OpposeColors.mutedGray),
          ),
        ],
      ],
    );
  }
}
