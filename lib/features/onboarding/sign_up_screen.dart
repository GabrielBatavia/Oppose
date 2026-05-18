import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/paper_card.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/onboarding/onboarding_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import 'widgets/onboarding_progress.dart';
import 'widgets/social_auth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = OnboardingScope.watch(context);

    return OpposeScreen(
      children: [
        const OnboardingProgress(
          currentStep: 1,
          totalSteps: 4,
          label: 'Account',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const OpposeHeader(
          title: 'Create your Oppose account',
          subtitle: 'Join daily debates with friends and AI.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const Center(
          child: StickerImage(asset: OpposeAssets.bimaSignup, size: 132),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            children: [
              OpposeTextInput(
                label: 'Email or phone',
                hintText: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.alternate_email_rounded),
                errorText: onboarding.emailError,
                onChanged: onboarding.setEmailOrPhone,
              ),
              const SizedBox(height: OpposeSpacing.md),
              OpposeTextInput(
                label: 'Password',
                hintText: 'At least 8 characters',
                obscureText: !onboarding.passwordVisible,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: onboarding.passwordVisible
                      ? 'Hide password'
                      : 'Show password',
                  onPressed: onboarding.togglePasswordVisible,
                  icon: Icon(
                    onboarding.passwordVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
                errorText: onboarding.passwordError,
                onChanged: onboarding.setPassword,
              ),
              const SizedBox(height: OpposeSpacing.lg),
              PrimaryButton(
                label: 'Create account',
                isLoading: onboarding.isSigningUp,
                onPressed:
                    onboarding.canSubmitSignUp || !onboarding.signUpSubmitted
                    ? () async {
                        final ok = await onboarding.submitSignUp();
                        if (ok && context.mounted) {
                          context.go(AppRoutes.usernameSetup);
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.lg),
        Row(
          children: [
            const Expanded(child: Divider(color: OpposeColors.warmBorder)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: OpposeSpacing.md),
              child: Text('or', style: Theme.of(context).textTheme.bodyMedium),
            ),
            const Expanded(child: Divider(color: OpposeColors.warmBorder)),
          ],
        ),
        const SizedBox(height: OpposeSpacing.lg),
        SocialAuthButton(
          label: 'Continue with Google',
          icon: Icons.g_mobiledata_rounded,
          onPressed: () {},
        ),
        const SizedBox(height: OpposeSpacing.md),
        SocialAuthButton(
          label: 'Continue with Apple',
          icon: Icons.apple_rounded,
          onPressed: () {},
        ),
        const SizedBox(height: OpposeSpacing.lg),
        Text(
          'By creating an account, you agree to the Terms and Privacy Policy.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'Back to welcome',
          onPressed: () => context.go(AppRoutes.welcome),
        ),
      ],
    );
  }
}
