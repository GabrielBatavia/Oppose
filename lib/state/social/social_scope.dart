import 'package:flutter/widgets.dart';

import 'social_controller.dart';

class SocialScope extends InheritedNotifier<SocialController> {
  const SocialScope({
    super.key,
    required SocialController controller,
    required super.child,
  }) : super(notifier: controller);

  static SocialController watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SocialScope>();
    assert(scope != null, 'SocialScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static SocialController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<SocialScope>();
    assert(scope != null, 'SocialScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
