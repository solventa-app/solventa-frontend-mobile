import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/subida_archivo_service.dart';
import 'package:solventa_mobile/core/ubicacion/coordenada.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/repositories/reporte_siniestro_repository_impl.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_notifier.dart';

final _poliza = PolizaReportable(
  id: 'pol-demo-01',
  numero: 'SOL-2026-000123',
  vigenciaDesde: DateTime.utc(2026, 2, 10),
  vigenciaHasta: DateTime.utc(2027, 2, 10),
);

ReporteSiniestro _reporte({
  String id = '0c9f2b7e-4a51-4c1e-9d6a-1f2e3d4c5b6a',
}) => ReporteSiniestro(
  idReporte: id,
  poliza: _poliza,
  ocurridoEn: DateTime.utc(2026, 11, 4, 13),
  descripcion: '  Me chocaron por detrás en un semáforo.  ',
  lugar: 'Cra 15 con Calle 93',
  ciudad: 'Bogotá',
  ubicacion: const Coordenada(4.6767, -74.0483),
  fotos: [
    FotoSiniestro(
      bytes: Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xD9]),
      tipoContenido: 'image/jpeg',
      tomadaEn: DateTime.utc(2026, 11, 4, 13, 5),
      ubicacion: const Coordenada(4.6767, -74.0483),
    ),
    FotoSiniestro(
      bytes: Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xD9]),
      tipoContenido: 'image/jpeg',
      tomadaEn: DateTime.utc(2026, 11, 4, 13, 6),
    ),
  ],
);

void main() {
  late FakeReporteSiniestroRemoteDataSource bff;
  late FakeSubidaArchivoService bucket;
  late ReporteSiniestroRepositoryImpl repo;

  setUp(() {
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
    bucket = FakeSubidaArchivoService();
    repo = ReporteSiniestroRepositoryImpl(bff, bucket);
  });

  test(
    'las pólizas emitidas del cliente salen del fixture del contrato',
    () async {
      final r = await repo.polizas();
      final polizas = (r as Exito<List<PolizaReportable>>).valor;
      expect(polizas.map((p) => p.numero), [
        'SOL-2026-000123',
        'SOL-2026-000456',
      ]);
      expect(polizas.first.cubre(DateTime.utc(2026, 11, 4)), isTrue);
      expect(polizas.first.cubre(DateTime.utc(2025, 11, 4)), isFalse);
    },
  );

  test('sube cada foto, la confirma y crea el caso PENDIENTE', () async {
    final r = await repo.reportar(_reporte());
    final s = (r as Exito<SiniestroReportado>).valor;
    expect(s.radicado, 'SIN-2026-1001');
    expect(s.estado, 'PENDIENTE');
    expect(bucket.subidas, hasLength(2));
    final entrada = bff.reportes.single;
    expect(entrada.descripcion, 'Me chocaron por detrás en un semáforo.');
    expect(entrada.fotos.map((f) => f.archivoId), ['arch-1', 'arch-2']);
    expect(entrada.fotos.first.latitud, 4.6767);
    expect(entrada.fotos.last.latitud, isNull); // sin geoetiqueta
  });

  test(
    'CA-M05-04: si falla la red, el reintento no vuelve a subir las fotos',
    () async {
      bff.errorAlReportar = const ErrorRed();
      final primero = await repo.reportar(_reporte());
      expect(
        (primero as Fracaso<SiniestroReportado>).falla,
        isA<SinConexion>(),
      );
      expect(bff.subidas, hasLength(2));

      final segundo = await repo.reportar(_reporte());
      expect(segundo, isA<Exito<SiniestroReportado>>());
      expect(bff.subidas, hasLength(2)); // las mismas dos fotos
      expect(bff.reportes.single.idReporte, _reporte().idReporte);
    },
  );

  test(
    'la regla que rechaza CLAIMS llega con su mensaje para el cliente',
    () async {
      bff.rechazar = true;
      final r = await repo.reportar(_reporte());
      final falla = (r as Fracaso<SiniestroReportado>).falla;
      expect(falla, isA<FallaNegocio>());
      expect(
        (falla as FallaNegocio).motivo,
        'La fecha del siniestro está fuera de la vigencia de la póliza.',
      );
      expect(falla.reintentable, isFalse);
    },
  );

  test('nuevoIdReporte genera UUID v4 distintos', () {
    final a = nuevoIdReporte();
    final b = nuevoIdReporte();
    final uuid = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    );
    expect(uuid.hasMatch(a), isTrue);
    expect(a, isNot(b));
  });
}
