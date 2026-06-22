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

  test('android 21 build avoids rustls platform verifier android glue', () async {
    final gradleContent = await File('android/app/build.gradle.kts').readAsString();
    final activityContent = await File(
      'android/app/src/main/kotlin/com/zephyr/breeze/MainActivity.kt',
    ).readAsString();

    expect(
      gradleContent.contains('implementation("rustls:rustls-platform-verifier:0.1.1")'),
      isFalse,
    );
    expect(activityContent.contains('initRustlsPlatformVerifier'), isFalse);
  });

  test('android 21 release workflow uses temporary signing and release build', () async {
    final content = await File(
      '.github/workflows/android5-jm-release.yml',
    ).readAsString();

    expect(content.contains('push:'), isTrue);
    expect(content.contains('branches:'), isTrue);
    expect(content.contains('- main'), isTrue);
    expect(content.contains('keytool -genkeypair'), isTrue);
    expect(content.contains('android/key.properties'), isTrue);
    expect(content.contains('fvm dart ./script/build_apk.dart'), isTrue);
    expect(content.contains('fvm dart ./script/build_apk.dart debug'), isFalse);
    expect(content.contains('android5-jm-release-apks'), isTrue);
  });
}
