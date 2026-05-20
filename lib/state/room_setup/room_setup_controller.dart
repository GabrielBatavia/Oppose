import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';
import '../mock_data/mock_oppose_data.dart';

enum RoomSetupType { quickHangout, dailyDebate, studyTalk, custom }

enum MicState { ready, permissionDenied }

enum AudioRouteOption { phoneSpeaker, bluetooth, wiredHeadset }

class RoomSetupController extends ChangeNotifier {
  RoomSetupController({required this.analytics});

  final AnalyticsService analytics;

  bool _createViewed = false;
  bool _lobbyViewed = false;

  String topic = MockOpposeData.room.topic;
  RoomSetupType selectedRoomType = RoomSetupType.dailyDebate;
  final Set<String> invitedFriendIds = MockOpposeData.friends
      .map((friend) => friend.id)
      .toSet();
  AIMode selectedAIMode = AIMode.quietHelper;
  SummarySetting selectedSummarySetting = SummarySetting.privateToMe;
  MicState micState = MicState.ready;
  AudioRouteOption audioRoute = AudioRouteOption.phoneSpeaker;

  List<Friend> get invitedFriends => MockOpposeData.friends
      .where((friend) => invitedFriendIds.contains(friend.id))
      .toList(growable: false);

  String get effectiveTopic {
    final trimmed = topic.trim();
    return trimmed.isEmpty ? selectedRoomType.defaultTopic : trimmed;
  }

  String get roomTitle => selectedRoomType.title;

  String get aiModeLabel => selectedAIMode.roomLabel;

  String get summaryLabel => selectedSummarySetting.roomLabel;

  void trackCreateViewedOnce() {
    if (_createViewed) return;
    _createViewed = true;
    unawaited(
      analytics.track('create_room_viewed', {'source': 'create_route'}),
    );
  }

  void trackLobbyViewedOnce() {
    if (_lobbyViewed) return;
    _lobbyViewed = true;
    unawaited(
      analytics.track('room_lobby_viewed', {
        'room_type': selectedRoomType.name,
      }),
    );
  }

  void setTopic(String value) {
    topic = value;
    notifyListeners();
  }

  void selectRoomType(RoomSetupType type) {
    selectedRoomType = type;
    unawaited(analytics.track('room_type_selected', {'room_type': type.name}));
    notifyListeners();
  }

  void toggleFriend(String friendId) {
    if (invitedFriendIds.contains(friendId)) {
      invitedFriendIds.remove(friendId);
    } else {
      invitedFriendIds.add(friendId);
      unawaited(analytics.track('friend_invited', {'friend_id': friendId}));
    }
    notifyListeners();
  }

  void removeInvitedFriends(Set<String> friendIds) {
    final before = invitedFriendIds.length;
    invitedFriendIds.removeAll(friendIds);
    if (invitedFriendIds.length == before) return;
    notifyListeners();
  }

  void selectAIMode(AIMode mode, {String source = 'create_room'}) {
    selectedAIMode = mode;
    unawaited(
      analytics.track('ai_mode_selected', {
        'ai_mode': mode.name,
        'source': source,
      }),
    );
    if (source == 'lobby') {
      unawaited(
        analytics.track('ai_settings_changed_from_lobby', {
          'ai_mode': mode.name,
        }),
      );
    }
    notifyListeners();
  }

  void selectSummarySetting(SummarySetting setting) {
    selectedSummarySetting = setting;
    unawaited(
      analytics.track('summary_setting_selected', {
        'summary_setting': setting.name,
      }),
    );
    notifyListeners();
  }

  void createRoom() {
    unawaited(
      analytics.track('room_created', {
        'room_type': selectedRoomType.name,
        'ai_mode': selectedAIMode.name,
        'summary_setting': selectedSummarySetting.name,
        'invited_count': invitedFriendIds.length,
        'has_topic': topic.trim().isNotEmpty,
      }),
    );
  }

  void toggleMicState() {
    micState = micState == MicState.ready
        ? MicState.permissionDenied
        : MicState.ready;
    unawaited(analytics.track('mic_state_changed', {'state': micState.name}));
    notifyListeners();
  }

  void selectAudioRoute(AudioRouteOption option) {
    audioRoute = option;
    notifyListeners();
  }

  void trackInviteClicked() {
    unawaited(analytics.track('invite_clicked', {'source': 'room_lobby'}));
  }

  void joinRoom() {
    unawaited(
      analytics.track('room_joined', {
        'room_type': selectedRoomType.name,
        'mic_state': micState.name,
        'ai_mode': selectedAIMode.name,
      }),
    );
  }
}

extension RoomSetupTypePresentation on RoomSetupType {
  String get label => switch (this) {
    RoomSetupType.quickHangout => 'Quick Hangout',
    RoomSetupType.dailyDebate => 'Daily Debate',
    RoomSetupType.studyTalk => 'Study Talk',
    RoomSetupType.custom => 'Custom',
  };

  String get title => switch (this) {
    RoomSetupType.quickHangout => 'Quick Hangout Room',
    RoomSetupType.dailyDebate => 'Daily Debate Room',
    RoomSetupType.studyTalk => 'Study Talk Room',
    RoomSetupType.custom => 'Custom Room',
  };

  String get subtitle => switch (this) {
    RoomSetupType.quickHangout => 'Casual voice space with friends.',
    RoomSetupType.dailyDebate => 'A focused room around today\'s question.',
    RoomSetupType.studyTalk => 'Compare ideas and keep notes together.',
    RoomSetupType.custom => 'Set your own topic and tone.',
  };

  String get defaultTopic => switch (this) {
    RoomSetupType.quickHangout => 'What should we catch up on today?',
    RoomSetupType.dailyDebate => 'Is remote work good for the future?',
    RoomSetupType.studyTalk =>
      'What is the strongest way to explain this topic?',
    RoomSetupType.custom => 'A friendly room for different takes.',
  };
}

extension AIModePresentation on AIMode {
  String get roomLabel => switch (this) {
    AIMode.off => 'AI Off',
    AIMode.quietHelper => 'AI Quiet Helper',
    AIMode.brainstormer => 'AI Brainstormer',
    AIMode.translator => 'AI Translator',
    AIMode.moderatorLite => 'AI Moderator-lite',
  };

  String get setupSubtitle => switch (this) {
    AIMode.off => 'No AI in this room.',
    AIMode.quietHelper => 'Responds only when asked.',
    AIMode.brainstormer => 'Suggests ideas when prompted.',
    AIMode.translator => 'Helps translate when requested.',
    AIMode.moderatorLite => 'Helps keep discussion respectful.',
  };
}

extension SummarySettingPresentation on SummarySetting {
  String get roomLabel => switch (this) {
    SummarySetting.off => 'Summary Off',
    SummarySetting.privateToMe => 'Private to me',
    SummarySetting.sharedWithRoom => 'Shared with room',
  };

  String get setupSubtitle => switch (this) {
    SummarySetting.off => 'No summary after the room.',
    SummarySetting.privateToMe => 'Only you can see it unless you share.',
    SummarySetting.sharedWithRoom => 'Room members can see the summary.',
  };
}

extension MicStatePresentation on MicState {
  String get label => switch (this) {
    MicState.ready => 'Mic ready',
    MicState.permissionDenied => 'Mic permission denied',
  };
}

extension AudioRouteOptionPresentation on AudioRouteOption {
  String get label => switch (this) {
    AudioRouteOption.phoneSpeaker => 'Phone speaker',
    AudioRouteOption.bluetooth => 'Bluetooth',
    AudioRouteOption.wiredHeadset => 'Wired headset',
  };
}
