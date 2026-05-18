# Oppose Sprint 1 Foundation Report

Date: 2026-05-18

## What Was Built

Sprint 1 replaced the generated Flutter starter UI with an Oppose-specific app foundation.

Completed:

- `GoRouter` route system for all MVP screens.
- Oppose Material theme with colors, typography, spacing, radius, and shadows.
- Shared app shell with safe-area layout and optional bottom navigation.
- Core reusable components for buttons, cards, inputs, chips, status pills, avatars, badges, stickers, and bottom sheets.
- Bottom navigation for Home, Chats, Create, Rooms, and Profile.
- Screen stubs or lightweight mock UI for all MVP screens.
- AI Drawer bottom sheet component.
- Typed mock data models and mock data.
- Placeholder service interfaces for future backend/API integration.
- Asset registry constants and copied Oppose image assets into Flutter's asset tree.
- Updated widget smoke test for the Oppose welcome screen.

## Routes

| Route | Screen | Status |
| --- | --- | --- |
| `/welcome` | Welcome | Lightweight UI |
| `/sign-up` | Sign Up | Stub with form placeholders |
| `/username-setup` | Username Setup | Stub with identity placeholders |
| `/interest-setup` | Interest Setup | Stub with mock chips |
| `/ai-consent` | AI Consent Setup | Stub with required AI safety copy |
| `/home` | Home | Lightweight mock dashboard |
| `/chats` | Chats List | Lightweight mock list |
| `/direct-chat` | Direct Chat | Lightweight mock chat |
| `/create-room` | Create Room | Stub with room settings placeholders |
| `/room-lobby` | Room Lobby | Lightweight mock lobby |
| `/live-room` | Live Voice Room | Lightweight mock room with mute and AI drawer |
| `/room-summary` | Room Summary | Lightweight mock summary |
| `/profile` | My Profile | Lightweight mock profile |
| `/report` | Report Flow | Lightweight mock report form |

## Important Files

- `lib/main.dart`
- `lib/app/oppose_app.dart`
- `lib/app/navigation/app_router.dart`
- `lib/app/routes/app_routes.dart`
- `lib/theme/`
- `lib/components/`
- `lib/features/`
- `lib/types/domain_models.dart`
- `lib/state/mock_data/mock_oppose_data.dart`
- `lib/services/`
- `lib/assets/oppose_assets.dart`
- `assets/images/oppose/`

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

## Known Limitations

- Most screens are Sprint 1 stubs or lightweight mock UI, not final page implementations.
- No real onboarding validation yet.
- No persistent state management yet.
- No real authentication, chat, room, WebRTC, AI, moderation, or notification integration.
- Image assets are copied flat into `assets/images/oppose/`; Sprint 2 or polish can reorganize them semantically if desired.
- Generated platform icons and splash screens are still Flutter defaults.

## Next Sprint Recommendation

Start Sprint 2: Onboarding Flow.

Sprint 2 should fully implement:

- Welcome
- Sign Up
- Username Setup
- Interest Setup
- AI Consent Setup
- Mock onboarding state
- Validation and disabled/loading/error states
- Navigation from first launch to Home
- Accessibility labels for onboarding controls
- Analytics placeholder calls for onboarding events

Do not start backend integration before the UI shell, onboarding state, and consent flow are stable.
