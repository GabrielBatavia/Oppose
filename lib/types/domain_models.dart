enum FriendStatus { online, offline, inRoom, typing }

enum FriendRequestStatus { pending, accepted, declined }

enum ConversationType { direct, group, room }

enum MessageStatus { sending, sent, delivered, read, failed }

enum SenderType { user, ai, system }

enum RoomPrivacy { friendsOnly, private, publicLater }

enum RoomStatus { lobby, live, ended }

enum AIMode { off, quietHelper, brainstormer, translator, moderatorLite }

enum AIStatusValue {
  off,
  notListening,
  listening,
  thinking,
  speaking,
  summarizing,
  memoryOff,
}

enum SummarySetting { off, privateToMe, sharedWithRoom }

enum ReportTargetType { user, room, chat, general }

enum ReportReason {
  harassment,
  spam,
  unsafeBehavior,
  hateOrDiscrimination,
  privacyConcern,
  other,
}

class ReportTarget {
  const ReportTarget({
    required this.id,
    required this.displayName,
    required this.type,
    required this.source,
  });

  const ReportTarget.general()
    : id = 'general',
      displayName = 'a problem',
      type = ReportTargetType.general,
      source = 'unknown';

  final String id;
  final String displayName;
  final ReportTargetType type;
  final String source;

  bool get isUser => type == ReportTargetType.user;
}

class OpposeUser {
  const OpposeUser({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarAsset,
    this.language = 'en',
    this.interests = const [],
  });

  final String id;
  final String username;
  final String displayName;
  final String? avatarAsset;
  final String language;
  final List<String> interests;
}

class Friend {
  const Friend({
    required this.id,
    required this.displayName,
    required this.username,
    required this.status,
    this.avatarAsset,
    this.isBlocked = false,
  });

  final String id;
  final String displayName;
  final String username;
  final FriendStatus status;
  final String? avatarAsset;
  final bool isBlocked;
}

class FriendRequest {
  const FriendRequest({
    required this.id,
    required this.displayName,
    required this.username,
    required this.status,
    this.avatarAsset,
  });

  final String id;
  final String displayName;
  final String username;
  final FriendRequestStatus status;
  final String? avatarAsset;
}

class Conversation {
  const Conversation({
    required this.id,
    required this.type,
    required this.title,
    required this.participantNames,
    required this.lastMessage,
    required this.updatedLabel,
    this.unreadCount = 0,
  });

  final String id;
  final ConversationType type;
  final String title;
  final List<String> participantNames;
  final String lastMessage;
  final String updatedLabel;
  final int unreadCount;
}

class Message {
  const Message({
    required this.id,
    required this.conversationId,
    required this.senderName,
    required this.senderType,
    required this.body,
    required this.createdLabel,
    required this.status,
  });

  final String id;
  final String conversationId;
  final String senderName;
  final SenderType senderType;
  final String body;
  final String createdLabel;
  final MessageStatus status;

  bool get isAI => senderType == SenderType.ai;
}

class RoomParticipant {
  const RoomParticipant({
    required this.id,
    required this.displayName,
    required this.role,
    this.avatarAsset,
    this.isAI = false,
    this.isSpeaking = false,
    this.isMuted = false,
  });

  final String id;
  final String displayName;
  final String role;
  final String? avatarAsset;
  final bool isAI;
  final bool isSpeaking;
  final bool isMuted;
}

class Room {
  const Room({
    required this.id,
    required this.title,
    required this.topic,
    required this.privacy,
    required this.status,
    required this.aiMode,
    required this.summarySetting,
    required this.participants,
  });

  final String id;
  final String title;
  final String topic;
  final RoomPrivacy privacy;
  final RoomStatus status;
  final AIMode aiMode;
  final SummarySetting summarySetting;
  final List<RoomParticipant> participants;
}

class AIState {
  const AIState({
    required this.mode,
    required this.status,
    required this.memoryEnabled,
    required this.canListen,
    required this.consentAccepted,
  });

  final AIMode mode;
  final AIStatusValue status;
  final bool memoryEnabled;
  final bool canListen;
  final bool consentAccepted;
}

class RoomSummary {
  const RoomSummary({
    required this.id,
    required this.roomId,
    required this.title,
    required this.durationLabel,
    required this.visibility,
    required this.takeaways,
    required this.bestArguments,
    required this.funnyMoments,
    required this.openQuestions,
  });

  final String id;
  final String roomId;
  final String title;
  final String durationLabel;
  final String visibility;
  final List<String> takeaways;
  final List<String> bestArguments;
  final List<String> funnyMoments;
  final List<String> openQuestions;
}

class ProfileBadge {
  const ProfileBadge({required this.label, required this.description});

  final String label;
  final String description;
}
