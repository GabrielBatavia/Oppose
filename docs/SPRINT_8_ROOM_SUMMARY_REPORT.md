# Oppose Sprint 8 Room Summary MVP Report

Date: 2026-05-19

## Sprint Goal

Turn Room Summary from a static mock screen into a dynamic, privacy-aware post-room recap that reflects the room setup and closes the first core loop.

Target flow:

`Create Room -> Room Lobby -> Live Voice Room -> Leave -> Room Summary -> save / share / delete / return home`

This sprint stayed frontend/mock-state only. No real transcription, AI summarization, backend persistence, notifications, or room-history storage was added.

## Build Split

### Sprint 8a: Shared Summary State

Added app-level summary state.

Built:

- `RoomSummaryController`
- `RoomSummaryScope`
- summary generation from `RoomSetupController`
- save/share/delete mock state
- action feedback copy
- summary view tracking placeholder
- per-room summary state reset when room configuration changes

### Sprint 8b: Dynamic Summary Content

Replaced the static summary with generated mock content based on current room setup.

Summary now reflects:

- room title
- room type
- topic
- selected AI mode
- selected summary privacy setting
- invited friend count through mock duration

Generated sections:

- Main takeaways
- Best arguments
- Funny moments
- Open questions

### Sprint 8c: Privacy And Actions

Added visible summary privacy state and user controls.

Built:

- `Summary: Private to me` / `Summary: Shared with room` / `Summary: Summary Off` visibility chips
- `Memory Off` reminder
- `Not saved yet` / `Saved` status
- `Private to you` / `Shared with room` status
- Save summary action
- Share with room action
- Delete summary action
- Summary Off empty state
- Back to home action when no summary exists

### Sprint 8d: Summary Off Path

Room Summary now respects `Summary Off` from room creation.

When Summary Off is selected:

- no generated sections are shown
- the screen says no summary was generated
- the header status shows `AI Off`
- the user can return home

## Important Files Changed

- `lib/app/oppose_app.dart`
- `lib/features/room/room_summary_screen.dart`
- `lib/state/room_summary/room_summary_controller.dart`
- `lib/state/room_summary/room_summary_scope.dart`
- `test/widget_test.dart`
- `README.md`

## Acceptance Criteria Status

- Room Summary uses current room title: done.
- Room Summary uses current room topic: done.
- Room Summary reflects room type: done.
- Room Summary reflects selected AI mode: done.
- Room Summary reflects summary privacy setting: done.
- Room Summary shows dynamic takeaways, arguments, moments, and open questions: done.
- Save action updates UI: done.
- Share action updates UI: done.
- Delete action hides generated summary: done.
- Summary Off shows no generated summary: done.
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
- `flutter test`: passed, 15 tests.

Widget coverage includes:

- Existing onboarding/home/messaging/room setup/live room/AI drawer paths.
- Custom room topic appears in Room Summary.
- Selected room type appears in Room Summary.
- Selected AI mode appears in Room Summary.
- Summary privacy appears in Room Summary.
- Generated mock takeaways appear.
- Save summary updates UI.
- Share summary updates UI.
- Delete summary removes generated sections.
- Summary Off path shows no generated summary and returns home.

## Known Limitations

- No real room transcript.
- No real AI summary generation.
- No persistence for saved summaries.
- No actual room-member sharing.
- No notification fanout.
- No summary history list.
- Mock duration is derived from room type and invited friend count.
- Mock generated text is generic and should be replaced when real transcript and AI services exist.

## Next Sprint Recommendation

Start Sprint 9: Safety/Reporting MVP.

Recommended Sprint 9 scope:

- Expand report flow beyond placeholder copy.
- Add report reasons, details input, and confirmation state.
- Add block/mute affordances for friends or room participants.
- Add post-report safety guidance.
- Add tests for reporting, blocking, and safe navigation back to room/home.
