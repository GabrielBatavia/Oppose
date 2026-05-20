import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';

class SafetyController extends ChangeNotifier {
  SafetyController({required this.analytics});

  final AnalyticsService analytics;

  ReportTarget target = const ReportTarget.general();
  ReportReason? selectedReason;
  String details = '';
  bool alsoBlock = false;
  bool submitted = false;
  String returnRoute = '/home';

  final Set<String> _blockedUserIds = <String>{};
  final Set<String> _mutedUserIds = <String>{};

  Set<String> get blockedUserIds => Set.unmodifiable(_blockedUserIds);

  Set<String> get mutedUserIds => Set.unmodifiable(_mutedUserIds);

  bool get canSubmit => selectedReason != null;

  bool get targetBlocked => target.isUser && isBlocked(target.id);

  bool isBlocked(String userId) => _blockedUserIds.contains(userId);

  bool isMuted(String userId) => _mutedUserIds.contains(userId);

  void prepareReport({
    required ReportTarget target,
    required String returnRoute,
  }) {
    this.target = target;
    this.returnRoute = returnRoute;
    selectedReason = null;
    details = '';
    alsoBlock = target.isUser && isBlocked(target.id);
    submitted = false;
    unawaited(
      analytics.track('report_flow_opened', {
        'target_id': target.id,
        'target_type': target.type.name,
        'source': target.source,
      }),
    );
    notifyListeners();
  }

  void selectReason(ReportReason reason) {
    selectedReason = reason;
    notifyListeners();
  }

  void setDetails(String value) {
    details = value;
    notifyListeners();
  }

  void setAlsoBlock(bool value) {
    if (!target.isUser) return;
    alsoBlock = value;
    notifyListeners();
  }

  bool submitReport() {
    if (selectedReason == null) return false;
    if (target.isUser && alsoBlock) {
      _blockedUserIds.add(target.id);
    }
    submitted = true;
    unawaited(
      analytics.track('report_submitted', {
        'target_id': target.id,
        'target_type': target.type.name,
        'source': target.source,
        'reason': selectedReason!.name,
        'has_details': details.trim().isNotEmpty,
        'also_blocked': target.isUser && alsoBlock,
      }),
    );
    notifyListeners();
    return true;
  }

  void toggleMuted(String userId) {
    if (_mutedUserIds.contains(userId)) {
      _mutedUserIds.remove(userId);
    } else {
      _mutedUserIds.add(userId);
    }
    unawaited(
      analytics.track('mock_user_mute_toggled', {
        'user_id': userId,
        'is_muted': _mutedUserIds.contains(userId),
      }),
    );
    notifyListeners();
  }

  void blockUser(String userId) {
    _blockedUserIds.add(userId);
    unawaited(analytics.track('mock_user_blocked', {'user_id': userId}));
    notifyListeners();
  }

  void unblockUser(String userId) {
    _blockedUserIds.remove(userId);
    unawaited(analytics.track('mock_user_unblocked', {'user_id': userId}));
    notifyListeners();
  }

  void unmuteUser(String userId) {
    _mutedUserIds.remove(userId);
    unawaited(analytics.track('mock_user_unmuted', {'user_id': userId}));
    notifyListeners();
  }

  String reportTitle() {
    return switch (target.type) {
      ReportTargetType.user => 'Report ${target.displayName}',
      ReportTargetType.room => 'Report this room',
      ReportTargetType.chat => 'Report this chat',
      ReportTargetType.general => 'Report a problem',
    };
  }
}

extension ReportReasonPresentation on ReportReason {
  String get label => switch (this) {
    ReportReason.harassment => 'Harassment',
    ReportReason.spam => 'Spam',
    ReportReason.unsafeBehavior => 'Unsafe behavior',
    ReportReason.hateOrDiscrimination => 'Hate or discrimination',
    ReportReason.privacyConcern => 'Privacy concern',
    ReportReason.other => 'Other',
  };

  String get description => switch (this) {
    ReportReason.harassment =>
      'Insults, threats, pressure, or repeated targeting.',
    ReportReason.spam => 'Repeated, irrelevant, or unwanted messages.',
    ReportReason.unsafeBehavior =>
      'Self-harm concern, threats, coercion, or danger.',
    ReportReason.hateOrDiscrimination =>
      'Attacks based on identity, background, or protected traits.',
    ReportReason.privacyConcern =>
      'Personal information was shared or requested.',
    ReportReason.other => 'Something else that made the space feel unsafe.',
  };
}
