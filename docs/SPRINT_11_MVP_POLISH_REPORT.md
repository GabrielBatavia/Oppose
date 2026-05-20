# Oppose Sprint 11 MVP Polish And Demo Readiness Report

Date: 2026-05-19

## Sprint Goal

Make the completed frontend/mock MVP more stable and demo-ready across the full flow:

`Onboarding -> Home -> Chats -> Create Room -> Lobby -> Live Room -> AI Drawer -> Safety -> Summary -> Profile`

This sprint focused on polish, route coverage, copy clarity, demo docs, and verification. It did not add new backend systems or major product surfaces.

## Build Split

### Sprint 11a: Route Smoke Coverage

Added widget smoke coverage for every MVP route.

Covered routes:

- `/welcome`
- `/sign-up`
- `/username-setup`
- `/interest-setup`
- `/ai-consent`
- `/home`
- `/chats`
- `/direct-chat`
- `/create-room`
- `/room-lobby`
- `/live-room`
- `/room-summary`
- `/profile`
- `/report`

Each route is visited through `GoRouter` and checked for primary native Flutter text.

### Sprint 11b: Copy And Mock-State Polish

Tightened user-facing copy around demo-only behavior.

Updated copy for:

- AI Drawer visibility and Memory Off behavior
- Report Flow local demo block behavior
- Report Flow backend-not-connected explanation
- Room Safety local mock report behavior
- Room Safety demo-only safety state
- Room Invite local demo state
- Live Room demo controls

### Sprint 11c: Alpha Control Labels

Renamed the Live Room mock controls card from `Mock room state` to `Demo room controls` and clarified that connection/speaker controls are local demo controls.

### Sprint 11d: Demo Documentation

Added demo-readiness docs.

Built:

- `docs/MVP_DEMO_CHECKLIST.md`
- `docs/MVP_KNOWN_LIMITATIONS.md`

The checklist covers:

- app run commands
- happy path demo
- AI Drawer demo
- Safety demo
- Room demo
- Summary demo
- Profile/social demo
- demo notes

Known limitations cover:

- no backend
- no persistence
- no real auth
- no real AI
- no real WebRTC/audio
- no real moderation submission
- no real social graph
- no real summary generation
- Android debug build tooling issue

## Important Files Changed

- `test/widget_test.dart`
- `lib/features/ai/ai_control_drawer.dart`
- `lib/features/safety/report_flow_screen.dart`
- `lib/features/room/widgets/mock_room_state_card.dart`
- `lib/features/room/widgets/room_safety_sheet.dart`
- `lib/features/room/widgets/room_invite_sheet.dart`
- `docs/MVP_DEMO_CHECKLIST.md`
- `docs/MVP_KNOWN_LIMITATIONS.md`
- `docs/SPRINT_11_MVP_POLISH_REPORT.md`
- `README.md`

## Acceptance Criteria Status

- All MVP routes have smoke coverage: done.
- Existing tests still pass: done.
- Mock/local/demo behavior is clearer in UI copy: done.
- Alpha controls are labeled as demo controls: done.
- Demo checklist exists: done.
- Known limitations are documented: done.
- README reflects Sprint 11 status: done.
- `flutter analyze` passes: done.
- `flutter test` passes: done.
- Optional debug APK build result is documented: done.

## Verification

Commands run from `Oppose/`:

```bash
dart format lib test
flutter analyze
flutter test
flutter build apk --debug
```

Results:

- `dart format lib test`: completed.
- `flutter analyze`: passed with no issues.
- `flutter test`: passed, 23 tests.
- `flutter build apk --debug`: failed due local Android NDK install corruption.

Debug APK failure detail:

```text
[CXX1101] NDK at C:\Users\GabrielBatavia\AppData\Local\Android\Sdk\ndk\28.2.13676358 did not have a source.properties file
```

Flutter suggested deleting the malformed local NDK copy at:

```text
C:\Users\GabrielBatavia\AppData\Local\Android\Sdk\ndk\28.2.13676358
```

and allowing Android Gradle Plugin to re-download it. Source validation is unaffected: analyze and tests pass.

## Known Limitations

See `docs/MVP_KNOWN_LIMITATIONS.md` for the full limitations list.

High-level limitations remain:

- no backend
- no persistence
- no real auth
- no real AI service
- no real WebRTC/audio
- no real moderation submission
- no real social graph
- Android debug APK build blocked by malformed local NDK install

## Next Sprint Recommendation

Start Sprint 12: Backend And Persistence Planning, or pause feature work and fix Android toolchain first.

Recommended options:

- Fix Android NDK and produce a debug APK.
- Add local persistence for onboarding/social/safety state.
- Plan backend contracts for auth, rooms, realtime voice, AI, reports, and social graph.
- Begin the first real service integration only after choosing the backend architecture.
