import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/plugin/visible_plugin_policy.dart';

void main() {
  test('JM remains visible while Bika is hidden', () {
    expect(isPluginVisibleInFrontend('jm'), isTrue);
    expect(isPluginVisibleInFrontend('JM'), isTrue);
    expect(isPluginVisibleInFrontend('bika'), isFalse);
    expect(isPluginVisibleInFrontend('Bika'), isFalse);
  });

  test('unknown plugin is hidden by default', () {
    expect(isPluginVisibleInFrontend(''), isFalse);
    expect(isPluginVisibleInFrontend('random-source'), isFalse);
  });
}
