import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('android app config targets min sdk 21', () async {
    final content = await File('android/app/build.gradle.kts').readAsString();

    expect(content.contains('minSdk = 21 + 0'), isTrue);
  });

  test('android app config pins AndroidX core libraries for api 21', () async {
    final content = await File('android/app/build.gradle.kts').readAsString();

    expect(content.contains('configurations.all'), isTrue);
    expect(content.contains('force("androidx.core:core:1.16.0")'), isTrue);
    expect(content.contains('force("androidx.core:core-ktx:1.16.0")'), isTrue);
  });
}
