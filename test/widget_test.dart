import 'package:flutter_test/flutter_test.dart';
import 'package:oppose/app/oppose_app.dart';

void main() {
  testWidgets('Oppose app opens to welcome screen', (tester) async {
    await tester.pumpWidget(const OpposeApp());
    await tester.pumpAndSettle();

    expect(find.text('Different take, better talk.'), findsOneWidget);
    expect(find.text('Start debating'), findsOneWidget);
  });
}
