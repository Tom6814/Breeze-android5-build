import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/page/plugin_settings/view/plugin_settings_page.dart';

void main() {
  testWidgets('hidden plugin shows frontend closed state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PluginSettingsPage(
          from: 'bika',
          pluginUuid: 'bika',
          pluginRuntimeName: 'bika',
          pluginDisplayName: 'Bika',
        ),
      ),
    );

    await tester.pump();

    expect(find.text('当前来源未在前端开放'), findsOneWidget);
    expect(find.text('Bika 设置'), findsNothing);
  });
}
