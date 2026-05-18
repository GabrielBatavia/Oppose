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
import '../../state/onboarding/onboarding_controller.dart';
import '../../state/onboarding/onboarding_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = OnboardingScope.watch(context);
    final isEnglish = onboarding.isEnglish;

    return OpposeScreen(
      children: [
        OpposeHeader(
          title: isEnglish
              ? 'Different take, better talk.'
              : 'Beda pendapat, ngobrol lebih baik.',
          subtitle: isEnglish
              ? 'A warm place to discuss daily takes with friends and AI when you allow it.'
              : 'Ruang hangat untuk membahas pendapat harian bersama teman dan AI saat kamu izinkan.',
          trailing: _LanguageToggle(onboarding: onboarding),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: 16,
              top: 0,
              child: Opacity(
                opacity: 0.9,
                child: StickerImage(
                  asset: OpposeAssets.yellowStarburst,
                  size: 72,
                ),
              ),
            ),
            const StickerImage(
              asset: OpposeAssets.welcomeBima,
              size: 190,
              semanticLabel: 'Bima mascot waving with a mug',
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEnglish
                    ? 'Daily debates with your people'
                    : 'Debat harian dengan orang dekatmu',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: OpposeSpacing.sm),
              Text(
                isEnglish
                    ? 'Create rooms, chat through different opinions, and invite AI only when it helps.'
                    : 'Buat room, obrolkan pendapat berbeda, dan undang AI hanya saat dibutuhkan.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: OpposeSpacing.md),
              const AIStatusPill(status: AIStatusValue.off),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: isEnglish ? 'Start debating' : 'Mulai debat',
          onPressed: () {
            onboarding.startSignUp();
            context.go(AppRoutes.signUp);
          },
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: isEnglish
              ? 'I already have an account'
              : 'Saya sudah punya akun',
          onPressed: () => context.go(AppRoutes.home),
        ),
        const SizedBox(height: OpposeSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 18,
              color: OpposeColors.maroon,
            ),
            const SizedBox(width: OpposeSpacing.xs),
            Flexible(
              child: Text(
                isEnglish
                    ? 'AI joins only when you allow it.'
                    : 'AI hanya bergabung saat kamu izinkan.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: OpposeColors.maroon),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.onboarding});

  final OnboardingController onboarding;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<OpposeLanguage>(
      segments: const [
        ButtonSegment(value: OpposeLanguage.english, label: Text('EN')),
        ButtonSegment(value: OpposeLanguage.indonesia, label: Text('ID')),
      ],
      selected: {onboarding.language},
      onSelectionChanged: (selection) =>
          onboarding.setLanguage(selection.first),
    );
  }
}
