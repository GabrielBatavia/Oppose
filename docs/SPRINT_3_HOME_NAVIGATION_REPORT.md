# Oppose Sprint 3 Home And Main Navigation Report

Date: 2026-05-18

## Sprint Goal

Turn Home from a lightweight mock into the main daily dashboard and stabilize main app navigation.

Target loop:

`Home -> Daily Debate -> Recent Chat -> Create Room -> Main Tabs -> Profile/Chats`

## Build Split

### Sprint 3a: Home State, Data, And Analytics

Added a Home-specific controller and typed dashboard data.

Built:

- `HomeController`
- `HomeDashboardData`
- `DailyDebate`
- `DailyDebateResponse`
- Home viewed tracking guard
- Daily debate selected response state
- Recent chat open tracking
- Start room tracking
- Empty-state switches for future no-friends/no-chats states

Analytics placeholder events:

- `home_viewed`
- `daily_debate_agree_clicked`
- `daily_debate_oppose_clicked`
- `recent_chat_opened`
- `start_room_clicked`

### Sprint 3b: Home Components

Added Home-specific reusable widgets to avoid hardcoding the whole dashboard inside `HomeScreen`.

Built:

- `DailyDebateCard`
- `LiveFriendsRow`
- `RecentChatPreviewCard`
- `StartRoomCard`
- `HomeSectionHeader`
- `UnreadBadge`
- `NotificationButton`

### Sprint 3c: Polished Home Dashboard

Replaced the previous Home implementation with a warmer daily-use dashboard.

Built:

- Oppose header with notification placeholder
- Greeting: `Hi, Bima's Friend`
- Weekly nudge card
- Daily Debate card with Bima asset
- Agree/Oppose selected states with checkmark and text status
- Horizontal live friends row
- Recent chat previews with unread badges
- Strong Start Room CTA using the mug sticker asset
- Bottom batik decorative accent

### Sprint 3d: Navigation Stabilization

Stabilized main navigation behavior.

Built:

- Bottom navigation always shows labels.
- Routes remain selected correctly for Home, Chats, Create, Rooms, and Profile.
- Main app screens keep bottom navigation.
- Onboarding screens remain bottom-nav free.
- `GoRouter` is now created per `OpposeApp` instance instead of as a shared global, preventing stale route state across tests and improving lifecycle isolation.

## Important Files Changed

- `lib/app/navigation/app_router.dart`
- `lib/app/oppose_app.dart`
- `lib/assets/oppose_assets.dart`
- `lib/components/navigation/oppose_bottom_navigation.dart`
- `lib/features/home/home_screen.dart`
- `lib/features/home/widgets/`
- `lib/state/home/home_controller.dart`
- `lib/state/home/home_dashboard_data.dart`
- `lib/state/mock_data/mock_oppose_data.dart`
- `test/widget_test.dart`

## Acceptance Criteria Status

- Home feels like a daily-use social dashboard: done.
- User can choose Agree/Oppose and see selected state: done.
- User can reach Direct Chat from Home: done.
- User can reach Create Room from Home: done.
- Bottom navigation routes to Chats and Profile: done.
- Empty-state paths exist in Home controller/widgets: done.
- Analytics placeholder calls exist for Home actions: done.
- Important UI text is native Flutter text: done.
- Assets are used as illustrations/decorations only: done.
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
- `flutter test`: passed.

Widget coverage added:

- Welcome opens correctly.
- Full onboarding reaches Home.
- Home Agree/Oppose selection works.
- Home recent chat opens Direct Chat.
- Home Start Room opens Create Room.
- Bottom navigation opens Chats and Profile.

## Known Limitations

- Home state is in-memory only.
- Notifications are a placeholder snackbar.
- Empty-state switches are controller-level only; no debug UI toggles yet.
- Recent chat opens a single Direct Chat route for now.
- Create Room is still Sprint 5-level stub UI.
- Friends/chats are mock data only.

## Next Sprint Recommendation

Start Sprint 4: Messaging MVP.

Recommended Sprint 4 scope:

- Polish Chats List against `docs/refrences/pages/Chats List.png`.
- Implement search/filter over mock conversations.
- Implement chat list empty/search-empty states.
- Polish Direct Chat against `docs/refrences/pages/Direct Chat.png`.
- Add local message send behavior.
- Add AI helper suggestion interactions.
- Add Start Room from Direct Chat.
- Add message status/failed-send placeholder.
- Add messaging analytics placeholders.
- Add widget tests for search, opening chat, sending message, Ask AI, and Start Room.
