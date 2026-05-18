import '../../types/domain_models.dart';

abstract class ModerationService {
  Future<void> submitReport({
    required String targetId,
    required ReportReason reason,
    String? note,
    bool alsoBlock = false,
  });

  Future<void> blockUser(String userId);

  Future<void> muteParticipant(String participantId);

  Future<void> removeParticipant(String participantId);
}
