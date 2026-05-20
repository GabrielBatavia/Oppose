import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/selectable.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../state/onboarding/onboarding_scope.dart';
import '../../theme/oppose_spacing.dart';
import 'widgets/onboarding_progress.dart';

class InterestSetupScreen extends StatelessWidget {
  const InterestSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = OnboardingScope.watch(context);

    return OpposeScreen(
      children: [
        const OnboardingProgress(
          currentStep: 3,
          totalSteps: 4,
          label: 'Interests',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const OpposeHeader(
          title: 'What do you like to talk about?',
          subtitle: "We'll suggest better daily debates.",
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const Center(
          child: StickerImage(asset: OpposeAssets.bimaInterest, size: 132),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose any that feel fun today',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: OpposeSpacing.sm),
              Text(
                '${onboarding.selectedInterests.length} selected',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: OpposeSpacing.lg),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final interest in MockOpposeData.interests)
                    SelectableChip(
                      label: interest,
                      selected: onboarding.selectedInterests.contains(interest),
                      onSelected: (_) => onboarding.toggleInterest(interest),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'Continue',
          isLoading: onboarding.isSavingInterests,
          onPressed: () async {
            final ok = await onboarding.continueInterests(skipped: false);
            if (ok && context.mounted) context.go(AppRoutes.aiConsent);
          },
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'Skip for now',
          onPressed: onboarding.isSavingInterests
              ? null
              : () async {
                  final ok = await onboarding.continueInterests(skipped: true);
                  if (ok && context.mounted) context.go(AppRoutes.aiConsent);
                },
        ),
        if (onboarding.errorMessage != null) ...[
          const SizedBox(height: OpposeSpacing.md),
          Text(
            onboarding.errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}
