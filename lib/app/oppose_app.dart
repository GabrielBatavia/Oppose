import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'navigation/app_router.dart';
import '../services/analytics/analytics_service.dart';
import '../state/onboarding/onboarding_controller.dart';
import '../state/onboarding/onboarding_scope.dart';
import '../theme/oppose_theme.dart';

class OpposeApp extends StatefulWidget {
  const OpposeApp({super.key});

  @override
  State<OpposeApp> createState() => _OpposeAppState();
}

class _OpposeAppState extends State<OpposeApp> {
  late final OnboardingController _onboardingController;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _onboardingController = OnboardingController(
      analytics: const NoopAnalyticsService(),
    );
    _router = createAppRouter();
  }

  @override
  void dispose() {
    _router.dispose();
    _onboardingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScope(
      controller: _onboardingController,
      child: MaterialApp.router(
        title: 'Oppose',
        debugShowCheckedModeBanner: false,
        theme: OpposeTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
