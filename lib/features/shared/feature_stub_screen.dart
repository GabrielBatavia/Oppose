import 'package:flutter/material.dart';

import '../../components/core/paper_card.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../theme/oppose_spacing.dart';

class FeatureStubScreen extends StatelessWidget {
  const FeatureStubScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.sprintLabel,
    required this.bullets,
    this.showBottomNavigation = false,
    this.hero,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final String sprintLabel;
  final List<String> bullets;
  final bool showBottomNavigation;
  final Widget? hero;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return OpposeScreen(
      showBottomNavigation: showBottomNavigation,
      children: [
        OpposeHeader(title: title, subtitle: subtitle),
        if (hero != null) ...[
          const SizedBox(height: OpposeSpacing.xl),
          Center(child: hero!),
        ],
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sprintLabel, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: OpposeSpacing.md),
              for (final bullet in bullets) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('- '),
                    Expanded(child: Text(bullet)),
                  ],
                ),
                const SizedBox(height: OpposeSpacing.sm),
              ],
            ],
          ),
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(height: OpposeSpacing.xl),
          ...actions.expand(
            (action) => [action, const SizedBox(height: OpposeSpacing.md)],
          ),
        ],
      ],
    );
  }
}
