import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/selectable.dart';
import '../../components/core/status_pill.dart';
import '../../components/stickers/sticker_image.dart';
import '../../types/domain_models.dart';
import '../shared/feature_stub_screen.dart';

class AIConsentScreen extends StatelessWidget {
  const AIConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureStubScreen(
      title: 'How AI works in your room',
      subtitle: 'You stay in control.',
      sprintLabel: 'Sprint 2 target',
      hero: const StickerImage(asset: OpposeAssets.bimaAIConsent, size: 136),
      bullets: const [
        'AI only listens when it is turned on.',
        'You can mute or remove AI anytime.',
        'Summaries are optional and deletable.',
      ],
      actions: [
        const AIStatusPill(status: AIStatusValue.off),
        SelectableCard(
          title: 'Memory is off',
          subtitle: 'AI will not save this conversation for future chats.',
          selected: true,
          icon: Icons.lock_outline_rounded,
          onTap: () {},
        ),
        PrimaryButton(
          label: 'I understand',
          onPressed: () => context.go(AppRoutes.home),
        ),
        SecondaryButton(label: 'Customize AI settings', onPressed: () {}),
      ],
    );
  }
}
