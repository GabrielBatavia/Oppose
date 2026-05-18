import '../../assets/oppose_assets.dart';
import '../../types/domain_models.dart';
import '../mock_data/mock_oppose_data.dart';

class DailyDebate {
  const DailyDebate({
    required this.id,
    required this.question,
    required this.categoryLabel,
    required this.contextLabel,
    required this.heroAsset,
  });

  final String id;
  final String question;
  final String categoryLabel;
  final String contextLabel;
  final String heroAsset;
}

class HomeDashboardData {
  const HomeDashboardData({
    required this.user,
    required this.dailyDebate,
    required this.liveFriends,
    required this.recentConversations,
    required this.startRoomTitle,
    required this.startRoomBody,
    required this.weeklyNudge,
  });

  final OpposeUser user;
  final DailyDebate dailyDebate;
  final List<Friend> liveFriends;
  final List<Conversation> recentConversations;
  final String startRoomTitle;
  final String startRoomBody;
  final String weeklyNudge;
}

class HomeDashboardFixtures {
  const HomeDashboardFixtures._();

  static const dashboard = HomeDashboardData(
    user: MockOpposeData.currentUser,
    dailyDebate: DailyDebate(
      id: 'remote_work_future',
      question: 'Is remote work good for the future?',
      categoryLabel: 'Daily Debate',
      contextLabel: 'Friends are split on this one',
      heroAsset: OpposeAssets.bimaHome,
    ),
    liveFriends: MockOpposeData.friends,
    recentConversations: MockOpposeData.conversations,
    startRoomTitle: 'Start a room',
    startRoomBody:
        'Invite friends, choose AI mode, and keep the talk respectful.',
    weeklyNudge: 'You listened well in 5 debates this week.',
  );
}
