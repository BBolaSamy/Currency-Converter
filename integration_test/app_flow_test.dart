import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:currency_converter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Main flows: navigate between tabs', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Currencies'), findsOneWidget);

    await tester.tap(find.text('Convert'));
    await tester.pumpAndSettle();
    expect(find.text('Convert'), findsOneWidget);

    await tester.tap(find.text('Historical'));
    await tester.pumpAndSettle();
    expect(find.text('Historical (7 days)'), findsOneWidget);
  });
}
