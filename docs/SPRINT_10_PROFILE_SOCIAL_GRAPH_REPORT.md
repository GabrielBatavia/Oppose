# Oppose Sprint 10 Profile And Social Graph MVP Report

Date: 2026-05-19

## Sprint Goal

Make Profile and social identity usable enough for the current Oppose MVP loop: users can view and edit their profile, manage friends, accept or decline mock requests, manage blocked/muted users, and keep room invites aligned with safety state.

Target flows:

`Profile -> Edit profile -> Save -> updated profile`

`Profile -> Manage friends -> search -> mute/block/invite/message`

`Profile -> Friend requests -> accept/decline`

`Profile -> Manage safety -> unblock/unmute`

`Profile block -> Create Room -> blocked friend disabled in invite selector`

This sprint stayed frontend/mock-state only. No backend social graph, persisted profile edits, real friend requests, contact sync, profile uploads, or push notifications were added.

## Build Split

### Sprint 10a: Shared Social State

Added app-level social state.

Built:

- `SocialController`
- `SocialScope`
- mutable local friends list
- local friend search query
- local friend request state
- local profile display name and tagline
- local room-invite intent state
- social analytics placeholder events

Domain additions:

- `FriendRequestStatus`
- `FriendRequest`

Mock data additions:

- Nadia friend request
- Dito friend request

### Sprint 10b: Dynamic Profile

Rebuilt Profile from static mock content into a state-driven social dashboard.

Profile now shows:

- editable display name
- username
- editable tagline
- interests
- dynamic friend count
- badges
- weekly summary card
- friends preview
- friend requests
- safety center with blocked/muted counts

### Sprint 10c: Profile Editing

Added a local edit profile bottom sheet.

Built:

- display name input
- tagline input
- Save profile action
- local confirmation message

### Sprint 10d: Friends Management

Added friend management as a bottom sheet from Profile.

Built:

- friend search
- friend cards
- friend status pills
- Message action
- Invite action
- Mute/Unmute action using `SafetyController`
- Block/Unblock action using `SafetyController`
- blocked-state disabled message/invite actions
- invited-state pill

### Sprint 10e: Friend Requests

Added mock request handling.

Built:

- request list on Profile
- Accept action
- Decline action
- accepted request becomes a friend
- declined request disappears
- local action messages

### Sprint 10f: Safety Management From Profile

Expanded the Profile Safety Center.

Built:

- Manage safety bottom sheet
- blocked users list
- muted users list
- unblock action
- unmute action
- empty states for blocked and muted lists

### Sprint 10g: Room Invite Safety Integration

Room invite surfaces now use social and safety state.

Built:

- Create Room invite selector uses `SocialController.friends`
- Room Invite sheet uses `SocialController.friends`
- blocked users are disabled in invite selector
- blocked selected invites are removed from room setup state
- blocked invite tiles show `Blocked`

## Important Files Changed

- `lib/app/oppose_app.dart`
- `lib/types/domain_models.dart`
- `lib/state/mock_data/mock_oppose_data.dart`
- `lib/state/social/social_controller.dart`
- `lib/state/social/social_scope.dart`
- `lib/state/safety/safety_controller.dart`
- `lib/state/room_setup/room_setup_controller.dart`
- `lib/features/profile/my_profile_screen.dart`
- `lib/features/room/create_room_screen.dart`
- `lib/features/room/widgets/invite_friend_selector.dart`
- `lib/features/room/widgets/room_invite_sheet.dart`
- `test/widget_test.dart`
- `README.md`

## Acceptance Criteria Status

- Profile is no longer mostly static: done.
- User can edit display name and tagline locally: done.
- User can view dynamic friend count: done.
- User can view and search friends: done.
- User can mute/unmute friends: done.
- User can block/unblock friends: done.
- Blocked friends are visibly marked: done.
- Blocked friends cannot be messaged/invited in mock UI: done.
- User can accept mock friend requests: done.
- User can decline mock friend requests: done.
- Profile Safety Center can manage blocked/muted users: done.
- Room invite respects blocked state: done.
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
- `flutter test`: passed, 22 tests.

Widget coverage includes:

- Existing onboarding/home/messaging/room setup/live room/AI drawer/summary/safety paths.
- Profile edit updates display name and tagline.
- Profile shows dynamic friends and safety counts.
- Friend requests can be accepted and declined.
- Friend search filters management results.
- Friend mute/block updates safety counts.
- Profile safety management can unblock/unmute users.
- Room invite disables blocked friends and keeps selected count stable.

## Known Limitations

- No backend social graph.
- No persistence for profile edits, friends, blocks, mutes, or invites.
- No real friend request delivery.
- No contact sync.
- No profile image upload.
- Message action only routes to the existing Maya direct chat.
- Accepted new friends do not yet participate in live room mock participant generation.
- Invite action is local social intent unless used through room setup.

## Next Sprint Recommendation

Start Sprint 11: MVP Polish And Demo Readiness.

Recommended Sprint 11 scope:

- Improve visual consistency across completed flows.
- Tighten empty states and disabled states.
- Add route-level smoke coverage for every MVP route.
- Remove or hide alpha-only mock controls where appropriate.
- Add a demo checklist and known-limitations doc.
- Optionally attempt a debug build again after the Android NDK install issue.
