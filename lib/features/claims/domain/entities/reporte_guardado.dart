import '../../../../core/ubicacion/coordenada.dart';
import 'reporte_siniestro.dart';

/// En qué va un reporte guardado en el teléfono (HU-M05, sin conexión).
enum EstadoLocal {
  /// Sin terminar: faltan datos o el cliente lo está editando.
  borrador('BORRADOR'),

  /// Completo, esperando red o su turno en la cola.
  pendiente('PENDIENTE'),

  /// Subiendo fotos o radicando. No se puede editar.
  enviando('ENVIANDO'),

  /// La aseguradora devolvió el radicado.
  enviado('ENVIADO'),

  /// La aseguradora lo rechazó: hay que corregirlo.
  conError('CON_ERROR'),

  /// Falló muchas veces por razones técnicas: ya no se reintenta solo.
  necesitaAtencion('NECESITA_ATENCION');

  const EstadoLocal(this.codigo);

  final String codigo;

  static EstadoLocal deCodigo(String codigo) => values.firstWhere(
    (e) => e.codigo == codigo,
    orElse: () => EstadoLocal.borrador,
  );
}

/// Una foto guardada con su reporte. Los bytes viven en la base cifrada y se
/// leen aparte, una por una.
final class FotoGuardada {
  const FotoGuardada({
    required this.id,
    required this.orden,
    required this.tamano,
    required this.tipoContenido,
    required this.tomadaEn,
    this.ubicacion,
    this.deDireccion = false,
    this.archivoId,
  });

  final int id;
  final int orden;

  /// Bytes de la foto (para el progreso y el aviso de datos móviles).
  final int tamano;
  final String tipoContenido;
  final DateTime tomadaEn;
  final Coordenada? ubicacion;
  final bool deDireccion;

  /// Id del archivo en el almacenamiento cuando ya subió. Un reintento no la
  /// vuelve a subir.
  final String? archivoId;

  bool get subida => archivoId != null;

  FotoGuardada copyWith({
    Coordenada? ubicacion,
    bool? deDireccion,
    String? Function()? archivoId,
  }) => FotoGuardada(
    id: id,
    orden: orden,
    tamano: tamano,
    tipoContenido: tipoContenido,
    tomadaEn: tomadaEn,
    ubicacion: ubicacion ?? this.ubicacion,
    deDireccion: deDireccion ?? this.deDireccion,
    archivoId: archivoId != null ? archivoId() : this.archivoId,
  );
}

/// Un reporte guardado en el teléfono: borrador, por enviar o recién enviado.
/// [id] es el `idReporte` que viaja al backend: reenviar no duplica el caso.
final class ReporteGuardado {
  const ReporteGuardado({
    required this.id,
    required this.cuentaId,
    required this.estado,
    required this.creadoEn,
    required this.actualizadoEn,
    this.poliza,
    this.tipoAuto,
    this.ocurridoEn,
    this.descripcion = '',
    this.lugar = '',
    this.ciudad = '',
    this.ubicacion,
    this.direccionEscrita,
    this.guardadoEn,
    this.intentos = 0,
    this.proximoIntentoEn,
    this.ultimoError,
    this.radicacionIncierta = false,
    this.datosPermitidos = false,
    this.esperaWifi = false,
    this.avisoWifiDado = false,
    this.resultado,
    this.enviadoEn,
    this.fotos = const [],
  });

  final String id;

  /// La cuenta que lo creó. Solo ella lo ve y lo envía.
  final String cuentaId;
  final EstadoLocal estado;
  final DateTime creadoEn;
  final DateTime actualizadoEn;

  final PolizaReportable? poliza;
  final TipoSiniestroAuto? tipoAuto;
  final DateTime? ocurridoEn;
  final String descripcion;
  final String lugar;
  final String ciudad;
  final Coordenada? ubicacion;
  final String? direccionEscrita;

  /// Cuándo quedó completo y listo para enviar.
  final DateTime? guardadoEn;

  /// Intentos de envío que fallaron por razones técnicas.
  final int intentos;

  /// Antes de esta hora la cola no lo reintenta sola.
  final DateTime? proximoIntentoEn;

  /// Por qué no se envió: el mensaje de la aseguradora en un rechazo, o el
  /// código de la falla técnica. Nunca datos del cliente.
  final String? ultimoError;

  /// Se pidió radicar y no llegó respuesta: puede que el caso ya exista. No se
  /// edita hasta saberlo (el reintento lo aclara: mismo `idReporte`).
  final bool radicacionIncierta;

  /// «Enviar ahora con datos» para este reporte, aunque la preferencia pida
  /// esperar Wi-Fi.
  final bool datosPermitidos;

  /// El cliente pidió esperar Wi-Fi para este reporte (sin cambiar la
  /// preferencia de Mi perfil).
  final bool esperaWifi;

  /// Ya se avisó que espera Wi-Fi (se avisa una sola vez).
  final bool avisoWifiDado;

  /// El caso que devolvió la aseguradora.
  final SiniestroReportado? resultado;
  final DateTime? enviadoEn;

  final List<FotoGuardada> fotos;

  bool get faltaTipoAuto => (poliza?.esAuto ?? false) && tipoAuto == null;

  /// Las mismas reglas que valida el backend antes de aceptar un reporte.
  bool get completo =>
      poliza != null &&
      !faltaTipoAuto &&
      ocurridoEn != null &&
      fotos.length >= ReglasReporte.minFotos &&
      ubicacion != null &&
      ReglasReporte.relatoValido(descripcion) &&
      lugar.trim().isNotEmpty &&
      ciudad.trim().isNotEmpty;

  /// Aún no tiene radicado.
  bool get porEnviar => estado != EstadoLocal.enviado;

  /// En cola: la app lo enviará sola.
  bool get enCola =>
      estado == EstadoLocal.pendiente || estado == EstadoLocal.enviando;

  /// Con solo datos móviles, este reporte espera Wi-Fi: lo pide la
  /// preferencia de Mi perfil ([soloWifi]) o lo pidió el cliente para este.
  bool esperaWifiCon({required bool soloWifi}) =>
      !datosPermitidos && (soloWifi || esperaWifi);

  /// Se puede corregir o descartar.
  bool get editable =>
      !radicacionIncierta &&
      estado != EstadoLocal.enviando &&
      estado != EstadoLocal.enviado;

  int get bytesFotos => fotos.fold(0, (suma, f) => suma + f.tamano);

  int get fotosSubidas => fotos.where((f) => f.subida).length;

  ReporteGuardado copyWith({
    EstadoLocal? estado,
    DateTime? actualizadoEn,
    PolizaReportable? Function()? poliza,
    TipoSiniestroAuto? Function()? tipoAuto,
    DateTime? Function()? ocurridoEn,
    String? descripcion,
    String? lugar,
    String? ciudad,
    Coordenada? Function()? ubicacion,
    String? Function()? direccionEscrita,
    DateTime? Function()? guardadoEn,
    int? intentos,
    DateTime? Function()? proximoIntentoEn,
    String? Function()? ultimoError,
    bool? radicacionIncierta,
    bool? datosPermitidos,
    bool? esperaWifi,
    bool? avisoWifiDado,
    SiniestroReportado? Function()? resultado,
    DateTime? Function()? enviadoEn,
    List<FotoGuardada>? fotos,
  }) => ReporteGuardado(
    id: id,
    cuentaId: cuentaId,
    creadoEn: creadoEn,
    estado: estado ?? this.estado,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    poliza: poliza != null ? poliza() : this.poliza,
    tipoAuto: tipoAuto != null ? tipoAuto() : this.tipoAuto,
    ocurridoEn: ocurridoEn != null ? ocurridoEn() : this.ocurridoEn,
    descripcion: descripcion ?? this.descripcion,
    lugar: lugar ?? this.lugar,
    ciudad: ciudad ?? this.ciudad,
    ubicacion: ubicacion != null ? ubicacion() : this.ubicacion,
    direccionEscrita: direccionEscrita != null
        ? direccionEscrita()
        : this.direccionEscrita,
    guardadoEn: guardadoEn != null ? guardadoEn() : this.guardadoEn,
    intentos: intentos ?? this.intentos,
    proximoIntentoEn: proximoIntentoEn != null
        ? proximoIntentoEn()
        : this.proximoIntentoEn,
    ultimoError: ultimoError != null ? ultimoError() : this.ultimoError,
    radicacionIncierta: radicacionIncierta ?? this.radicacionIncierta,
    datosPermitidos: datosPermitidos ?? this.datosPermitidos,
    esperaWifi: esperaWifi ?? this.esperaWifi,
    avisoWifiDado: avisoWifiDado ?? this.avisoWifiDado,
    resultado: resultado != null ? resultado() : this.resultado,
    enviadoEn: enviadoEn != null ? enviadoEn() : this.enviadoEn,
    fotos: fotos ?? this.fotos,
  );
}

/// Límites del almacén local (plan 4.2).
abstract final class LimitesLocales {
  /// Reportes sin enviar por cuenta (borradores y pendientes).
  static const maxSinEnviar = 5;

  /// Un borrador sin tocar se borra a los 7 días.
  static const vidaBorrador = Duration(days: 7);

  /// Desde cuándo la lista avisa que un borrador se va a borrar.
  static const avisoBorrador = Duration(days: 5);

  /// Un enviado se quita del teléfono al día: ya está en la aseguradora.
  static const vidaEnviado = Duration(hours: 24);

  /// Lo de una cuenta que no volvió a entrar se borra a los 30 días.
  static const vidaOtraCuenta = Duration(days: 30);

  /// Espacio libre mínimo para guardar otra foto.
  static const espacioMinimo = 50 * 1024 * 1024;
}
