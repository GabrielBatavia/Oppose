import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oppose/app/oppose_app.dart';

void main() {
  testWidgets('Oppose app opens to welcome screen', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();

    expect(find.text('Different take, better talk.'), findsOneWidget);
    expect(find.text('Start debating'), findsOneWidget);
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
