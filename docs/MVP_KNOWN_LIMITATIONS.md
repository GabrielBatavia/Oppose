# Oppose MVP Known Limitations

Date: 2026-05-19

## Architecture

- No backend services are connected.
- No state is persisted between app restarts.
- No real authentication provider exists.
- Analytics events are placeholder no-op calls.

## AI

- No real AI model is connected.
- No real speech-to-text exists.
- No real translation exists.
- No real summarization exists.
- AI responses are static mock text.
- AI status changes are frontend timers only.
- Memory is represented as off, with no real memory store.

## Voice Rooms

- No real microphone audio is captured.
- No WebRTC, SFU, or realtime voice transport exists.
- Speaking indicators are mock UI state.
- Connection states are demo controls, not telemetry.
- Room invites are local demo state only.

## Safety And Moderation

- Reports are not sent to a moderation backend.
- Blocks and mutes are local mock state only.
- No evidence attachments are supported.
- No transcript/audio evidence exists.
- No emergency escalation workflow exists.
- No admin review tooling exists.

## Social Graph

- Friends and friend requests are mock data.
- Accepting or declining requests is local only.
- Profile edits are local only.
- Profile image upload is not supported.
- Contact sync is not supported.
- Push notifications are not supported.

## Room Summary

- Summaries are not generated from transcripts.
- Save/share/delete are local mock state only.
- No room history list exists.
- Summary visibility is represented in UI only.

## Platform Build

- Source validation uses `flutter analyze` and `flutter test`.
- Earlier Android debug build attempts timed out while installing/preparing the Android NDK.
- Sprint 11 retried `flutter build apk --debug`.
- The build failed because `C:\Users\GabrielBatavia\AppData\Local\Android\Sdk\ndk\28.2.13676358` is missing `source.properties`, which indicates a malformed local NDK install.
- Flutter suggested deleting that local NDK folder and allowing Android Gradle Plugin to re-download it.
