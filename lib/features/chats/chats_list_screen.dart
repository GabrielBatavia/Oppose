import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/empty_state.dart';
import '../../components/core/paper_card.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/messaging/messaging_scope.dart';
import '../../theme/oppose_spacing.dart';
import 'widgets/chat_list_item.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  bool _viewTracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_viewTracked) {
      _viewTracked = true;
      MessagingScope.read(context).trackChatsViewedOnce();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messaging = MessagingScope.watch(context);
    final filtered = messaging.filteredConversations;

    return OpposeScreen(
      showBottomNavigation: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: messaging.showNewChatPlaceholder,
        label: const Text('New chat'),
        icon: const Icon(Icons.edit_rounded),
      ),
      children: [
        const OpposeHeader(
          title: 'Chats',
          subtitle: 'Keep better talks going.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        SearchInput(onChanged: messaging.setSearchQuery),
        if (messaging.newChatPlaceholderVisible) ...[
          const SizedBox(height: OpposeSpacing.md),
          PaperCard(
            child: Row(
              children: [
                const Icon(Icons.construction_rounded),
                const SizedBox(width: OpposeSpacing.md),
                const Expanded(
                  child: Text('New chat flow is coming after core messaging.'),
                ),
                IconButton(
                  tooltip: 'Dismiss new chat placeholder',
                  onPressed: messaging.dismissNewChatPlaceholder,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: OpposeSpacing.xl),
        if (messaging.conversations.isEmpty)
          EmptyState(
            title: 'No chats yet',
            message: 'Start a room or invite a friend to begin.',
            actionLabel: 'Create room',
            onAction: () => context.go(AppRoutes.createRoom),
          )
        else if (filtered.isEmpty)
          EmptyState(
            title: 'No matching chats',
            message: 'Try a friend name, group, or topic.',
            actionLabel: 'Clear search',
            onAction: () => messaging.setSearchQuery(''),
            icon: Icons.search_off_rounded,
          )
        else
          for (final conversation in filtered) ...[
            ChatListItem(
              conversation: conversation,
              onTap: () {
                messaging.openConversation(conversation.id);
                context.go(AppRoutes.directChat);
              },
            ),
            const SizedBox(height: OpposeSpacing.md),
          ],
        const SizedBox(height: OpposeSpacing.xl),
        SecondaryButton(
          label: 'Open report flow',
          onPressed: () => context.go(AppRoutes.report),
        ),
      ],
    );
  }
}
