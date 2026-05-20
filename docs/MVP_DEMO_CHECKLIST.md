# Oppose MVP Demo Checklist

Date: 2026-05-19

## Run The App

From `Oppose/`:

```bash
flutter pub get
flutter run
```

Useful validation:

```bash
dart format lib test
flutter analyze
flutter test
```

## Happy Path Demo

1. Start at Welcome.
2. Tap `Start debating`.
3. Create the mock account.
4. Pick display name and username.
5. Pick at least one interest.
6. Accept AI consent.
7. Land on Home.
8. Choose `Agree` or `Oppose` on Daily Debate.
9. Open Chats.
10. Open Maya direct chat.
11. Send a message.
12. Ask AI from chat.
13. Start a room.
14. Configure Create Room.
15. Join the Lobby.
16. Join Live Room.
17. Open AI Drawer.
18. Run a quick action or prompt.
19. Open Safety.
20. Mute a participant or submit a mock report.
21. Leave room.
22. Review Room Summary.
23. Save/share/delete the summary.
24. Open Profile.
25. Edit profile, manage friends, accept/decline requests, and manage safety lists.

## AI Drawer Demo

1. Create and join a room.
2. Tap `Ask AI`.
3. Confirm `Memory Off` is visible.
4. Choose `Brainstormer`.
5. Tap `Summarize so far`.
6. Type a prompt and tap `Ask AI`.
7. Tap `Turn off AI`.
8. Confirm AI Bima disappears and the Live Room control says `AI Off`.

## Safety Demo

1. Open Chats.
2. Tap `Open report flow`.
3. Select a reason and submit.
4. Return to Chats.
5. Open Maya direct chat.
6. Tap `Report`.
7. Select a reason, toggle `Also block Maya`, and submit.
8. Return to Direct Chat and confirm sending is disabled.
9. Open Profile.
10. Use `Manage safety` to unblock or unmute users.

## Room Demo

1. Open Create.
2. Set a custom topic.
3. Change room type.
4. Invite or remove friends.
5. Choose AI mode and summary privacy.
6. Start room.
7. Toggle mock mic permission in Lobby.
8. Join Live Room.
9. Use `Demo room controls` to change connection state.
10. Tap a participant to change active speaker.
11. Use Chat, Invite, Safety, Ask AI, Mute, and Leave controls.

## Summary Demo

1. Leave a room through `Leave and see summary`.
2. Confirm title, topic, AI mode, and summary privacy match setup.
3. Review takeaways, best arguments, funny moments, and open questions.
4. Save summary.
5. Share with room.
6. Delete summary.
7. Repeat with `Summary Off` to show no generated summary.

## Profile And Social Demo

1. Open Profile.
2. Edit display name and tagline.
3. Accept Nadia's friend request.
4. Decline Dito's friend request.
5. Open `Manage friends`.
6. Search for Raka or Maya.
7. Mute/block a friend.
8. Open `Manage safety`.
9. Unmute/unblock users.
10. Block Maya, then open Create Room and confirm Maya is disabled in the invite selector.

## Demo Notes

- AI is mock, visible, and user-triggered.
- Memory is shown as off.
- Reports, blocks, mutes, profile edits, friend requests, and invites are local demo state.
- Live voice/audio is not real yet.
- Room summary is mock-generated from allowed room context and setup state.
