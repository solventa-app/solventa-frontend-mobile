import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/contrato/schema.graphql.dart';
import 'package:solventa_mobile/core/ubicacion/coordenada.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/fixtures/reporte_siniestro_fixtures.dart';
import 'package:solventa_mobile/features/claims/data/graphql/reporte_siniestro.graphql.dart';
import 'package:solventa_mobile/features/claims/data/mappers/reporte_siniestro_mapper.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';

import '../../helpers/bff_de_prueba.dart';

/// El datasource real contra un BFF simulado: las respuestas pasan por los
/// tipos generados, así que una que rompa el contrato falla aquí.
void main() {
  late BffDePrueba bff;
  late GqlReporteSiniestroRemoteDataSource remoto;

  setUp(() {
    bff = BffDePrueba();
    remoto = GqlReporteSiniestroRemoteDataSource(bff.cliente);
  });

  test('polizas trae las pólizas para reportar', () async {
    bff.responder(ReporteSiniestroFixtures.polizas);

    final r = await remoto.polizas();

    expect(r.propuestas.propuestas, isNotEmpty);
    expect(bff.query, contains('propuestas'));
  });

  test('solicitarSubida manda reporte, tipo y tamaño', () async {
    bff.responder(ReporteSiniestroFixtures.subida('arch-1'));

    final r = await remoto.solicitarSubida('rep-1', 'image/jpeg', 2048);

    final subida =
        r as Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo;
    expect(subida.archivo.id, 'arch-1');
    expect(subida.metodo, 'PUT');
    expect(bff.variables, {
      'idReporte': 'rep-1',
      'tipoContenido': 'image/jpeg',
      'tamanoBytes': 2048,
    });
  });

  test('confirmar manda el id del archivo', () async {
    bff.responder(ReporteSiniestroFixtures.confirmada('arch-1'));

    final r = await remoto.confirmar('arch-1');

    expect(
      (r as Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo)
          .id,
      'arch-1',
    );
    expect(bff.variables, {'id': 'arch-1'});
  });

  Input$ReporteSiniestroInput entrada() => Input$ReporteSiniestroInput(
    idReporte: 'rep-1',
    polizaId: 'pol-demo-01',
    ocurridoEn: DateTime.utc(2026, 11, 4, 13),
    descripcion: 'Choque leve',
    ubicacion: Input$UbicacionReporteInput(
      descripcion: 'Calle 80',
      ciudad: 'Bogotá',
      latitud: 4.68,
      longitud: -74.05,
    ),
    fotos: [
      Input$FotoReporteInput(
        archivoId: 'arch-1',
        tomadaEn: DateTime.utc(2026, 11, 4, 13, 5),
      ),
    ],
  );

  test('reportar devuelve el siniestro reportado', () async {
    bff.responder(ReporteSiniestroFixtures.reportado('rep-1', 1));

    final r = await remoto.reportar(entrada());

    expect(
      r,
      isA<Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado>(),
    );
    expect(
      (bff.variables['entrada'] as Map<String, dynamic>)['idReporte'],
      'rep-1',
    );
  });

  test(
    'solo llegan las pólizas de auto, con su vehículo; la de vida no',
    () async {
      // El fixture trae la póliza de vida del crédito hipotecario y la de auto.
      bff.responder(ReporteSiniestroFixtures.polizas);

      final polizas = polizasDesdeGql(await remoto.polizas());

      expect(polizas.map((p) => p.numero), ['SOL-2026-000456']);
      expect(polizas.single.esAuto, isTrue);
      expect(polizas.single.vehiculo, 'MAZDA ABC•••');
    },
  );

  test('el reporte de auto manda el tipo de siniestro (KAN-290)', () {
    final reporte = ReporteSiniestro(
      idReporte: 'rep-1',
      poliza: PolizaReportable(
        id: 'pol-demo-02',
        numero: 'SOL-2026-000456',
        vigenciaDesde: DateTime.utc(2026, 6),
        vigenciaHasta: DateTime.utc(2027, 6),
        esAuto: true,
      ),
      ocurridoEn: DateTime.utc(2026, 11, 4, 13),
      descripcion: 'Choque leve en la calle 80 con 30.',
      lugar: 'Calle 80 con 30',
      ciudad: 'Bogotá',
      ubicacion: const Coordenada(4.68, -74.07),
      fotos: const [],
      tipoAuto: TipoSiniestroAuto.hurtoParcial,
    );

    expect(
      entradaReporte(reporte, const []).toJson()['tipoSiniestroAuto'],
      'HURTO_PARCIAL',
    );
  });

  test('reportar devuelve la regla rechazada', () async {
    bff.responder(ReporteSiniestroFixtures.rechazado);

    final r = await remoto.reportar(entrada());

    expect(
      r,
      isA<Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro>(),
    );
  });

  test('misSiniestros trae el historial', () async {
    bff.responder(ReporteSiniestroFixtures.misSiniestros(nuevos: ['rep-1']));

    final r = await remoto.misSiniestros();

    expect(r.misSiniestros, isNotEmpty);
    expect(bff.query, contains('misSiniestros'));
  });
}
