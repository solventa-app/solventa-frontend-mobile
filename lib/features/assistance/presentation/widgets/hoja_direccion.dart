import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/asistencia.dart';
import '../providers.dart';

/// «¿Dónde estás?» (HU-M06, 2.0, boceto de ubicación paso 5).
///
/// Sugerencias de `autocompletarDireccion` mientras escribe (Colombia, en el
/// idioma de la app). Al elegir una, `ubicarDireccion(placeId)`; si no eligió
/// ninguna (o Places no respondió), «Buscar esta dirección» la ubica por el
/// texto. Devuelve la [DireccionEncontrada] al cerrar. Los mensajes salen del
/// catálogo según el código del backend, nunca del backend.
class HojaDireccion extends ConsumerStatefulWidget {
  const HojaDireccion({super.key});

  /// Abre la hoja y devuelve la dirección ubicada (o `null` si la cerró).
  static Future<DireccionEncontrada?> abrir(BuildContext context) =>
      SolBottomSheet.show<DireccionEncontrada>(
        context,
        builder: (_) => const HojaDireccion(),
      );

  @override
  ConsumerState<HojaDireccion> createState() => _HojaDireccionState();
}

class _HojaDireccionState extends ConsumerState<HojaDireccion> {
  final _texto = TextEditingController();
  Timer? _espera;
  List<SugerenciaDireccion> _sugerencias = const [];
  int _consulta = 0;
  bool _ubicando = false;
  String? _error;

  @override
  void dispose() {
    _espera?.cancel();
    _texto.dispose();
    super.dispose();
  }

  void _escribio(String texto) {
    _espera?.cancel();
    setState(() => _error = null);
    _espera = Timer(const Duration(milliseconds: 300), () async {
      final consulta = ++_consulta;
      final r = await ref
          .read(asistenciaRepositoryProvider)
          .sugerirDirecciones(texto);
      // Gana la última consulta: una respuesta vieja no pisa la nueva.
      if (!mounted || consulta != _consulta) return;
      setState(() {
        _sugerencias = switch (r) {
          Exito(:final valor) => valor,
          Fracaso() => const [],
        };
      });
    });
  }

  Future<void> _ubicar({String? placeId, String? texto}) async {
    if (_ubicando) return;
    setState(() {
      _ubicando = true;
      _error = null;
    });
    final r = await ref
        .read(asistenciaRepositoryProvider)
        .ubicarDireccion(placeId: placeId, texto: texto);
    if (!mounted) return;
    final l10n = context.l10n;
    switch (r) {
      case Exito(valor: final DireccionEncontrada d):
        Navigator.of(context).pop(d);
        return;
      case Exito(valor: DireccionNoEncontrada()):
        _error = l10n.direccionNoEncontrada;
      case Exito(valor: DireccionServicioCaido()) || Fracaso():
        _error = l10n.direccionServicioCaido;
    }
    setState(() => _ubicando = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final texto = _texto.text.trim();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolSectionHeader(title: l10n.direccionTitulo),
        SolTextField(
          label: l10n.direccionCampo,
          controller: _texto,
          textInputAction: TextInputAction.search,
          errorText: _error,
          onChanged: _escribio,
          onSubmitted: (v) {
            if (v.trim().length >= 3) unawaited(_ubicar(texto: v.trim()));
          },
        ),
        if (_ubicando)
          const Padding(
            padding: EdgeInsets.all(SolSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          for (final s in _sugerencias)
            ListTile(
              minTileHeight: 56,
              contentPadding: EdgeInsets.zero,
              leading: Icon(SolIcons.location, color: colors.onSurfaceVariant),
              title: Text(s.descripcion),
              onTap: () => unawaited(_ubicar(placeId: s.placeId)),
            ),
          if (texto.length >= 3) ...[
            const SizedBox(height: SolSpacing.sm),
            SolButton.tonal(
              label: l10n.direccionBuscar,
              onPressed: () => unawaited(_ubicar(texto: texto)),
            ),
          ],
        ],
      ],
    );
  }
}
