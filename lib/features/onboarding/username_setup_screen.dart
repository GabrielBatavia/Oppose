import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/status_pill.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/stickers/sticker_image.dart';
import '../shared/feature_stub_screen.dart';

class UsernameSetupScreen extends StatelessWidget {
  const UsernameSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureStubScreen(
      title: 'Pick your debate name',
      subtitle: 'Create the identity your friends will recognize.',
      sprintLabel: 'Sprint 2 target',
      hero: const StickerImage(asset: OpposeAssets.bimaUsername, size: 120),
      bullets: const [
        'Avatar placeholder and edit affordance.',
        'Display name and username inputs.',
        'Mock username availability states.',
        'Continue disabled until profile is valid.',
      ],
      actions: [
        const Center(child: OpposeAvatar(label: "Bima's Friend", size: 76)),
        const OpposeTextInput(label: 'Display name', hintText: "Bima's Friend"),
        const OpposeTextInput(label: 'Username', hintText: '@thinkwithbima'),
        const StatusPill(label: 'Available', icon: Icons.check_circle_rounded),
        PrimaryButton(
          label: 'Continue',
          onPressed: () => context.go(AppRoutes.interestSetup),
        ),
      ],
    );
  }
}
