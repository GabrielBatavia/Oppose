import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/stickers/sticker_image.dart';
import '../../theme/oppose_spacing.dart';
import '../shared/feature_stub_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureStubScreen(
      title: 'Create your Oppose account',
      subtitle: 'Join daily debates with friends and AI.',
      sprintLabel: 'Sprint 2 target',
      hero: const StickerImage(asset: OpposeAssets.bimaSignup, size: 136),
      bullets: const [
        'Email or phone input with validation.',
        'Password field with visibility toggle.',
        'Google and Apple placeholders.',
        'Terms, privacy, loading, and error states.',
      ],
      actions: [
        const OpposeTextInput(
          label: 'Email or phone',
          hintText: 'you@example.com',
        ),
        const OpposeTextInput(label: 'Password', obscureText: true),
        PrimaryButton(
          label: 'Create account',
          onPressed: () => context.go(AppRoutes.usernameSetup),
        ),
        SecondaryButton(
          label: 'Back to welcome',
          onPressed: () => context.go(AppRoutes.welcome),
        ),
        const SizedBox(height: OpposeSpacing.xs),
      ],
    );
  }
}
