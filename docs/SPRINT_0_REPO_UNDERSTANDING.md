# Oppose Sprint 0 Repo Understanding

Date: 2026-05-18

## Scope Decision

Build Oppose first as a standalone Flutter mobile app. Clash remains separate and should not be implemented inside the Oppose codebase unless explicitly requested later.

## Product Summary

Oppose is a daily social AI-assisted debate app for friends and small groups. It should feel warm, handmade, friendly, respectful, safe, and social. The app must not feel like a political conflict platform, casino, crypto product, generic SaaS dashboard, or autonomous AI agent.

Core line: "Different take, better talk."

Primary loop:

1. Welcome
2. Sign up or log in
3. Create username and profile identity
4. Select interests
5. Accept AI consent
6. Land on Home
7. Chat or create a room
8. Join a voice room
9. Ask AI through visible controls
10. Leave safely
11. Review optional summary
12. Return for another daily debate

## Technical Decision

Framework: Flutter

Platforms: iOS and Android

Project location: `Oppose/`

Package name: `oppose`

Application id/org base from Flutter init: `com.clashopposition.oppose`

Initial app status: generated Flutter project with Android and iOS targets.

## Source References Read

- `startup/docs/Clash_Oppose_Development_Master_Specification_v1.docx`
- `Oppose/docs/AI_AGENT_REFERENCE_CONTEXT.txt`
- `Oppose/docs/OPPOSE_AI_AGENT_BUILD_GUIDE_AND_SPRINT_PLAN.txt`
- `Oppose/docs/refrences/pages/`
- `Oppose/docs/refrences/assets/`

Important spelling note: keep the existing `refrences` folder name unless the owner chooses to rename it.

## MVP Route Map

| Route | Screen | Sprint |
| --- | --- | --- |
| `/welcome` | Welcome | 2 |
| `/sign-up` | Sign Up | 2 |
| `/username-setup` | Username Setup | 2 |
| `/interest-setup` | Interest Setup | 2 |
| `/ai-consent` | AI Consent Setup | 2 |
| `/home` | Home | 3 |
| `/chats` | Chats List | 4 |
| `/direct-chat` | Direct Chat | 4 |
| `/create-room` | Create Room | 5 |
| `/room-lobby` | Room Lobby | 5 |
| `/live-room` | Live Voice Room | 6 |
| `/room-summary` | Room Summary | 8 |
| `/profile` | My Profile | 9 |
| `/report` | Report Flow | 9 |

AI Drawer should be implemented as a reusable bottom sheet component opened from Live Voice Room and later Direct Chat, not as a primary tab.

## Main Navigation Direction

Use bottom navigation for the main app area after onboarding.

Initial tabs:

- Home
- Chats
- Create
- Activity or Rooms placeholder
- Profile

The Create tab should route to room creation or act as a prominent centered action once the app shell exists.

## Recommended Flutter Structure For Sprint 1

```text
lib/
  app/
    navigation/
    routes/
  components/
    core/
    layout/
    cards/
    buttons/
    inputs/
    navigation/
    stickers/
  features/
    onboarding/
    home/
    chats/
    room/
    ai/
    profile/
    safety/
  services/
    analytics/
    api/
    auth/
    chat/
    room/
    ai/
    moderation/
  state/
    mock_data/
    stores/
  theme/
  types/
  utils/
```

## Component Targets For Sprint 1

Core components:

- OpposeScreen
- OpposeHeader
- OpposeLogo
- PaperCard
- TornPaperCard
- StickerImage
- TapeDecoration
- PrimaryButton
- SecondaryButton
- OutlineButton
- DangerButton
- OpposeTextInput
- SearchInput
- SelectableChip
- SelectableCard
- StatusPill
- AIStatusPill
- Avatar
- AvatarGroup
- Badge
- OpposeBottomNavigation
- EmptyState
- BottomSheet base

Domain components should be added when their screens are implemented, not all at once.

## Asset Inventory Plan

Existing assets live in `docs/refrences/assets/` and should be copied or registered into the Flutter app during Sprint 1. Do not use full reference page images as UI. Use page references only for layout, spacing, hierarchy, and mood.

Suggested app asset destination:

```text
assets/images/oppose/
  decor/
  onboarding/
  home/
  chats/
  room/
  ai/
  profile/
  safety/
```

Required Sprint 1 output:

- Add asset folders.
- Register image paths in `pubspec.yaml`.
- Create an asset constants file or semantic registry.
- Keep all important text as native Flutter text.

## Theme Tokens

Initial palette from the docs:

- Maroon Red: `#8E1D2C`
- Mint Green: `#72C8A3`
- Sunflower Yellow: `#FFD34D`
- Indigo Blue: `#384BA7`
- Warm Cream: `#FFF6E6`
- Soft Ink: `#222222`
- Muted Gray: `#6F6F6F`

Theme files should define colors, spacing, radius, shadows, and typography before screen work starts.

## AI And Safety Rules

AI must always be visible and user-controlled.

Required AI states:

- AI Off
- Not listening yet
- AI Listening
- AI Thinking
- AI Speaking
- Summarizing
- Memory Off

Required controls:

- Ask AI
- Turn off AI
- Change AI settings
- Choose AI mode
- Choose summary setting
- Delete summary

Required safety actions:

- Report
- Block
- Mute
- Leave room
- Turn off AI
- Delete summary

Analytics must not store private message content or transcript text by default.

## Sprint 1 Recommendation

Sprint 1 should deliver a running app shell with:

- Theme tokens
- Route constants
- Navigation between all MVP screen stubs
- Shared layout/components
- Bottom navigation
- Asset registry skeleton
- Mock data models
- Placeholder service boundaries
- Placeholder analytics service

Do not implement full screen UI before the shell, theme, and reusable components are stable.

## Known Limitations After Sprint 0

- App still has Flutter starter UI.
- No custom route system yet.
- No Oppose visual system implemented yet.
- No assets registered in Flutter yet.
- No mock data or service boundary files yet.
- No tests beyond generated Flutter starter test.

These are expected and should be addressed in Sprint 1.
