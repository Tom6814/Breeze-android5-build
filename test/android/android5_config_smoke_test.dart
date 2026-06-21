import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('android app config targets min sdk 21', () async {
    final content = await File('android/app/build.gradle.kts').readAsString();

    expect(content.contains('minSdk = 21 + 0'), isTrue);
  });
}
