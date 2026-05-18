import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_radius.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';

class DirectChatScreen extends StatelessWidget {
  const DirectChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.go(AppRoutes.chats),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const OpposeAvatar(label: 'Maya'),
            const SizedBox(width: OpposeSpacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maya',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  Text('Online'),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.go(AppRoutes.roomLobby),
              icon: const Icon(Icons.call_rounded),
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        for (final message in MockOpposeData.messages) ...[
          Align(
            alignment: message.senderName == "Bima's Friend"
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(OpposeSpacing.lg),
              decoration: BoxDecoration(
                color: message.isAI
                    ? OpposeColors.indigo.withValues(alpha: 0.12)
                    : message.senderName == "Bima's Friend"
                    ? OpposeColors.mint.withValues(alpha: 0.3)
                    : OpposeColors.paper,
                borderRadius: BorderRadius.circular(OpposeRadius.lg),
                border: Border.all(color: OpposeColors.warmBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.senderType == SenderType.ai)
                    const StatusPill(
                      label: 'AI Helper',
                      icon: Icons.smart_toy_rounded,
                    ),
                  if (message.senderType == SenderType.ai)
                    const SizedBox(height: OpposeSpacing.sm),
                  Text(message.body),
                ],
              ),
            ),
          ),
          const SizedBox(height: OpposeSpacing.md),
        ],
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AIStatusPill(status: AIStatusValue.notListening),
              const SizedBox(height: OpposeSpacing.md),
              const Text('AI can suggest a balanced question when you ask.'),
              const SizedBox(height: OpposeSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(label: 'Ask AI', onPressed: () {}),
                  ),
                  const SizedBox(width: OpposeSpacing.md),
                  Expanded(
                    child: SecondaryButton(
                      label: 'Start room',
                      onPressed: () => context.go(AppRoutes.createRoom),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const OpposeTextInput(
          label: 'Message',
          hintText: 'Type a respectful reply...',
        ),
      ],
    );
  }
}
