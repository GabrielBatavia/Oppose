import 'package:flutter/widgets.dart';

import 'ai_interaction_controller.dart';

class AIInteractionScope extends InheritedNotifier<AIInteractionController> {
  const AIInteractionScope({
    super.key,
    required AIInteractionController controller,
    required super.child,
  }) : super(notifier: controller);

  static AIInteractionController watch(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AIInteractionScope>();
    assert(
      scope != null,
      'AIInteractionScope is missing from the widget tree.',
    );
    return scope!.notifier!;
  }

  static AIInteractionController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AIInteractionScope>();
    assert(
      scope != null,
      'AIInteractionScope is missing from the widget tree.',
    );
    return scope!.notifier!;
  }
}
