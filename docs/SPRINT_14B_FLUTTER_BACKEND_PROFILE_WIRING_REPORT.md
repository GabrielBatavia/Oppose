# Oppose Sprint 14b Flutter Backend Profile Wiring Report

Date: 2026-05-20

## Sprint Goal

Add a real Flutter backend repository path for auth/profile data and wire onboarding/profile flows through repository interfaces while keeping the current mock/demo app stable by default.

## Completed

### Backend API Client

Expanded `lib/repositories/backend_api_client.dart` into a small JSON REST client.

Built:

- GET/PATCH/POST helpers
- development auth header support through `x-dev-user-id`
- structured `BackendApiException`
- injectable transport for tests
- `dart:io` default transport for Flutter mobile/desktop runtime

### Backend Repositories

Added:

- `lib/repositories/user/backend_user_repository.dart`
- `lib/repositories/user/user_dto_mapper.dart`
- `lib/repositories/auth/backend_auth_repository.dart`

Profile endpoints covered:

- `GET /me`
- `GET /users/check-username`
- `PATCH /me/profile`
- `PATCH /me/interests`
- `POST /me/ai-consent`

### App Wiring

Updated `lib/app/oppose_app.dart` so the app can use either mock or backend repositories.

Default behavior:

- mock repository mode remains default
- existing widget tests and demo flow stay local/offline

Backend mode:

```bash
flutter run \
  --dart-define=OPPOSE_USE_BACKEND=true \
  --dart-define=OPPOSE_BACKEND_URL=http://127.0.0.1:4000 \
  --dart-define=OPPOSE_DEV_USER_ID=00000000-0000-4000-8000-000000000001
```

Use `http://10.0.2.2:4000` for Android Emulator.

### Onboarding Wiring

Updated `OnboardingController` to use `UserRepository` for:

- username availability checks
- profile save from username setup
- interests save/skip
- AI consent persistence

Added loading/error state for:

- username save
- interests save
- AI consent save
- username availability failures

### Profile Wiring

Updated `SocialController` and Profile UI so profile display uses repository-backed current user state instead of static mock user reads.

Profile edit now saves display name through `UserRepository.updateProfile` and keeps the local tagline as an app-only field for now.

## Validation

Commands run from `Oppose/`:

```bash
dart format lib test
flutter analyze
flutter test
```

Results:

- `dart format lib test`: completed.
- `flutter analyze`: passed with no issues.
- `flutter test`: passed with 27 tests.

## Known Limitations

- Backend mode still uses Sprint 13 development auth, not production auth.
- `BackendAuthRepository` maps sign-up/log-in to the current dev user because no production auth/session endpoint exists yet.
- Profile tagline remains local-only because the backend user schema does not include it yet.
- Flutter backend mode was added and unit-tested with fake transport; full manual device smoke should be run with backend server running.
- Chat, room, social graph, safety, AI, summaries, and LiveKit remain mock/local in Flutter.

## Next Sprint Recommendation

Sprint 15 should either:

1. Add manual backend-mode Flutter smoke on desktop/emulator and polish connection copy, or
2. Start social graph persistence for friends, requests, block, and mute.
