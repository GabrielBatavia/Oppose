import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../theme/oppose_spacing.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OpposeScreen(
      showBottomNavigation: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('New chat'),
        icon: const Icon(Icons.edit_rounded),
      ),
      children: [
        const OpposeHeader(
          title: 'Chats',
          subtitle: 'Keep better talks going.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const SearchInput(),
        const SizedBox(height: OpposeSpacing.xl),
        for (final conversation in MockOpposeData.conversations) ...[
          PaperCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: OpposeAvatar(label: conversation.title),
              title: Text(conversation.title),
              subtitle: Text(conversation.lastMessage),
              trailing: conversation.unreadCount > 0
                  ? StatusPill(label: '${conversation.unreadCount}')
                  : Text(conversation.updatedLabel),
              onTap: () => context.go(AppRoutes.directChat),
            ),
          ),
          const SizedBox(height: OpposeSpacing.md),
        ],
        SecondaryButton(
          label: 'Open report flow',
          onPressed: () => context.go(AppRoutes.report),
        ),
      ],
    );
  }
}
