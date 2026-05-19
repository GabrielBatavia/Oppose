# Oppose Sprint 5 Room Setup Report

Date: 2026-05-18

## Sprint Goal

Turn Create Room and Room Lobby into a usable mock setup flow:

`Home/Chat -> Create Room -> Configure Topic/Friends/AI/Summary -> Room Lobby -> Join Live Room`

This sprint stayed frontend/mock-state only. No backend, WebRTC, real mic permission request, audio route detection, or persistence was added.

## Build Split

### Sprint 5a: Room Setup State, Data, And Analytics

Added shared room setup state to the app shell.

Built:

- `RoomSetupController`
- `RoomSetupScope`
- room topic state
- selected room type state
- invited friends state
- selected AI mode state
- selected summary privacy state
- mic readiness mock state
- audio route mock state
- lobby/live room carry-through getters

Room setup options:

- Quick Hangout
- Daily Debate
- Study Talk
- Custom
- AI Off
- AI Quiet Helper
- AI Brainstormer
- AI Moderator-lite
- Summary Off
- Private to me
- Shared with room

Analytics placeholder events:

- `create_room_viewed`
- `room_type_selected`
- `friend_invited`
- `ai_mode_selected`
- `summary_setting_selected`
- `room_created`
- `room_lobby_viewed`
- `mic_state_changed`
- `room_joined`
- `invite_clicked`
- `ai_settings_changed_from_lobby`

### Sprint 5b: Create Room Polish

Replaced the Sprint 1 Create Room stub with an interactive setup screen.

Built:

- room topic input
- room type cards
- invite friend selector row
- AI mode cards
- summary privacy cards
- Start Room state handoff to Lobby
- selected states with mint/checkmark affordance
- Bima/room assets and warm paper-card layout

Components added:

- `CreateRoomSection`
- `RoomTypeCard`
- `AIModeCard`
- `SummaryPrivacyCard`
- `InviteFriendSelector`

### Sprint 5c: Room Lobby Polish

Replaced the Sprint 1 Room Lobby stub with a stateful pre-join screen.

Built:

- room title and topic from Create Room
- selected room type pill
- selected summary privacy pill
- invited friend preview
- invite more slot
- mic test card
- mock mic ready / permission denied toggle
- audio route dropdown
- AI status card
- explicit `Not listening yet` state
- required copy that AI is not listening before joining
- room rule card: `Challenge ideas, not people.`
- Join Room route to Live Voice Room

Components added:

- `LobbyFriendPreview`
- `MicTestCard`
- `AudioRouteSelector`
- `LobbyAIStatusCard`
- `RoomRuleCard`

### Sprint 5d: Bottom Sheets And Route Stabilization

Added lobby bottom sheets and carried setup state into Live Voice Room.

Built:

- `InviteFriendsSheet`
- `LobbyAISettingsSheet`
- lobby AI mode changes update the shared setup state
- lobby invite flow updates selected friends
- Live Voice Room now uses setup title, topic, invited friends, and AI mode
- AI participant is omitted from Live Room when AI mode is Off

## Important Files Changed

- `lib/app/oppose_app.dart`
- `lib/assets/oppose_assets.dart`
- `lib/features/room/create_room_screen.dart`
- `lib/features/room/room_lobby_screen.dart`
- `lib/features/room/live_voice_room_screen.dart`
- `lib/features/room/widgets/`
- `lib/state/room_setup/room_setup_controller.dart`
- `lib/state/room_setup/room_setup_scope.dart`
- `test/widget_test.dart`

## Acceptance Criteria Status

- User can configure a mock room: done.
- User can select room type, friends, AI mode, and summary privacy: done.
- User can start room and see choices in Lobby: done.
- Lobby clearly states AI is not listening yet: done.
- Mic and audio route state are visible: done.
- Join Room path reaches Live Voice Room: done.
- Safety/social room rule is visible: done.
- Controls are native Flutter widgets: done.
- Important text is native text: done.
- No reference page is used as a static background: done.
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

- Existing onboarding/home/messaging paths.
- Create Room renders room choices.
- Room topic input updates state.
- Room type selection carries into Lobby.
- AI mode selection carries into Lobby.
- Summary privacy selection carries into Lobby.
- Friend invite selection carries into Lobby.
- Mic mock state toggles.
- Lobby AI settings bottom sheet updates AI mode.
- Join Room reaches Live Voice Room with configured topic/title.

## Known Limitations

- Room setup state is in-memory only.
- No backend room creation.
- No real WebRTC/SFU.
- No real microphone permission request.
- No real audio route detection.
- Invite flow is local/mock only.
- AI settings are local/mock only.

## Next Sprint Recommendation

Start Sprint 6: Live Voice Room UI Alpha.

Recommended Sprint 6 scope:

- Polish Live Voice Room against `docs/refrences/pages/Live Voice Room.png`.
- Add participant grid with clearer active speaker state.
- Add local mute state and stronger muted visuals.
- Add AI status pill states: Listening / Off.
- Add privacy pill.
- Add topic card with selected room setup.
- Add connection status variants: stable, reconnecting, poor connection.
- Add bottom control bar for Mute, Chat, Ask AI, Invite, Leave.
- Add room chat placeholder drawer.
- Add invite modal placeholder.
- Add leave confirmation or summary route.
- Add widget tests for mute, Ask AI drawer open, invite placeholder, connection state, and leave flow.
