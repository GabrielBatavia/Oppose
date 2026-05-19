import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';
import '../room_setup/room_setup_controller.dart';

enum LiveConnectionState { stable, reconnecting, poor }

class LiveRoomController extends ChangeNotifier {
  LiveRoomController({required this.analytics});

  final AnalyticsService analytics;

  bool isMuted = false;
  String activeSpeakerId = 'maya';
  LiveConnectionState connectionState = LiveConnectionState.stable;
  bool _enteredTracked = false;

  List<RoomParticipant> participantsFor(
    RoomSetupController setup, {
    AIStatusValue aiStatus = AIStatusValue.listening,
  }) {
    final aiEnabled =
        setup.selectedAIMode != AIMode.off && aiStatus != AIStatusValue.off;
    final participants = [
      for (final friend in setup.invitedFriends)
        RoomParticipant(
          id: friend.id,
          displayName: friend.displayName,
          role: 'Friend',
          avatarAsset: friend.avatarAsset,
          isSpeaking: activeSpeakerId == friend.id,
        ),
      RoomParticipant(
        id: 'you',
        displayName: 'You',
        role: 'Host',
        isSpeaking: activeSpeakerId == 'you',
        isMuted: isMuted,
      ),
      if (aiEnabled)
        RoomParticipant(
          id: 'ai_bima',
          displayName: 'AI Bima',
          role: setup.selectedAIMode.roomLabel.replaceFirst('AI ', ''),
          isAI: true,
          isSpeaking:
              activeSpeakerId == 'ai_bima' ||
              aiStatus == AIStatusValue.speaking,
        ),
    ];

    if (participants.every(
      (participant) => participant.id != activeSpeakerId,
    )) {
      activeSpeakerId = participants.first.id;
    }

    return participants;
  }

  void trackEnteredOnce(RoomSetupController setup) {
    if (_enteredTracked) return;
    _enteredTracked = true;
    unawaited(
      analytics.track('room_joined', {
        'room_type': setup.selectedRoomType.name,
        'ai_mode': setup.selectedAIMode.name,
      }),
    );
  }

  void setActiveSpeaker(String participantId) {
    activeSpeakerId = participantId;
    notifyListeners();
  }

  void toggleMute() {
    isMuted = !isMuted;
    unawaited(analytics.track('mute_toggled', {'is_muted': isMuted}));
    notifyListeners();
  }

  void setConnectionState(LiveConnectionState state) {
    connectionState = state;
    unawaited(
      analytics.track('connection_state_changed', {'state': state.name}),
    );
    notifyListeners();
  }

  void trackAIDrawerOpened() {
    unawaited(analytics.track('ai_drawer_opened', {'source': 'live_room'}));
  }

  void trackRoomChatOpened() {
    unawaited(analytics.track('room_chat_opened', {'source': 'live_room'}));
  }

  void trackInviteClicked() {
    unawaited(analytics.track('invite_clicked', {'source': 'live_room'}));
  }

  void trackLeaveConfirmationViewed() {
    unawaited(
      analytics.track('leave_confirmation_viewed', {'source': 'live_room'}),
    );
  }

  void leaveRoom() {
    unawaited(analytics.track('room_left', {'source': 'live_room'}));
  }
}

extension LiveConnectionStatePresentation on LiveConnectionState {
  String get label => switch (this) {
    LiveConnectionState.stable => 'Good connection',
    LiveConnectionState.reconnecting => 'Reconnecting',
    LiveConnectionState.poor => 'Poor connection',
  };
}
