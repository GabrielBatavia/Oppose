import 'package:flutter/widgets.dart';

import 'safety_controller.dart';

class SafetyScope extends InheritedNotifier<SafetyController> {
  const SafetyScope({
    super.key,
    required SafetyController controller,
    required super.child,
  }) : super(notifier: controller);

  static SafetyController watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SafetyScope>();
    assert(scope != null, 'SafetyScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static SafetyController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<SafetyScope>();
    assert(scope != null, 'SafetyScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
