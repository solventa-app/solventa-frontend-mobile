import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/config/app_config.dart';

void main() {
  test('sin --dart-define-from-file el ambiente es dev', () {
    expect(AppConfig.flavor, 'dev');
    expect(AppConfig.isDev, isTrue);
    expect(AppConfig.isProd, isFalse);
    expect(AppConfig.apiEnv, 'mock');
  });
}
