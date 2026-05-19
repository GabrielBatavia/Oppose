import 'package:flutter/widgets.dart';

import 'room_setup_controller.dart';

class RoomSetupScope extends InheritedNotifier<RoomSetupController> {
  const RoomSetupScope({
    super.key,
    required RoomSetupController controller,
    required super.child,
  }) : super(notifier: controller);

  static RoomSetupController watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RoomSetupScope>();
    assert(scope != null, 'RoomSetupScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static RoomSetupController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<RoomSetupScope>();
    assert(scope != null, 'RoomSetupScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
