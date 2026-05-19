import 'package:flutter/widgets.dart';

import 'room_summary_controller.dart';

class RoomSummaryScope extends InheritedNotifier<RoomSummaryController> {
  const RoomSummaryScope({
    super.key,
    required RoomSummaryController controller,
    required super.child,
  }) : super(notifier: controller);

  static RoomSummaryController watch(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<RoomSummaryScope>();
    assert(scope != null, 'RoomSummaryScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static RoomSummaryController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<RoomSummaryScope>();
    assert(scope != null, 'RoomSummaryScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
