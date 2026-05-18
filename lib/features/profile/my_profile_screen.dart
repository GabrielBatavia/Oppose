import 'package:flutter/material.dart';

import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/badge.dart';
import '../../components/core/paper_card.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockOpposeData.currentUser;

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        const OpposeHeader(
          title: 'Oppose',
          subtitle: 'Your respectful debate identity.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            children: [
              const OpposeAvatar(
                label: "Bima's Friend",
                imageAsset: OpposeAssets.profileBima,
                size: 104,
              ),
              const SizedBox(height: OpposeSpacing.md),
              Text(
                user.displayName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('@${user.username}'),
              const SizedBox(height: OpposeSpacing.sm),
              const Text('Different take, better talk.'),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        Row(
          children: const [
            Expanded(
              child: _StatCard(label: 'Debates', value: '18'),
            ),
            SizedBox(width: OpposeSpacing.md),
            Expanded(
              child: _StatCard(label: 'Streak', value: '5'),
            ),
            SizedBox(width: OpposeSpacing.md),
            Expanded(
              child: _StatCard(label: 'Friends', value: '24'),
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        Text('Badges', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: OpposeSpacing.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final badge in MockOpposeData.profileBadges)
              OpposeBadge(label: badge.label),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: OpposeSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final height in const [
                    34.0,
                    58.0,
                    42.0,
                    72.0,
                    50.0,
                  ]) ...[
                    Expanded(
                      child: Container(
                        height: height,
                        color: OpposeColors.mint,
                      ),
                    ),
                    const SizedBox(width: OpposeSpacing.sm),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(label: 'Edit profile', onPressed: () {}),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(label: 'Share profile', onPressed: () {}),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: OpposeSpacing.xs),
          Text(label),
        ],
      ),
    );
  }
}
