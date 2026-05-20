# Oppose Sprint 9 Safety And Reporting MVP Report

Date: 2026-05-19

## Sprint Goal

Add a frontend/mock-state safety layer so users can report problems, optionally block a reported user, mute room participants locally, and see clear confirmation before returning to the prior surface.

Target flows:

`Chats -> Open report flow -> choose reason -> submit -> confirmation -> Chats`

`Direct Chat -> Report -> choose reason -> also block -> submit -> confirmation -> Direct Chat blocked state`

`Live Voice Room -> Safety -> mute participant / report room -> confirmation -> Live Voice Room`

This sprint stayed frontend/mock-state only. No moderation backend, persistence, evidence upload, transcript attachment, emergency escalation, or admin review tooling was added.

## Build Split

### Sprint 9a: Shared Safety State

Added app-level safety state.

Built:

- `SafetyController`
- `SafetyScope`
- `ReportTargetType`
- `ReportTarget`
- selected report target
- selected report reason
- optional details note state
- optional block state for user targets
- submitted report confirmation state
- local blocked user IDs
- local muted user IDs
- analytics placeholder events

### Sprint 9b: Report Flow MVP

Replaced the local report screen with a shared-state report flow.

Built:

- dynamic report title based on target
- target context card
- enum-backed reason selector using `ReportReason`
- reason helper descriptions
- optional note input
- `Also block` toggle for user targets only
- private-report explainer copy
- submit disabled until reason selection
- confirmation state after submit
- return to source action
- go home action

### Sprint 9c: Direct Chat Safety

Added Direct Chat report and block handling.

Built:

- `Report` quick action in Direct Chat
- report target for Maya in the current direct chat
- optional block during report submission
- blocked-state card in Direct Chat
- local message sending disabled when blocked
- `Blocked` pill in Chats List for blocked direct chat

### Sprint 9d: Live Room Safety

Added a Live Room safety surface.

Built:

- `RoomSafetySheet`
- `Safety` room control
- `Report room` action
- participant mute/unmute actions
- participant report actions
- muted participant state reflected in participant cards
- local mock safety explainer copy

### Sprint 9e: Profile Safety Center

Added a lightweight safety card to Profile.

Built:

- blocked count
- muted count
- generic report entry point
- local mock-state explanation

## Important Files Changed

- `lib/app/oppose_app.dart`
- `lib/types/domain_models.dart`
- `lib/state/safety/safety_controller.dart`
- `lib/state/safety/safety_scope.dart`
- `lib/features/safety/report_flow_screen.dart`
- `lib/features/chats/direct_chat_screen.dart`
- `lib/features/chats/chats_list_screen.dart`
- `lib/features/chats/widgets/chat_list_item.dart`
- `lib/features/room/live_voice_room_screen.dart`
- `lib/features/room/widgets/room_control_bar.dart`
- `lib/features/room/widgets/room_safety_sheet.dart`
- `lib/features/profile/my_profile_screen.dart`
- `test/widget_test.dart`
- `README.md`

## Acceptance Criteria Status

- User can open Report Flow from Chats: done.
- User can open reporting from Direct Chat: done.
- User can open safety/reporting from Live Room: done.
- User can select a reason and submit: done.
- Submit shows confirmation instead of instantly navigating away: done.
- User can optionally block a reported user: done.
- Direct Chat reflects blocked state: done.
- Chats List shows blocked state: done.
- User can mute a live room participant in mock state: done.
- UI clearly says safety state is local/mock where applicable: done.
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
- `flutter test`: passed, 18 tests.

Widget coverage includes:

- Existing onboarding/home/messaging/room setup/live room/AI drawer/summary paths.
- Generic report from Chats submits and returns to Chats.
- Direct Chat report can block Maya.
- Direct Chat shows blocked state after reporting.
- Chats List shows blocked pill.
- Live Room Safety sheet opens.
- Live Room participant mute updates UI.
- Live Room room report submits and returns to Live Room.

## Known Limitations

- No real report submission API.
- No persisted block or mute list.
- No moderation review queue.
- No evidence attachments.
- No transcript or audio evidence capture.
- No emergency escalation flow.
- No unblock management screen yet.
- Safety state resets when the app restarts.

## Next Sprint Recommendation

Start Sprint 10: Profile And Social Graph MVP.

Recommended Sprint 10 scope:

- Expand profile beyond static mock stats.
- Add friends list and friend status surfaces.
- Add invite/friend management mock state.
- Add blocked/muted management from Profile Safety Center.
- Add tests for friend list, profile state, and safety management.
