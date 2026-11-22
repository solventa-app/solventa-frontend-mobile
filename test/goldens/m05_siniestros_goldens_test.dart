import 'dart:async';
import 'dart:typed_data';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_06_mis_siniestros_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_07_detalle_siniestro_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';

/// HU-M05 (KAN-35, contrato v0.54): «Mis siniestros» con su filtro (M05-06) y
/// el detalle de un caso (M05-07) en revisión y aprobado, con el carrusel de
/// fotos (sin almacenamiento en el fake: «Imagen no disponible»), la línea de
/// tiempo y la póliza. Sin conexión (plan §4.5): «Por enviar» arriba, con un
/// borrador reciente y otro a punto de borrarse.
void main() {
  DateTime ahora() => DateTime.utc(2026, 11, 5, 17, 40);

  Widget conL10n(Widget hijo, Locale locale) => Builder(
    builder: (context) => Localizations.override(
      context: context,
      locale: locale,
      delegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      child: hijo,
    ),
  );

  Widget pantalla(
    Widget pagina,
    Locale locale, {
    AlmacenReportesMemoria? almacen,
  }) => ProviderScope(
    overrides: [
      usarFakesProvider.overrideWithValue(true),
      reporteSiniestroRemoteDataSourceProvider.overrideWithValue(
        FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero),
      ),
      if (almacen != null) ...[
        cuentaReporteProvider.overrideWithValue('c1'),
        almacenReportesProvider.overrideWithValue(almacen),
        relojReporteProvider.overrideWithValue(ahora),
      ],
    ],
    child: conL10n(pagina, locale),
  );

  /// Dos borradores: uno de hace un rato y otro de hace 6 días (se borra mañana).
  AlmacenReportesMemoria conBorradores() {
    final almacen = AlmacenReportesMemoria();
    void borrador(String id, Duration hace, {PolizaReportable? poliza}) {
      final cuando = ahora().subtract(hace);
      unawaited(
        almacen.guardar(
          ReporteGuardado(
            id: id,
            cuentaId: 'c1',
            estado: EstadoLocal.borrador,
            creadoEn: cuando,
            actualizadoEn: cuando,
            poliza: poliza,
            tipoAuto: poliza == null ? null : TipoSiniestroAuto.choqueParcial,
          ),
        ),
      );
      unawaited(
        almacen.agregarFoto(
          id,
          bytes: Uint8List.fromList([1, 2, 3]),
          tipoContenido: 'image/jpeg',
          tomadaEn: cuando,
        ),
      );
    }

    borrador(
      'b1',
      const Duration(minutes: 20),
      poliza: PolizaReportable(
        id: 'pol-1',
        numero: 'SOL-2026-000456',
        vigenciaDesde: DateTime.utc(2026, 6),
        vigenciaHasta: DateTime.utc(2027, 6),
        esAuto: true,
        vehiculo: 'MAZDA ABC•••',
      ),
    );
    borrador('b2', const Duration(days: 6));
    return almacen;
  }

  final casos = <(double, double, Locale)>[
    (360, 1, AppLocales.es),
    (390, 1, AppLocales.es),
    (390, 2, AppLocales.es),
    (390, 1, AppLocales.en),
  ];

  for (final (ancho, escala, locale) in casos) {
    final sufijo = '${ancho.toInt()}_x${escala.toInt()}_${locale.languageCode}';
    goldenTest(
      'M05-06 Mis siniestros · $sufijo',
      fileName: 'm05_06_mis_siniestros_$sufijo',
      textScaleFactor: escala,
      constraints: BoxConstraints.tight(Size(ancho, escala > 1 ? 1500 : 900)),
      builder: () =>
          pantalla(M0506MisSiniestrosPage(ahora: ahora, onHome: () {}), locale),
    );
    goldenTest(
      'M05-06 Mis siniestros con borradores · $sufijo',
      fileName: 'm05_06_por_enviar_$sufijo',
      textScaleFactor: escala,
      constraints: BoxConstraints.tight(Size(ancho, escala > 1 ? 2400 : 1400)),
      builder: () => pantalla(
        M0506MisSiniestrosPage(ahora: ahora),
        locale,
        almacen: conBorradores(),
      ),
    );
    for (final (id, nombre) in [
      ('demo-2', 'revision'),
      ('demo-3', 'aprobado'),
    ]) {
      goldenTest(
        'M05-07 Detalle $nombre · $sufijo',
        fileName: 'm05_07_detalle_${nombre}_$sufijo',
        textScaleFactor: escala,
        constraints: BoxConstraints.tight(
          Size(ancho, escala > 1 ? 2400 : 1400),
        ),
        builder: () => pantalla(
          M0507DetalleSiniestroPage(
            id: id,
            ahora: ahora,
            cadaCuanto: const Duration(days: 1),
            onHome: () {},
          ),
          locale,
        ),
      );
    }
  }
}
