import 'dart:async';

import 'package:flutter/material.dart';

import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/ai_interaction/ai_interaction_scope.dart';
import '../../state/onboarding/onboarding_scope.dart';
import '../../state/room_setup/room_setup_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';
import 'widgets/ai_memory_card.dart';
import 'widgets/ai_mode_selector.dart';
import 'widgets/ai_quick_action_grid.dart';
import 'widgets/ai_response_card.dart';

class AIControlDrawer extends StatefulWidget {
  const AIControlDrawer({super.key});

  @override
  State<AIControlDrawer> createState() => _AIControlDrawerState();
}

class _AIControlDrawerState extends State<AIControlDrawer> {
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ai = AIInteractionScope.watch(context);
    final setup = RoomSetupScope.watch(context);
    final onboarding = OnboardingScope.watch(context);
    final hasConsent = onboarding.aiConsentAccepted;
    final controlsEnabled = hasConsent && !ai.isOff && !ai.isBusy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StickerImage(asset: OpposeAssets.aiDrawerRobot, size: 72),
            const SizedBox(width: OpposeSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Helper',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: OpposeSpacing.xs),
                  const Text('AI responds only when asked and stays visible.'),
                  const SizedBox(height: OpposeSpacing.md),
                  AIStatusPill(status: ai.status),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.lg),
        if (!hasConsent)
          const PaperCard(
            color: OpposeColors.paper,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI needs your consent first.'),
                SizedBox(height: OpposeSpacing.sm),
                Text('Finish AI Consent before using AI in rooms.'),
              ],
            ),
          )
        else ...[
          AIModeSelector(
            selectedMode: setup.selectedAIMode == AIMode.off
                ? ai.selectedMode
                : setup.selectedAIMode,
            onSelected: (mode) {
              ai.selectMode(mode);
              setup.selectAIMode(mode, source: 'ai_drawer');
            },
          ),
          AIMemoryCard(onViewed: ai.viewMemoryState),
          const SizedBox(height: OpposeSpacing.lg),
          AIQuickActionGrid(
            enabled: controlsEnabled,
            onAction: (action) => unawaited(ai.runQuickAction(action)),
          ),
          const SizedBox(height: OpposeSpacing.lg),
          OpposeTextInput(
            label: 'Ask AI',
            hintText: 'Ask something...',
            controller: _promptController,
            enabled: controlsEnabled,
            prefixIcon: const Icon(Icons.question_answer_outlined),
            onChanged: ai.setPromptDraft,
          ),
          const SizedBox(height: OpposeSpacing.md),
          PrimaryButton(
            label: ai.isBusy ? 'AI is working...' : 'Ask AI',
            isLoading: ai.isBusy,
            onPressed: controlsEnabled
                ? () {
                    unawaited(ai.askPrompt());
                    _promptController.clear();
                  }
                : null,
          ),
          if (ai.latestResponse != null) ...[
            const SizedBox(height: OpposeSpacing.lg),
            AIResponseCard(response: ai.latestResponse!),
          ],
          const SizedBox(height: OpposeSpacing.md),
          DangerButton(
            label: 'Turn off AI',
            onPressed: () {
              ai.turnOffAI();
              setup.selectAIMode(AIMode.off, source: 'ai_drawer');
              Navigator.of(context).pop();
            },
          ),
        ],
      ],
    );
  }
}
