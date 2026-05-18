import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/core/empty_state.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/layout/oppose_logo.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../services/analytics/analytics_service.dart';
import '../../state/home/home_controller.dart';
import '../../state/messaging/messaging_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import 'widgets/daily_debate_card.dart';
import 'widgets/home_section_header.dart';
import 'widgets/live_friends_row.dart';
import 'widgets/notification_button.dart';
import 'widgets/recent_chat_preview_card.dart';
import 'widgets/start_room_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(analytics: const NoopAnalyticsService())
      ..addListener(_handleHomeChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.trackViewedOnce();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleHomeChanged)
      ..dispose();
    super.dispose();
  }

  void _handleHomeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final data = _controller.data;

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        Row(
          children: [
            const OpposeLogo(),
            const Spacer(),
            NotificationButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications are coming soon.')),
              ),
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        Text(
          'Hi, ${data.user.displayName}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: OpposeSpacing.sm),
        Text(
          'Ready for a different take today?',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: OpposeColors.mutedGray),
        ),
        const SizedBox(height: OpposeSpacing.lg),
        PaperCard(
          color: OpposeColors.paper,
          child: Row(
            children: [
              const StickerImage(asset: OpposeAssets.welcomeHeart, size: 42),
              const SizedBox(width: OpposeSpacing.md),
              Expanded(child: Text(data.weeklyNudge)),
              const SizedBox(width: OpposeSpacing.md),
              const StatusPill(
                label: 'Streak 5',
                icon: Icons.local_fire_department_rounded,
                color: OpposeColors.maroon,
              ),
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        DailyDebateCard(
          debate: data.dailyDebate,
          selectedResponse: _controller.selectedResponse,
          onAgree: () => _controller.selectResponse(DailyDebateResponse.agree),
          onOppose: () =>
              _controller.selectResponse(DailyDebateResponse.oppose),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const HomeSectionHeader(title: 'Live friends'),
        const SizedBox(height: OpposeSpacing.md),
        LiveFriendsRow(friends: _controller.liveFriends),
        const SizedBox(height: OpposeSpacing.xl),
        HomeSectionHeader(
          title: 'Recent chats',
          actionLabel: 'View all',
          onAction: () => context.go(AppRoutes.chats),
        ),
        const SizedBox(height: OpposeSpacing.md),
        if (_controller.recentConversations.isEmpty)
          EmptyState(
            title: 'No chats yet',
            message: 'Start with a friendly take and invite someone in.',
            actionLabel: 'Create room',
            onAction: () => context.go(AppRoutes.createRoom),
          )
        else
          for (final conversation in _controller.recentConversations.take(
            3,
          )) ...[
            RecentChatPreviewCard(
              conversation: conversation,
              onTap: () {
                _controller.openRecentChat(conversation);
                MessagingScope.read(context).openConversation(conversation.id);
                context.go(AppRoutes.directChat);
              },
            ),
            const SizedBox(height: OpposeSpacing.md),
          ],
        const SizedBox(height: OpposeSpacing.md),
        StartRoomCard(
          title: data.startRoomTitle,
          body: data.startRoomBody,
          onStartRoom: () {
            _controller.startRoom();
            context.go(AppRoutes.createRoom);
          },
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const Center(
          child: Opacity(
            opacity: 0.55,
            child: StickerImage(asset: OpposeAssets.bottomBatik, size: 220),
          ),
        ),
      ],
    );
  }
}
