import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/textos_prestador.dart';

/// HU-M06 (contrato v0.53): especialidad, horario, horas y distancias en el
/// idioma de la app, no en el español que antes mandaba el backend.
void main() {
  final es = lookupAppLocalizations(AppLocales.es);
  final en = lookupAppLocalizations(AppLocales.en);
  const ubicacion = Coordenada(4.68, -74.05);

  Prestador prestador({
    EspecialidadPrestador? codigo,
    HorarioAtencion? horario,
    String especialidad = 'Grúa liviana',
    String? horarioTexto,
  }) => Prestador(
    id: 'p',
    nombre: 'P',
    tipo: TipoPrestador.grua,
    ubicacion: ubicacion,
    ciudad: 'Bogotá',
    especialidad: especialidad,
    horario: horarioTexto,
    codigoEspecialidad: codigo,
    horarioAtencion: horario,
  );

  const lunASab = HorarioAtencion(
    abierto24h: false,
    diaDesde: DiaSemana.lunes,
    diaHasta: DiaSemana.sabado,
    abre: '07:00',
    cierra: '19:00',
  );

  test('la especialidad se traduce; sin código, el texto de la copia', () {
    final p = prestador(codigo: EspecialidadPrestador.gruaLiviana);
    expect(es.especialidadDe(p), 'Grúa liviana');
    expect(en.especialidadDe(p), 'Light tow truck');
    expect(en.especialidadDe(prestador()), 'Grúa liviana');
  });

  test('el horario se arma en cada idioma', () {
    const n = SolFormat.nbsp;
    expect(
      es.horarioDe(prestador(horario: lunASab), AppLocales.es),
      'Lun a sáb, 7:00 a.${n}m. a 7:00 p.${n}m.',
    );
    expect(
      en.horarioDe(prestador(horario: lunASab), AppLocales.en),
      'Mon–Sat, 7:00${n}AM to 7:00${n}PM',
    );
    const todos = HorarioAtencion(
      abierto24h: false,
      diaDesde: DiaSemana.lunes,
      diaHasta: DiaSemana.domingo,
      abre: '06:00',
      cierra: '22:00',
    );
    expect(
      en.horarioDe(prestador(horario: todos), AppLocales.en),
      'Every day, 6:00${n}AM to 10:00${n}PM',
    );
    const abierto = HorarioAtencion(abierto24h: true);
    expect(
      es.horarioDe(prestador(horario: abierto), AppLocales.es),
      'Abierto 24 h',
    );
    expect(
      en.horarioDe(prestador(horario: abierto), AppLocales.en),
      'Open 24 hours',
    );
  });

  test('sin horario de datos se usa el de la copia (o ninguno)', () {
    expect(
      en.horarioDe(prestador(horarioTexto: 'Abierto 24 h'), AppLocales.en),
      'Abierto 24 h',
    );
    expect(en.horarioDe(prestador(), AppLocales.en), isNull);
  });

  test('horas y distancias según el idioma', () {
    final d = DateTime(2026, 11, 18, 14, 5);
    expect(SolFormat.timeFor(d, AppLocales.es), SolFormat.time(d));
    expect(SolFormat.timeFor(d, AppLocales.en), '2:05${SolFormat.nbsp}PM');
    expect(
      SolFormat.timeFor(DateTime(2026, 1, 1, 0, 30), const Locale('en')),
      '12:30${SolFormat.nbsp}AM',
    );
    expect(
      SolFormat.distanceKmFor(1.5, AppLocales.es),
      '1,5${SolFormat.nbsp}km',
    );
    expect(
      SolFormat.distanceKmFor(1250.5, AppLocales.en),
      '1,250.5${SolFormat.nbsp}km',
    );
  });
}
