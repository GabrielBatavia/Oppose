# Oppose Sprint 2 Onboarding Report

Date: 2026-05-18

## Sprint Goal

Implement the first-time user onboarding flow:

`Welcome -> Sign Up -> Username Setup -> Interest Setup -> AI Consent -> Home`

The goal was to make the flow usable with mock/local state while preserving Oppose's warm scrapbook style and AI consent rules.

## Build Split

### Sprint 2a: Onboarding State And Shared Components

Added lightweight local onboarding state without introducing a larger state-management dependency.

Built:

- `OnboardingController`
- `OnboardingScope`
- Language state: English / Indonesia
- Sign-up state and validation
- Username availability state with debounce
- Interest selection state
- AI consent accepted state
- Analytics placeholder calls through `NoopAnalyticsService`
- Onboarding progress component
- Consent info card component
- Social auth placeholder button
- Username availability row

### Sprint 2b: Account, Identity, And Interests

Replaced Sprint 1 stubs with interactive screens.

Built:

- Welcome language toggle
- Welcome CTA tracking and navigation
- Native email/phone input
- Password input with visibility toggle
- Sign-up validation and loading state
- Google / Apple placeholder buttons
- Avatar identity setup layout
- Display name validation
- Username validation and availability states
- Selectable/deselectable interest chips
- Continue and skip path into AI consent

### Sprint 2c: AI Consent And Completion

Implemented the consent screen as a real user-control surface.

Built:

- Required AI safety copy:
  - "AI only listens when it is turned on."
  - "You can mute or remove AI anytime."
  - "Summaries are optional and deletable."
- Visible `AI Off` state
- Explicit `Memory is off` copy
- AI settings preview bottom sheet
- Consent accepted state
- `onboarding_completed` analytics placeholder
- Navigation into Home after consent

## Main Files Changed

- `lib/app/oppose_app.dart`
- `lib/components/inputs/oppose_text_input.dart`
- `lib/features/onboarding/welcome_screen.dart`
- `lib/features/onboarding/sign_up_screen.dart`
- `lib/features/onboarding/username_setup_screen.dart`
- `lib/features/onboarding/interest_setup_screen.dart`
- `lib/features/ai/ai_consent_screen.dart`
- `lib/features/onboarding/widgets/`
- `lib/state/onboarding/onboarding_controller.dart`
- `lib/state/onboarding/onboarding_scope.dart`
- `test/widget_test.dart`

## Analytics Placeholders Added

- `signup_started`
- `signup_completed`
- `username_submitted`
- `username_available`
- `profile_completed`
- `interests_selected`
- `ai_consent_viewed`
- `ai_consent_accepted`
- `onboarding_completed`

No sensitive message or transcript content is tracked.

## Acceptance Criteria Status

- User can complete onboarding end-to-end and reach Home: done.
- Invalid sign-up/profile states block progress: done.
- Username availability is visible: done.
- Interest chips are interactive: done.
- AI consent is explicit and reassuring: done.
- Important text is native Flutter text: done.
- Reference pages are not used as static backgrounds: done.
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
- `flutter test`: passed, including the full onboarding flow test.

## Known Limitations

- Onboarding state is in-memory only; app restart loses progress.
- Sign up is mock-only and does not create a real auth session.
- Google and Apple buttons are visual placeholders.
- Username availability uses local mock rules.
- Avatar edit is represented visually but does not open a picker yet.
- AI settings customization is a preview bottom sheet only.
- No persistent local storage yet.

## Next Sprint Recommendation

Start Sprint 3: Home and Main Navigation.

Recommended Sprint 3 scope:

- Polish Home against `docs/refrences/pages/Home.png`.
- Implement Daily Debate selected states.
- Improve live friends row with asset-backed avatars where useful.
- Improve recent chats list and empty state.
- Implement Start Room card as a stronger habit loop.
- Confirm bottom navigation behavior across Home, Chats, Create, Rooms, and Profile.
- Add analytics placeholder calls for Home events.
- Add widget tests for Home navigation paths.
