import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/push/push_service.dart';

void main() {
  test(
    'el manifiesto declara el canal de push como canal por defecto de FCM',
    () {
      final manifiesto = File('android/app/src/main/AndroidManifest.xml')
          .readAsStringSync();
      expect(
        manifiesto,
        contains(
          'android:name="com.google.firebase.messaging.default_notification_channel_id"',
        ),
      );
      expect(manifiesto, contains('android:value="${canalPush.id}"'));
    },
  );
}
