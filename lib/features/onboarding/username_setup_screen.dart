import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/paper_card.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/onboarding/onboarding_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import 'widgets/onboarding_progress.dart';
import 'widgets/username_availability_row.dart';

class UsernameSetupScreen extends StatelessWidget {
  const UsernameSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = OnboardingScope.watch(context);

    return OpposeScreen(
      children: [
        const OnboardingProgress(
          currentStep: 2,
          totalSteps: 4,
          label: 'Identity',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const OpposeHeader(
          title: 'Pick your debate name',
          subtitle: 'Create the identity your friends will recognize.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            const Center(
              child: StickerImage(asset: OpposeAssets.bimaUsername, size: 122),
            ),
            Positioned(
              right: 100,
              bottom: 4,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: OpposeColors.indigo,
                ),
                padding: const EdgeInsets.all(OpposeSpacing.sm),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            children: [
              const OpposeAvatar(label: "Bima's Friend", size: 76),
              const SizedBox(height: OpposeSpacing.lg),
              OpposeTextInput(
                label: 'Display name',
                hintText: "Bima's Friend",
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.badge_outlined),
                errorText: onboarding.displayNameError,
                onChanged: onboarding.setDisplayName,
              ),
              const SizedBox(height: OpposeSpacing.md),
              OpposeTextInput(
                label: 'Username',
                hintText: 'thinkwithbima',
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.alternate_email_rounded),
                helperText: 'Letters, numbers, and underscores only.',
                onChanged: onboarding.setUsername,
              ),
              const SizedBox(height: OpposeSpacing.md),
              Align(
                alignment: Alignment.centerLeft,
                child: UsernameAvailabilityRow(
                  availability: onboarding.usernameAvailability,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'Continue',
          isLoading: onboarding.isSavingUsername,
          onPressed:
              onboarding.canContinueProfile || !onboarding.usernameSubmitted
              ? () async {
                  final ok = await onboarding.submitUsername();
                  if (ok && context.mounted) {
                    context.go(AppRoutes.interestSetup);
                  }
                }
              : null,
        ),
        const SizedBox(height: OpposeSpacing.md),
        Text(
          'You can change this later.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
