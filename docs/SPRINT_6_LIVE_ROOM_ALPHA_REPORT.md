# Oppose Sprint 6 Live Voice Room UI Alpha Report

Date: 2026-05-18

## Sprint Goal

Turn Live Voice Room from a basic mock room into a usable live-room interface with visible participants, AI state, mute/leave controls, connection state, and placeholders for chat/invite.

Target flow:

`Create Room -> Room Lobby -> Live Voice Room -> Ask AI / Chat / Invite / Mute / Leave -> Room Summary`

This sprint stayed frontend/mock-state only. No real WebRTC, audio streaming, SFU, realtime presence, or backend was added.

## Build Split

### Sprint 6a: Live Room State, Data, And Analytics

Added shared live-room state to the app shell.

Built:

- `LiveRoomController`
- `LiveRoomScope`
- active speaker state
- local muted state
- connection state
- participant list derived from `RoomSetupController`
- AI participant visibility based on selected AI mode

Connection states:

- stable / `Good connection`
- reconnecting / `Reconnecting`
- poor / `Poor connection`

Analytics placeholder events:

- `room_joined`
- `room_left`
- `mute_toggled`
- `invite_clicked`
- `connection_state_changed`
- `ai_drawer_opened`
- `room_chat_opened`
- `leave_confirmation_viewed`

### Sprint 6b: Live Room Layout Polish

Replaced the previous Live Voice Room screen with a composed room UI.

Built:

- room title from setup state
- privacy pill: `Friends only`
- AI status pill: `AI Listening` or `AI Off`
- participant grid
- active speaker visual state
- AI Bima visually distinct and labeled as AI
- topic card using setup state
- connection status pill

Components added:

- `RoomParticipantCard`
- `SpeakingIndicator`
- `RoomTopicCard`
- `ConnectionStatusPill`
- `RoomPrivacyPill`

### Sprint 6c: Bottom Control Bar

Replaced loose action chips with a stable room control bar.

Built:

- `RoomControlBar`
- `RoomControlButton`
- Mute/Muted toggle
- Chat control
- Ask AI control
- AI Off disabled state
- Invite control
- always-visible Leave danger control

### Sprint 6d: Room Chat, Invite, And Leave Sheets

Added lightweight placeholders for room surfaces.

Built:

- `RoomChatSheet`
- `RoomInviteSheet`
- `LeaveRoomSheet`
- scroll-safe shared bottom sheet behavior
- Leave confirmation route to Room Summary

### Sprint 6e: Mock Speaker And Connection Controls

Added safe mock controls for testability before realtime infrastructure exists.

Built:

- participant card tap updates active speaker
- `Mock room state` card
- connection state chips for Good/Reconnecting/Poor

## Important Files Changed

- `lib/app/oppose_app.dart`
- `lib/components/core/oppose_bottom_sheet.dart`
- `lib/features/room/live_voice_room_screen.dart`
- `lib/features/room/widgets/`
- `lib/state/live_room/live_room_controller.dart`
- `lib/state/live_room/live_room_scope.dart`
- `test/widget_test.dart`

## Acceptance Criteria Status

- Live room feels like a real audio room shell: done.
- Room title, topic, privacy, AI state, participants, speaking state, and connection state are visible: done.
- User can toggle mute: done.
- User can open AI Drawer: done.
- User can open chat and invite placeholders: done.
- User can leave via visible danger action: done.
- AI Bima is visually distinct and labeled as AI: done.
- AI Off state is respected when selected during room setup: done.
- Controls use native Flutter widgets: done.
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

- Existing onboarding/home/messaging/room setup paths.
- Live Room renders configured room title and topic.
- AI participant appears when AI mode is active.
- AI participant is absent when AI mode is Off.
- Mute toggles to Muted.
- Connection state can switch to Reconnecting.
- Chat sheet opens.
- AI Drawer opens.
- Invite sheet opens.
- Leave confirmation opens and routes to Room Summary.

## Known Limitations

- No real microphone audio.
- No real WebRTC/SFU.
- No realtime speaking detection.
- No real room chat messages.
- No real invite notifications.
- No real connection telemetry.
- AI Drawer remains placeholder-level and will be Sprint 7's focus.
- Mock room state controls are visible in UI for alpha/testability and should be removed or hidden before production polish.

## Next Sprint Recommendation

Start Sprint 7: AI Drawer and AI Interaction Alpha.

Recommended Sprint 7 scope:

- Upgrade AI Drawer to use shared AI state.
- Add AI mode selector wired to room setup/live state.
- Add quick actions with mock responses.
- Add AI status transitions: Listening -> Thinking -> Speaking -> Listening.
- Add Turn off AI behavior that updates live room UI.
- Add Ask AI input and mock response handling.
- Add consent guard for AI actions.
- Connect Direct Chat Ask AI and Live Room Ask AI behavior if practical.
- Add widget tests for mode changes, quick actions, turn off AI, memory off visibility, and AI status transitions.
