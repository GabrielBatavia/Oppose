import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';
import '../../features/ai/ai_consent_screen.dart';
import '../../features/chats/chats_list_screen.dart';
import '../../features/chats/direct_chat_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/interest_setup_screen.dart';
import '../../features/onboarding/sign_up_screen.dart';
import '../../features/onboarding/username_setup_screen.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/profile/my_profile_screen.dart';
import '../../features/room/create_room_screen.dart';
import '../../features/room/live_voice_room_screen.dart';
import '../../features/room/room_lobby_screen.dart';
import '../../features/room/room_summary_screen.dart';
import '../../features/safety/report_flow_screen.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.usernameSetup,
        builder: (context, state) => const UsernameSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.interestSetup,
        builder: (context, state) => const InterestSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiConsent,
        builder: (context, state) => const AIConsentScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.chats,
        builder: (context, state) => const ChatsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.directChat,
        builder: (context, state) => const DirectChatScreen(),
      ),
      GoRoute(
        path: AppRoutes.createRoom,
        builder: (context, state) => const CreateRoomScreen(),
      ),
      GoRoute(
        path: AppRoutes.roomLobby,
        builder: (context, state) => const RoomLobbyScreen(),
      ),
      GoRoute(
        path: AppRoutes.liveRoom,
        builder: (context, state) => const LiveVoiceRoomScreen(),
      ),
      GoRoute(
        path: AppRoutes.roomSummary,
        builder: (context, state) => const RoomSummaryScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const MyProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.report,
        builder: (context, state) => const ReportFlowScreen(),
      ),
    ],
  );
}
