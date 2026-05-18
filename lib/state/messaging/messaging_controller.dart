import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../services/analytics/analytics_service.dart';
import '../../types/domain_models.dart';
import '../mock_data/mock_oppose_data.dart';

class MessagingController extends ChangeNotifier {
  MessagingController({required this.analytics}) {
    _messagesByConversation = {
      for (final conversation in _conversations)
        conversation.id: MockOpposeData.messages
            .where((message) => message.conversationId == conversation.id)
            .toList(),
    };
  }

  final AnalyticsService analytics;

  final List<Conversation> _conversations = List.of(
    MockOpposeData.conversations,
  );
  late final Map<String, List<Message>> _messagesByConversation;

  String selectedConversationId = 'maya_direct';
  String searchQuery = '';
  bool aiSuggestionVisible = true;
  bool newChatPlaceholderVisible = false;
  int _messageCounter = 100;
  bool _chatsViewed = false;

  List<Conversation> get conversations => List.unmodifiable(_conversations);

  List<Conversation> get filteredConversations {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return conversations;

    return _conversations
        .where((conversation) {
          final searchable = [
            conversation.title,
            conversation.lastMessage,
            ...conversation.participantNames,
            conversation.type.name,
          ].join(' ').toLowerCase();
          return searchable.contains(query);
        })
        .toList(growable: false);
  }

  Conversation get selectedConversation {
    return _conversations.firstWhere(
      (conversation) => conversation.id == selectedConversationId,
      orElse: () => _conversations.first,
    );
  }

  List<Message> get selectedMessages => List.unmodifiable(
    _messagesByConversation[selectedConversation.id] ?? const [],
  );

  void trackChatsViewedOnce() {
    if (_chatsViewed) return;
    _chatsViewed = true;
    unawaited(analytics.track('chats_viewed', {'source': 'main_tab'}));
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void openConversation(String conversationId) {
    selectedConversationId = conversationId;
    final conversation = selectedConversation;
    unawaited(
      analytics.track('chat_opened', {
        'conversation_id': conversation.id,
        'conversation_type': conversation.type.name,
      }),
    );
    notifyListeners();
  }

  void showNewChatPlaceholder() {
    newChatPlaceholderVisible = true;
    unawaited(analytics.track('new_chat_clicked', {'source': 'chats_list'}));
    notifyListeners();
  }

  void dismissNewChatPlaceholder() {
    newChatPlaceholderVisible = false;
    notifyListeners();
  }

  void trackAISuggestionViewed() {
    if (!aiSuggestionVisible) return;
    unawaited(
      analytics.track('ai_suggestion_viewed', {
        'conversation_id': selectedConversation.id,
      }),
    );
  }

  bool sendMessage(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return false;

    final status = trimmed.contains('/fail')
        ? MessageStatus.failed
        : MessageStatus.sent;
    final message = Message(
      id: 'local_${_messageCounter++}',
      conversationId: selectedConversation.id,
      senderName: MockOpposeData.currentUser.displayName,
      senderType: SenderType.user,
      body: trimmed.replaceAll('/fail', '').trim().isEmpty
          ? 'This message failed to send.'
          : trimmed.replaceAll('/fail', '').trim(),
      createdLabel: 'Now',
      status: status,
    );
    _messagesByConversation
        .putIfAbsent(selectedConversation.id, () => [])
        .add(message);
    unawaited(
      analytics.track('message_sent', {
        'conversation_id': selectedConversation.id,
        'status': status.name,
      }),
    );
    notifyListeners();
    return status != MessageStatus.failed;
  }

  void askAI() {
    aiSuggestionVisible = false;
    _messagesByConversation
        .putIfAbsent(selectedConversation.id, () => [])
        .add(
          Message(
            id: 'ai_${_messageCounter++}',
            conversationId: selectedConversation.id,
            senderName: 'AI Helper',
            senderType: SenderType.ai,
            body:
                'Try asking: What is one strong reason for each side, and what would change your mind?',
            createdLabel: 'Now',
            status: MessageStatus.sent,
          ),
        );
    unawaited(
      analytics.track('ask_ai_from_chat_clicked', {
        'conversation_id': selectedConversation.id,
      }),
    );
    notifyListeners();
  }

  void startRoomFromChat() {
    unawaited(
      analytics.track('start_room_from_chat_clicked', {
        'conversation_id': selectedConversation.id,
      }),
    );
  }
}
