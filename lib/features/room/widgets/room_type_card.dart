import 'package:flutter/material.dart';

import '../../../assets/oppose_assets.dart';
import '../../../components/core/selectable.dart';
import '../../../state/room_setup/room_setup_controller.dart';

class RoomTypeCard extends StatelessWidget {
  const RoomTypeCard({
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final RoomSetupType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SelectableCard(
      title: type.label,
      subtitle: type.subtitle,
      selected: selected,
      icon: _icon(type),
      onTap: onTap,
    );
  }

  IconData _icon(RoomSetupType type) => switch (type) {
    RoomSetupType.quickHangout => Icons.local_cafe_rounded,
    RoomSetupType.dailyDebate => Icons.wb_sunny_rounded,
    RoomSetupType.studyTalk => Icons.menu_book_rounded,
    RoomSetupType.custom => Icons.tune_rounded,
  };
}

String roomTypeAsset(RoomSetupType type) => switch (type) {
  RoomSetupType.quickHangout => OpposeAssets.createRoomQuickHangout,
  RoomSetupType.dailyDebate => OpposeAssets.createRoomDailyDebate,
  RoomSetupType.studyTalk => OpposeAssets.createRoomStudyTalk,
  RoomSetupType.custom => OpposeAssets.createRoomCustom,
};
