# Oppose Sprint 4 Messaging MVP Report

Date: 2026-05-18

## Sprint Goal

Turn Chats List and Direct Chat from lightweight mock screens into a usable messaging MVP:

`Home -> Recent Chat -> Direct Chat -> Send Message -> Ask AI / Start Room`

This sprint stayed frontend/mock-state only. No backend, realtime transport, push notifications, or persistence were added.

## Build Split

### Sprint 4a: Messaging State, Data, And Analytics

Added shared mock messaging state to the app shell.

Built:

- `MessagingController`
- `MessagingScope`
- selected/open conversation state
- search query state
- filtered conversation list
- local message list per conversation
- local send behavior
- failed-send placeholder support with `/fail`
- AI suggestion visibility state
- mock AI response append behavior
- new chat placeholder state

Analytics placeholder events:

- `chats_viewed`
- `chat_opened`
- `message_sent`
- `ai_suggestion_viewed`
- `ask_ai_from_chat_clicked`
- `start_room_from_chat_clicked`
- `new_chat_clicked`

### Sprint 4b: Chats List Polish

Replaced the previous static Chats List with a searchable dynamic list.

Built:

- Native search input filtering mock conversations.
- `ChatListItem` component.
- `ConversationTypePill` component.
- Unread badges.
- Direct/group/room type labels.
- Search-empty state.
- No-chats empty state path.
- Floating `New chat` placeholder.
- Chat tap opens Direct Chat using shared messaging state.

### Sprint 4c: Direct Chat Polish

Replaced the previous static Direct Chat with a reusable message UI.

Built:

- `DirectChatHeader`
- `ChatBubble`
- `AIMessageCard`
- `MessageInputBar`
- `QuickActionButton`
- incoming/outgoing message alignment
- AI-labeled messages
- message status labels
- local outgoing message append
- failed-send display when using `/fail`
- input clear after successful send

### Sprint 4d: AI And Room Hooks From Chat

Added mock AI and room actions without implying hidden AI listening.

Built:

- AI helper suggestion card with explicit copy: `AI responds only when asked. It is not listening in this chat.`
- `Ask AI` appends a clearly labeled AI response.
- AI suggestion hides after asking AI.
- `Start room` routes to Create Room.
- call icon routes to Room Lobby.
- Home recent-chat tap now selects the correct conversation in shared messaging state.

## Important Files Changed

- `lib/app/oppose_app.dart`
- `lib/features/chats/chats_list_screen.dart`
- `lib/features/chats/direct_chat_screen.dart`
- `lib/features/chats/widgets/`
- `lib/features/home/home_screen.dart`
- `lib/state/messaging/messaging_controller.dart`
- `lib/state/messaging/messaging_scope.dart`
- `test/widget_test.dart`

## Acceptance Criteria Status

- User can search chats: done.
- User can open a conversation: done.
- User can send a mock message locally: done.
- AI helper response is clearly labeled as AI: done.
- Start Room path exists from chat: done.
- Unread states are visible: done.
- Empty/search-empty states exist: done.
- No important UI text is baked into images: done.
- `flutter analyze` passes: done.
- `flutter test` passes: done.

## Verification

Commands run from `Oppose/`:

```bash
dart format lib test
flutter analyze
flutter test
```

Results:

- `flutter analyze`: passed with no issues.
- `flutter test`: passed.

Widget coverage includes:

- Welcome opens correctly.
- Full onboarding reaches Home.
- Home Agree/Oppose selection works.
- Home recent chat opens Direct Chat.
- Home Start Room opens Create Room.
- Bottom navigation opens Chats and Profile.
- Chats List renders conversations.
- Search filters conversations.
- Empty search state appears.
- Direct Chat sends a local message.
- Ask AI appends an AI-labeled response.
- Start Room from chat routes to Create Room.

## Known Limitations

- Messaging state is in-memory only.
- No real backend, realtime delivery, read receipts, or persistence.
- New chat flow is a placeholder.
- Attachments are placeholders.
- AI response is mock-only.
- Failed send is triggered by `/fail` and is local-only.
- Direct Chat route is still one route backed by selected mock conversation state.

## Next Sprint Recommendation

Start Sprint 5: Create Room and Room Lobby.

Recommended Sprint 5 scope:

- Polish Create Room against `docs/refrences/pages/Create Room.png`.
- Add room topic input state.
- Add room type selection.
- Add invite friend selector row.
- Add AI mode selection.
- Add summary privacy selection.
- Create mock room state.
- Polish Room Lobby against `docs/refrences/pages/Room Lobby.png`.
- Add mic-ready and permission-denied mock states.
- Add AI status card: `AI Quiet Helper / Not listening yet`.
- Add room rule card.
- Wire Join Room to Live Voice Room.
- Add widget tests for Create Room -> Lobby -> Live Room.
