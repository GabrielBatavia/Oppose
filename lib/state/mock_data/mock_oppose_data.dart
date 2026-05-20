import '../../assets/oppose_assets.dart';
import '../../types/domain_models.dart';

class MockOpposeData {
  const MockOpposeData._();

  static const currentUser = OpposeUser(
    id: 'user_bima_friend',
    username: 'thinkwithbima',
    displayName: "Bima's Friend",
    interests: ['Technology', 'Friendship', 'Food'],
  );

  static const friends = <Friend>[
    Friend(
      id: 'maya',
      displayName: 'Maya',
      username: 'mayaTalks',
      status: FriendStatus.online,
      avatarAsset: OpposeAssets.avatarMaya,
    ),
    Friend(
      id: 'raka',
      displayName: 'Raka',
      username: 'rakaReplies',
      status: FriendStatus.inRoom,
      avatarAsset: OpposeAssets.avatarRaka,
    ),
    Friend(
      id: 'sari',
      displayName: 'Sari',
      username: 'sariNotes',
      status: FriendStatus.typing,
    ),
  ];

  static const friendRequests = <FriendRequest>[
    FriendRequest(
      id: 'nadia',
      displayName: 'Nadia',
      username: 'nadiaNuance',
      status: FriendRequestStatus.pending,
    ),
    FriendRequest(
      id: 'dito',
      displayName: 'Dito',
      username: 'ditoDebates',
      status: FriendRequestStatus.pending,
    ),
  ];

  static const conversations = <Conversation>[
    Conversation(
      id: 'maya_direct',
      type: ConversationType.direct,
      title: 'Maya',
      participantNames: ['Maya'],
      lastMessage: 'Should we make this a room?',
      updatedLabel: '2m',
      unreadCount: 2,
    ),
    Conversation(
      id: 'study_room',
      type: ConversationType.group,
      title: 'Study Room',
      participantNames: ['Maya', 'Raka', 'Sari'],
      lastMessage: 'AI can help summarize both sides.',
      updatedLabel: '12m',
    ),
    Conversation(
      id: 'weekend_debate',
      type: ConversationType.room,
      title: 'Weekend Debate',
      participantNames: ['Raka', 'Maya'],
      lastMessage: 'Remote work or office days?',
      updatedLabel: '1h',
      unreadCount: 1,
    ),
  ];

  static const messages = <Message>[
    Message(
      id: 'm1',
      conversationId: 'maya_direct',
      senderName: 'Maya',
      senderType: SenderType.user,
      body: 'I think remote work helps people focus.',
      createdLabel: '10:22',
      status: MessageStatus.read,
    ),
    Message(
      id: 'm2',
      conversationId: 'maya_direct',
      senderName: "Bima's Friend",
      senderType: SenderType.user,
      body: 'True, but office days make collaboration easier.',
      createdLabel: '10:24',
      status: MessageStatus.delivered,
    ),
    Message(
      id: 'm3',
      conversationId: 'maya_direct',
      senderName: 'AI Helper',
      senderType: SenderType.ai,
      body: 'Want a balanced question for a room?',
      createdLabel: '10:24',
      status: MessageStatus.sent,
    ),
  ];

  static const aiState = AIState(
    mode: AIMode.quietHelper,
    status: AIStatusValue.notListening,
    memoryEnabled: false,
    canListen: false,
    consentAccepted: true,
  );

  static const room = Room(
    id: 'remote_work_room',
    title: 'Remote Work Debate',
    topic: 'Is remote work good for the future?',
    privacy: RoomPrivacy.friendsOnly,
    status: RoomStatus.lobby,
    aiMode: AIMode.quietHelper,
    summarySetting: SummarySetting.privateToMe,
    participants: [
      RoomParticipant(
        id: 'maya',
        displayName: 'Maya',
        role: 'Friend',
        isSpeaking: true,
      ),
      RoomParticipant(id: 'raka', displayName: 'Raka', role: 'Friend'),
      RoomParticipant(id: 'you', displayName: 'You', role: 'Host'),
      RoomParticipant(
        id: 'ai_bima',
        displayName: 'AI Bima',
        role: 'Quiet Helper',
        isAI: true,
      ),
    ],
  );

  static const summary = RoomSummary(
    id: 'summary_remote_work',
    roomId: 'remote_work_room',
    title: 'Remote Work Debate',
    durationLabel: '24 min',
    visibility: 'Only you can see this summary',
    takeaways: [
      'Remote work helps focus and flexibility.',
      'Office days can improve trust and fast collaboration.',
    ],
    bestArguments: [
      'Flexibility supports different family and commute situations.',
      'Hybrid work may preserve connection without forcing one style.',
    ],
    funnyMoments: ['Everyone agreed snacks improve any work model.'],
    openQuestions: ['What work should always happen face to face?'],
  );

  static const profileBadges = <ProfileBadge>[
    ProfileBadge(label: 'Good Listener', description: 'Gives people room.'),
    ProfileBadge(label: 'Respect Champion', description: 'Keeps talks kind.'),
    ProfileBadge(label: 'Open Mind', description: 'Changes when convinced.'),
  ];

  static const interests = <String>[
    'School',
    'Technology',
    'Music',
    'Friendship',
    'Gaming',
    'Food',
    'Culture',
    'Movies',
    'Life',
    'Random Takes',
  ];
}
