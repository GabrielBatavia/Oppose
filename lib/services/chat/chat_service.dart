import '../../types/domain_models.dart';

abstract class ChatService {
  Future<List<Conversation>> getConversations();

  Future<List<Message>> getMessages(String conversationId);

  Future<Message> sendMessage({
    required String conversationId,
    required String body,
  });

  Future<void> markRead(String conversationId);
}
