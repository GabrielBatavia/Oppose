class AppRoutes {
  const AppRoutes._();

  static const welcome = '/welcome';
  static const signUp = '/sign-up';
  static const usernameSetup = '/username-setup';
  static const interestSetup = '/interest-setup';
  static const aiConsent = '/ai-consent';
  static const home = '/home';
  static const chats = '/chats';
  static const directChat = '/direct-chat';
  static const createRoom = '/create-room';
  static const roomLobby = '/room-lobby';
  static const liveRoom = '/live-room';
  static const roomSummary = '/room-summary';
  static const profile = '/profile';
  static const report = '/report';
}

class AppRouteInfo {
  const AppRouteInfo({
    required this.path,
    required this.label,
    required this.sprint,
  });

  final String path;
  final String label;
  final int sprint;
}

const appRouteMap = <AppRouteInfo>[
  AppRouteInfo(path: AppRoutes.welcome, label: 'Welcome', sprint: 2),
  AppRouteInfo(path: AppRoutes.signUp, label: 'Sign Up', sprint: 2),
  AppRouteInfo(
    path: AppRoutes.usernameSetup,
    label: 'Username Setup',
    sprint: 2,
  ),
  AppRouteInfo(
    path: AppRoutes.interestSetup,
    label: 'Interest Setup',
    sprint: 2,
  ),
  AppRouteInfo(path: AppRoutes.aiConsent, label: 'AI Consent', sprint: 2),
  AppRouteInfo(path: AppRoutes.home, label: 'Home', sprint: 3),
  AppRouteInfo(path: AppRoutes.chats, label: 'Chats List', sprint: 4),
  AppRouteInfo(path: AppRoutes.directChat, label: 'Direct Chat', sprint: 4),
  AppRouteInfo(path: AppRoutes.createRoom, label: 'Create Room', sprint: 5),
  AppRouteInfo(path: AppRoutes.roomLobby, label: 'Room Lobby', sprint: 5),
  AppRouteInfo(path: AppRoutes.liveRoom, label: 'Live Voice Room', sprint: 6),
  AppRouteInfo(path: AppRoutes.roomSummary, label: 'Room Summary', sprint: 8),
  AppRouteInfo(path: AppRoutes.profile, label: 'My Profile', sprint: 9),
  AppRouteInfo(path: AppRoutes.report, label: 'Report Flow', sprint: 9),
];
