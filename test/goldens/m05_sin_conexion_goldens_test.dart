@Tags(['golden'])
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';
import 'package:solventa_mobile/core/ubicacion/coordenada.dart';
import 'package:solventa_mobile/features/claims/data/cola_reportes.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/data/preferencias_envio.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_05_resultado_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_06_mis_siniestros_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_07b_reporte_pendiente_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_notifier.dart';
import 'package:solventa_mobile/features/claims/presentation/widgets/cierre_sesion_reportes.dart';
import 'package:solventa_mobile/features/claims/presentation/widgets/hoja_datos_moviles.dart';
import 'package:solventa_mobile/features/home/presentation/home_page.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/verificacion_identidad.dart';
import 'package:solventa_mobile/features/profile/presentation/perfil_sin_conexion.dart';

/// El recorrido ya terminó en «Reporte guardado» (M05-05).
class _ReporteGuardadoFijo extends ReporteNotifier {
  _ReporteGuardadoFijo(this._espera);

  final EsperaCola _espera;

  @override
  ReporteState build() => ReporteState(
    idReporte: 'r1',
    fotos: [
      for (var i = 0; i < 2; i++)
        FotoSiniestro(
          bytes: Uint8List.fromList([1, 2, 3]),
          tipoContenido: 'image/jpeg',
          tomadaEn: DateTime.utc(2026, 11, 5, 17, 30),
        ),
    ],
    envio: EnvioGuardado(
      guardadoEn: DateTime.utc(2026, 11, 5, 17, 35),
      espera: _espera,
    ),
  );
}

/// HU-M05, reporte sin conexión (KAN-35, plan 4.4 a 4.6 y bocetos 3.3 a 3.9):
/// lo que el cliente ve mientras su reporte espera en el teléfono. «Reporte
/// guardado», la cola en «Mis siniestros», el detalle de uno por enviar, la
/// hoja de datos móviles, el cierre de sesión con reportes, y el inicio y Mi
/// perfil cuando se entró con la huella y sin red.
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

  /// Sin señal y con lo guardado en [almacen].
  Widget sinRed(
    Widget pagina,
    Locale locale, {
    AlmacenReportesMemoria? almacen,
    TipoRed red = TipoRed.ninguna,
    EsperaCola? guardadoCon,
  }) => ProviderScope(
    overrides: [
      usarFakesProvider.overrideWithValue(true),
      conectividadProvider.overrideWithValue(ConectividadFalsa(red)),
      sondaRedProvider.overrideWithValue(SondaFalsa()),
      reporteSiniestroRemoteDataSourceProvider.overrideWithValue(
        FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero)
          ..sinRed = true,
      ),
      cuentaReporteProvider.overrideWithValue('c1'),
      almacenReportesProvider.overrideWithValue(
        almacen ?? AlmacenReportesMemoria(),
      ),
      relojReporteProvider.overrideWithValue(ahora),
      preferenciasEnvioStoreProvider.overrideWithValue(
        MemoriaPreferenciasEnvioStore(),
      ),
      if (guardadoCon != null)
        reporteProvider.overrideWith(() => _ReporteGuardadoFijo(guardadoCon)),
    ],
    child: conL10n(pagina, locale),
  );

  final poliza = PolizaReportable(
    id: 'pol-1',
    numero: 'SOL-2026-000456',
    vigenciaDesde: DateTime.utc(2026, 6),
    vigenciaHasta: DateTime.utc(2027, 6),
    esAuto: true,
    vehiculo: 'MAZDA ABC•••',
  );

  ReporteGuardado reporte(
    String id,
    EstadoLocal estado, {
    Duration hace = const Duration(minutes: 5),
    String? error,
    int intentos = 0,
  }) {
    final cuando = ahora().subtract(hace);
    return ReporteGuardado(
      id: id,
      cuentaId: 'c1',
      estado: estado,
      creadoEn: cuando,
      actualizadoEn: cuando,
      guardadoEn: cuando,
      poliza: poliza,
      tipoAuto: TipoSiniestroAuto.choqueParcial,
      ocurridoEn: cuando.subtract(const Duration(hours: 1)),
      descripcion: 'Me chocaron por detrás en un semáforo.',
      lugar: 'Cra 15 con Calle 93',
      ciudad: 'Bogotá',
      ubicacion: const Coordenada(4.6767, -74.0483),
      ultimoError: error,
      intentos: intentos,
    );
  }

  /// La cola con sus tres casos: esperando señal, rechazado por la
  /// aseguradora y uno que agotó los reintentos.
  AlmacenReportesMemoria conCola(List<ReporteGuardado> reportes) {
    final almacen = AlmacenReportesMemoria();
    for (final r in reportes) {
      unawaited(almacen.guardar(r));
      for (var i = 0; i < 2; i++) {
        unawaited(
          almacen.agregarFoto(
            r.id,
            bytes: Uint8List.fromList([1, 2, 3]),
            tipoContenido: 'image/jpeg',
            tomadaEn: r.creadoEn,
          ),
        );
      }
    }
    return almacen;
  }

  const rechazo = 'La póliza no cubre la fecha del siniestro.';
  List<ReporteGuardado> cola() => [
    reporte('p1', EstadoLocal.pendiente),
    reporte(
      'p2',
      EstadoLocal.conError,
      hace: const Duration(hours: 3),
      error: rechazo,
    ),
    reporte(
      'p3',
      EstadoLocal.necesitaAtencion,
      hace: const Duration(hours: 30),
      intentos: 8,
    ),
  ];

  Widget enTarjeta(Widget hijo) => ColoredBox(
    color: SolColors.surfaceContainer,
    child: Padding(
      padding: const EdgeInsets.all(SolSpacing.lg),
      child: Material(
        color: SolColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: SolRadius.cardAll),
        child: hijo,
      ),
    ),
  );

  final casos = <(double, double, Locale)>[
    (360, 1, AppLocales.es),
    (390, 2, AppLocales.es),
    (390, 1, AppLocales.en),
  ];

  for (final (ancho, escala, locale) in casos) {
    final sufijo = '${ancho.toInt()}_x${escala.toInt()}_${locale.languageCode}';
    BoxConstraints alto(double normal, double grande) =>
        BoxConstraints.tight(Size(ancho, escala > 1 ? grande : normal));

    goldenTest(
      'M05-05 Reporte guardado sin conexión · $sufijo',
      fileName: 'm05_05_guardado_sin_red_$sufijo',
      textScaleFactor: escala,
      constraints: alto(844, 1500),
      builder: () => sinRed(
        const M0505ResultadoPage(),
        locale,
        guardadoCon: EsperaCola.sinRed,
      ),
    );
    goldenTest(
      'M05-05 Reporte guardado esperando Wi-Fi · $sufijo',
      fileName: 'm05_05_guardado_wifi_$sufijo',
      textScaleFactor: escala,
      constraints: alto(844, 1500),
      builder: () => sinRed(
        const M0505ResultadoPage(),
        locale,
        red: TipoRed.movil,
        guardadoCon: EsperaCola.wifi,
      ),
    );
    goldenTest(
      'M05-06 Mis siniestros con la cola sin conexión · $sufijo',
      fileName: 'm05_06_cola_sin_red_$sufijo',
      textScaleFactor: escala,
      constraints: alto(1500, 2800),
      builder: () => sinRed(
        M0506MisSiniestrosPage(ahora: ahora),
        locale,
        almacen: conCola(cola()),
      ),
    );
    goldenTest(
      'M05-07b Reporte por enviar esperando conexión · $sufijo',
      fileName: 'm05_07b_esperando_$sufijo',
      textScaleFactor: escala,
      constraints: alto(1400, 2600),
      builder: () => sinRed(
        const M0507bReportePendientePage(id: 'p1'),
        locale,
        almacen: conCola(cola()),
      ),
    );
    goldenTest(
      'M05-07b Reporte que la aseguradora no aceptó · $sufijo',
      fileName: 'm05_07b_rechazado_$sufijo',
      textScaleFactor: escala,
      constraints: alto(1400, 2600),
      builder: () => sinRed(
        const M0507bReportePendientePage(id: 'p2'),
        locale,
        almacen: conCola(cola()),
      ),
    );
    goldenTest(
      'M05-03 Hoja de datos móviles · $sufijo',
      fileName: 'm05_03_datos_moviles_$sufijo',
      textScaleFactor: escala,
      constraints: BoxConstraints.tightFor(width: ancho),
      builder: () => conL10n(
        enTarjeta(
          const Padding(
            padding: EdgeInsets.all(SolSpacing.lg),
            child: HojaDatosMoviles(fotos: 2, bytes: 3565158),
          ),
        ),
        locale,
      ),
    );
    goldenTest(
      'G-04 Cierre de sesión con reportes guardados · $sufijo',
      fileName: 'g04_cierre_con_reportes_$sufijo',
      textScaleFactor: escala,
      constraints: BoxConstraints.tightFor(width: ancho),
      builder: () => conL10n(
        enTarjeta(
          const DialogoCierreConReportes(
            sinEnviar: 2,
            sinTerminar: 1,
            puedeEnviar: true,
          ),
        ),
        locale,
      ),
    );
    goldenTest(
      'G-03 Inicio sin conexión · $sufijo',
      fileName: 'home_sin_conexion_$sufijo',
      textScaleFactor: escala,
      constraints: alto(900, 1700),
      builder: () => conL10n(
        Scaffold(
          body: SafeArea(
            child: HomePage(
              userName: 'Laura',
              verificacion: EstadoVerificacion.verificada,
              sinConexion: true,
              porEnviar: 1,
              onCompleteRegistration: () {},
              onRequestAssistance: () {},
              onReportClaim: () {},
              onMyClaims: () {},
              onMyCoverage: () {},
            ),
          ),
        ),
        locale,
      ),
    );
    goldenTest(
      'G-05 Mi perfil sin conexión · $sufijo',
      fileName: 'g05_perfil_sin_conexion_$sufijo',
      textScaleFactor: escala,
      constraints: alto(1300, 2500),
      builder: () => sinRed(
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(SolSpacing.lg),
              child: PerfilSinConexion(
                cuenta: CuentaLocal(
                  id: 'c1',
                  nombre: 'Laura Gómez',
                  verificada: true,
                  ultimaConexion: ahora(),
                ),
                idioma: locale.languageCode.toUpperCase(),
                moneda: 'COP',
                onVerPorEnviar: () {},
                onLogout: () {},
              ),
            ),
          ),
        ),
        locale,
        almacen: conCola([reporte('p1', EstadoLocal.pendiente)]),
      ),
    );
  }
}
