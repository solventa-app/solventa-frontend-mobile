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

  test('v0.50: la dirección escrita y ubicada viaja con coordenadas y origen DIRECCION', () async {
    final r = await repo.solicitar(
      SolicitudAsistencia(
        idSolicitud: id,
        prestador: clinica,
        tipo: TipoPrestador.medico,
        ubicacion: const Coordenada(4.6729, -74.0512),
        origen: OrigenUbicacion.direccion,
        descripcion: '  ',
        direccion: ' Cra 45 # 22-18 ',
      ),
    );
    expect(r, isA<Exito<Asistencia>>());
    expect(bff.solicitudes.single, {
      'idSolicitud': id,
      'prestadorId': 'prs-bog-001',
      'tipoAsistencia': 'MEDICO',
      'descripcion': null,
      'direccion': 'Cra 45 # 22-18',
      'latitud': 4.6729,
      'longitud': -74.0512,
      'origenUbicacion': 'DIRECCION',
    });
  });

  group('2.0: dirección escrita', () {
    test('sugerencias desde 3 letras; con el BFF caído, lista vacía', () async {
      expect(
        await repo.sugerirDirecciones('Cr'),
        isA<Exito<List<SugerenciaDireccion>>>(),
      );
      final r = await repo.sugerirDirecciones('Cra 45');
      final lista = (r as Exito<List<SugerenciaDireccion>>).valor;
      expect(lista.first.descripcion, 'Cra 45, Bogotá, Cundinamarca');
      bff.error = const ErrorRed();
      final caido = await repo.sugerirDirecciones('Cra 45');
      expect((caido as Exito<List<SugerenciaDireccion>>).valor, isEmpty);
    });

    test('ubicar: encontrada, no encontrada o servicio caído', () async {
      final ok = await repo.ubicarDireccion(texto: 'Cra 45 # 22-18');
      final d = (ok as Exito<DireccionUbicada>).valor as DireccionEncontrada;
      expect(d.direccion, 'Cra 45 # 22-18');
      expect(d.coordenada.latitud, closeTo(4.67, 0.01));
      final no = await repo.ubicarDireccion(texto: 'calle noexiste');
      expect(
        (no as Exito<DireccionUbicada>).valor,
        isA<DireccionNoEncontrada>(),
      );
      bff.lugaresCaidos = true;
      final caido = await repo.ubicarDireccion(placeId: 'stub:CO:Cra 45');
      expect(
        (caido as Exito<DireccionUbicada>).valor,
        isA<DireccionServicioCaido>(),
      );
    });
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
      'origenUbicacion': 'GPS',
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
