import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/prestador.dart';
import '../prestadores_state.dart';
import '../providers.dart';
import '../widgets/detalle_prestador.dart';
import '../widgets/hoja_direccion.dart';
import '../widgets/mapa/mapa_prestadores.dart';

/// M06-01 · Mapa de prestadores cercanos (Figma 2005:2, KAN-264).
///
/// Mapa (Mapbox, M0) con todos los prestadores de la zona y una hoja
/// arrastrable encima (M9) con los 3 más cercanos y, al subirla, el resto.
/// - Tocar un **pin**: vibración leve, pin seleccionado, cámara suave hacia él
///   y el detalle en una hoja modal (M4, M6, 2.2).
/// - Tocar una **fila**: enfoca el pin sin abrir el detalle (M5).
/// - «Solicitar» (fila o detalle) lleva directo a M06-02 (KAN-265).
/// - Botones flotantes: calles/satélite (M14) y «Volver a centrar» tras mover
///   el mapa (M8).
/// - Sin prestadores en 50 km: el mapa con el cliente y «Aún no tenemos
///   prestadores en tu zona» (M11). Si el mapa falla, solo la lista (CA-M06-04).
class M0601PrestadoresPage extends ConsumerStatefulWidget {
  const M0601PrestadoresPage({super.key, required this.onSolicitar});

  /// El prestador elegido y adónde debe llegar: el GPS o la dirección escrita
  /// ya ubicada ([direccionEscrita], 2.0); con GPS, `null`.
  final void Function(
    PrestadorCercano cercano,
    Coordenada origen,
    String? direccionEscrita,
  )
  onSolicitar;

  @override
  ConsumerState<M0601PrestadoresPage> createState() =>
      _M0601PrestadoresPageState();
}

class _M0601PrestadoresPageState extends ConsumerState<M0601PrestadoresPage> {
  late final AppLifecycleListener _ciclo;
  final _hoja = DraggableScrollableController();
  bool _mapaFallo = false;
  bool _volviendoDeAjustes = false;

  /// Prestador elegido en el mapa (pin grande con anillo y fila marcada).
  String? _seleccionado;
  OrdenCamara? _orden;
  int _generacionCamara = 0;
  bool _verRecentrar = false;

  // M12: un solo detalle, un solo push a M06-02 y una sola ruta a la vez.
  bool _detalleAbierto = false;
  Timer? _navegando;
  bool _abriendoRuta = false;

  /// Fracción inicial de la hoja (la que tapa el mapa al encuadrar).
  double _fraccionInicial = 0.4;

  @override
  void initState() {
    super.initState();
    // Al volver de Ajustes (permiso o GPS) se reintenta solo.
    _ciclo = AppLifecycleListener(
      onResume: () {
        final s = ref.read(prestadoresProvider);
        // Al volver de Ajustes se revisa otra vez; con la dirección escrita,
        // por si ya dio el permiso («Usar mi ubicación actual», 2.0).
        if (_volviendoDeAjustes ||
            (s is PrestadoresListos && s.direccionEscrita != null)) {
          _volviendoDeAjustes = false;
          unawaited(ref.read(prestadoresProvider.notifier).cargar());
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(ref.read(prestadoresProvider.notifier).cargar());
    });
  }

  @override
  void dispose() {
    _ciclo.dispose();
    _navegando?.cancel();
    _hoja.dispose();
    super.dispose();
  }

  String _tipo(TipoPrestador t) => switch (t) {
    TipoPrestador.medico => context.l10n.m0601TipoMedico,
    TipoPrestador.mecanico => context.l10n.m0601TipoMecanico,
    TipoPrestador.grua => context.l10n.m0601TipoGrua,
  };

  SolProviderType _tipoFila(TipoPrestador t) => switch (t) {
    TipoPrestador.medico => SolProviderType.medico,
    TipoPrestador.mecanico => SolProviderType.mecanico,
    TipoPrestador.grua => SolProviderType.grua,
  };

  /// M13: si ninguna app abre la ruta, aviso con la dirección y «Copiar».
  Future<void> _abrirRuta(PrestadorCercano c) async {
    if (_abriendoRuta) return;
    _abriendoRuta = true;
    try {
      final ok = await ref
          .read(rutaExternaServiceProvider)
          .abrirRuta(c.prestador.ubicacion, nombre: c.prestador.nombre);
      if (ok || !mounted) return;
      final l10n = context.l10n;
      final direccion = c.prestador.direccion.isEmpty
          ? '${c.prestador.ubicacion.latitud}, ${c.prestador.ubicacion.longitud}'
          : c.prestador.direccion;
      await showDialog<void>(
        context: context,
        builder: (dialogo) => AlertDialog(
          content: Text('${l10n.m0601RutaNoDisponible}\n\n$direccion'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogo).pop(),
              child: Text(l10n.m0601Cerrar),
            ),
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: direccion));
                if (dialogo.mounted) Navigator.of(dialogo).pop();
              },
              child: Text(l10n.m0601Copiar),
            ),
          ],
        ),
      );
    } finally {
      _abriendoRuta = false;
    }
  }

  void _solicitar(PrestadorCercano c, Coordenada origen) {
    if (_navegando?.isActive ?? false) return;
    // Un solo push a M06-02 aunque se toque dos veces (M12).
    _navegando = Timer(const Duration(milliseconds: 800), () {});
    final s = ref.read(prestadoresProvider);
    widget.onSolicitar(
      c,
      origen,
      s is PrestadoresListos ? s.direccionEscrita : null,
    );
  }

  /// «Escribir mi dirección» o «Cambiar» (2.0): con la dirección ubicada, el
  /// mapa se encuadra de nuevo desde ese punto.
  Future<void> _escribirDireccion() async {
    final d = await HojaDireccion.abrir(context);
    if (d == null || !mounted) return;
    setState(() {
      _seleccionado = null;
      _orden = EncuadrarInicio(++_generacionCamara);
      _verRecentrar = false;
    });
    await ref.read(prestadoresProvider.notifier).usarDireccion(d);
  }

  void _enfocar(PrestadorCercano c) => setState(() {
    _seleccionado = c.prestador.id;
    _orden = EnfocarPrestador(++_generacionCamara, c.prestador.ubicacion);
    _verRecentrar = true;
  });

  /// M4: pin → vibración, selección, cámara y detalle.
  Future<void> _tocarPin(
    PrestadorCercano c,
    Coordenada origen,
    bool destacado,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    _enfocar(c);
    if (_detalleAbierto) return;
    _detalleAbierto = true;
    try {
      await SolBottomSheet.show<void>(
        context,
        builder: (hoja) => DetallePrestador(
          cercano: c,
          destacado: destacado,
          tiempo: _tiempo(c, destacado: destacado),
          tipo: _tipo(c.prestador.tipo),
          onSolicitar: () {
            Navigator.of(hoja).pop();
            _solicitar(c, origen);
          },
          onComoLlegar: () => unawaited(_abrirRuta(c)),
        ),
      );
    } finally {
      _detalleAbierto = false;
    }
  }

  /// M5: la fila enfoca el pin y, si la hoja estaba subida, la baja.
  void _tocarFila(PrestadorCercano c) {
    _enfocar(c);
    if (_hoja.isAttached && _hoja.size > _fraccionInicial + 0.01) {
      final duracion = SolMotion.of(context, SolMotion.medium);
      if (duracion == Duration.zero) {
        _hoja.jumpTo(_fraccionInicial);
      } else {
        unawaited(
          _hoja.animateTo(
            _fraccionInicial,
            duration: duracion,
            curve: SolMotion.standard,
          ),
        );
      }
    }
  }

  /// M15: el tiempo de la ruta si el backend la mandó; si no, Haversine,
  /// aproximado («~») para los que no son destacados o si no hubo rutas.
  String _tiempo(PrestadorCercano c, {required bool destacado}) {
    final s = ref.read(prestadoresProvider);
    final ruta = s is PrestadoresListos ? s.rutas[c.prestador.id] : null;
    if (ruta != null) return SolFormat.minutes(ruta.minutos);
    final texto = SolFormat.minutes(c.minutosEstimados);
    final aproximado =
        !destacado || (s is PrestadoresListos && s.rutasAproximadas);
    return aproximado ? context.l10n.m0601Aproximado(texto) : texto;
  }

  Widget _fila(
    PrestadorCercano c,
    Coordenada origen, {
    required bool destacado,
  }) {
    final l10n = context.l10n;
    final tiempo = _tiempo(c, destacado: destacado);
    return SolProviderRow(
      name: c.prestador.nombre,
      type: _tipoFila(c.prestador.tipo),
      typeLabel: _tipo(c.prestador.tipo),
      isPartner: c.prestador.aliado,
      partnerLabel: l10n.m0601Aliado,
      distance: SolFormat.distanceKm(c.distanciaKm),
      eta: tiempo,
      requestLabel: l10n.m0601Solicitar,
      selected: c.prestador.id == _seleccionado,
      onTap: () => _tocarFila(c),
      onRequest: () => _solicitar(c, origen),
    );
  }

  Widget _mapaYLista(
    BuildContext context,
    Coordenada origen,
    List<PrestadorCercano> destacados,
    List<PrestadorCercano> otros, {
    String? direccionEscrita,
    bool permisoDisponible = false,
    Map<String, RutaPrestador> rutas = const {},
  }) {
    final l10n = context.l10n;
    final conMapa =
        !_mapaFallo && ref.watch(motorMapaProvider) != MotorMapa.ninguno;
    final estilo = ref.watch(estiloMapaProvider);
    _orden ??= EncuadrarInicio(_generacionCamara);

    return LayoutBuilder(
      builder: (context, box) {
        final alto = box.maxHeight;
        final escala = MediaQuery.textScalerOf(context).scale(1).clamp(1, 2);
        // Tirador (24) + encabezado (~56) y una fila (~68) por destacado.
        final cabecera = 24 + 56 * escala;
        final filas = destacados.isEmpty
            ? 64 * escala
            : destacados.length * 68 * escala;
        final minimo = conMapa ? (cabecera / alto).clamp(0.1, 0.4) : 1.0;
        final inicial = conMapa
            ? ((cabecera + filas + SolSpacing.lg) / alto).clamp(minimo, 0.6)
            : 1.0;
        _fraccionInicial = inicial;

        final hoja = SolDraggableSheet(
          controller: _hoja,
          minFraction: minimo,
          initialFraction: inicial,
          maxFraction: conMapa ? 0.85 : 1,
          expandLabel: l10n.m0601ExpandirLista,
          collapseLabel: l10n.m0601ContraerLista,
          builder: (context, scroll) => ListView(
            controller: scroll,
            padding: const EdgeInsets.only(bottom: SolSpacing.lg),
            children: [
              SolSectionHeader(
                title: l10n.m0601Titulo,
                count: destacados.isEmpty
                    ? null
                    : l10n.m0601Disponibles(destacados.length + otros.length),
              ),
              if (destacados.isEmpty)
                SolInlineNote(text: l10n.m0601SinPrestadores)
              else
                for (final (i, c) in destacados.indexed) ...[
                  if (i > 0) const SolDivider(),
                  _fila(c, origen, destacado: true),
                ],
              if (otros.isNotEmpty) ...[
                const SizedBox(height: SolSpacing.md),
                Text(
                  l10n.m0601MasPrestadores,
                  style: context.solText.labelStrong.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                for (final (i, c) in otros.indexed) ...[
                  if (i > 0) const SolDivider(),
                  _fila(c, origen, destacado: false),
                ],
              ],
            ],
          ),
        );
        final destacadosIds = {for (final c in destacados) c.prestador.id};
        // Siempre el mismo Stack: si el mapa falla, la hoja sigue siendo la
        // misma (un controlador no se puede pegar a dos hojas a la vez).
        return Stack(
          children: [
            if (conMapa) ...[
              Positioned.fill(
                child: MapaPrestadores(
                  datos: DatosMapa(
                    origen: origen,
                    destacados: destacados,
                    otros: otros,
                    seleccionadoId: _seleccionado,
                    estilo: estilo,
                    paddingInferior: inicial * alto,
                    etiquetaTiempo: (c) => _tiempo(c, destacado: true),
                    semanticaPin: (c) => l10n.m0601PinSemantica(
                      c.prestador.nombre,
                      _tipo(c.prestador.tipo),
                      _tiempo(
                        c,
                        destacado: destacadosIds.contains(c.prestador.id),
                      ),
                    ),
                    rutas: rutas.values
                        .where((r) => destacadosIds.contains(r.prestadorId))
                        .toList(),
                    etiquetaUsuario: direccionEscrita ?? l10n.m0601TuUbicacion,
                    etiquetaPinUsuario: direccionEscrita == null
                        ? null
                        : l10n.direccionPinEtiqueta,
                  ),
                  orden: _orden,
                  onTapPrestador: (c) => unawaited(
                    _tocarPin(
                      c,
                      origen,
                      destacadosIds.contains(c.prestador.id),
                    ),
                  ),
                  // Quitar la selección no mueve la cámara (M6).
                  onTapVacio: () => setState(() => _seleccionado = null),
                  onGesto: () {
                    if (!_verRecentrar) setState(() => _verRecentrar = true);
                  },
                  onFallo: () {
                    setState(() => _mapaFallo = true);
                    // Sin mapa la lista ocupa toda la pantalla (CA-M06-04).
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_hoja.isAttached) _hoja.jumpTo(1);
                    });
                  },
                ),
              ),
              PositionedDirectional(
                top: SolSpacing.sm,
                start: SolSpacing.sm,
                end: SolSpacing.sm,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 2.0: el aviso recuerda que se usa la dirección escrita.
                      if (direccionEscrita != null) ...[
                        SolStatusBanner(
                          status: SolStatus.warning,
                          title: l10n.direccionUsando(direccionEscrita),
                          action: Wrap(
                            spacing: SolSpacing.md,
                            children: [
                              SolLinkButton(
                                label: l10n.direccionCambiar,
                                onPressed: () =>
                                    unawaited(_escribirDireccion()),
                              ),
                              if (permisoDisponible)
                                SolLinkButton(
                                  label: l10n.direccionUsarActual,
                                  onPressed: () {
                                    setState(() {
                                      _orden = EncuadrarInicio(
                                        ++_generacionCamara,
                                      );
                                    });
                                    unawaited(
                                      ref
                                          .read(prestadoresProvider.notifier)
                                          .usarUbicacionActual(),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: SolSpacing.sm),
                      ],
                      SolMapFab(
                        icon: SolIcons.layers,
                        semanticLabel: estilo == EstiloMapa.calles
                            ? l10n.m0601VerSatelite
                            : l10n.m0601VerCalles,
                        onPressed: () => unawaited(
                          ref.read(estiloMapaProvider.notifier).alternar(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_verRecentrar)
                ListenableBuilder(
                  listenable: _hoja,
                  builder: (context, _) {
                    final fraccion = _hoja.isAttached ? _hoja.size : inicial;
                    return PositionedDirectional(
                      end: SolSpacing.sm,
                      bottom: fraccion * alto + SolSpacing.lg,
                      child: SolMapFab(
                        icon: SolIcons.myLocation,
                        semanticLabel: l10n.m0601Recentrar,
                        onPressed: () => setState(() {
                          _orden = EncuadrarInicio(++_generacionCamara);
                          _verRecentrar = false;
                        }),
                      ),
                    );
                  },
                ),
            ],
            hoja,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final estado = ref.watch(prestadoresProvider);
    final notifier = ref.read(prestadoresProvider.notifier);

    return switch (estado) {
      PrestadoresCargando() => _Centro(
        child: SolLoadingState(message: l10n.m0601Buscando, center: true),
      ),
      PrestadoresFallidos(:final falla) => _Centro(
        child: _Aviso(
          texto: l10n.falla(falla),
          accion: falla.reintentable ? l10n.m0601Reintentar : null,
          onAccion: notifier.cargar,
        ),
      ),
      PrestadoresExplicacion() => _Centro(
        child: _Aviso(
          icono: SolIcons.location,
          titulo: l10n.ubicacionExplicaTitulo,
          texto: l10n.ubicacionExplicaTexto,
          accion: l10n.ubicacionPermitir,
          onAccion: notifier.permitir,
          accionSecundaria: l10n.direccionEscribir,
          onAccionSecundaria: _escribirDireccion,
        ),
      ),
      PrestadoresSinUbicacion(:final permisoPermanente, :final gpsApagado) =>
        _Centro(
          child: _Aviso(
            icono: gpsApagado ? SolIcons.gpsOff : SolIcons.locationOff,
            titulo: gpsApagado
                ? l10n.gpsApagadoTitulo
                : l10n.ubicacionNegadaTitulo,
            texto: gpsApagado
                ? l10n.gpsApagadoTexto
                : l10n.ubicacionNegadaTexto,
            accion: gpsApagado
                ? l10n.gpsActivar
                : permisoPermanente
                ? l10n.ubicacionAbrirAjustes
                : l10n.ubicacionPermitir,
            onAccion: permisoPermanente || gpsApagado
                ? () async {
                    _volviendoDeAjustes = true;
                    await notifier.abrirAjustes();
                  }
                : notifier.permitir,
            accionSecundaria: l10n.direccionEscribir,
            onAccionSecundaria: _escribirDireccion,
          ),
        ),
      PrestadoresListos(
        :final origen,
        :final destacados,
        :final otros,
        :final direccionEscrita,
        :final permisoDisponible,
        :final rutas,
      ) =>
        _mapaYLista(
          context,
          origen,
          destacados,
          otros,
          direccionEscrita: direccionEscrita,
          permisoDisponible: permisoDisponible,
          rutas: rutas,
        ),
    };
  }
}

class _Centro extends StatelessWidget {
  const _Centro({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(SolSpacing.screen),
      child: child,
    ),
  );
}

/// Aviso a pantalla completa. Con [titulo] es el de ubicación (2.0, boceto
/// pasos 1, 3 y 4): ícono en un círculo, título, texto y dos salidas, una
/// para arreglarlo y otra para escribir la dirección.
class _Aviso extends StatelessWidget {
  const _Aviso({
    required this.texto,
    required this.accion,
    required this.onAccion,
    this.titulo,
    this.icono,
    this.accionSecundaria,
    this.onAccionSecundaria,
  });

  final String? titulo;
  final String texto;
  final String? accion;
  final Future<void> Function() onAccion;
  final IconData? icono;
  final String? accionSecundaria;
  final Future<void> Function()? onAccionSecundaria;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final titulo = this.titulo;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (titulo == null)
          Semantics(
            liveRegion: true,
            child: SolInlineNote(icon: icono, text: texto, center: true),
          )
        else ...[
          if (icono != null)
            ExcludeSemantics(
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: context.solColors.navIndicator,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icono, size: 36, fill: 1, color: colors.primary),
                ),
              ),
            ),
          const SizedBox(height: SolSpacing.lg),
          Semantics(
            header: true,
            liveRegion: true,
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: context.solText.headline.copyWith(color: colors.onSurface),
            ),
          ),
          const SizedBox(height: SolSpacing.sm),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: context.solText.body.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
        if (accion != null) ...[
          const SizedBox(height: SolSpacing.xxl),
          if (titulo == null)
            SolButton.tonal(
              label: accion!,
              onPressed: () => unawaited(onAccion()),
            )
          else
            SolButton.primary(
              label: accion!,
              onPressed: () => unawaited(onAccion()),
            ),
        ],
        if (accionSecundaria != null) ...[
          const SizedBox(height: SolSpacing.sm),
          SolButton.outlined(
            label: accionSecundaria!,
            onPressed: () => unawaited(onAccionSecundaria!()),
          ),
        ],
      ],
    );
  }
}
