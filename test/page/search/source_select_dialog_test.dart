import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/page/search/widget/source_select_dialog.dart';

void main() {
  testWidgets('source dialog renders only visible frontend sources', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => FilledButton(
            onPressed: () {
              showSourceSelectDialog(
                context,
                initial: const {'jm': true, 'bika': true},
                sourceOptions: const [
                  (pluginId: 'jm', title: 'JM'),
                  (pluginId: 'bika', title: 'Bika'),
                ],
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('JM'), findsOneWidget);
    expect(find.text('Bika'), findsNothing);
  });
}
