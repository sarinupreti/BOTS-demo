import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bots_demo/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('success', (WidgetTester tester) async {
    expect(1 + 1, 2); // This should pass
  });

  testWidgets('failure 1', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    app.main();

    // Verify that platform version is retrieved.
    await expectLater(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text && widget.data.startsWith('This should fail'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('failure 2', (WidgetTester tester) async {
    expect(1 + 1, 3); // This should fail
  });
}
