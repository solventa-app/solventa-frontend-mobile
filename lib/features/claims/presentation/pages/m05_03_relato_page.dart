import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/ciudades.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';
import '../reporte_routes.dart';

/// M05-03 · Qué pasó y dónde (KAN-277).
class M0503RelatoPage extends ConsumerStatefulWidget {
  const M0503RelatoPage({super.key});

  @override
  ConsumerState<M0503RelatoPage> createState() => _M0503RelatoPageState();
}

class _M0503RelatoPageState extends ConsumerState<M0503RelatoPage> {
  late final TextEditingController _relato;
  late final TextEditingController _lugar;
  late final TextEditingController _ciudad;
  late bool _otraCiudad;
  bool _intentoEnviar = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(reporteProvider);
    _relato = TextEditingController(text: s.descripcion);
    _lugar = TextEditingController(text: s.lugar);
    _ciudad = TextEditingController(text: s.ciudad);
    // Una ciudad que ya estaba escrita y no es del catálogo se sigue mostrando como texto.
    _otraCiudad =
        s.ciudad.isNotEmpty &&
        !ciudadesColombia.any((c) => c.nombre == s.ciudad);
  }

  @override
  void dispose() {
    _relato.dispose();
    _lugar.dispose();
    _ciudad.dispose();
    super.dispose();
  }

  /// La lista desplegable de ciudades (catálogo `ciudades.json`); «Otra ciudad» deja escribirla.
  Future<void> _elegirCiudad() async {
    final l10n = context.l10n;
    final actual = ref.read(reporteProvider).ciudad;
    final elegida = await SolBottomSheet.show<String>(
      context,
      builder: (hoja) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(hoja).height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SolSectionHeader(title: l10n.m0503CiudadElegir),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final c in ciudadesColombia)
                    ListTile(
                      minTileHeight: 56,
                      title: Text(c.nombre),
                      subtitle: Text(c.departamento),
                      selected: actual == c.nombre,
                      onTap: () => Navigator.pop(hoja, c.nombre),
                    ),
                  ListTile(
                    minTileHeight: 56,
                    title: Text(l10n.m0503CiudadOtra),
                    onTap: () => Navigator.pop(hoja, ''),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (elegida == null || !mounted) return;
    final notifier = ref.read(reporteProvider.notifier);
    if (elegida.isEmpty) {
      _ciudad.clear();
      notifier.fijarRelato(ciudad: '');
      setState(() => _otraCiudad = true);
    } else {
      notifier.fijarRelato(ciudad: elegida);
      setState(() => _otraCiudad = false);
    }
  }

  void _enviar() {
    setState(() => _intentoEnviar = true);
    if (!ref.read(reporteProvider).listoParaEnviar) return;
    context.push(ReporteRoutes.enviando);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final estado = ref.watch(reporteProvider);
    final notifier = ref.read(reporteProvider.notifier);
    final relatoMal =
        _intentoEnviar && !ReglasReporte.relatoValido(estado.descripcion);
    final lugarMal = _intentoEnviar && estado.lugar.trim().isEmpty;
    final ciudadMal = _intentoEnviar && estado.ciudad.trim().isEmpty;

    return SolFlowScaffold(
      title: l10n.m0503Titulo,
      onBack: () => context.pop(),
      anchorActions: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SolTextField(
            label: l10n.m0503Relato,
            controller: _relato,
            minLines: 4,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            helperText: l10n.m0503RelatoAyuda,
            errorText: relatoMal ? l10n.m0503RelatoAyuda : null,
            onChanged: (v) => notifier.fijarRelato(descripcion: v),
          ),
          const SizedBox(height: SolSpacing.lg),
          SolTextField(
            label: l10n.m0503Lugar,
            controller: _lugar,
            helperText: l10n.m0503LugarAyuda,
            errorText: lugarMal ? l10n.m0503Requerido : null,
            textInputAction: TextInputAction.next,
            onChanged: (v) => notifier.fijarRelato(lugar: v),
          ),
          const SizedBox(height: SolSpacing.lg),
          if (_otraCiudad)
            SolTextField(
              label: l10n.m0503Ciudad,
              controller: _ciudad,
              errorText: ciudadMal ? l10n.m0503Requerido : null,
              textInputAction: TextInputAction.done,
              onChanged: (v) => notifier.fijarRelato(ciudad: v),
            )
          else
            SolTextField.select(
              label: l10n.m0503Ciudad,
              value: estado.ciudad,
              errorText: ciudadMal ? l10n.m0503Requerido : null,
              onTap: _elegirCiudad,
            ),
          if (estado.ubicacion case final u?) ...[
            const SizedBox(height: SolSpacing.md),
            SolInlineNote(
              icon: SolIcons.location,
              text:
                  '${u.latitud.toStringAsFixed(4)}, '
                  '${u.longitud.toStringAsFixed(4)}',
            ),
          ],
        ],
      ),
      actions: [SolButton.primary(label: l10n.m0503Enviar, onPressed: _enviar)],
    );
  }
}
