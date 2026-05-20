import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oppose/app/oppose_app.dart';
import 'package:oppose/app/routes/app_routes.dart';

void main() {
  testWidgets('Oppose app opens to welcome screen', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();

    expect(find.text('Different take, better talk.'), findsOneWidget);
    expect(find.text('Start debating'), findsOneWidget);
  });

  testWidgets('all MVP routes render primary content', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();

    final routeSmokeCases = <(String, Finder)>[
      (AppRoutes.welcome, find.text('Different take, better talk.')),
      (AppRoutes.signUp, find.text('Create your Oppose account')),
      (AppRoutes.usernameSetup, find.text('Pick your debate name')),
      (AppRoutes.interestSetup, find.text('What do you like to talk about?')),
      (AppRoutes.aiConsent, find.text('How AI works in your room')),
      (AppRoutes.home, find.textContaining('Daily Debate')),
      (AppRoutes.chats, find.text('Keep better talks going.')),
      (AppRoutes.directChat, find.text('AI Helper')),
      (AppRoutes.createRoom, find.text('Create a room')),
      (AppRoutes.roomLobby, find.text('Daily Debate Room')),
      (AppRoutes.liveRoom, find.text('Daily Debate Room')),
      (AppRoutes.roomSummary, find.text('Room Summary')),
      (AppRoutes.profile, find.text('Your respectful debate identity.')),
      (AppRoutes.report, find.text('Report a problem')),
    ];

    for (final (route, finder) in routeSmokeCases) {
      await goToRoute(tester, route);
      expect(finder, findsWidgets, reason: 'Route $route should render.');
    }
  });

  testWidgets('user can complete onboarding flow', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();

    await completeOnboarding(tester, openAISettings: true);
    expect(find.text("Hi, Bima's Friend"), findsOneWidget);
  });

  testWidgets('home daily debate selection works', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);

    await tapVisibleText(tester, 'Agree');
    expect(find.text('Agree selected'), findsOneWidget);

    await tapVisibleFinder(tester, find.text('Oppose').last);
    expect(find.text('Oppose selected'), findsOneWidget);
  });

  testWidgets('home opens recent chat and create room', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);

    await tapVisibleText(tester, 'Should we make this a room?');
    expect(
      find.text('AI can suggest a balanced question when you ask.'),
      findsOneWidget,
    );

    await tapVisibleText(tester, 'Home');
    expect(find.text("Hi, Bima's Friend"), findsOneWidget);

    await tapVisibleText(tester, 'Create room');
    expect(find.text('Create a room'), findsOneWidget);
  });

  testWidgets('bottom navigation opens Chats and Profile', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);

    await tapVisibleText(tester, 'Chats');
    expect(find.text('Keep better talks going.'), findsOneWidget);

    await tapVisibleText(tester, 'Profile');
    expect(find.text('Your respectful debate identity.'), findsOneWidget);
  });

  testWidgets('profile edit updates display name and tagline', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await tapVisibleText(tester, 'Profile');

    expect(find.text('3 friends'), findsOneWidget);
    expect(find.text('0 blocked'), findsOneWidget);
    expect(find.text('0 muted'), findsOneWidget);

    await tapVisibleText(tester, 'Edit profile');
    expect(find.text('Edit profile'), findsWidgets);
    await tester.enterText(find.byType(EditableText).at(0), 'Friendly Bima');
    await tester.enterText(
      find.byType(EditableText).at(1),
      'Kind debate, clearer ideas.',
    );
    await tester.pumpAndSettle();
    await tapVisibleText(tester, 'Save profile');

    expect(find.text('Friendly Bima'), findsOneWidget);
    expect(find.text('Kind debate, clearer ideas.'), findsOneWidget);
    expect(find.text('Profile updated locally.'), findsOneWidget);
  });

  testWidgets('profile friend requests can be accepted and declined', (
    tester,
  ) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await tapVisibleText(tester, 'Profile');

    expect(find.text('Nadia'), findsOneWidget);
    expect(find.text('Dito'), findsOneWidget);
    await tapVisibleFinder(tester, find.text('Accept').first);
    expect(find.text('Nadia is now your friend.'), findsOneWidget);
    expect(find.text('4 friends'), findsOneWidget);

    await tapVisibleText(tester, 'Decline');
    expect(find.text('Dito request declined.'), findsOneWidget);
    expect(find.text('No pending friend requests.'), findsOneWidget);
  });

  testWidgets('profile manages friends and safety lists', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await tapVisibleText(tester, 'Profile');

    await tapVisibleText(tester, 'Manage friends');
    expect(find.text('Manage friends'), findsWidgets);
    await tester.enterText(find.byType(EditableText).last, 'raka');
    await tester.pumpAndSettle();
    expect(find.text('Raka'), findsOneWidget);
    expect(find.text('Maya'), findsNothing);

    await tapVisibleText(tester, 'Mute');
    expect(find.text('Muted'), findsOneWidget);
    await tapVisibleText(tester, 'Block');
    expect(find.text('Blocked'), findsOneWidget);
    expect(find.text('Unblock'), findsOneWidget);
    await tapVisibleText(tester, 'Done');

    expect(find.text('1 blocked'), findsOneWidget);
    expect(find.text('1 muted'), findsOneWidget);

    await tapVisibleText(tester, 'Manage safety');
    expect(find.text('Blocked users'), findsOneWidget);
    await tapVisibleText(tester, 'Unblock');
    expect(find.text('No blocked users.'), findsOneWidget);
    await tapVisibleText(tester, 'Unmute');
    expect(find.text('No muted users.'), findsOneWidget);
    await tapVisibleText(tester, 'Done');

    expect(find.text('0 blocked'), findsOneWidget);
    expect(find.text('0 muted'), findsOneWidget);
  });

  testWidgets('room invite disables blocked friends', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await tapVisibleText(tester, 'Profile');
    await tapVisibleText(tester, 'Manage friends');
    await tester.enterText(find.byType(EditableText).last, 'maya');
    await tester.pumpAndSettle();
    await tapVisibleText(tester, 'Block');
    await tapVisibleText(tester, 'Done');

    await tapVisibleText(tester, 'Create');
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);
    expect(find.text('Blocked'), findsOneWidget);

    await tapVisibleText(tester, 'Maya');
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);
  });

  testWidgets('chats list renders and search filters conversations', (
    tester,
  ) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await tapVisibleText(tester, 'Chats');

    expect(find.text('Maya'), findsOneWidget);
    expect(find.text('Study Room'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).last, 'study');
    await tester.pumpAndSettle();
    expect(find.text('Study Room'), findsOneWidget);
    expect(find.text('Maya'), findsNothing);

    await tester.enterText(find.byType(EditableText).last, 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('No matching chats'), findsOneWidget);
  });

  testWidgets('direct chat sends message and asks AI', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await tapVisibleText(tester, 'Chats');
    await tapVisibleText(tester, 'Maya');

    expect(
      find.text(
        'AI responds only when asked. It is not listening in this chat.',
      ),
      findsOneWidget,
    );

    await tester.enterText(
      find.byType(EditableText).last,
      'Let us compare both sides.',
    );
    await tapVisibleFinder(tester, find.byTooltip('Send message'));
    expect(find.text('Let us compare both sides.'), findsOneWidget);

    await tapVisibleFinder(tester, find.text('Ask AI').first);
    expect(
      find.textContaining('What is one strong reason for each side'),
      findsOneWidget,
    );
  });

  testWidgets('direct chat start room routes to create room', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await tapVisibleText(tester, 'Chats');
    await tapVisibleText(tester, 'Maya');

    await tapVisibleFinder(tester, find.text('Start room').last);
    expect(find.text('Create a room'), findsOneWidget);
  });

  testWidgets('generic report flow submits from chats', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await tapVisibleText(tester, 'Chats');

    await tapVisibleText(tester, 'Open report flow');
    expect(find.text('Report a problem'), findsOneWidget);
    expect(find.text('Choose a reason'), findsOneWidget);

    await tapVisibleText(tester, 'Spam');
    await tapVisibleText(tester, 'Submit report');
    expect(find.text('Report submitted'), findsWidgets);

    await tapVisibleText(tester, 'Back to safety source');
    expect(find.text('Keep better talks going.'), findsOneWidget);
  });

  testWidgets('direct chat report can block Maya', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await tapVisibleText(tester, 'Chats');
    await tapVisibleText(tester, 'Maya');

    await tapVisibleText(tester, 'Report');
    expect(find.text('Report Maya'), findsOneWidget);

    await tapVisibleText(tester, 'Harassment');
    await tester.enterText(
      find.byType(EditableText).last,
      'Maya kept targeting me.',
    );
    await tester.pumpAndSettle();
    await tapVisibleText(tester, 'Also block Maya');
    await tapVisibleText(tester, 'Submit report');

    expect(find.text('Report submitted'), findsWidgets);
    expect(
      find.text('Maya is blocked in this local demo session.'),
      findsOneWidget,
    );

    await tapVisibleText(tester, 'Back to safety source');
    expect(find.text('Maya blocked'), findsOneWidget);
    expect(
      find.text('Messages are disabled because you blocked Maya.'),
      findsOneWidget,
    );

    await tapVisibleFinder(tester, find.byTooltip('Back to chats'));
    expect(find.text('Blocked'), findsOneWidget);
  });

  testWidgets('create room selections carry into lobby and live room', (
    tester,
  ) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);

    await tapVisibleText(tester, 'Create');
    expect(find.text('Create a room'), findsOneWidget);
    expect(find.text('Quick Hangout'), findsOneWidget);
    expect(find.text('Daily Debate'), findsOneWidget);

    await tester.enterText(
      find.byType(EditableText).last,
      'Can group study be more fun?',
    );
    await tester.pumpAndSettle();
    await tapVisibleText(tester, 'Study Talk');
    await tapVisibleText(tester, 'AI Brainstormer');
    await tapVisibleText(tester, 'Shared with room');
    await tapVisibleText(tester, 'Raka');

    await tapVisibleText(tester, 'Start room');
    expect(find.text('Study Talk Room'), findsOneWidget);
    expect(find.text('Can group study be more fun?'), findsOneWidget);
    expect(find.text('AI Brainstormer'), findsOneWidget);
    expect(find.text('Summary: Shared with room'), findsOneWidget);
    expect(find.text('2 friends are here'), findsOneWidget);

    await tapVisibleText(tester, 'Mock permission denied');
    expect(find.text('Mic permission denied'), findsOneWidget);
    expect(
      find.text('You can join, but mic may not work yet.'),
      findsOneWidget,
    );

    await tapVisibleText(tester, 'Change AI settings');
    expect(find.text('AI settings'), findsOneWidget);
    await tapVisibleText(tester, 'AI Off');
    await tapVisibleText(tester, 'Save AI settings');
    expect(find.text('AI Off'), findsOneWidget);

    await tapVisibleText(tester, 'Join room');
    expect(find.text('Study Talk Room'), findsOneWidget);
    expect(find.text('Can group study be more fun?'), findsOneWidget);
  });

  testWidgets('live room controls, sheets, and leave flow work', (
    tester,
  ) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);

    await tapVisibleText(tester, 'Create');
    await tapVisibleText(tester, 'Start room');
    await tapVisibleText(tester, 'Join room');

    expect(find.text('Daily Debate Room'), findsOneWidget);
    expect(find.text('AI Bima'), findsOneWidget);
    expect(find.text('Friends only'), findsOneWidget);

    await tapVisibleText(tester, 'Mute');
    expect(find.text('Muted'), findsOneWidget);

    await tapVisibleText(tester, 'Reconnecting');
    expect(find.text('Reconnecting'), findsWidgets);

    await tapVisibleText(tester, 'Raka');
    expect(find.text('Speaking'), findsWidgets);

    await tapVisibleText(tester, 'Chat');
    expect(find.text('Room chat'), findsOneWidget);
    await tapVisibleText(tester, 'Close');

    await tapVisibleText(tester, 'Ask AI');
    expect(find.text('AI Helper'), findsOneWidget);
    await tapVisibleText(tester, 'Turn off AI');
    expect(find.text('AI Bima'), findsNothing);
    expect(find.text('AI participant'), findsNothing);
    expect(find.text('AI Off'), findsWidgets);

    await tapVisibleText(tester, 'Invite');
    expect(find.text('Invite to live room'), findsOneWidget);
    await tapVisibleText(tester, 'Done');

    await tapVisibleText(tester, 'Leave');
    expect(find.text('Leave room?'), findsOneWidget);
    await tapVisibleText(tester, 'Leave and see summary');
    expect(find.text('Room Summary'), findsOneWidget);
  });

  testWidgets('live room safety can mute and report room', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await enterDefaultLiveRoom(tester);

    await tapVisibleText(tester, 'Safety');
    expect(find.text('Room safety'), findsOneWidget);

    await tapVisibleText(tester, 'Mute Raka');
    expect(find.text('Unmute Raka'), findsOneWidget);
    expect(find.text('Muted'), findsWidgets);

    await tapVisibleText(tester, 'Report room');
    expect(find.text('Report this room'), findsOneWidget);
    await tapVisibleText(tester, 'Unsafe behavior');
    await tapVisibleText(tester, 'Submit report');
    expect(find.text('Report submitted'), findsWidgets);

    await tapVisibleText(tester, 'Back to safety source');
    expect(find.text('Daily Debate Room'), findsOneWidget);
  });

  testWidgets('AI drawer supports modes quick actions and prompts', (
    tester,
  ) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await enterDefaultLiveRoom(tester);

    await tapVisibleText(tester, 'Ask AI');
    expect(find.text('AI Helper'), findsOneWidget);
    expect(find.text('Memory Off'), findsOneWidget);

    await tapVisibleText(tester, 'Brainstormer');
    await tapVisibleText(tester, 'Summarize so far');
    await pumpAIResponse(tester);
    expect(
      find.textContaining('So far: one side values flexibility'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byType(EditableText).last,
      'How can we make this fair?',
    );
    await tester.pumpAndSettle();
    await tapVisibleFinder(tester, find.text('Ask AI').last);
    await pumpAIResponse(tester);
    expect(find.textContaining('How can we make this fair?'), findsOneWidget);
  });

  testWidgets('turning off AI disables live room AI controls', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);
    await enterDefaultLiveRoom(tester);

    expect(find.text('AI Bima'), findsOneWidget);
    await tapVisibleText(tester, 'Ask AI');
    await tapVisibleText(tester, 'Turn off AI');

    expect(find.text('AI Bima'), findsNothing);
    expect(find.text('AI participant'), findsNothing);
    expect(find.text('AI Off'), findsWidgets);

    await tapVisibleFinder(tester, find.text('AI Off').last);
    expect(find.text('AI Helper'), findsNothing);
  });

  testWidgets('live room respects AI Off mode', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);

    await tapVisibleText(tester, 'Create');
    await tapVisibleText(tester, 'AI Off');
    await tapVisibleText(tester, 'Start room');
    await tapVisibleText(tester, 'Join room');

    expect(find.text('AI Off'), findsWidgets);
    expect(find.text('AI Bima'), findsNothing);
    expect(find.text('AI participant'), findsNothing);
  });

  testWidgets('room summary reflects room setup and actions', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);

    await tapVisibleText(tester, 'Create');
    await tester.enterText(
      find.byType(EditableText).last,
      'Can group study be more fun?',
    );
    await tester.pumpAndSettle();
    await tapVisibleText(tester, 'Study Talk');
    await tapVisibleText(tester, 'AI Brainstormer');
    await tapVisibleText(tester, 'Start room');
    await tapVisibleText(tester, 'Join room');
    await leaveRoomForSummary(tester);

    expect(find.text('Room Summary'), findsOneWidget);
    expect(find.text('Study Talk Room'), findsWidgets);
    expect(find.text('Can group study be more fun?'), findsOneWidget);
    expect(find.text('Summary: Private to me'), findsOneWidget);
    expect(find.text('AI Brainstormer'), findsOneWidget);
    expect(find.text('Main takeaways'), findsOneWidget);
    expect(
      find.textContaining('The room focused on "Can group study be more fun?"'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Brainstormer mode pushed the room'),
      findsOneWidget,
    );

    await tapVisibleText(tester, 'Save summary');
    expect(find.text('Summary saved privately.'), findsOneWidget);
    expect(find.text('Saved'), findsWidgets);

    await tapVisibleText(tester, 'Share with room');
    expect(find.text('Shared with room members.'), findsOneWidget);
    expect(find.text('Shared with room'), findsWidgets);

    await tapVisibleText(tester, 'Delete summary');
    expect(find.text('Summary deleted from this device.'), findsOneWidget);
    expect(find.text('No summary generated'), findsOneWidget);
    expect(find.text('Main takeaways'), findsNothing);
  });

  testWidgets('room summary respects Summary Off setting', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();
    await completeOnboarding(tester);

    await tapVisibleText(tester, 'Create');
    await tapVisibleText(tester, 'Summary Off');
    await tapVisibleText(tester, 'Start room');
    await tapVisibleText(tester, 'Join room');
    await leaveRoomForSummary(tester);

    expect(find.text('Room Summary'), findsOneWidget);
    expect(find.text('Summary was off'), findsOneWidget);
    expect(find.text('No summary generated'), findsOneWidget);
    expect(
      find.text(
        'You chose Summary Off before joining. Oppose did not create room notes.',
      ),
      findsOneWidget,
    );
    expect(find.text('Main takeaways'), findsNothing);

    await tapVisibleText(tester, 'Back to home');
    expect(find.text("Hi, Bima's Friend"), findsOneWidget);
  });
}

Future<void> enterDefaultLiveRoom(WidgetTester tester) async {
  await tapVisibleText(tester, 'Create');
  await tapVisibleText(tester, 'Start room');
  await tapVisibleText(tester, 'Join room');
}

Future<void> goToRoute(WidgetTester tester, String route) async {
  final context = tester.element(find.byType(Navigator).first);
  GoRouter.of(context).go(route);
  await tester.pumpAndSettle();
}

Future<void> leaveRoomForSummary(WidgetTester tester) async {
  await tapVisibleText(tester, 'Leave');
  expect(find.text('Leave room?'), findsOneWidget);
  await tapVisibleText(tester, 'Leave and see summary');
}

Future<void> pumpAIResponse(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
}

Future<void> completeOnboarding(
  WidgetTester tester, {
  bool openAISettings = false,
}) async {
  await tapVisibleText(tester, 'Start debating');
  expect(find.text('Create your Oppose account'), findsOneWidget);

  await tapVisibleText(tester, 'Create account');
  expect(find.text('Enter your email or phone.'), findsOneWidget);

  await tester.enterText(find.byType(EditableText).at(0), 'friend@example.com');
  await tester.enterText(find.byType(EditableText).at(1), 'friendly8');
  await tester.pumpAndSettle();
  await tapVisibleText(tester, 'Create account');
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
  expect(find.text('Pick your debate name'), findsOneWidget);

  await tapVisibleText(tester, 'Continue');
  expect(find.text('Use at least 2 characters.'), findsOneWidget);

  await tester.enterText(find.byType(EditableText).at(0), "Bima's Friend");
  await tester.enterText(find.byType(EditableText).at(1), 'thinkwithbima');
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
  expect(find.text('Username available'), findsOneWidget);

  await tapVisibleText(tester, 'Continue');
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pumpAndSettle();
  expect(find.text('What do you like to talk about?'), findsOneWidget);

  await tapVisibleText(tester, 'Music');
  await tapVisibleText(tester, 'Continue');
  expect(find.text('How AI works in your room'), findsOneWidget);

  if (openAISettings) {
    await tapVisibleText(tester, 'Customize AI settings');
    expect(find.text('AI settings preview'), findsOneWidget);
    await tapVisibleText(tester, 'Close');
  }

  await tapVisibleText(tester, 'I understand');
}

Future<void> tapVisibleText(WidgetTester tester, String text) async {
  await tapVisibleFinder(tester, find.text(text));
}

Future<void> tapVisibleFinder(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
