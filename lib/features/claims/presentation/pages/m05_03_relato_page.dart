import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/navegacion/volver.dart';
import '../../../../core/red/estado_red_notifier.dart';
import '../../domain/ciudades.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';
import '../reporte_notifier.dart';
import '../reporte_routes.dart';
import '../widgets/banner_reporte.dart';
import '../widgets/hoja_datos_moviles.dart';

/// M05-03 · Qué pasó y dónde (KAN-277).
class M0503RelatoPage extends ConsumerStatefulWidget {
  const M0503RelatoPage({super.key, this.onHome});

  /// Casita al inicio en la barra superior (en lugar del avatar).
  final VoidCallback? onHome;

  @override
  ConsumerState<M0503RelatoPage> createState() => _M0503RelatoPageState();
}

class _M0503RelatoPageState extends ConsumerState<M0503RelatoPage> {
  late final TextEditingController _relato;
  late final TextEditingController _lugar;
  late final TextEditingController _ciudad;
  late bool _otraCiudad;
  bool _intentoEnviar = false;
  bool _guardando = false;

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

  /// Con conexión envía (M05-04 muestra el avance). Sin conexión, o si el
  /// cliente prefiere esperar Wi-Fi, lo deja guardado en la cola y va directo
  /// a «Reporte guardado»: la app lo envía sola después.
  Future<void> _enviar() async {
    setState(() => _intentoEnviar = true);
    final estado = ref.read(reporteProvider);
    if (!estado.listoParaEnviar || _guardando) return;
    final notifier = ref.read(reporteProvider.notifier);
    // Sin cuenta nada se guarda en el teléfono: el envío es el directo.
    if (ref.read(cuentaReporteProvider) == null) {
      unawaited(context.push(ReporteRoutes.enviando));
      return;
    }
    final red = ref.read(estadoRedProvider);
    var conDatos = false;
    var esperarWifi = false;
    if (red.porDatosMoviles) {
      final preferencias = ref.read(preferenciasEnvioProvider);
      if (!preferencias.preguntado) {
        final eleccion = await HojaDatosMoviles.preguntar(
          context,
          fotos: estado.fotos.length,
          bytes: estado.fotos.fold(0, (suma, f) => suma + f.bytes.length),
        );
        if (eleccion == null || !mounted) return;
        conDatos = eleccion.conDatos;
        esperarWifi = !eleccion.conDatos;
        if (eleccion.recordar) {
          await ref
              .read(preferenciasEnvioProvider.notifier)
              .fijarSoloWifi(soloWifi: !eleccion.conDatos);
          if (!mounted) return;
        }
      } else {
        esperarWifi = preferencias.soloWifi;
      }
    }
    if (!red.conectado || esperarWifi) {
      setState(() => _guardando = true);
      await notifier.enviar(esperarWifi: esperarWifi);
      if (!mounted) return;
      setState(() => _guardando = false);
      unawaited(context.push(ReporteRoutes.resultado));
      return;
    }
    unawaited(notifier.enviar(conDatos: conDatos));
    unawaited(context.push(ReporteRoutes.enviando, extra: true));
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
    // Sin conexión, y con dónde guardarlo, el botón guarda en vez de enviar.
    final guardaEnTelefono = ref.watch(cuentaReporteProvider) != null;
    final sinConexion =
        guardaEnTelefono &&
        !ref.watch(estadoRedProvider.select((red) => red.conectado));

    return SolFlowScaffold(
      banner: const BannerReporte(),
      title: l10n.m0503Titulo,
      onBack: context.volverOInicio,
      onHomeTap: salirAlInicioConfirmando(context, widget.onHome),
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
          if (estado.avisoGuardado case final aviso?) ...[
            const SizedBox(height: SolSpacing.md),
            SolStatusBanner(
              status: SolStatus.warning,
              title: aviso == AvisoGuardado.sinEspacio
                  ? l10n.m05SinEspacio
                  : l10n.m05NoGuardado,
            ),
          ],
          if (guardaEnTelefono) ...[
            const SizedBox(height: SolSpacing.md),
            SolInlineNote(
              icon: sinConexion ? SolIcons.offline : SolIcons.info,
              text: sinConexion
                  ? l10n.m0503SinConexionNota
                  : l10n.m0503Avisaremos,
            ),
          ],
        ],
      ),
      actions: [
        SolButton.primary(
          label: sinConexion ? l10n.m0503GuardarDespues : l10n.m0503Enviar,
          icon: sinConexion ? SolIcons.saved : null,
          loading: _guardando,
          onPressed: () => unawaited(_enviar()),
        ),
      ],
    );
  }
}
