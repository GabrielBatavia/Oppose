import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/oppose_bottom_sheet.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/selectable.dart';
import '../../components/core/status_pill.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/onboarding/onboarding_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';
import '../onboarding/widgets/consent_info_card.dart';
import '../onboarding/widgets/onboarding_progress.dart';

class AIConsentScreen extends StatefulWidget {
  const AIConsentScreen({super.key});

  @override
  State<AIConsentScreen> createState() => _AIConsentScreenState();
}

class _AIConsentScreenState extends State<AIConsentScreen> {
  bool _viewTracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_viewTracked) {
      _viewTracked = true;
      OnboardingScope.read(context).viewAIConsent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = OnboardingScope.watch(context);

    return OpposeScreen(
      children: [
        const OnboardingProgress(
          currentStep: 4,
          totalSteps: 4,
          label: 'AI Consent',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const OpposeHeader(
          title: 'How AI works in your room',
          subtitle: 'You stay in control.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const Center(
          child: StickerImage(asset: OpposeAssets.bimaAIConsent, size: 148),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const ConsentInfoCard(
          icon: Icons.power_settings_new_rounded,
          title: 'AI only listens when it is turned on.',
          body:
              'Rooms start with AI clearly labeled. You always see the current AI state.',
        ),
        const SizedBox(height: OpposeSpacing.md),
        const ConsentInfoCard(
          icon: Icons.mic_off_rounded,
          title: 'You can mute or remove AI anytime.',
          body: 'Ask AI, change mode, or turn it off from the AI drawer.',
        ),
        const SizedBox(height: OpposeSpacing.md),
        const ConsentInfoCard(
          icon: Icons.delete_outline_rounded,
          title: 'Summaries are optional and deletable.',
          body:
              'Generated summaries show privacy state and include a delete action.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          color: OpposeColors.indigo.withValues(alpha: 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AIStatusPill(status: AIStatusValue.off),
              const SizedBox(height: OpposeSpacing.md),
              Text(
                'Memory is off',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: OpposeSpacing.xs),
              const Text(
                'AI will not save this conversation for future chats.',
              ),
              const SizedBox(height: OpposeSpacing.md),
              Row(
                children: [
                  Icon(
                    onboarding.aiConsentAccepted
                        ? Icons.check_circle_rounded
                        : Icons.info_outline_rounded,
                    color: onboarding.aiConsentAccepted
                        ? OpposeColors.success
                        : OpposeColors.indigo,
                  ),
                  const SizedBox(width: OpposeSpacing.sm),
                  Expanded(
                    child: Text(
                      onboarding.aiConsentAccepted
                          ? 'Consent accepted for this mock session.'
                          : 'Consent has not been accepted yet.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'I understand',
          isLoading: onboarding.isSavingAIConsent,
          onPressed: () async {
            final ok = await onboarding.acceptAIConsent();
            if (ok && context.mounted) context.go(AppRoutes.home);
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
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'Customize AI settings',
          onPressed: () => showOpposeBottomSheet(
            context: context,
            child: const _AISettingsPlaceholder(),
          ),
        ),
      ],
    );
  }
}

class _AISettingsPlaceholder extends StatelessWidget {
  const _AISettingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'AI settings preview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: OpposeSpacing.md),
        const Text(
          'These settings will connect to real preferences later. For now, the safe defaults stay on.',
        ),
        const SizedBox(height: OpposeSpacing.lg),
        SelectableCard(
          title: 'Default mode: Quiet Helper',
          subtitle: 'AI responds only when asked.',
          selected: true,
          icon: Icons.hearing_rounded,
          onTap: () {},
        ),
        const SizedBox(height: OpposeSpacing.md),
        SelectableCard(
          title: 'Memory: Off',
          subtitle: 'No long-term AI memory is created in MVP.',
          selected: true,
          icon: Icons.lock_outline_rounded,
          onTap: () {},
        ),
        const SizedBox(height: OpposeSpacing.lg),
        SecondaryButton(
          label: 'Close',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
