import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OpposeScreen(
      children: [
        OpposeHeader(
          title: 'Different take, better talk.',
          subtitle:
              'A warm place to discuss daily takes with friends and AI when you allow it.',
          trailing: const StatusPill(
            label: 'EN / ID',
            icon: Icons.language_rounded,
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const Center(
          child: StickerImage(
            asset: OpposeAssets.welcomeBima,
            size: 180,
            semanticLabel: 'Bima mascot waving with a mug',
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily debates with your people',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: OpposeSpacing.sm),
              Text(
                'Create rooms, chat through different opinions, and invite AI only when it helps.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: OpposeSpacing.md),
              const AIStatusPill(status: AIStatusValue.off),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'Start debating',
          onPressed: () => context.go(AppRoutes.signUp),
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'I already have an account',
          onPressed: () => context.go(AppRoutes.home),
        ),
        const SizedBox(height: OpposeSpacing.lg),
        Text(
          'AI joins only when you allow it.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: OpposeColors.maroon),
        ),
      ],
    );
  }
}
