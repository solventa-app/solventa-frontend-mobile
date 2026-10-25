import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../solventa_ui.dart';

/// Galería interna con todos los componentes y variantes (solo debug).
///
/// Ábrela con un toque largo en el wordmark «Solventa», o con
/// `flutter run --dart-define=SOL_GALLERY=true`.
class SolGalleryPage extends StatefulWidget {
  const SolGalleryPage({super.key});

  static const String routeName = '/galeria';

  /// Ruta solo disponible en builds de debug; en release devuelve `null`.
  static Route<void>? route(RouteSettings settings) {
    if (!kDebugMode || settings.name != routeName) return null;
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const SolGalleryPage(),
    );
  }

  @override
  State<SolGalleryPage> createState() => _SolGalleryPageState();
}

class _SolGalleryPageState extends State<SolGalleryPage> {
  bool _consent = false;
  String _pin = '';
  int _navIndex = 0;
  bool _loading = false;

  void _noop() {}

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return SolFlowScaffold(
      title: 'Galería de componentes',
      anchorActions: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Section('Botón (2018:16)'),
          SolButton.primary(
            label: 'Primario',
            loading: _loading,
            onPressed: () => setState(() => _loading = !_loading),
          ),
          const _Gap(),
          SolButton.tonal(label: 'Tonal', onPressed: _noop),
          const _Gap(),
          SolButton.destructive(label: 'Destructivo', onPressed: _noop),
          const _Gap(),
          const SolButton.primary(label: 'Deshabilitado', onPressed: null),
          const _Gap(),
          SolButton.outlined(
            label: 'Delineado',
            icon: SolIcons.retry,
            onPressed: _noop,
          ),
          const _Gap(),
          Center(
            child: SolButton.text(label: 'Texto', onPressed: _noop),
          ),
          SolLinkButton(
            label: 'Olvidé mi PIN o patrón',
            note: '(se resuelve en Ajustes del teléfono)',
            size: SolLinkSize.small,
            onPressed: _noop,
          ),

          const _Section('Barra superior (2018:35)'),
          SolTopBar.flow(title: 'Título de pantalla', onBack: _noop),
          const SolTopBar.home(),

          const _Section('Barra de navegación inferior (2018:76)'),
          SolBottomNav(
            selectedIndex: _navIndex,
            onDestinationSelected: (i) => setState(() => _navIndex = i),
          ),

          const _Section('Idioma y moneda (2018:3) y avatar'),
          Row(
            children: [
              SolLocaleChip(onTap: _noop),
              const SizedBox(width: SolSpacing.sm),
              SolAvatar(onTap: _noop),
            ],
          ),

          const _Section('Fila de prestador (2018:103)'),
          SolProviderRow(
            name: 'Clínica Norte',
            type: SolProviderType.medico,
            distance: '1.2 km',
            eta: '6 min',
            onRequest: _noop,
          ),
          const SolDivider(),
          SolProviderRow(
            name: 'Taller AutoAyuda',
            type: SolProviderType.mecanico,
            distance: '2.0 km',
            eta: '9 min',
            onRequest: _noop,
          ),

          const _Section('Disparador de demo (2018:17)'),
          SolDemoTrigger(
            label: 'Simular que no reconoce la biometría',
            onTap: _noop,
          ),

          const _Section('Estados'),
          const Wrap(
            spacing: SolSpacing.sm,
            runSpacing: SolSpacing.sm,
            children: [
              SolStatusBadge(
                status: SolStatus.success,
                label: 'Identidad verificada',
              ),
              SolStatusBadge(status: SolStatus.warning, label: 'En revisión'),
              SolStatusBadge(
                status: SolStatus.error,
                label: 'No pudimos verificarte',
              ),
            ],
          ),
          const _Gap(),
          const SolStatusBanner(
            status: SolStatus.warning,
            title: 'En revisión',
            message: 'Estamos revisando tu identidad, te avisamos.',
          ),

          const _Section('Consentimiento'),
          SolConsentCheckbox(
            value: _consent,
            onChanged: (v) => setState(() => _consent = v),
            label: 'Autorizo el tratamiento de mis datos personales',
          ),

          const _Section('PIN y teclado'),
          Center(child: SolPinIndicator(filled: _pin.length)),
          const SizedBox(height: SolSpacing.xxl),
          SolNumericKeypad(
            onDigit: (d) {
              if (_pin.length < 4) setState(() => _pin += '$d');
            },
            onBackspace: () {
              if (_pin.isNotEmpty) {
                setState(() => _pin = _pin.substring(0, _pin.length - 1));
              }
            },
          ),

          const _Section('Tarjetas'),
          const SolCard.outlined(child: Text('Tarjeta delineada')),
          const _Gap(),
          const SolCard(child: Text('Tarjeta elevada')),
          const _Gap(),
          SolActionTile(
            icon: SolIcons.assistanceActive,
            title: 'Solicitar asistencia en sitio',
            onTap: _noop,
          ),

          const _Section('Campos'),
          SolTextField.select(
            label: 'Tipo de asistencia',
            value: 'Médica',
            onTap: _noop,
          ),
          const _Gap(),
          const SolTextField(
            label: 'Describe brevemente qué pasó',
            hint: 'Ej. dolor en el pecho, mareo...',
            maxLines: 4,
            minLines: 4,
          ),
          const _Gap(),
          const SolTextField(
            label: 'Número de cédula',
            errorText: 'La cédula debe tener entre 6 y 10 dígitos.',
          ),

          const _Section('Carga, resultado y cámara'),
          const SolLoadingState(message: 'Validando con el proveedor...'),
          const _Gap(),
          const SolResultView(
            status: SolStatus.success,
            message: '¡Identidad verificada! Bienvenido a Solventa.',
          ),
          const _Gap(),
          const Center(
            child: SolCameraFrame(
              label: 'Cédula de ciudadanía',
              labelIcon: SolIcons.idCard,
              instruction: 'Ubica el FRENTE del documento dentro del marco',
            ),
          ),

          const _Section('Varios'),
          const SolSectionHeader(
            title: 'Prestadores cercanos',
            count: '3 disponibles',
          ),
          const SolInlineNote(
            icon: SolIcons.wallet,
            text: 'Billetera y estado de póliza — próximamente',
            center: true,
          ),
          Text(
            'Formatos es-CO: ${SolFormat.currency(450000)} · '
            '${SolFormat.dateTime(DateTime(2026, 9, 12, 11, 2))} · '
            '${SolFormat.maskedAccount('99994821')}',
            style: context.solText.note,
          ),

          const _Section('Hojas, diálogos y layouts'),
          SolButton.tonal(
            label: 'Abrir hoja inferior',
            onPressed: () => SolBottomSheet.show<void>(
              context,
              builder: (_) => const SolSectionHeader(
                title: 'Prestadores cercanos',
                count: '3 disponibles',
              ),
            ),
          ),
          const _Gap(),
          SolButton.tonal(
            label: 'Abrir confirmación destructiva',
            onPressed: () => SolConfirmDialog.show(
              context,
              title: '¿Seguro que quieres cancelar?',
              message:
                  'Clínica Norte ya está en camino. Si cancelas ahora, '
                  'tendrás que solicitar asistencia de nuevo desde cero.',
              confirmLabel: 'Sí, cancelar',
              cancelLabel: 'No, mantener solicitud',
            ),
          ),
          const _Gap(),
          SolButton.tonal(
            label: 'Pantalla transitoria',
            onPressed: () => _open(
              _Closable(
                child: const SolTransitionalScreen(
                  title: 'Verificación',
                  message: 'Validando con el proveedor KYC/AML...',
                ),
              ),
            ),
          ),
          const _Gap(),
          for (final status in [
            SolStatus.success,
            SolStatus.warning,
            SolStatus.error,
          ]) ...[
            SolButton.tonal(
              label: 'Resultado: ${status.name}',
              onPressed: () => _open(
                SolResultScreen(
                  title: 'Verificación',
                  status: status,
                  message: 'Mensaje de resultado',
                  actionLabel: 'Entendido',
                  onAction: () => Navigator.pop(context),
                ),
              ),
            ),
            const _Gap(),
          ],
          SolButton.tonal(
            label: 'Pantalla de entrada',
            onPressed: () => _open(
              _Closable(
                child: SolEntryScaffold(
                  title: 'Bienvenido',
                  body: const Text('Pantalla de entrada sin flecha.'),
                  actions: [
                    SolButton.primary(
                      label: 'Volver a la galería',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Las pantallas sin flecha bloquean el atrás; en la galería se cierran
/// con un toque largo para poder volver.
class _Closable extends StatelessWidget {
  const _Closable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => Navigator.pop(context),
      child: child,
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: SolSpacing.xxxl,
        bottom: SolSpacing.md,
      ),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: context.solText.title.copyWith(
            color: context.colors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => const SizedBox(height: SolSpacing.md);
}
