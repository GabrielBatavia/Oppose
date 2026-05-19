import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';
import '../room_setup/room_setup_controller.dart';

class RoomSummaryController extends ChangeNotifier {
  RoomSummaryController({required this.analytics});

  final AnalyticsService analytics;

  bool isSaved = false;
  bool isShared = false;
  bool isDeleted = false;
  String? actionMessage;
  bool _viewed = false;
  String? _activeRoomSignature;

  bool hasSummary(RoomSetupController setup) {
    return setup.selectedSummarySetting != SummarySetting.off;
  }

  void prepareFor(RoomSetupController setup) {
    final invitedFriendIds = setup.invitedFriendIds.toList()..sort();
    final signature = [
      setup.selectedRoomType.name,
      setup.effectiveTopic,
      setup.selectedAIMode.name,
      setup.selectedSummarySetting.name,
      invitedFriendIds.join(','),
    ].join('|');
    if (_activeRoomSignature == signature) return;

    _activeRoomSignature = signature;
    isSaved = false;
    isShared = false;
    isDeleted = false;
    actionMessage = null;
    _viewed = false;
  }

  RoomSummary buildSummary(RoomSetupController setup) {
    final topic = setup.effectiveTopic;
    return RoomSummary(
      id: 'summary_${setup.selectedRoomType.name}',
      roomId: 'room_${setup.selectedRoomType.name}',
      title: setup.roomTitle,
      durationLabel: _durationFor(setup),
      visibility: _visibilityFor(setup.selectedSummarySetting),
      takeaways: _takeawaysFor(setup, topic),
      bestArguments: _bestArgumentsFor(setup, topic),
      funnyMoments: _funnyMomentsFor(setup),
      openQuestions: _openQuestionsFor(topic),
    );
  }

  void trackViewedOnce(RoomSetupController setup) {
    if (_viewed) return;
    _viewed = true;
    unawaited(
      analytics.track('room_summary_viewed', {
        'room_type': setup.selectedRoomType.name,
        'summary_setting': setup.selectedSummarySetting.name,
        'ai_mode': setup.selectedAIMode.name,
      }),
    );
  }

  void saveSummary(RoomSetupController setup) {
    if (!hasSummary(setup)) return;
    isSaved = true;
    isDeleted = false;
    actionMessage = 'Summary saved privately.';
    unawaited(
      analytics.track('room_summary_saved', {
        'room_type': setup.selectedRoomType.name,
        'summary_setting': setup.selectedSummarySetting.name,
      }),
    );
    notifyListeners();
  }

  void shareSummary(RoomSetupController setup) {
    if (!hasSummary(setup)) return;
    isShared = true;
    isDeleted = false;
    actionMessage = 'Shared with room members.';
    unawaited(
      analytics.track('room_summary_shared', {
        'room_type': setup.selectedRoomType.name,
        'summary_setting': setup.selectedSummarySetting.name,
      }),
    );
    notifyListeners();
  }

  void deleteSummary(RoomSetupController setup) {
    isSaved = false;
    isShared = false;
    isDeleted = true;
    actionMessage = 'Summary deleted from this device.';
    unawaited(
      analytics.track('room_summary_deleted', {
        'room_type': setup.selectedRoomType.name,
        'summary_setting': setup.selectedSummarySetting.name,
      }),
    );
    notifyListeners();
  }

  String _durationFor(RoomSetupController setup) {
    final baseMinutes = switch (setup.selectedRoomType) {
      RoomSetupType.quickHangout => 14,
      RoomSetupType.dailyDebate => 24,
      RoomSetupType.studyTalk => 31,
      RoomSetupType.custom => 19,
    };
    return '${baseMinutes + setup.invitedFriends.length} min';
  }

  String _visibilityFor(SummarySetting setting) => switch (setting) {
    SummarySetting.off => 'Summary was off for this room',
    SummarySetting.privateToMe => 'Only you can see this summary',
    SummarySetting.sharedWithRoom => 'Room members can see this summary',
  };

  List<String> _takeawaysFor(RoomSetupController setup, String topic) {
    final roomSpecific = switch (setup.selectedRoomType) {
      RoomSetupType.quickHangout =>
        'Friends kept the conversation light while still naming real trade-offs.',
      RoomSetupType.dailyDebate =>
        'The debate stayed centered on evidence instead of winning points.',
      RoomSetupType.studyTalk =>
        'The room turned the topic into clearer study notes and examples.',
      RoomSetupType.custom =>
        'The custom room left space for different angles and personal context.',
    };
    final aiLine = setup.selectedAIMode == AIMode.off
        ? 'AI was off in the live room; this mock summary uses allowed room metadata only.'
        : '${setup.selectedAIMode.roomLabel} helped keep the recap structured after the room.';

    return ['The room focused on "$topic".', roomSpecific, aiLine];
  }

  List<String> _bestArgumentsFor(RoomSetupController setup, String topic) {
    return [
      'One strong side asked what benefits people gain when "$topic" works well.',
      'The opposing side named what could break trust, access, or fairness.',
      if (setup.selectedAIMode == AIMode.brainstormer)
        'Brainstormer mode pushed the room toward comparing trade-offs instead of picking a winner.',
    ];
  }

  List<String> _funnyMomentsFor(RoomSetupController setup) {
    return switch (setup.selectedRoomType) {
      RoomSetupType.quickHangout => [
        'Someone tried to make a serious point, then admitted they mostly wanted better snacks.',
      ],
      RoomSetupType.dailyDebate => [
        'The room briefly agreed that every debate improves when nobody says "it depends" too early.',
      ],
      RoomSetupType.studyTalk => [
        'The best example somehow became a group project about pizza toppings.',
      ],
      RoomSetupType.custom => [
        'The custom topic took one unexpected detour, then found its way back.',
      ],
    };
  }

  List<String> _openQuestionsFor(String topic) {
    return [
      'What evidence would make each side update their view on "$topic"?',
      'Who is most affected by the decision, and did they get represented fairly?',
    ];
  }
}
