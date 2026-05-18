import 'package:flutter/widgets.dart';

import 'onboarding_controller.dart';

class OnboardingScope extends InheritedNotifier<OnboardingController> {
  const OnboardingScope({
    super.key,
    required OnboardingController controller,
    required super.child,
  }) : super(notifier: controller);

  static OnboardingController watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<OnboardingScope>();
    assert(scope != null, 'OnboardingScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static OnboardingController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<OnboardingScope>();
    assert(scope != null, 'OnboardingScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
