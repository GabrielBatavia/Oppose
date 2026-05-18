import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/selectable.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../shared/feature_stub_screen.dart';

class InterestSetupScreen extends StatelessWidget {
  const InterestSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureStubScreen(
      title: 'What do you like to talk about?',
      subtitle: "We'll suggest better daily debates.",
      sprintLabel: 'Sprint 2 target',
      hero: const StickerImage(asset: OpposeAssets.bimaInterest, size: 128),
      bullets: const [
        'Selectable interest chips with checkmarks.',
        'Mint selected state that does not rely on color alone.',
        'Continue and skip paths into AI consent.',
      ],
      actions: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final interest in MockOpposeData.interests)
              SelectableChip(
                label: interest,
                selected: MockOpposeData.currentUser.interests.contains(
                  interest,
                ),
                onSelected: (_) {},
              ),
          ],
        ),
        PrimaryButton(
          label: 'Continue',
          onPressed: () => context.go(AppRoutes.aiConsent),
        ),
        SecondaryButton(
          label: 'Skip for now',
          onPressed: () => context.go(AppRoutes.aiConsent),
        ),
      ],
    );
  }
}
