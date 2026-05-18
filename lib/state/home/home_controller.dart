import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';
import 'home_dashboard_data.dart';

enum DailyDebateResponse { agree, oppose }

class HomeController extends ChangeNotifier {
  HomeController({
    required this.analytics,
    this.data = HomeDashboardFixtures.dashboard,
  });

  final AnalyticsService analytics;
  final HomeDashboardData data;

  bool _viewed = false;
  DailyDebateResponse? selectedResponse;
  bool showFriendEmptyState = false;
  bool showChatEmptyState = false;

  List<Friend> get liveFriends =>
      showFriendEmptyState ? const [] : data.liveFriends;

  List<Conversation> get recentConversations =>
      showChatEmptyState ? const [] : data.recentConversations;

  void trackViewedOnce() {
    if (_viewed) return;
    _viewed = true;
    unawaited(analytics.track('home_viewed', {'source': 'main_tab'}));
  }

  void selectResponse(DailyDebateResponse response) {
    selectedResponse = response;
    final eventName = response == DailyDebateResponse.agree
        ? 'daily_debate_agree_clicked'
        : 'daily_debate_oppose_clicked';
    unawaited(analytics.track(eventName, {'debate_id': data.dailyDebate.id}));
    notifyListeners();
  }

  void openRecentChat(Conversation conversation) {
    unawaited(
      analytics.track('recent_chat_opened', {
        'conversation_id': conversation.id,
        'conversation_type': conversation.type.name,
      }),
    );
  }

  void startRoom() {
    unawaited(analytics.track('start_room_clicked', {'source': 'home_card'}));
  }
}
