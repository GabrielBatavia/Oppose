import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/messaging/messaging_scope.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';
import 'widgets/ai_message_card.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/direct_chat_header.dart';
import 'widgets/message_input_bar.dart';
import 'widgets/quick_action_button.dart';

class DirectChatScreen extends StatefulWidget {
  const DirectChatScreen({super.key});

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  bool _aiSuggestionTracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final messaging = MessagingScope.read(context);
    if (!_aiSuggestionTracked) {
      _aiSuggestionTracked = true;
      messaging.trackAISuggestionViewed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messaging = MessagingScope.watch(context);
    final conversation = messaging.selectedConversation;
    final messages = messaging.selectedMessages;

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        DirectChatHeader(
          conversation: conversation,
          onBack: () => context.go(AppRoutes.chats),
          onStartCall: () {
            messaging.startRoomFromChat();
            context.go(AppRoutes.roomLobby);
          },
        ),
        const SizedBox(height: OpposeSpacing.xl),
        for (final message in messages) ...[
          ChatBubble(
            message: message,
            isMine:
                message.senderName == MockOpposeData.currentUser.displayName &&
                message.senderType == SenderType.user,
          ),
          const SizedBox(height: OpposeSpacing.md),
        ],
        if (messaging.aiSuggestionVisible) ...[
          AIMessageCard(
            onAskAI: messaging.askAI,
            onStartRoom: () {
              messaging.startRoomFromChat();
              context.go(AppRoutes.createRoom);
            },
          ),
          const SizedBox(height: OpposeSpacing.lg),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            QuickActionButton(
              label: 'Ask AI',
              icon: Icons.smart_toy_rounded,
              onPressed: messaging.askAI,
            ),
            QuickActionButton(
              label: 'Start room',
              icon: Icons.graphic_eq_rounded,
              onPressed: () {
                messaging.startRoomFromChat();
                context.go(AppRoutes.createRoom);
              },
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        MessageInputBar(onSend: messaging.sendMessage),
      ],
    );
  }
}
