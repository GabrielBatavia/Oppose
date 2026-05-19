import 'package:flutter/material.dart';

import '../../../types/domain_models.dart';
import 'room_control_button.dart';

class RoomControlBar extends StatelessWidget {
  const RoomControlBar({
    super.key,
    required this.isMuted,
    required this.aiMode,
    required this.onMute,
    required this.onChat,
    required this.onAskAI,
    required this.onInvite,
    required this.onLeave,
  });

  final bool isMuted;
  final AIMode aiMode;
  final VoidCallback onMute;
  final VoidCallback onChat;
  final VoidCallback onAskAI;
  final VoidCallback onInvite;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final aiEnabled = aiMode != AIMode.off;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 8,
      spacing: 8,
      children: [
        RoomControlButton(
          label: isMuted ? 'Muted' : 'Mute',
          icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
          isSelected: isMuted,
          onPressed: onMute,
        ),
        RoomControlButton(
          label: 'Chat',
          icon: Icons.chat_bubble_rounded,
          onPressed: onChat,
        ),
        RoomControlButton(
          label: aiEnabled ? 'Ask AI' : 'AI Off',
          icon: aiEnabled
              ? Icons.smart_toy_rounded
              : Icons.power_settings_new_rounded,
          enabled: aiEnabled,
          onPressed: onAskAI,
        ),
        RoomControlButton(
          label: 'Invite',
          icon: Icons.person_add_alt_1_rounded,
          onPressed: onInvite,
        ),
        RoomControlButton(
          label: 'Leave',
          icon: Icons.logout_rounded,
          isDanger: true,
          onPressed: onLeave,
        ),
      ],
    );
  }
}
