// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
class Input$ConsentimientoInput {
  factory Input$ConsentimientoInput({
    required String finalidad,
    required String versionTexto,
    String? documentoIdentidad,
    String? tipoDato,
    String? fuenteDatos,
    String? canal,
  }) => Input$ConsentimientoInput._({
    r'finalidad': finalidad,
    r'versionTexto': versionTexto,
    if (documentoIdentidad != null) r'documentoIdentidad': documentoIdentidad,
    if (tipoDato != null) r'tipoDato': tipoDato,
    if (fuenteDatos != null) r'fuenteDatos': fuenteDatos,
    if (canal != null) r'canal': canal,
  });

  Input$ConsentimientoInput._(this._$data);

  factory Input$ConsentimientoInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$finalidad = data['finalidad'];
    result$data['finalidad'] = (l$finalidad as String);
    final l$versionTexto = data['versionTexto'];
    result$data['versionTexto'] = (l$versionTexto as String);
    if (data.containsKey('documentoIdentidad')) {
      final l$documentoIdentidad = data['documentoIdentidad'];
      result$data['documentoIdentidad'] = (l$documentoIdentidad as String?);
    }
    if (data.containsKey('tipoDato')) {
      final l$tipoDato = data['tipoDato'];
      result$data['tipoDato'] = (l$tipoDato as String?);
    }
    if (data.containsKey('fuenteDatos')) {
      final l$fuenteDatos = data['fuenteDatos'];
      result$data['fuenteDatos'] = (l$fuenteDatos as String?);
    }
    if (data.containsKey('canal')) {
      final l$canal = data['canal'];
      result$data['canal'] = (l$canal as String?);
    }
    return Input$ConsentimientoInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get finalidad => (_$data['finalidad'] as String);

  String get versionTexto => (_$data['versionTexto'] as String);

  String? get documentoIdentidad => (_$data['documentoIdentidad'] as String?);

  String? get tipoDato => (_$data['tipoDato'] as String?);

  String? get fuenteDatos => (_$data['fuenteDatos'] as String?);

  String? get canal => (_$data['canal'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$finalidad = finalidad;
    result$data['finalidad'] = l$finalidad;
    final l$versionTexto = versionTexto;
    result$data['versionTexto'] = l$versionTexto;
    if (_$data.containsKey('documentoIdentidad')) {
      final l$documentoIdentidad = documentoIdentidad;
      result$data['documentoIdentidad'] = l$documentoIdentidad;
    }
    if (_$data.containsKey('tipoDato')) {
      final l$tipoDato = tipoDato;
      result$data['tipoDato'] = l$tipoDato;
    }
    if (_$data.containsKey('fuenteDatos')) {
      final l$fuenteDatos = fuenteDatos;
      result$data['fuenteDatos'] = l$fuenteDatos;
    }
    if (_$data.containsKey('canal')) {
      final l$canal = canal;
      result$data['canal'] = l$canal;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ConsentimientoInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$finalidad = finalidad;
    final lOther$finalidad = other.finalidad;
    if (l$finalidad != lOther$finalidad) {
      return false;
    }
    final l$versionTexto = versionTexto;
    final lOther$versionTexto = other.versionTexto;
    if (l$versionTexto != lOther$versionTexto) {
      return false;
    }
    final l$documentoIdentidad = documentoIdentidad;
    final lOther$documentoIdentidad = other.documentoIdentidad;
    if (_$data.containsKey('documentoIdentidad') !=
        other._$data.containsKey('documentoIdentidad')) {
      return false;
    }
    if (l$documentoIdentidad != lOther$documentoIdentidad) {
      return false;
    }
    final l$tipoDato = tipoDato;
    final lOther$tipoDato = other.tipoDato;
    if (_$data.containsKey('tipoDato') !=
        other._$data.containsKey('tipoDato')) {
      return false;
    }
    if (l$tipoDato != lOther$tipoDato) {
      return false;
    }
    final l$fuenteDatos = fuenteDatos;
    final lOther$fuenteDatos = other.fuenteDatos;
    if (_$data.containsKey('fuenteDatos') !=
        other._$data.containsKey('fuenteDatos')) {
      return false;
    }
    if (l$fuenteDatos != lOther$fuenteDatos) {
      return false;
    }
    final l$canal = canal;
    final lOther$canal = other.canal;
    if (_$data.containsKey('canal') != other._$data.containsKey('canal')) {
      return false;
    }
    if (l$canal != lOther$canal) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$finalidad = finalidad;
    final l$versionTexto = versionTexto;
    final l$documentoIdentidad = documentoIdentidad;
    final l$tipoDato = tipoDato;
    final l$fuenteDatos = fuenteDatos;
    final l$canal = canal;
    return Object.hashAll([
      l$finalidad,
      l$versionTexto,
      _$data.containsKey('documentoIdentidad')
          ? l$documentoIdentidad
          : const {},
      _$data.containsKey('tipoDato') ? l$tipoDato : const {},
      _$data.containsKey('fuenteDatos') ? l$fuenteDatos : const {},
      _$data.containsKey('canal') ? l$canal : const {},
    ]);
  }
}

class Input$SolicitudOfertaInput {
  factory Input$SolicitudOfertaInput({
    required String consentimientoId,
    required String documentoIdentidad,
    required String valorCredito,
    required int plazoMeses,
    required String direccionInmueble,
  }) => Input$SolicitudOfertaInput._({
    r'consentimientoId': consentimientoId,
    r'documentoIdentidad': documentoIdentidad,
    r'valorCredito': valorCredito,
    r'plazoMeses': plazoMeses,
    r'direccionInmueble': direccionInmueble,
  });

  Input$SolicitudOfertaInput._(this._$data);

  factory Input$SolicitudOfertaInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$consentimientoId = data['consentimientoId'];
    result$data['consentimientoId'] = (l$consentimientoId as String);
    final l$documentoIdentidad = data['documentoIdentidad'];
    result$data['documentoIdentidad'] = (l$documentoIdentidad as String);
    final l$valorCredito = data['valorCredito'];
    result$data['valorCredito'] = (l$valorCredito as String);
    final l$plazoMeses = data['plazoMeses'];
    result$data['plazoMeses'] = (l$plazoMeses as int);
    final l$direccionInmueble = data['direccionInmueble'];
    result$data['direccionInmueble'] = (l$direccionInmueble as String);
    return Input$SolicitudOfertaInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get consentimientoId => (_$data['consentimientoId'] as String);

  String get documentoIdentidad => (_$data['documentoIdentidad'] as String);

  String get valorCredito => (_$data['valorCredito'] as String);

  int get plazoMeses => (_$data['plazoMeses'] as int);

  String get direccionInmueble => (_$data['direccionInmueble'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$consentimientoId = consentimientoId;
    result$data['consentimientoId'] = l$consentimientoId;
    final l$documentoIdentidad = documentoIdentidad;
    result$data['documentoIdentidad'] = l$documentoIdentidad;
    final l$valorCredito = valorCredito;
    result$data['valorCredito'] = l$valorCredito;
    final l$plazoMeses = plazoMeses;
    result$data['plazoMeses'] = l$plazoMeses;
    final l$direccionInmueble = direccionInmueble;
    result$data['direccionInmueble'] = l$direccionInmueble;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$SolicitudOfertaInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$consentimientoId = consentimientoId;
    final lOther$consentimientoId = other.consentimientoId;
    if (l$consentimientoId != lOther$consentimientoId) {
      return false;
    }
    final l$documentoIdentidad = documentoIdentidad;
    final lOther$documentoIdentidad = other.documentoIdentidad;
    if (l$documentoIdentidad != lOther$documentoIdentidad) {
      return false;
    }
    final l$valorCredito = valorCredito;
    final lOther$valorCredito = other.valorCredito;
    if (l$valorCredito != lOther$valorCredito) {
      return false;
    }
    final l$plazoMeses = plazoMeses;
    final lOther$plazoMeses = other.plazoMeses;
    if (l$plazoMeses != lOther$plazoMeses) {
      return false;
    }
    final l$direccionInmueble = direccionInmueble;
    final lOther$direccionInmueble = other.direccionInmueble;
    if (l$direccionInmueble != lOther$direccionInmueble) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$consentimientoId = consentimientoId;
    final l$documentoIdentidad = documentoIdentidad;
    final l$valorCredito = valorCredito;
    final l$plazoMeses = plazoMeses;
    final l$direccionInmueble = direccionInmueble;
    return Object.hashAll([
      l$consentimientoId,
      l$documentoIdentidad,
      l$valorCredito,
      l$plazoMeses,
      l$direccionInmueble,
    ]);
  }
}

class Input$MontoInput {
  factory Input$MontoInput({required String valor, required String moneda}) =>
      Input$MontoInput._({r'valor': valor, r'moneda': moneda});

  Input$MontoInput._(this._$data);

  factory Input$MontoInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$valor = data['valor'];
    result$data['valor'] = (l$valor as String);
    final l$moneda = data['moneda'];
    result$data['moneda'] = (l$moneda as String);
    return Input$MontoInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get valor => (_$data['valor'] as String);

  String get moneda => (_$data['moneda'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$valor = valor;
    result$data['valor'] = l$valor;
    final l$moneda = moneda;
    result$data['moneda'] = l$moneda;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$MontoInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$valor = valor;
    final lOther$valor = other.valor;
    if (l$valor != lOther$valor) {
      return false;
    }
    final l$moneda = moneda;
    final lOther$moneda = other.moneda;
    if (l$moneda != lOther$moneda) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$valor = valor;
    final l$moneda = moneda;
    return Object.hashAll([l$valor, l$moneda]);
  }
}

class Input$CrearCobroInput {
  factory Input$CrearCobroInput({
    required String idIntentoCobro,
    required String polizaId,
    String? clienteId,
    required Input$MontoInput monto,
    required String tokenMedioPago,
  }) => Input$CrearCobroInput._({
    r'idIntentoCobro': idIntentoCobro,
    r'polizaId': polizaId,
    if (clienteId != null) r'clienteId': clienteId,
    r'monto': monto,
    r'tokenMedioPago': tokenMedioPago,
  });

  Input$CrearCobroInput._(this._$data);

  factory Input$CrearCobroInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$idIntentoCobro = data['idIntentoCobro'];
    result$data['idIntentoCobro'] = (l$idIntentoCobro as String);
    final l$polizaId = data['polizaId'];
    result$data['polizaId'] = (l$polizaId as String);
    if (data.containsKey('clienteId')) {
      final l$clienteId = data['clienteId'];
      result$data['clienteId'] = (l$clienteId as String?);
    }
    final l$monto = data['monto'];
    result$data['monto'] = Input$MontoInput.fromJson(
      (l$monto as Map<String, dynamic>),
    );
    final l$tokenMedioPago = data['tokenMedioPago'];
    result$data['tokenMedioPago'] = (l$tokenMedioPago as String);
    return Input$CrearCobroInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get idIntentoCobro => (_$data['idIntentoCobro'] as String);

  String get polizaId => (_$data['polizaId'] as String);

  String? get clienteId => (_$data['clienteId'] as String?);

  Input$MontoInput get monto => (_$data['monto'] as Input$MontoInput);

  String get tokenMedioPago => (_$data['tokenMedioPago'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$idIntentoCobro = idIntentoCobro;
    result$data['idIntentoCobro'] = l$idIntentoCobro;
    final l$polizaId = polizaId;
    result$data['polizaId'] = l$polizaId;
    if (_$data.containsKey('clienteId')) {
      final l$clienteId = clienteId;
      result$data['clienteId'] = l$clienteId;
    }
    final l$monto = monto;
    result$data['monto'] = l$monto.toJson();
    final l$tokenMedioPago = tokenMedioPago;
    result$data['tokenMedioPago'] = l$tokenMedioPago;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CrearCobroInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$idIntentoCobro = idIntentoCobro;
    final lOther$idIntentoCobro = other.idIntentoCobro;
    if (l$idIntentoCobro != lOther$idIntentoCobro) {
      return false;
    }
    final l$polizaId = polizaId;
    final lOther$polizaId = other.polizaId;
    if (l$polizaId != lOther$polizaId) {
      return false;
    }
    final l$clienteId = clienteId;
    final lOther$clienteId = other.clienteId;
    if (_$data.containsKey('clienteId') !=
        other._$data.containsKey('clienteId')) {
      return false;
    }
    if (l$clienteId != lOther$clienteId) {
      return false;
    }
    final l$monto = monto;
    final lOther$monto = other.monto;
    if (l$monto != lOther$monto) {
      return false;
    }
    final l$tokenMedioPago = tokenMedioPago;
    final lOther$tokenMedioPago = other.tokenMedioPago;
    if (l$tokenMedioPago != lOther$tokenMedioPago) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$idIntentoCobro = idIntentoCobro;
    final l$polizaId = polizaId;
    final l$clienteId = clienteId;
    final l$monto = monto;
    final l$tokenMedioPago = tokenMedioPago;
    return Object.hashAll([
      l$idIntentoCobro,
      l$polizaId,
      _$data.containsKey('clienteId') ? l$clienteId : const {},
      l$monto,
      l$tokenMedioPago,
    ]);
  }
}

class Input$CredencialesInput {
  factory Input$CredencialesInput({
    required String usuario,
    required String clave,
  }) => Input$CredencialesInput._({r'usuario': usuario, r'clave': clave});

  Input$CredencialesInput._(this._$data);

  factory Input$CredencialesInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$usuario = data['usuario'];
    result$data['usuario'] = (l$usuario as String);
    final l$clave = data['clave'];
    result$data['clave'] = (l$clave as String);
    return Input$CredencialesInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get usuario => (_$data['usuario'] as String);

  String get clave => (_$data['clave'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$usuario = usuario;
    result$data['usuario'] = l$usuario;
    final l$clave = clave;
    result$data['clave'] = l$clave;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CredencialesInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$usuario = usuario;
    final lOther$usuario = other.usuario;
    if (l$usuario != lOther$usuario) {
      return false;
    }
    final l$clave = clave;
    final lOther$clave = other.clave;
    if (l$clave != lOther$clave) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$usuario = usuario;
    final l$clave = clave;
    return Object.hashAll([l$usuario, l$clave]);
  }
}

class Input$CrearUsuarioInput {
  factory Input$CrearUsuarioInput({
    required String usuario,
    required String clave,
    required Enum$RolUsuario rol,
    String? nombre,
  }) => Input$CrearUsuarioInput._({
    r'usuario': usuario,
    r'clave': clave,
    r'rol': rol,
    if (nombre != null) r'nombre': nombre,
  });

  Input$CrearUsuarioInput._(this._$data);

  factory Input$CrearUsuarioInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$usuario = data['usuario'];
    result$data['usuario'] = (l$usuario as String);
    final l$clave = data['clave'];
    result$data['clave'] = (l$clave as String);
    final l$rol = data['rol'];
    result$data['rol'] = fromJson$Enum$RolUsuario((l$rol as String));
    if (data.containsKey('nombre')) {
      final l$nombre = data['nombre'];
      result$data['nombre'] = (l$nombre as String?);
    }
    return Input$CrearUsuarioInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get usuario => (_$data['usuario'] as String);

  String get clave => (_$data['clave'] as String);

  Enum$RolUsuario get rol => (_$data['rol'] as Enum$RolUsuario);

  String? get nombre => (_$data['nombre'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$usuario = usuario;
    result$data['usuario'] = l$usuario;
    final l$clave = clave;
    result$data['clave'] = l$clave;
    final l$rol = rol;
    result$data['rol'] = toJson$Enum$RolUsuario(l$rol);
    if (_$data.containsKey('nombre')) {
      final l$nombre = nombre;
      result$data['nombre'] = l$nombre;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CrearUsuarioInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$usuario = usuario;
    final lOther$usuario = other.usuario;
    if (l$usuario != lOther$usuario) {
      return false;
    }
    final l$clave = clave;
    final lOther$clave = other.clave;
    if (l$clave != lOther$clave) {
      return false;
    }
    final l$rol = rol;
    final lOther$rol = other.rol;
    if (l$rol != lOther$rol) {
      return false;
    }
    final l$nombre = nombre;
    final lOther$nombre = other.nombre;
    if (_$data.containsKey('nombre') != other._$data.containsKey('nombre')) {
      return false;
    }
    if (l$nombre != lOther$nombre) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$usuario = usuario;
    final l$clave = clave;
    final l$rol = rol;
    final l$nombre = nombre;
    return Object.hashAll([
      l$usuario,
      l$clave,
      l$rol,
      _$data.containsKey('nombre') ? l$nombre : const {},
    ]);
  }
}

enum Enum$EstadoConsentimiento {
  VIGENTE,
  REVOCADO,
  VENCIDO,
  $unknown;

  factory Enum$EstadoConsentimiento.fromJson(String value) =>
      fromJson$Enum$EstadoConsentimiento(value);

  String toJson() => toJson$Enum$EstadoConsentimiento(this);
}

String toJson$Enum$EstadoConsentimiento(Enum$EstadoConsentimiento e) {
  switch (e) {
    case Enum$EstadoConsentimiento.VIGENTE:
      return r'VIGENTE';
    case Enum$EstadoConsentimiento.REVOCADO:
      return r'REVOCADO';
    case Enum$EstadoConsentimiento.VENCIDO:
      return r'VENCIDO';
    case Enum$EstadoConsentimiento.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoConsentimiento fromJson$Enum$EstadoConsentimiento(String value) {
  switch (value) {
    case r'VIGENTE':
      return Enum$EstadoConsentimiento.VIGENTE;
    case r'REVOCADO':
      return Enum$EstadoConsentimiento.REVOCADO;
    case r'VENCIDO':
      return Enum$EstadoConsentimiento.VENCIDO;
    default:
      return Enum$EstadoConsentimiento.$unknown;
  }
}

enum Enum$TipoOferta {
  COMPLETA,
  PRELIMINAR,
  $unknown;

  factory Enum$TipoOferta.fromJson(String value) =>
      fromJson$Enum$TipoOferta(value);

  String toJson() => toJson$Enum$TipoOferta(this);
}

String toJson$Enum$TipoOferta(Enum$TipoOferta e) {
  switch (e) {
    case Enum$TipoOferta.COMPLETA:
      return r'COMPLETA';
    case Enum$TipoOferta.PRELIMINAR:
      return r'PRELIMINAR';
    case Enum$TipoOferta.$unknown:
      return r'$unknown';
  }
}

Enum$TipoOferta fromJson$Enum$TipoOferta(String value) {
  switch (value) {
    case r'COMPLETA':
      return Enum$TipoOferta.COMPLETA;
    case r'PRELIMINAR':
      return Enum$TipoOferta.PRELIMINAR;
    default:
      return Enum$TipoOferta.$unknown;
  }
}

enum Enum$EstadoFuente {
  OK,
  CACHE,
  FALLO,
  $unknown;

  factory Enum$EstadoFuente.fromJson(String value) =>
      fromJson$Enum$EstadoFuente(value);

  String toJson() => toJson$Enum$EstadoFuente(this);
}

String toJson$Enum$EstadoFuente(Enum$EstadoFuente e) {
  switch (e) {
    case Enum$EstadoFuente.OK:
      return r'OK';
    case Enum$EstadoFuente.CACHE:
      return r'CACHE';
    case Enum$EstadoFuente.FALLO:
      return r'FALLO';
    case Enum$EstadoFuente.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoFuente fromJson$Enum$EstadoFuente(String value) {
  switch (value) {
    case r'OK':
      return Enum$EstadoFuente.OK;
    case r'CACHE':
      return Enum$EstadoFuente.CACHE;
    case r'FALLO':
      return Enum$EstadoFuente.FALLO;
    default:
      return Enum$EstadoFuente.$unknown;
  }
}

enum Enum$NivelRiesgo {
  BAJO,
  MEDIO,
  ALTO,
  $unknown;

  factory Enum$NivelRiesgo.fromJson(String value) =>
      fromJson$Enum$NivelRiesgo(value);

  String toJson() => toJson$Enum$NivelRiesgo(this);
}

String toJson$Enum$NivelRiesgo(Enum$NivelRiesgo e) {
  switch (e) {
    case Enum$NivelRiesgo.BAJO:
      return r'BAJO';
    case Enum$NivelRiesgo.MEDIO:
      return r'MEDIO';
    case Enum$NivelRiesgo.ALTO:
      return r'ALTO';
    case Enum$NivelRiesgo.$unknown:
      return r'$unknown';
  }
}

Enum$NivelRiesgo fromJson$Enum$NivelRiesgo(String value) {
  switch (value) {
    case r'BAJO':
      return Enum$NivelRiesgo.BAJO;
    case r'MEDIO':
      return Enum$NivelRiesgo.MEDIO;
    case r'ALTO':
      return Enum$NivelRiesgo.ALTO;
    default:
      return Enum$NivelRiesgo.$unknown;
  }
}

enum Enum$MotivoErrorOferta {
  CONSENTIMIENTO_NO_VIGENTE,
  DATOS_INSUFICIENTES,
  FUENTES_NO_DISPONIBLES,
  $unknown;

  factory Enum$MotivoErrorOferta.fromJson(String value) =>
      fromJson$Enum$MotivoErrorOferta(value);

  String toJson() => toJson$Enum$MotivoErrorOferta(this);
}

String toJson$Enum$MotivoErrorOferta(Enum$MotivoErrorOferta e) {
  switch (e) {
    case Enum$MotivoErrorOferta.CONSENTIMIENTO_NO_VIGENTE:
      return r'CONSENTIMIENTO_NO_VIGENTE';
    case Enum$MotivoErrorOferta.DATOS_INSUFICIENTES:
      return r'DATOS_INSUFICIENTES';
    case Enum$MotivoErrorOferta.FUENTES_NO_DISPONIBLES:
      return r'FUENTES_NO_DISPONIBLES';
    case Enum$MotivoErrorOferta.$unknown:
      return r'$unknown';
  }
}

Enum$MotivoErrorOferta fromJson$Enum$MotivoErrorOferta(String value) {
  switch (value) {
    case r'CONSENTIMIENTO_NO_VIGENTE':
      return Enum$MotivoErrorOferta.CONSENTIMIENTO_NO_VIGENTE;
    case r'DATOS_INSUFICIENTES':
      return Enum$MotivoErrorOferta.DATOS_INSUFICIENTES;
    case r'FUENTES_NO_DISPONIBLES':
      return Enum$MotivoErrorOferta.FUENTES_NO_DISPONIBLES;
    default:
      return Enum$MotivoErrorOferta.$unknown;
  }
}

enum Enum$OrigenFuente {
  OPEN_FINANCE,
  OPEN_DATA,
  $unknown;

  factory Enum$OrigenFuente.fromJson(String value) =>
      fromJson$Enum$OrigenFuente(value);

  String toJson() => toJson$Enum$OrigenFuente(this);
}

String toJson$Enum$OrigenFuente(Enum$OrigenFuente e) {
  switch (e) {
    case Enum$OrigenFuente.OPEN_FINANCE:
      return r'OPEN_FINANCE';
    case Enum$OrigenFuente.OPEN_DATA:
      return r'OPEN_DATA';
    case Enum$OrigenFuente.$unknown:
      return r'$unknown';
  }
}

Enum$OrigenFuente fromJson$Enum$OrigenFuente(String value) {
  switch (value) {
    case r'OPEN_FINANCE':
      return Enum$OrigenFuente.OPEN_FINANCE;
    case r'OPEN_DATA':
      return Enum$OrigenFuente.OPEN_DATA;
    default:
      return Enum$OrigenFuente.$unknown;
  }
}

enum Enum$CanalContacto {
  LLAMAR,
  CHAT,
  AGENDAR,
  $unknown;

  factory Enum$CanalContacto.fromJson(String value) =>
      fromJson$Enum$CanalContacto(value);

  String toJson() => toJson$Enum$CanalContacto(this);
}

String toJson$Enum$CanalContacto(Enum$CanalContacto e) {
  switch (e) {
    case Enum$CanalContacto.LLAMAR:
      return r'LLAMAR';
    case Enum$CanalContacto.CHAT:
      return r'CHAT';
    case Enum$CanalContacto.AGENDAR:
      return r'AGENDAR';
    case Enum$CanalContacto.$unknown:
      return r'$unknown';
  }
}

Enum$CanalContacto fromJson$Enum$CanalContacto(String value) {
  switch (value) {
    case r'LLAMAR':
      return Enum$CanalContacto.LLAMAR;
    case r'CHAT':
      return Enum$CanalContacto.CHAT;
    case r'AGENDAR':
      return Enum$CanalContacto.AGENDAR;
    default:
      return Enum$CanalContacto.$unknown;
  }
}

enum Enum$EstadoCobro {
  COBRANDO,
  COBRADO,
  RECHAZADO,
  PENDIENTE,
  $unknown;

  factory Enum$EstadoCobro.fromJson(String value) =>
      fromJson$Enum$EstadoCobro(value);

  String toJson() => toJson$Enum$EstadoCobro(this);
}

String toJson$Enum$EstadoCobro(Enum$EstadoCobro e) {
  switch (e) {
    case Enum$EstadoCobro.COBRANDO:
      return r'COBRANDO';
    case Enum$EstadoCobro.COBRADO:
      return r'COBRADO';
    case Enum$EstadoCobro.RECHAZADO:
      return r'RECHAZADO';
    case Enum$EstadoCobro.PENDIENTE:
      return r'PENDIENTE';
    case Enum$EstadoCobro.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoCobro fromJson$Enum$EstadoCobro(String value) {
  switch (value) {
    case r'COBRANDO':
      return Enum$EstadoCobro.COBRANDO;
    case r'COBRADO':
      return Enum$EstadoCobro.COBRADO;
    case r'RECHAZADO':
      return Enum$EstadoCobro.RECHAZADO;
    case r'PENDIENTE':
      return Enum$EstadoCobro.PENDIENTE;
    default:
      return Enum$EstadoCobro.$unknown;
  }
}

enum Enum$RolUsuario {
  CLIENTE,
  ASESOR,
  BACKOFFICE,
  $unknown;

  factory Enum$RolUsuario.fromJson(String value) =>
      fromJson$Enum$RolUsuario(value);

  String toJson() => toJson$Enum$RolUsuario(this);
}

String toJson$Enum$RolUsuario(Enum$RolUsuario e) {
  switch (e) {
    case Enum$RolUsuario.CLIENTE:
      return r'CLIENTE';
    case Enum$RolUsuario.ASESOR:
      return r'ASESOR';
    case Enum$RolUsuario.BACKOFFICE:
      return r'BACKOFFICE';
    case Enum$RolUsuario.$unknown:
      return r'$unknown';
  }
}

Enum$RolUsuario fromJson$Enum$RolUsuario(String value) {
  switch (value) {
    case r'CLIENTE':
      return Enum$RolUsuario.CLIENTE;
    case r'ASESOR':
      return Enum$RolUsuario.ASESOR;
    case r'BACKOFFICE':
      return Enum$RolUsuario.BACKOFFICE;
    default:
      return Enum$RolUsuario.$unknown;
  }
}

enum Enum$EstadoUsuario {
  ACTIVO,
  SUSPENDIDO,
  $unknown;

  factory Enum$EstadoUsuario.fromJson(String value) =>
      fromJson$Enum$EstadoUsuario(value);

  String toJson() => toJson$Enum$EstadoUsuario(this);
}

String toJson$Enum$EstadoUsuario(Enum$EstadoUsuario e) {
  switch (e) {
    case Enum$EstadoUsuario.ACTIVO:
      return r'ACTIVO';
    case Enum$EstadoUsuario.SUSPENDIDO:
      return r'SUSPENDIDO';
    case Enum$EstadoUsuario.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoUsuario fromJson$Enum$EstadoUsuario(String value) {
  switch (value) {
    case r'ACTIVO':
      return Enum$EstadoUsuario.ACTIVO;
    case r'SUSPENDIDO':
      return Enum$EstadoUsuario.SUSPENDIDO;
    default:
      return Enum$EstadoUsuario.$unknown;
  }
}

enum Enum$__TypeKind {
  SCALAR,
  OBJECT,
  INTERFACE,
  UNION,
  ENUM,
  INPUT_OBJECT,
  LIST,
  NON_NULL,
  $unknown;

  factory Enum$__TypeKind.fromJson(String value) =>
      fromJson$Enum$__TypeKind(value);

  String toJson() => toJson$Enum$__TypeKind(this);
}

String toJson$Enum$__TypeKind(Enum$__TypeKind e) {
  switch (e) {
    case Enum$__TypeKind.SCALAR:
      return r'SCALAR';
    case Enum$__TypeKind.OBJECT:
      return r'OBJECT';
    case Enum$__TypeKind.INTERFACE:
      return r'INTERFACE';
    case Enum$__TypeKind.UNION:
      return r'UNION';
    case Enum$__TypeKind.ENUM:
      return r'ENUM';
    case Enum$__TypeKind.INPUT_OBJECT:
      return r'INPUT_OBJECT';
    case Enum$__TypeKind.LIST:
      return r'LIST';
    case Enum$__TypeKind.NON_NULL:
      return r'NON_NULL';
    case Enum$__TypeKind.$unknown:
      return r'$unknown';
  }
}

Enum$__TypeKind fromJson$Enum$__TypeKind(String value) {
  switch (value) {
    case r'SCALAR':
      return Enum$__TypeKind.SCALAR;
    case r'OBJECT':
      return Enum$__TypeKind.OBJECT;
    case r'INTERFACE':
      return Enum$__TypeKind.INTERFACE;
    case r'UNION':
      return Enum$__TypeKind.UNION;
    case r'ENUM':
      return Enum$__TypeKind.ENUM;
    case r'INPUT_OBJECT':
      return Enum$__TypeKind.INPUT_OBJECT;
    case r'LIST':
      return Enum$__TypeKind.LIST;
    case r'NON_NULL':
      return Enum$__TypeKind.NON_NULL;
    default:
      return Enum$__TypeKind.$unknown;
  }
}

enum Enum$__DirectiveLocation {
  QUERY,
  MUTATION,
  SUBSCRIPTION,
  FIELD,
  FRAGMENT_DEFINITION,
  FRAGMENT_SPREAD,
  INLINE_FRAGMENT,
  VARIABLE_DEFINITION,
  SCHEMA,
  SCALAR,
  OBJECT,
  FIELD_DEFINITION,
  ARGUMENT_DEFINITION,
  INTERFACE,
  UNION,
  ENUM,
  ENUM_VALUE,
  INPUT_OBJECT,
  INPUT_FIELD_DEFINITION,
  $unknown;

  factory Enum$__DirectiveLocation.fromJson(String value) =>
      fromJson$Enum$__DirectiveLocation(value);

  String toJson() => toJson$Enum$__DirectiveLocation(this);
}

String toJson$Enum$__DirectiveLocation(Enum$__DirectiveLocation e) {
  switch (e) {
    case Enum$__DirectiveLocation.QUERY:
      return r'QUERY';
    case Enum$__DirectiveLocation.MUTATION:
      return r'MUTATION';
    case Enum$__DirectiveLocation.SUBSCRIPTION:
      return r'SUBSCRIPTION';
    case Enum$__DirectiveLocation.FIELD:
      return r'FIELD';
    case Enum$__DirectiveLocation.FRAGMENT_DEFINITION:
      return r'FRAGMENT_DEFINITION';
    case Enum$__DirectiveLocation.FRAGMENT_SPREAD:
      return r'FRAGMENT_SPREAD';
    case Enum$__DirectiveLocation.INLINE_FRAGMENT:
      return r'INLINE_FRAGMENT';
    case Enum$__DirectiveLocation.VARIABLE_DEFINITION:
      return r'VARIABLE_DEFINITION';
    case Enum$__DirectiveLocation.SCHEMA:
      return r'SCHEMA';
    case Enum$__DirectiveLocation.SCALAR:
      return r'SCALAR';
    case Enum$__DirectiveLocation.OBJECT:
      return r'OBJECT';
    case Enum$__DirectiveLocation.FIELD_DEFINITION:
      return r'FIELD_DEFINITION';
    case Enum$__DirectiveLocation.ARGUMENT_DEFINITION:
      return r'ARGUMENT_DEFINITION';
    case Enum$__DirectiveLocation.INTERFACE:
      return r'INTERFACE';
    case Enum$__DirectiveLocation.UNION:
      return r'UNION';
    case Enum$__DirectiveLocation.ENUM:
      return r'ENUM';
    case Enum$__DirectiveLocation.ENUM_VALUE:
      return r'ENUM_VALUE';
    case Enum$__DirectiveLocation.INPUT_OBJECT:
      return r'INPUT_OBJECT';
    case Enum$__DirectiveLocation.INPUT_FIELD_DEFINITION:
      return r'INPUT_FIELD_DEFINITION';
    case Enum$__DirectiveLocation.$unknown:
      return r'$unknown';
  }
}

Enum$__DirectiveLocation fromJson$Enum$__DirectiveLocation(String value) {
  switch (value) {
    case r'QUERY':
      return Enum$__DirectiveLocation.QUERY;
    case r'MUTATION':
      return Enum$__DirectiveLocation.MUTATION;
    case r'SUBSCRIPTION':
      return Enum$__DirectiveLocation.SUBSCRIPTION;
    case r'FIELD':
      return Enum$__DirectiveLocation.FIELD;
    case r'FRAGMENT_DEFINITION':
      return Enum$__DirectiveLocation.FRAGMENT_DEFINITION;
    case r'FRAGMENT_SPREAD':
      return Enum$__DirectiveLocation.FRAGMENT_SPREAD;
    case r'INLINE_FRAGMENT':
      return Enum$__DirectiveLocation.INLINE_FRAGMENT;
    case r'VARIABLE_DEFINITION':
      return Enum$__DirectiveLocation.VARIABLE_DEFINITION;
    case r'SCHEMA':
      return Enum$__DirectiveLocation.SCHEMA;
    case r'SCALAR':
      return Enum$__DirectiveLocation.SCALAR;
    case r'OBJECT':
      return Enum$__DirectiveLocation.OBJECT;
    case r'FIELD_DEFINITION':
      return Enum$__DirectiveLocation.FIELD_DEFINITION;
    case r'ARGUMENT_DEFINITION':
      return Enum$__DirectiveLocation.ARGUMENT_DEFINITION;
    case r'INTERFACE':
      return Enum$__DirectiveLocation.INTERFACE;
    case r'UNION':
      return Enum$__DirectiveLocation.UNION;
    case r'ENUM':
      return Enum$__DirectiveLocation.ENUM;
    case r'ENUM_VALUE':
      return Enum$__DirectiveLocation.ENUM_VALUE;
    case r'INPUT_OBJECT':
      return Enum$__DirectiveLocation.INPUT_OBJECT;
    case r'INPUT_FIELD_DEFINITION':
      return Enum$__DirectiveLocation.INPUT_FIELD_DEFINITION;
    default:
      return Enum$__DirectiveLocation.$unknown;
  }
}

const possibleTypesMap = <String, Set<String>>{
  'ResultadoOferta': {'Oferta', 'ErrorOferta'},
  'ResultadoCobro': {'Cobro', 'ErrorCobro'},
  'ResultadoSesion': {'Sesion', 'ErrorAutenticacion'},
  'ResultadoUsuario': {'Usuario', 'ErrorUsuario'},
};
