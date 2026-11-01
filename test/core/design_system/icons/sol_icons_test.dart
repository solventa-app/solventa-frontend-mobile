import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

void main() {
  test('Todos los íconos son Material Symbols outlined', () {
    const icons = [
      SolIcons.back,
      SolIcons.chevronRight,
      SolIcons.expandMore,
      SolIcons.close,
      SolIcons.home,
      SolIcons.assistance,
      SolIcons.assistanceActive,
      SolIcons.logout,
      SolIcons.language,
      SolIcons.profile,
      SolIcons.lock,
      SolIcons.backspace,
      SolIcons.medical,
      SolIcons.mechanic,
      SolIcons.verifiedProvider,
      SolIcons.location,
      SolIcons.schedule,
      SolIcons.pendingRegistration,
      SolIcons.wallet,
      SolIcons.success,
      SolIcons.inReview,
      SolIcons.failure,
      SolIcons.warning,
      SolIcons.info,
      SolIcons.check,
      SolIcons.attention,
      SolIcons.error,
      SolIcons.camera,
      SolIcons.retry,
      SolIcons.idCard,
      SolIcons.lighting,
      SolIcons.face,
      SolIcons.portrait,
    ];
    for (final icon in icons) {
      expect(icon.fontFamily, 'MaterialSymbolsOutlined');
      expect(icon.fontPackage, 'material_symbols_icons');
    }
  });
}
