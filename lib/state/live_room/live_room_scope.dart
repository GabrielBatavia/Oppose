import 'package:flutter/widgets.dart';

import 'live_room_controller.dart';

class LiveRoomScope extends InheritedNotifier<LiveRoomController> {
  const LiveRoomScope({
    super.key,
    required LiveRoomController controller,
    required super.child,
  }) : super(notifier: controller);

  static LiveRoomController watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LiveRoomScope>();
    assert(scope != null, 'LiveRoomScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static LiveRoomController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<LiveRoomScope>();
    assert(scope != null, 'LiveRoomScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
