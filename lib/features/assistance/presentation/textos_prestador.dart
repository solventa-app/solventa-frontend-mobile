import 'package:flutter/widgets.dart';

import '../../../core/design_system/solventa_ui.dart';
import '../../../core/l10n/l10n.dart';
import '../domain/entities/prestador.dart';

/// Textos del prestador en el idioma de la app (contrato v0.53). Con una copia
/// del catálogo anterior a esa versión se usa el texto en español que trae.
extension TextosPrestador on AppLocalizations {
  /// «Urgencias» / «Emergency care»; vacía si el catálogo no la trae.
  String especialidadDe(Prestador p) => switch (p.codigoEspecialidad) {
    EspecialidadPrestador.urgencias => m0601EspecialidadUrgencias,
    EspecialidadPrestador.medicinaGeneral => m0601EspecialidadMedicinaGeneral,
    EspecialidadPrestador.mecanicaGeneral => m0601EspecialidadMecanicaGeneral,
    EspecialidadPrestador.llantasYFrenos => m0601EspecialidadLlantasYFrenos,
    EspecialidadPrestador.gruaLiviana => m0601EspecialidadGruaLiviana,
    EspecialidadPrestador.gruaYCarroTaller => m0601EspecialidadGruaYCarroTaller,
    null => p.especialidad,
  };

  /// «Lun a sáb, 7:00 a. m. a 7:00 p. m.» / «Mon–Sat, 7:00 AM to 7:00 PM»;
  /// `null` si no se publica.
  String? horarioDe(Prestador p, Locale locale) {
    final h = p.horarioAtencion;
    if (h == null) return p.horario;
    if (h.abierto24h) return m0601Abierto24h;
    final dias =
        h.diaDesde == DiaSemana.lunes && h.diaHasta == DiaSemana.domingo
        ? m0601TodosLosDias
        : h.diaDesde == h.diaHasta
        ? _dia(h.diaDesde!)
        : m0601RangoDias(_dia(h.diaDesde!), _dia(h.diaHasta!));
    final texto = m0601Horario(
      dias,
      _hora(h.abre!, locale),
      _hora(h.cierra!, locale),
    );
    return texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);
  }

  String _dia(DiaSemana d) => switch (d) {
    DiaSemana.lunes => m0601DiaLunes,
    DiaSemana.martes => m0601DiaMartes,
    DiaSemana.miercoles => m0601DiaMiercoles,
    DiaSemana.jueves => m0601DiaJueves,
    DiaSemana.viernes => m0601DiaViernes,
    DiaSemana.sabado => m0601DiaSabado,
    DiaSemana.domingo => m0601DiaDomingo,
  };

  /// «07:00» → «7:00 a. m.» o «7:00 AM».
  static String _hora(String hhmm, Locale locale) {
    final partes = hhmm.split(':');
    return SolFormat.timeFor(
      DateTime(2000, 1, 1, int.parse(partes[0]), int.parse(partes[1])),
      locale,
    );
  }
}
