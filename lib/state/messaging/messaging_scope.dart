import 'package:flutter/widgets.dart';

import 'messaging_controller.dart';

class MessagingScope extends InheritedNotifier<MessagingController> {
  const MessagingScope({
    super.key,
    required MessagingController controller,
    required super.child,
  }) : super(notifier: controller);

  static MessagingController watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MessagingScope>();
    assert(scope != null, 'MessagingScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static MessagingController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<MessagingScope>();
    assert(scope != null, 'MessagingScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
