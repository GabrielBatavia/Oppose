import '../../types/domain_models.dart';

abstract class AIService {
  Future<void> updateConsent(bool accepted);

  Future<AIState> setAIMode(AIMode mode);

  Future<Message> askAI({
    required String prompt,
    String? roomId,
    String? conversationId,
  });

  Future<RoomSummary> summarizeRoom(String roomId);

  Future<AIState> turnOffAI(String roomId);

  Future<bool> getMemoryState();

  Future<void> deleteSummary(String summaryId);
}
