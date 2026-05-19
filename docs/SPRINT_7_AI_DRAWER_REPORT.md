# Oppose Sprint 7 AI Drawer And AI Interaction Alpha Report

Date: 2026-05-19

## Sprint Goal

Turn the AI Drawer from a placeholder into a consent-aware, visible, user-controlled AI interaction surface for Live Voice Room.

Target flow:

`Live Voice Room -> Ask AI -> choose mode / quick action / prompt -> mock AI response -> Turn off AI -> Live Room updates`

This sprint stayed frontend/mock-state only. No real AI model, transcription, translation, backend memory, hidden listening, or realtime audio integration was added.

## Build Split

### Sprint 7a: Shared AI Interaction State

Added app-level AI interaction state.

Built:

- `AIInteractionController`
- `AIInteractionScope`
- shared AI mode and status
- prompt draft state
- latest mock response state
- Memory Off state
- AI Off state
- analytics placeholder events

Mock AI status transitions:

- `AI Listening`
- `AI Thinking`
- `AI Speaking`
- `AI Listening`

### Sprint 7b: Upgraded AI Drawer

Replaced the placeholder drawer with a composed AI control surface.

Built:

- status pill
- mode selector
- quick action chips
- Memory Off card
- Ask AI prompt input
- AI response card
- Turn off AI action
- consent guard copy when AI consent is missing

Components added:

- `AIModeSelector`
- `AIQuickActionGrid`
- `AIMemoryCard`
- `AIResponseCard`

### Sprint 7c: Mock AI Interaction

Added local-only AI interaction behavior.

Supported actions:

- `Summarize so far`
- `Suggest a better question`
- `Explain both sides`
- `Translate`
- custom prompt through Ask AI input

All responses are static mock text and only appear after a user action.

### Sprint 7d: Live Room Integration

Wired shared AI state into Live Voice Room.

Built:

- Live Room AI status pill reflects shared AI status.
- AI Bima speaks visually when AI status is `speaking`.
- Turn off AI removes AI Bima from the participant grid.
- Turn off AI changes the room control to `AI Off`.
- `AI Off` control stays disabled and does not reopen the drawer.
- Room entry syncs AI interaction state with the selected room AI mode.

## Important Files Changed

- `lib/app/oppose_app.dart`
- `lib/features/ai/ai_control_drawer.dart`
- `lib/features/ai/widgets/`
- `lib/features/room/live_voice_room_screen.dart`
- `lib/state/ai_interaction/ai_interaction_controller.dart`
- `lib/state/ai_interaction/ai_interaction_scope.dart`
- `lib/state/live_room/live_room_controller.dart`
- `test/widget_test.dart`
- `README.md`

## Acceptance Criteria Status

- AI Drawer opens from Live Room: done.
- AI Drawer has visible status: done.
- AI Drawer has mode selector: done.
- Brainstormer mode is selectable: done.
- Quick actions create mock responses: done.
- Prompt input creates mock responses: done.
- Memory Off is visible: done.
- AI responses are user-triggered only: done.
- Turn off AI updates Live Room: done.
- AI Bima disappears when AI is Off: done.
- Ask AI control becomes `AI Off` when disabled: done.
- Direct Chat AI safety copy remains explicit that AI is not listening: done.
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
- `flutter test`: passed, 13 tests.

Widget coverage includes:

- Existing onboarding/home/messaging/room setup/live room paths.
- AI Drawer opens from Live Room.
- Memory Off card is visible.
- Brainstormer mode is selectable.
- Quick action response appears.
- Prompt response appears.
- Turn off AI removes AI Bima.
- Turn off AI removes AI participant labeling.
- Live Room shows `AI Off` after disabling AI.
- Disabled `AI Off` control does not reopen the AI Drawer.

## Known Limitations

- No real AI service.
- No real speech-to-text.
- No real translation.
- No actual memory store.
- No backend AI consent persistence.
- No production streaming status from audio or model events.
- Mock responses are static and topic-light.
- Mock room state controls remain visible for alpha/testability.

## Next Sprint Recommendation

Start Sprint 8: Room Summary MVP or Safety/Reporting MVP, depending on product priority.

Recommended Sprint 8 options:

- Room Summary MVP: make the summary screen reflect room setup, selected summary setting, and mock takeaways.
- Safety/Reporting MVP: expand report flow, block/mute affordances, and post-room safety copy.
- Profile/Social Graph MVP: flesh out profile, friends, and invite state beyond static mock data.
