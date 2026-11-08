import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/fixtures/asistencia_fixtures.dart';
import 'package:solventa_mobile/features/assistance/data/mappers/asistencia_mapper.dart';
import 'package:solventa_mobile/features/assistance/data/mappers/prestador_mapper.dart';
import 'package:solventa_mobile/features/assistance/data/repositories/asistencia_repository_impl.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/asistencia.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';

void main() {
  const id = '0b6f3a52-5d6e-4d8e-9c1a-2f4b7c9d1e00';
  final clinica = prestadorDesdeMapa(AsistenciaFixtures.prestadores.first)!;
  late FakeAsistenciaRemoteDataSource bff;
  late AsistenciaRepositoryImpl repo;

  SolicitudAsistencia solicitud({
    String descripcion = '',
    String direccion = '',
  }) => SolicitudAsistencia(
    idSolicitud: id,
    prestador: clinica,
    tipo: TipoPrestador.medico,
    ubicacion: const Coordenada(4.676, -74.048),
    descripcion: descripcion,
    direccion: direccion,
  );

  setUp(() {
    bff = FakeAsistenciaRemoteDataSource(latencia: Duration.zero);
    repo = AsistenciaRepositoryImpl(bff, MemoriaCatalogoLocalDataSource());
  });

  test('la entrada lleva el contrato y los textos vacíos viajan como null', () {
    expect(entradaSolicitud(solicitud(descripcion: '  ')), {
      'idSolicitud': id,
      'prestadorId': 'prs-bog-001',
      'tipoAsistencia': 'MEDICO',
      'descripcion': null,
      'direccion': null,
      'latitud': 4.676,
      'longitud': -74.048,
    });
    expect(
      entradaSolicitud(solicitud(direccion: ' Cra 45 '))['direccion'],
      'Cra 45',
    );
  });

  test(
    'primero no confirmada; el reenvío con el mismo id, confirmada',
    () async {
      final primera = await repo.solicitar(solicitud());
      final a = (primera as Exito<Asistencia>).valor;
      expect(a.estado, EstadoAsistencia.noConfirmada);
      expect(a.minutosEstimados, isNull);
      expect(a.prestador.nombre, 'Clínica Norte');

      final segunda = (await repo.solicitar(solicitud())) as Exito<Asistencia>;
      expect(segunda.valor.id, id);
      expect(segunda.valor.estado, EstadoAsistencia.confirmada);
      expect(segunda.valor.minutosEstimados, 6);
    },
  );

  test('cancelar devuelve la asistencia cancelada', () async {
    bff.confirmarSiempre = true;
    await repo.solicitar(solicitud());
    final r = (await repo.cancelar(id)) as Exito<Asistencia>;
    expect(r.valor.estado, EstadoAsistencia.cancelada);
    expect(r.valor.canceladaEn, isNotNull);
  });

  test('el ErrorAsistencia llega como FallaNegocio con su código', () async {
    bff.rechazo = CodigosAsistencia.tipoNoAtendido;
    final r = await repo.solicitar(solicitud());
    expect(
      (r as Fracaso<Asistencia>).falla,
      isA<FallaNegocio>().having(
        (f) => f.motivo,
        'motivo',
        CodigosAsistencia.tipoNoAtendido,
      ),
    );
    final c = await repo.cancelar('no-existe');
    expect(
      ((c as Fracaso<Asistencia>).falla as FallaNegocio).motivo,
      CodigosAsistencia.noEncontrada,
    );
  });

  test('sin red es una falla reintentable, no una excepción', () async {
    bff.error = const ErrorRed();
    final r = await repo.solicitar(solicitud());
    final falla = (r as Fracaso<Asistencia>).falla;
    expect(falla, isA<SinConexion>());
    expect(falla.reintentable, isTrue);
  });

  test('un estado desconocido no se acepta en silencio', () {
    expect(
      () => asistenciaDesdeMapa(
        AsistenciaFixtures.asistencia(id: id, estado: 'EN_CAMINO'),
      ),
      throwsFormatException,
    );
  });
}
