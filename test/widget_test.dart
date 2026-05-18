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

    await tapVisibleText(tester, 'Start debating');
    expect(find.text('Create your Oppose account'), findsOneWidget);

    await tapVisibleText(tester, 'Create account');
    expect(find.text('Enter your email or phone.'), findsOneWidget);

    await tester.enterText(
      find.byType(EditableText).at(0),
      'friend@example.com',
    );
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

    await tapVisibleText(tester, 'Customize AI settings');
    expect(find.text('AI settings preview'), findsOneWidget);
    await tapVisibleText(tester, 'Close');

    await tapVisibleText(tester, 'I understand');
    expect(find.text("Hi, Bima's Friend"), findsOneWidget);
  });
}

Future<void> tapVisibleText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
