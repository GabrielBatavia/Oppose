import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'navigation/app_router.dart';
import '../repositories/backend_api_client.dart';
import '../repositories/user/backend_user_repository.dart';
import '../repositories/user/mock_user_repository.dart';
import '../repositories/user/user_repository.dart';
import '../services/analytics/analytics_service.dart';
import '../state/ai_interaction/ai_interaction_controller.dart';
import '../state/ai_interaction/ai_interaction_scope.dart';
import '../state/live_room/live_room_controller.dart';
import '../state/live_room/live_room_scope.dart';
import '../state/messaging/messaging_controller.dart';
import '../state/messaging/messaging_scope.dart';
import '../state/onboarding/onboarding_controller.dart';
import '../state/onboarding/onboarding_scope.dart';
import '../state/room_setup/room_setup_controller.dart';
import '../state/room_setup/room_setup_scope.dart';
import '../state/room_summary/room_summary_controller.dart';
import '../state/room_summary/room_summary_scope.dart';
import '../state/safety/safety_controller.dart';
import '../state/safety/safety_scope.dart';
import '../state/social/social_controller.dart';
import '../state/social/social_scope.dart';
import '../theme/oppose_theme.dart';

class OpposeApp extends StatefulWidget {
  const OpposeApp({super.key, this.userRepository});

  final UserRepository? userRepository;

  @override
  State<OpposeApp> createState() => _OpposeAppState();
}

class _OpposeAppState extends State<OpposeApp> {
  late final OnboardingController _onboardingController;
  late final MessagingController _messagingController;
  late final RoomSetupController _roomSetupController;
  late final LiveRoomController _liveRoomController;
  late final AIInteractionController _aiInteractionController;
  late final RoomSummaryController _roomSummaryController;
  late final SafetyController _safetyController;
  late final SocialController _socialController;
  late final UserRepository _userRepository;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _userRepository = widget.userRepository ?? _createUserRepository();
    _socialController = SocialController(
      analytics: const NoopAnalyticsService(),
      userRepository: _userRepository,
    );
    _onboardingController = OnboardingController(
      analytics: const NoopAnalyticsService(),
      userRepository: _userRepository,
      onCurrentUserChanged: _socialController.setCurrentUser,
    );
    _messagingController = MessagingController(
      analytics: const NoopAnalyticsService(),
    );
    _roomSetupController = RoomSetupController(
      analytics: const NoopAnalyticsService(),
    );
    _liveRoomController = LiveRoomController(
      analytics: const NoopAnalyticsService(),
    );
    _aiInteractionController = AIInteractionController(
      analytics: const NoopAnalyticsService(),
    );
    _roomSummaryController = RoomSummaryController(
      analytics: const NoopAnalyticsService(),
    );
    _safetyController = SafetyController(
      analytics: const NoopAnalyticsService(),
    );
    if (widget.userRepository == null && _shouldUseBackend) {
      unawaited(_socialController.loadCurrentUser());
    }
    _router = createAppRouter();
  }

  static bool get _shouldUseBackend =>
      bool.fromEnvironment('OPPOSE_USE_BACKEND', defaultValue: false);

  static UserRepository _createUserRepository() {
    if (!_shouldUseBackend) return MockUserRepository();

    const backendUrl = String.fromEnvironment(
      'OPPOSE_BACKEND_URL',
      defaultValue: 'http://localhost:4000',
    );
    const devUserId = String.fromEnvironment(
      'OPPOSE_DEV_USER_ID',
      defaultValue: '00000000-0000-4000-8000-000000000001',
    );
    return BackendUserRepository(
      client: BackendApiClient(baseUrl: backendUrl, devUserId: devUserId),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _socialController.dispose();
    _safetyController.dispose();
    _roomSummaryController.dispose();
    _aiInteractionController.dispose();
    _liveRoomController.dispose();
    _roomSetupController.dispose();
    _messagingController.dispose();
    _onboardingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScope(
      controller: _onboardingController,
      child: MessagingScope(
        controller: _messagingController,
        child: RoomSetupScope(
          controller: _roomSetupController,
          child: LiveRoomScope(
            controller: _liveRoomController,
            child: AIInteractionScope(
              controller: _aiInteractionController,
              child: RoomSummaryScope(
                controller: _roomSummaryController,
                child: SafetyScope(
                  controller: _safetyController,
                  child: SocialScope(
                    controller: _socialController,
                    child: MaterialApp.router(
                      title: 'Oppose',
                      debugShowCheckedModeBanner: false,
                      theme: OpposeTheme.light,
                      routerConfig: _router,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
