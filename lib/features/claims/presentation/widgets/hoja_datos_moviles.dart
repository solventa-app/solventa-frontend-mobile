import 'package:flutter/material.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';

/// Lo que el cliente eligió al enviar por datos móviles.
typedef EleccionDatos = ({bool conDatos, bool recordar});

/// «Estás usando datos móviles» (HU-M05, plan 4.4): se pregunta la primera
/// vez que un reporte va a salir por datos. Con «Recordar mi elección» queda
/// como la preferencia de Mi perfil y no se vuelve a preguntar.
class HojaDatosMoviles extends StatefulWidget {
  const HojaDatosMoviles({super.key, required this.fotos, required this.bytes});

  final int fotos;
  final int bytes;

  /// `null` si cerró la hoja sin elegir: no se envía nada.
  static Future<EleccionDatos?> preguntar(
    BuildContext context, {
    required int fotos,
    required int bytes,
  }) => SolBottomSheet.show<EleccionDatos>(
    context,
    builder: (_) => HojaDatosMoviles(fotos: fotos, bytes: bytes),
  );

  @override
  State<HojaDatosMoviles> createState() => _HojaDatosMovilesState();
}

class _HojaDatosMovilesState extends State<HojaDatosMoviles> {
  bool _recordar = true;

  void _elegir({required bool conDatos}) =>
      Navigator.pop(context, (conDatos: conDatos, recordar: _recordar));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final tamano = SolFormat.megabytesFor(
      widget.bytes,
      Localizations.localeOf(context),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(SolIcons.mobileData, color: colors.primary),
            const SizedBox(width: SolSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.m05DatosTitulo,
                      style: context.solText.title,
                    ),
                  ),
                  const SizedBox(height: SolSpacing.xxs),
                  Text(
                    l10n.m05DatosMensaje(widget.fotos, tamano),
                    style: context.solText.body.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: SolSpacing.lg),
        SolButton.primary(
          label: l10n.m05EnviarConDatos,
          onPressed: () => _elegir(conDatos: true),
        ),
        const SizedBox(height: SolSpacing.sm),
        SolButton.outlined(
          label: l10n.m05EsperarWifi,
          icon: SolIcons.wifi,
          onPressed: () => _elegir(conDatos: false),
        ),
        const SizedBox(height: SolSpacing.sm),
        SolConsentCheckbox(
          value: _recordar,
          onChanged: (v) => setState(() => _recordar = v),
          label: l10n.m05DatosRecordar,
        ),
      ],
    );
  }
}
