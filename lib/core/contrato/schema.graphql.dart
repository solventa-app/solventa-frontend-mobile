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
    String? documentoIdentidad,
    required String valorCredito,
    required int plazoMeses,
    required String direccionInmueble,
  }) => Input$SolicitudOfertaInput._({
    r'consentimientoId': consentimientoId,
    if (documentoIdentidad != null) r'documentoIdentidad': documentoIdentidad,
    r'valorCredito': valorCredito,
    r'plazoMeses': plazoMeses,
    r'direccionInmueble': direccionInmueble,
  });

  Input$SolicitudOfertaInput._(this._$data);

  factory Input$SolicitudOfertaInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$consentimientoId = data['consentimientoId'];
    result$data['consentimientoId'] = (l$consentimientoId as String);
    if (data.containsKey('documentoIdentidad')) {
      final l$documentoIdentidad = data['documentoIdentidad'];
      result$data['documentoIdentidad'] = (l$documentoIdentidad as String?);
    }
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

  String? get documentoIdentidad => (_$data['documentoIdentidad'] as String?);

  String get valorCredito => (_$data['valorCredito'] as String);

  int get plazoMeses => (_$data['plazoMeses'] as int);

  String get direccionInmueble => (_$data['direccionInmueble'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$consentimientoId = consentimientoId;
    result$data['consentimientoId'] = l$consentimientoId;
    if (_$data.containsKey('documentoIdentidad')) {
      final l$documentoIdentidad = documentoIdentidad;
      result$data['documentoIdentidad'] = l$documentoIdentidad;
    }
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
    if (_$data.containsKey('documentoIdentidad') !=
        other._$data.containsKey('documentoIdentidad')) {
      return false;
    }
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
      _$data.containsKey('documentoIdentidad')
          ? l$documentoIdentidad
          : const {},
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

class Input$FirmarPropuestaInput {
  factory Input$FirmarPropuestaInput({
    required String propuestaId,
    required bool autorizaCobro,
    required String versionDocumento,
  }) => Input$FirmarPropuestaInput._({
    r'propuestaId': propuestaId,
    r'autorizaCobro': autorizaCobro,
    r'versionDocumento': versionDocumento,
  });

  Input$FirmarPropuestaInput._(this._$data);

  factory Input$FirmarPropuestaInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$propuestaId = data['propuestaId'];
    result$data['propuestaId'] = (l$propuestaId as String);
    final l$autorizaCobro = data['autorizaCobro'];
    result$data['autorizaCobro'] = (l$autorizaCobro as bool);
    final l$versionDocumento = data['versionDocumento'];
    result$data['versionDocumento'] = (l$versionDocumento as String);
    return Input$FirmarPropuestaInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get propuestaId => (_$data['propuestaId'] as String);

  bool get autorizaCobro => (_$data['autorizaCobro'] as bool);

  String get versionDocumento => (_$data['versionDocumento'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$propuestaId = propuestaId;
    result$data['propuestaId'] = l$propuestaId;
    final l$autorizaCobro = autorizaCobro;
    result$data['autorizaCobro'] = l$autorizaCobro;
    final l$versionDocumento = versionDocumento;
    result$data['versionDocumento'] = l$versionDocumento;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$FirmarPropuestaInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$propuestaId = propuestaId;
    final lOther$propuestaId = other.propuestaId;
    if (l$propuestaId != lOther$propuestaId) {
      return false;
    }
    final l$autorizaCobro = autorizaCobro;
    final lOther$autorizaCobro = other.autorizaCobro;
    if (l$autorizaCobro != lOther$autorizaCobro) {
      return false;
    }
    final l$versionDocumento = versionDocumento;
    final lOther$versionDocumento = other.versionDocumento;
    if (l$versionDocumento != lOther$versionDocumento) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$propuestaId = propuestaId;
    final l$autorizaCobro = autorizaCobro;
    final l$versionDocumento = versionDocumento;
    return Object.hashAll([l$propuestaId, l$autorizaCobro, l$versionDocumento]);
  }
}

class Input$ContactoTitularInput {
  factory Input$ContactoTitularInput({
    required String nombre,
    required String correo,
  }) => Input$ContactoTitularInput._({r'nombre': nombre, r'correo': correo});

  Input$ContactoTitularInput._(this._$data);

  factory Input$ContactoTitularInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$nombre = data['nombre'];
    result$data['nombre'] = (l$nombre as String);
    final l$correo = data['correo'];
    result$data['correo'] = (l$correo as String);
    return Input$ContactoTitularInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get nombre => (_$data['nombre'] as String);

  String get correo => (_$data['correo'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$nombre = nombre;
    result$data['nombre'] = l$nombre;
    final l$correo = correo;
    result$data['correo'] = l$correo;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ContactoTitularInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$nombre = nombre;
    final lOther$nombre = other.nombre;
    if (l$nombre != lOther$nombre) {
      return false;
    }
    final l$correo = correo;
    final lOther$correo = other.correo;
    if (l$correo != lOther$correo) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$nombre = nombre;
    final l$correo = correo;
    return Object.hashAll([l$nombre, l$correo]);
  }
}

class Input$FirmarPorEnlaceInput {
  factory Input$FirmarPorEnlaceInput({
    String? propuestaId,
    required String versionDocumento,
    required bool aceptaTerminos,
    required bool autorizaCobro,
    required Enum$ModoFirma modo,
    String? imagenArchivoId,
    String? nombreFirma,
  }) => Input$FirmarPorEnlaceInput._({
    if (propuestaId != null) r'propuestaId': propuestaId,
    r'versionDocumento': versionDocumento,
    r'aceptaTerminos': aceptaTerminos,
    r'autorizaCobro': autorizaCobro,
    r'modo': modo,
    if (imagenArchivoId != null) r'imagenArchivoId': imagenArchivoId,
    if (nombreFirma != null) r'nombreFirma': nombreFirma,
  });

  Input$FirmarPorEnlaceInput._(this._$data);

  factory Input$FirmarPorEnlaceInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('propuestaId')) {
      final l$propuestaId = data['propuestaId'];
      result$data['propuestaId'] = (l$propuestaId as String?);
    }
    final l$versionDocumento = data['versionDocumento'];
    result$data['versionDocumento'] = (l$versionDocumento as String);
    final l$aceptaTerminos = data['aceptaTerminos'];
    result$data['aceptaTerminos'] = (l$aceptaTerminos as bool);
    final l$autorizaCobro = data['autorizaCobro'];
    result$data['autorizaCobro'] = (l$autorizaCobro as bool);
    final l$modo = data['modo'];
    result$data['modo'] = fromJson$Enum$ModoFirma((l$modo as String));
    if (data.containsKey('imagenArchivoId')) {
      final l$imagenArchivoId = data['imagenArchivoId'];
      result$data['imagenArchivoId'] = (l$imagenArchivoId as String?);
    }
    if (data.containsKey('nombreFirma')) {
      final l$nombreFirma = data['nombreFirma'];
      result$data['nombreFirma'] = (l$nombreFirma as String?);
    }
    return Input$FirmarPorEnlaceInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get propuestaId => (_$data['propuestaId'] as String?);

  String get versionDocumento => (_$data['versionDocumento'] as String);

  bool get aceptaTerminos => (_$data['aceptaTerminos'] as bool);

  bool get autorizaCobro => (_$data['autorizaCobro'] as bool);

  Enum$ModoFirma get modo => (_$data['modo'] as Enum$ModoFirma);

  String? get imagenArchivoId => (_$data['imagenArchivoId'] as String?);

  String? get nombreFirma => (_$data['nombreFirma'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('propuestaId')) {
      final l$propuestaId = propuestaId;
      result$data['propuestaId'] = l$propuestaId;
    }
    final l$versionDocumento = versionDocumento;
    result$data['versionDocumento'] = l$versionDocumento;
    final l$aceptaTerminos = aceptaTerminos;
    result$data['aceptaTerminos'] = l$aceptaTerminos;
    final l$autorizaCobro = autorizaCobro;
    result$data['autorizaCobro'] = l$autorizaCobro;
    final l$modo = modo;
    result$data['modo'] = toJson$Enum$ModoFirma(l$modo);
    if (_$data.containsKey('imagenArchivoId')) {
      final l$imagenArchivoId = imagenArchivoId;
      result$data['imagenArchivoId'] = l$imagenArchivoId;
    }
    if (_$data.containsKey('nombreFirma')) {
      final l$nombreFirma = nombreFirma;
      result$data['nombreFirma'] = l$nombreFirma;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$FirmarPorEnlaceInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$propuestaId = propuestaId;
    final lOther$propuestaId = other.propuestaId;
    if (_$data.containsKey('propuestaId') !=
        other._$data.containsKey('propuestaId')) {
      return false;
    }
    if (l$propuestaId != lOther$propuestaId) {
      return false;
    }
    final l$versionDocumento = versionDocumento;
    final lOther$versionDocumento = other.versionDocumento;
    if (l$versionDocumento != lOther$versionDocumento) {
      return false;
    }
    final l$aceptaTerminos = aceptaTerminos;
    final lOther$aceptaTerminos = other.aceptaTerminos;
    if (l$aceptaTerminos != lOther$aceptaTerminos) {
      return false;
    }
    final l$autorizaCobro = autorizaCobro;
    final lOther$autorizaCobro = other.autorizaCobro;
    if (l$autorizaCobro != lOther$autorizaCobro) {
      return false;
    }
    final l$modo = modo;
    final lOther$modo = other.modo;
    if (l$modo != lOther$modo) {
      return false;
    }
    final l$imagenArchivoId = imagenArchivoId;
    final lOther$imagenArchivoId = other.imagenArchivoId;
    if (_$data.containsKey('imagenArchivoId') !=
        other._$data.containsKey('imagenArchivoId')) {
      return false;
    }
    if (l$imagenArchivoId != lOther$imagenArchivoId) {
      return false;
    }
    final l$nombreFirma = nombreFirma;
    final lOther$nombreFirma = other.nombreFirma;
    if (_$data.containsKey('nombreFirma') !=
        other._$data.containsKey('nombreFirma')) {
      return false;
    }
    if (l$nombreFirma != lOther$nombreFirma) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$propuestaId = propuestaId;
    final l$versionDocumento = versionDocumento;
    final l$aceptaTerminos = aceptaTerminos;
    final l$autorizaCobro = autorizaCobro;
    final l$modo = modo;
    final l$imagenArchivoId = imagenArchivoId;
    final l$nombreFirma = nombreFirma;
    return Object.hashAll([
      _$data.containsKey('propuestaId') ? l$propuestaId : const {},
      l$versionDocumento,
      l$aceptaTerminos,
      l$autorizaCobro,
      l$modo,
      _$data.containsKey('imagenArchivoId') ? l$imagenArchivoId : const {},
      _$data.containsKey('nombreFirma') ? l$nombreFirma : const {},
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
    String? correo,
    String? telefono,
    String? documentoIdentidad,
  }) => Input$CrearUsuarioInput._({
    r'usuario': usuario,
    r'clave': clave,
    r'rol': rol,
    if (nombre != null) r'nombre': nombre,
    if (correo != null) r'correo': correo,
    if (telefono != null) r'telefono': telefono,
    if (documentoIdentidad != null) r'documentoIdentidad': documentoIdentidad,
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
    if (data.containsKey('correo')) {
      final l$correo = data['correo'];
      result$data['correo'] = (l$correo as String?);
    }
    if (data.containsKey('telefono')) {
      final l$telefono = data['telefono'];
      result$data['telefono'] = (l$telefono as String?);
    }
    if (data.containsKey('documentoIdentidad')) {
      final l$documentoIdentidad = data['documentoIdentidad'];
      result$data['documentoIdentidad'] = (l$documentoIdentidad as String?);
    }
    return Input$CrearUsuarioInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get usuario => (_$data['usuario'] as String);

  String get clave => (_$data['clave'] as String);

  Enum$RolUsuario get rol => (_$data['rol'] as Enum$RolUsuario);

  String? get nombre => (_$data['nombre'] as String?);

  String? get correo => (_$data['correo'] as String?);

  String? get telefono => (_$data['telefono'] as String?);

  String? get documentoIdentidad => (_$data['documentoIdentidad'] as String?);

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
    if (_$data.containsKey('correo')) {
      final l$correo = correo;
      result$data['correo'] = l$correo;
    }
    if (_$data.containsKey('telefono')) {
      final l$telefono = telefono;
      result$data['telefono'] = l$telefono;
    }
    if (_$data.containsKey('documentoIdentidad')) {
      final l$documentoIdentidad = documentoIdentidad;
      result$data['documentoIdentidad'] = l$documentoIdentidad;
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
    final l$correo = correo;
    final lOther$correo = other.correo;
    if (_$data.containsKey('correo') != other._$data.containsKey('correo')) {
      return false;
    }
    if (l$correo != lOther$correo) {
      return false;
    }
    final l$telefono = telefono;
    final lOther$telefono = other.telefono;
    if (_$data.containsKey('telefono') !=
        other._$data.containsKey('telefono')) {
      return false;
    }
    if (l$telefono != lOther$telefono) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$usuario = usuario;
    final l$clave = clave;
    final l$rol = rol;
    final l$nombre = nombre;
    final l$correo = correo;
    final l$telefono = telefono;
    final l$documentoIdentidad = documentoIdentidad;
    return Object.hashAll([
      l$usuario,
      l$clave,
      l$rol,
      _$data.containsKey('nombre') ? l$nombre : const {},
      _$data.containsKey('correo') ? l$correo : const {},
      _$data.containsKey('telefono') ? l$telefono : const {},
      _$data.containsKey('documentoIdentidad')
          ? l$documentoIdentidad
          : const {},
    ]);
  }
}

class Input$PreferenciasInput {
  factory Input$PreferenciasInput({
    required String idioma,
    required String moneda,
  }) => Input$PreferenciasInput._({r'idioma': idioma, r'moneda': moneda});

  Input$PreferenciasInput._(this._$data);

  factory Input$PreferenciasInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$idioma = data['idioma'];
    result$data['idioma'] = (l$idioma as String);
    final l$moneda = data['moneda'];
    result$data['moneda'] = (l$moneda as String);
    return Input$PreferenciasInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get idioma => (_$data['idioma'] as String);

  String get moneda => (_$data['moneda'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$idioma = idioma;
    result$data['idioma'] = l$idioma;
    final l$moneda = moneda;
    result$data['moneda'] = l$moneda;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$PreferenciasInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$idioma = idioma;
    final lOther$idioma = other.idioma;
    if (l$idioma != lOther$idioma) {
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
    final l$idioma = idioma;
    final l$moneda = moneda;
    return Object.hashAll([l$idioma, l$moneda]);
  }
}

class Input$ContactoInput {
  factory Input$ContactoInput({String? correo, String? telefono}) =>
      Input$ContactoInput._({
        if (correo != null) r'correo': correo,
        if (telefono != null) r'telefono': telefono,
      });

  Input$ContactoInput._(this._$data);

  factory Input$ContactoInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('correo')) {
      final l$correo = data['correo'];
      result$data['correo'] = (l$correo as String?);
    }
    if (data.containsKey('telefono')) {
      final l$telefono = data['telefono'];
      result$data['telefono'] = (l$telefono as String?);
    }
    return Input$ContactoInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get correo => (_$data['correo'] as String?);

  String? get telefono => (_$data['telefono'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('correo')) {
      final l$correo = correo;
      result$data['correo'] = l$correo;
    }
    if (_$data.containsKey('telefono')) {
      final l$telefono = telefono;
      result$data['telefono'] = l$telefono;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ContactoInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$correo = correo;
    final lOther$correo = other.correo;
    if (_$data.containsKey('correo') != other._$data.containsKey('correo')) {
      return false;
    }
    if (l$correo != lOther$correo) {
      return false;
    }
    final l$telefono = telefono;
    final lOther$telefono = other.telefono;
    if (_$data.containsKey('telefono') !=
        other._$data.containsKey('telefono')) {
      return false;
    }
    if (l$telefono != lOther$telefono) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$correo = correo;
    final l$telefono = telefono;
    return Object.hashAll([
      _$data.containsKey('correo') ? l$correo : const {},
      _$data.containsKey('telefono') ? l$telefono : const {},
    ]);
  }
}

class Input$SolicitudSubidaArchivoInput {
  factory Input$SolicitudSubidaArchivoInput({
    required String tipo,
    required String tipoContenido,
    required int tamanoBytes,
    String? propietarioId,
    String? consentimientoId,
  }) => Input$SolicitudSubidaArchivoInput._({
    r'tipo': tipo,
    r'tipoContenido': tipoContenido,
    r'tamanoBytes': tamanoBytes,
    if (propietarioId != null) r'propietarioId': propietarioId,
    if (consentimientoId != null) r'consentimientoId': consentimientoId,
  });

  Input$SolicitudSubidaArchivoInput._(this._$data);

  factory Input$SolicitudSubidaArchivoInput.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$tipo = data['tipo'];
    result$data['tipo'] = (l$tipo as String);
    final l$tipoContenido = data['tipoContenido'];
    result$data['tipoContenido'] = (l$tipoContenido as String);
    final l$tamanoBytes = data['tamanoBytes'];
    result$data['tamanoBytes'] = (l$tamanoBytes as int);
    if (data.containsKey('propietarioId')) {
      final l$propietarioId = data['propietarioId'];
      result$data['propietarioId'] = (l$propietarioId as String?);
    }
    if (data.containsKey('consentimientoId')) {
      final l$consentimientoId = data['consentimientoId'];
      result$data['consentimientoId'] = (l$consentimientoId as String?);
    }
    return Input$SolicitudSubidaArchivoInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get tipo => (_$data['tipo'] as String);

  String get tipoContenido => (_$data['tipoContenido'] as String);

  int get tamanoBytes => (_$data['tamanoBytes'] as int);

  String? get propietarioId => (_$data['propietarioId'] as String?);

  String? get consentimientoId => (_$data['consentimientoId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$tipo = tipo;
    result$data['tipo'] = l$tipo;
    final l$tipoContenido = tipoContenido;
    result$data['tipoContenido'] = l$tipoContenido;
    final l$tamanoBytes = tamanoBytes;
    result$data['tamanoBytes'] = l$tamanoBytes;
    if (_$data.containsKey('propietarioId')) {
      final l$propietarioId = propietarioId;
      result$data['propietarioId'] = l$propietarioId;
    }
    if (_$data.containsKey('consentimientoId')) {
      final l$consentimientoId = consentimientoId;
      result$data['consentimientoId'] = l$consentimientoId;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$SolicitudSubidaArchivoInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$tipo = tipo;
    final lOther$tipo = other.tipo;
    if (l$tipo != lOther$tipo) {
      return false;
    }
    final l$tipoContenido = tipoContenido;
    final lOther$tipoContenido = other.tipoContenido;
    if (l$tipoContenido != lOther$tipoContenido) {
      return false;
    }
    final l$tamanoBytes = tamanoBytes;
    final lOther$tamanoBytes = other.tamanoBytes;
    if (l$tamanoBytes != lOther$tamanoBytes) {
      return false;
    }
    final l$propietarioId = propietarioId;
    final lOther$propietarioId = other.propietarioId;
    if (_$data.containsKey('propietarioId') !=
        other._$data.containsKey('propietarioId')) {
      return false;
    }
    if (l$propietarioId != lOther$propietarioId) {
      return false;
    }
    final l$consentimientoId = consentimientoId;
    final lOther$consentimientoId = other.consentimientoId;
    if (_$data.containsKey('consentimientoId') !=
        other._$data.containsKey('consentimientoId')) {
      return false;
    }
    if (l$consentimientoId != lOther$consentimientoId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$tipo = tipo;
    final l$tipoContenido = tipoContenido;
    final l$tamanoBytes = tamanoBytes;
    final l$propietarioId = propietarioId;
    final l$consentimientoId = consentimientoId;
    return Object.hashAll([
      l$tipo,
      l$tipoContenido,
      l$tamanoBytes,
      _$data.containsKey('propietarioId') ? l$propietarioId : const {},
      _$data.containsKey('consentimientoId') ? l$consentimientoId : const {},
    ]);
  }
}

class Input$IniciarOnboardingInput {
  factory Input$IniciarOnboardingInput({
    String? jurisdiccion,
    required Enum$TipoDocumentoOnboarding tipoDocumento,
  }) => Input$IniciarOnboardingInput._({
    if (jurisdiccion != null) r'jurisdiccion': jurisdiccion,
    r'tipoDocumento': tipoDocumento,
  });

  Input$IniciarOnboardingInput._(this._$data);

  factory Input$IniciarOnboardingInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('jurisdiccion')) {
      final l$jurisdiccion = data['jurisdiccion'];
      result$data['jurisdiccion'] = (l$jurisdiccion as String);
    }
    final l$tipoDocumento = data['tipoDocumento'];
    result$data['tipoDocumento'] = fromJson$Enum$TipoDocumentoOnboarding(
      (l$tipoDocumento as String),
    );
    return Input$IniciarOnboardingInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get jurisdiccion => (_$data['jurisdiccion'] as String?);

  Enum$TipoDocumentoOnboarding get tipoDocumento =>
      (_$data['tipoDocumento'] as Enum$TipoDocumentoOnboarding);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('jurisdiccion')) {
      final l$jurisdiccion = jurisdiccion;
      result$data['jurisdiccion'] = (l$jurisdiccion as String);
    }
    final l$tipoDocumento = tipoDocumento;
    result$data['tipoDocumento'] = toJson$Enum$TipoDocumentoOnboarding(
      l$tipoDocumento,
    );
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$IniciarOnboardingInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$jurisdiccion = jurisdiccion;
    final lOther$jurisdiccion = other.jurisdiccion;
    if (_$data.containsKey('jurisdiccion') !=
        other._$data.containsKey('jurisdiccion')) {
      return false;
    }
    if (l$jurisdiccion != lOther$jurisdiccion) {
      return false;
    }
    final l$tipoDocumento = tipoDocumento;
    final lOther$tipoDocumento = other.tipoDocumento;
    if (l$tipoDocumento != lOther$tipoDocumento) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$jurisdiccion = jurisdiccion;
    final l$tipoDocumento = tipoDocumento;
    return Object.hashAll([
      _$data.containsKey('jurisdiccion') ? l$jurisdiccion : const {},
      l$tipoDocumento,
    ]);
  }
}

class Input$CuentaOnboardingInput {
  factory Input$CuentaOnboardingInput({
    required String correo,
    required String clave,
  }) => Input$CuentaOnboardingInput._({r'correo': correo, r'clave': clave});

  Input$CuentaOnboardingInput._(this._$data);

  factory Input$CuentaOnboardingInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$correo = data['correo'];
    result$data['correo'] = (l$correo as String);
    final l$clave = data['clave'];
    result$data['clave'] = (l$clave as String);
    return Input$CuentaOnboardingInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get correo => (_$data['correo'] as String);

  String get clave => (_$data['clave'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$correo = correo;
    result$data['correo'] = l$correo;
    final l$clave = clave;
    result$data['clave'] = l$clave;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CuentaOnboardingInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$correo = correo;
    final lOther$correo = other.correo;
    if (l$correo != lOther$correo) {
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
    final l$correo = correo;
    final l$clave = clave;
    return Object.hashAll([l$correo, l$clave]);
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

enum Enum$OrigenCobro {
  INTERACTIVO,
  RECURRENTE,
  $unknown;

  factory Enum$OrigenCobro.fromJson(String value) =>
      fromJson$Enum$OrigenCobro(value);

  String toJson() => toJson$Enum$OrigenCobro(this);
}

String toJson$Enum$OrigenCobro(Enum$OrigenCobro e) {
  switch (e) {
    case Enum$OrigenCobro.INTERACTIVO:
      return r'INTERACTIVO';
    case Enum$OrigenCobro.RECURRENTE:
      return r'RECURRENTE';
    case Enum$OrigenCobro.$unknown:
      return r'$unknown';
  }
}

Enum$OrigenCobro fromJson$Enum$OrigenCobro(String value) {
  switch (value) {
    case r'INTERACTIVO':
      return Enum$OrigenCobro.INTERACTIVO;
    case r'RECURRENTE':
      return Enum$OrigenCobro.RECURRENTE;
    default:
      return Enum$OrigenCobro.$unknown;
  }
}

enum Enum$TipoMedioPago {
  CREDITO,
  DEBITO,
  $unknown;

  factory Enum$TipoMedioPago.fromJson(String value) =>
      fromJson$Enum$TipoMedioPago(value);

  String toJson() => toJson$Enum$TipoMedioPago(this);
}

String toJson$Enum$TipoMedioPago(Enum$TipoMedioPago e) {
  switch (e) {
    case Enum$TipoMedioPago.CREDITO:
      return r'CREDITO';
    case Enum$TipoMedioPago.DEBITO:
      return r'DEBITO';
    case Enum$TipoMedioPago.$unknown:
      return r'$unknown';
  }
}

Enum$TipoMedioPago fromJson$Enum$TipoMedioPago(String value) {
  switch (value) {
    case r'CREDITO':
      return Enum$TipoMedioPago.CREDITO;
    case r'DEBITO':
      return Enum$TipoMedioPago.DEBITO;
    default:
      return Enum$TipoMedioPago.$unknown;
  }
}

enum Enum$EstadoPropuesta {
  ACEPTADA,
  EN_EMISION,
  EN_REVISION,
  PENDIENTE_PAGO,
  PAGO_RECHAZADO,
  NO_EMITIDA,
  EMITIDA,
  IDENTIDAD_VERIFICADA,
  EN_FIRMA,
  FIRMADA,
  CANCELADA,
  $unknown;

  factory Enum$EstadoPropuesta.fromJson(String value) =>
      fromJson$Enum$EstadoPropuesta(value);

  String toJson() => toJson$Enum$EstadoPropuesta(this);
}

String toJson$Enum$EstadoPropuesta(Enum$EstadoPropuesta e) {
  switch (e) {
    case Enum$EstadoPropuesta.ACEPTADA:
      return r'ACEPTADA';
    case Enum$EstadoPropuesta.EN_EMISION:
      return r'EN_EMISION';
    case Enum$EstadoPropuesta.EN_REVISION:
      return r'EN_REVISION';
    case Enum$EstadoPropuesta.PENDIENTE_PAGO:
      return r'PENDIENTE_PAGO';
    case Enum$EstadoPropuesta.PAGO_RECHAZADO:
      return r'PAGO_RECHAZADO';
    case Enum$EstadoPropuesta.NO_EMITIDA:
      return r'NO_EMITIDA';
    case Enum$EstadoPropuesta.EMITIDA:
      return r'EMITIDA';
    case Enum$EstadoPropuesta.IDENTIDAD_VERIFICADA:
      return r'IDENTIDAD_VERIFICADA';
    case Enum$EstadoPropuesta.EN_FIRMA:
      return r'EN_FIRMA';
    case Enum$EstadoPropuesta.FIRMADA:
      return r'FIRMADA';
    case Enum$EstadoPropuesta.CANCELADA:
      return r'CANCELADA';
    case Enum$EstadoPropuesta.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoPropuesta fromJson$Enum$EstadoPropuesta(String value) {
  switch (value) {
    case r'ACEPTADA':
      return Enum$EstadoPropuesta.ACEPTADA;
    case r'EN_EMISION':
      return Enum$EstadoPropuesta.EN_EMISION;
    case r'EN_REVISION':
      return Enum$EstadoPropuesta.EN_REVISION;
    case r'PENDIENTE_PAGO':
      return Enum$EstadoPropuesta.PENDIENTE_PAGO;
    case r'PAGO_RECHAZADO':
      return Enum$EstadoPropuesta.PAGO_RECHAZADO;
    case r'NO_EMITIDA':
      return Enum$EstadoPropuesta.NO_EMITIDA;
    case r'EMITIDA':
      return Enum$EstadoPropuesta.EMITIDA;
    case r'IDENTIDAD_VERIFICADA':
      return Enum$EstadoPropuesta.IDENTIDAD_VERIFICADA;
    case r'EN_FIRMA':
      return Enum$EstadoPropuesta.EN_FIRMA;
    case r'FIRMADA':
      return Enum$EstadoPropuesta.FIRMADA;
    case r'CANCELADA':
      return Enum$EstadoPropuesta.CANCELADA;
    default:
      return Enum$EstadoPropuesta.$unknown;
  }
}

enum Enum$EstadoVisible {
  EMITIENDO,
  EMITIDA,
  NO_EMITIDA,
  $unknown;

  factory Enum$EstadoVisible.fromJson(String value) =>
      fromJson$Enum$EstadoVisible(value);

  String toJson() => toJson$Enum$EstadoVisible(this);
}

String toJson$Enum$EstadoVisible(Enum$EstadoVisible e) {
  switch (e) {
    case Enum$EstadoVisible.EMITIENDO:
      return r'EMITIENDO';
    case Enum$EstadoVisible.EMITIDA:
      return r'EMITIDA';
    case Enum$EstadoVisible.NO_EMITIDA:
      return r'NO_EMITIDA';
    case Enum$EstadoVisible.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoVisible fromJson$Enum$EstadoVisible(String value) {
  switch (value) {
    case r'EMITIENDO':
      return Enum$EstadoVisible.EMITIENDO;
    case r'EMITIDA':
      return Enum$EstadoVisible.EMITIDA;
    case r'NO_EMITIDA':
      return Enum$EstadoVisible.NO_EMITIDA;
    default:
      return Enum$EstadoVisible.$unknown;
  }
}

enum Enum$MotivoErrorAceptacion {
  OFERTA_PRELIMINAR,
  OFERTA_VENCIDA,
  OFERTA_NO_ENCONTRADA,
  CONSENTIMIENTO_NO_VIGENTE,
  $unknown;

  factory Enum$MotivoErrorAceptacion.fromJson(String value) =>
      fromJson$Enum$MotivoErrorAceptacion(value);

  String toJson() => toJson$Enum$MotivoErrorAceptacion(this);
}

String toJson$Enum$MotivoErrorAceptacion(Enum$MotivoErrorAceptacion e) {
  switch (e) {
    case Enum$MotivoErrorAceptacion.OFERTA_PRELIMINAR:
      return r'OFERTA_PRELIMINAR';
    case Enum$MotivoErrorAceptacion.OFERTA_VENCIDA:
      return r'OFERTA_VENCIDA';
    case Enum$MotivoErrorAceptacion.OFERTA_NO_ENCONTRADA:
      return r'OFERTA_NO_ENCONTRADA';
    case Enum$MotivoErrorAceptacion.CONSENTIMIENTO_NO_VIGENTE:
      return r'CONSENTIMIENTO_NO_VIGENTE';
    case Enum$MotivoErrorAceptacion.$unknown:
      return r'$unknown';
  }
}

Enum$MotivoErrorAceptacion fromJson$Enum$MotivoErrorAceptacion(String value) {
  switch (value) {
    case r'OFERTA_PRELIMINAR':
      return Enum$MotivoErrorAceptacion.OFERTA_PRELIMINAR;
    case r'OFERTA_VENCIDA':
      return Enum$MotivoErrorAceptacion.OFERTA_VENCIDA;
    case r'OFERTA_NO_ENCONTRADA':
      return Enum$MotivoErrorAceptacion.OFERTA_NO_ENCONTRADA;
    case r'CONSENTIMIENTO_NO_VIGENTE':
      return Enum$MotivoErrorAceptacion.CONSENTIMIENTO_NO_VIGENTE;
    default:
      return Enum$MotivoErrorAceptacion.$unknown;
  }
}

enum Enum$MotivoErrorFirma {
  COBRO_NO_AUTORIZADO,
  VERSION_DOCUMENTO_DESACTUALIZADA,
  PROPUESTA_NO_FIRMABLE,
  SERVICIO_FIRMA_NO_DISPONIBLE,
  ENLACE_VENCIDO,
  IMAGEN_INVALIDA,
  $unknown;

  factory Enum$MotivoErrorFirma.fromJson(String value) =>
      fromJson$Enum$MotivoErrorFirma(value);

  String toJson() => toJson$Enum$MotivoErrorFirma(this);
}

String toJson$Enum$MotivoErrorFirma(Enum$MotivoErrorFirma e) {
  switch (e) {
    case Enum$MotivoErrorFirma.COBRO_NO_AUTORIZADO:
      return r'COBRO_NO_AUTORIZADO';
    case Enum$MotivoErrorFirma.VERSION_DOCUMENTO_DESACTUALIZADA:
      return r'VERSION_DOCUMENTO_DESACTUALIZADA';
    case Enum$MotivoErrorFirma.PROPUESTA_NO_FIRMABLE:
      return r'PROPUESTA_NO_FIRMABLE';
    case Enum$MotivoErrorFirma.SERVICIO_FIRMA_NO_DISPONIBLE:
      return r'SERVICIO_FIRMA_NO_DISPONIBLE';
    case Enum$MotivoErrorFirma.ENLACE_VENCIDO:
      return r'ENLACE_VENCIDO';
    case Enum$MotivoErrorFirma.IMAGEN_INVALIDA:
      return r'IMAGEN_INVALIDA';
    case Enum$MotivoErrorFirma.$unknown:
      return r'$unknown';
  }
}

Enum$MotivoErrorFirma fromJson$Enum$MotivoErrorFirma(String value) {
  switch (value) {
    case r'COBRO_NO_AUTORIZADO':
      return Enum$MotivoErrorFirma.COBRO_NO_AUTORIZADO;
    case r'VERSION_DOCUMENTO_DESACTUALIZADA':
      return Enum$MotivoErrorFirma.VERSION_DOCUMENTO_DESACTUALIZADA;
    case r'PROPUESTA_NO_FIRMABLE':
      return Enum$MotivoErrorFirma.PROPUESTA_NO_FIRMABLE;
    case r'SERVICIO_FIRMA_NO_DISPONIBLE':
      return Enum$MotivoErrorFirma.SERVICIO_FIRMA_NO_DISPONIBLE;
    case r'ENLACE_VENCIDO':
      return Enum$MotivoErrorFirma.ENLACE_VENCIDO;
    case r'IMAGEN_INVALIDA':
      return Enum$MotivoErrorFirma.IMAGEN_INVALIDA;
    default:
      return Enum$MotivoErrorFirma.$unknown;
  }
}

enum Enum$MotivoEstadoPropuesta {
  PAGO_FONDOS_INSUFICIENTES,
  PAGO_RECHAZADO,
  PAGO_EN_PROCESO,
  REVISION_MANUAL,
  NO_APROBADA,
  $unknown;

  factory Enum$MotivoEstadoPropuesta.fromJson(String value) =>
      fromJson$Enum$MotivoEstadoPropuesta(value);

  String toJson() => toJson$Enum$MotivoEstadoPropuesta(this);
}

String toJson$Enum$MotivoEstadoPropuesta(Enum$MotivoEstadoPropuesta e) {
  switch (e) {
    case Enum$MotivoEstadoPropuesta.PAGO_FONDOS_INSUFICIENTES:
      return r'PAGO_FONDOS_INSUFICIENTES';
    case Enum$MotivoEstadoPropuesta.PAGO_RECHAZADO:
      return r'PAGO_RECHAZADO';
    case Enum$MotivoEstadoPropuesta.PAGO_EN_PROCESO:
      return r'PAGO_EN_PROCESO';
    case Enum$MotivoEstadoPropuesta.REVISION_MANUAL:
      return r'REVISION_MANUAL';
    case Enum$MotivoEstadoPropuesta.NO_APROBADA:
      return r'NO_APROBADA';
    case Enum$MotivoEstadoPropuesta.$unknown:
      return r'$unknown';
  }
}

Enum$MotivoEstadoPropuesta fromJson$Enum$MotivoEstadoPropuesta(String value) {
  switch (value) {
    case r'PAGO_FONDOS_INSUFICIENTES':
      return Enum$MotivoEstadoPropuesta.PAGO_FONDOS_INSUFICIENTES;
    case r'PAGO_RECHAZADO':
      return Enum$MotivoEstadoPropuesta.PAGO_RECHAZADO;
    case r'PAGO_EN_PROCESO':
      return Enum$MotivoEstadoPropuesta.PAGO_EN_PROCESO;
    case r'REVISION_MANUAL':
      return Enum$MotivoEstadoPropuesta.REVISION_MANUAL;
    case r'NO_APROBADA':
      return Enum$MotivoEstadoPropuesta.NO_APROBADA;
    default:
      return Enum$MotivoEstadoPropuesta.$unknown;
  }
}

enum Enum$AccionSugerida {
  ESPERAR,
  CONTACTAR_ASESOR,
  $unknown;

  factory Enum$AccionSugerida.fromJson(String value) =>
      fromJson$Enum$AccionSugerida(value);

  String toJson() => toJson$Enum$AccionSugerida(this);
}

String toJson$Enum$AccionSugerida(Enum$AccionSugerida e) {
  switch (e) {
    case Enum$AccionSugerida.ESPERAR:
      return r'ESPERAR';
    case Enum$AccionSugerida.CONTACTAR_ASESOR:
      return r'CONTACTAR_ASESOR';
    case Enum$AccionSugerida.$unknown:
      return r'$unknown';
  }
}

Enum$AccionSugerida fromJson$Enum$AccionSugerida(String value) {
  switch (value) {
    case r'ESPERAR':
      return Enum$AccionSugerida.ESPERAR;
    case r'CONTACTAR_ASESOR':
      return Enum$AccionSugerida.CONTACTAR_ASESOR;
    default:
      return Enum$AccionSugerida.$unknown;
  }
}

enum Enum$EstadoPoliza {
  EMITIDA,
  $unknown;

  factory Enum$EstadoPoliza.fromJson(String value) =>
      fromJson$Enum$EstadoPoliza(value);

  String toJson() => toJson$Enum$EstadoPoliza(this);
}

String toJson$Enum$EstadoPoliza(Enum$EstadoPoliza e) {
  switch (e) {
    case Enum$EstadoPoliza.EMITIDA:
      return r'EMITIDA';
    case Enum$EstadoPoliza.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoPoliza fromJson$Enum$EstadoPoliza(String value) {
  switch (value) {
    case r'EMITIDA':
      return Enum$EstadoPoliza.EMITIDA;
    default:
      return Enum$EstadoPoliza.$unknown;
  }
}

enum Enum$MotivoErrorCodigo {
  CODIGO_INVALIDO,
  CODIGO_VENCIDO,
  INTENTOS_AGOTADOS,
  PROPUESTA_NO_VALIDA,
  $unknown;

  factory Enum$MotivoErrorCodigo.fromJson(String value) =>
      fromJson$Enum$MotivoErrorCodigo(value);

  String toJson() => toJson$Enum$MotivoErrorCodigo(this);
}

String toJson$Enum$MotivoErrorCodigo(Enum$MotivoErrorCodigo e) {
  switch (e) {
    case Enum$MotivoErrorCodigo.CODIGO_INVALIDO:
      return r'CODIGO_INVALIDO';
    case Enum$MotivoErrorCodigo.CODIGO_VENCIDO:
      return r'CODIGO_VENCIDO';
    case Enum$MotivoErrorCodigo.INTENTOS_AGOTADOS:
      return r'INTENTOS_AGOTADOS';
    case Enum$MotivoErrorCodigo.PROPUESTA_NO_VALIDA:
      return r'PROPUESTA_NO_VALIDA';
    case Enum$MotivoErrorCodigo.$unknown:
      return r'$unknown';
  }
}

Enum$MotivoErrorCodigo fromJson$Enum$MotivoErrorCodigo(String value) {
  switch (value) {
    case r'CODIGO_INVALIDO':
      return Enum$MotivoErrorCodigo.CODIGO_INVALIDO;
    case r'CODIGO_VENCIDO':
      return Enum$MotivoErrorCodigo.CODIGO_VENCIDO;
    case r'INTENTOS_AGOTADOS':
      return Enum$MotivoErrorCodigo.INTENTOS_AGOTADOS;
    case r'PROPUESTA_NO_VALIDA':
      return Enum$MotivoErrorCodigo.PROPUESTA_NO_VALIDA;
    default:
      return Enum$MotivoErrorCodigo.$unknown;
  }
}

enum Enum$ModoFirma {
  TRAZO,
  IMAGEN,
  NOMBRE,
  $unknown;

  factory Enum$ModoFirma.fromJson(String value) =>
      fromJson$Enum$ModoFirma(value);

  String toJson() => toJson$Enum$ModoFirma(this);
}

String toJson$Enum$ModoFirma(Enum$ModoFirma e) {
  switch (e) {
    case Enum$ModoFirma.TRAZO:
      return r'TRAZO';
    case Enum$ModoFirma.IMAGEN:
      return r'IMAGEN';
    case Enum$ModoFirma.NOMBRE:
      return r'NOMBRE';
    case Enum$ModoFirma.$unknown:
      return r'$unknown';
  }
}

Enum$ModoFirma fromJson$Enum$ModoFirma(String value) {
  switch (value) {
    case r'TRAZO':
      return Enum$ModoFirma.TRAZO;
    case r'IMAGEN':
      return Enum$ModoFirma.IMAGEN;
    case r'NOMBRE':
      return Enum$ModoFirma.NOMBRE;
    default:
      return Enum$ModoFirma.$unknown;
  }
}

enum Enum$MotivoErrorPago {
  PAGO_RECHAZADO,
  FONDOS_INSUFICIENTES,
  TARJETA_VENCIDA,
  PASARELA_NO_DISPONIBLE,
  REQUIERE_OTRA_TARJETA,
  SESION_VENCIDA,
  ENLACE_VENCIDO,
  $unknown;

  factory Enum$MotivoErrorPago.fromJson(String value) =>
      fromJson$Enum$MotivoErrorPago(value);

  String toJson() => toJson$Enum$MotivoErrorPago(this);
}

String toJson$Enum$MotivoErrorPago(Enum$MotivoErrorPago e) {
  switch (e) {
    case Enum$MotivoErrorPago.PAGO_RECHAZADO:
      return r'PAGO_RECHAZADO';
    case Enum$MotivoErrorPago.FONDOS_INSUFICIENTES:
      return r'FONDOS_INSUFICIENTES';
    case Enum$MotivoErrorPago.TARJETA_VENCIDA:
      return r'TARJETA_VENCIDA';
    case Enum$MotivoErrorPago.PASARELA_NO_DISPONIBLE:
      return r'PASARELA_NO_DISPONIBLE';
    case Enum$MotivoErrorPago.REQUIERE_OTRA_TARJETA:
      return r'REQUIERE_OTRA_TARJETA';
    case Enum$MotivoErrorPago.SESION_VENCIDA:
      return r'SESION_VENCIDA';
    case Enum$MotivoErrorPago.ENLACE_VENCIDO:
      return r'ENLACE_VENCIDO';
    case Enum$MotivoErrorPago.$unknown:
      return r'$unknown';
  }
}

Enum$MotivoErrorPago fromJson$Enum$MotivoErrorPago(String value) {
  switch (value) {
    case r'PAGO_RECHAZADO':
      return Enum$MotivoErrorPago.PAGO_RECHAZADO;
    case r'FONDOS_INSUFICIENTES':
      return Enum$MotivoErrorPago.FONDOS_INSUFICIENTES;
    case r'TARJETA_VENCIDA':
      return Enum$MotivoErrorPago.TARJETA_VENCIDA;
    case r'PASARELA_NO_DISPONIBLE':
      return Enum$MotivoErrorPago.PASARELA_NO_DISPONIBLE;
    case r'REQUIERE_OTRA_TARJETA':
      return Enum$MotivoErrorPago.REQUIERE_OTRA_TARJETA;
    case r'SESION_VENCIDA':
      return Enum$MotivoErrorPago.SESION_VENCIDA;
    case r'ENLACE_VENCIDO':
      return Enum$MotivoErrorPago.ENLACE_VENCIDO;
    default:
      return Enum$MotivoErrorPago.$unknown;
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
  PENDIENTE_VERIFICACION,
  RECHAZADA,
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
    case Enum$EstadoUsuario.PENDIENTE_VERIFICACION:
      return r'PENDIENTE_VERIFICACION';
    case Enum$EstadoUsuario.RECHAZADA:
      return r'RECHAZADA';
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
    case r'PENDIENTE_VERIFICACION':
      return Enum$EstadoUsuario.PENDIENTE_VERIFICACION;
    case r'RECHAZADA':
      return Enum$EstadoUsuario.RECHAZADA;
    default:
      return Enum$EstadoUsuario.$unknown;
  }
}

enum Enum$EstadoArchivo {
  PENDIENTE,
  DISPONIBLE,
  RECHAZADO,
  ELIMINADO,
  $unknown;

  factory Enum$EstadoArchivo.fromJson(String value) =>
      fromJson$Enum$EstadoArchivo(value);

  String toJson() => toJson$Enum$EstadoArchivo(this);
}

String toJson$Enum$EstadoArchivo(Enum$EstadoArchivo e) {
  switch (e) {
    case Enum$EstadoArchivo.PENDIENTE:
      return r'PENDIENTE';
    case Enum$EstadoArchivo.DISPONIBLE:
      return r'DISPONIBLE';
    case Enum$EstadoArchivo.RECHAZADO:
      return r'RECHAZADO';
    case Enum$EstadoArchivo.ELIMINADO:
      return r'ELIMINADO';
    case Enum$EstadoArchivo.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoArchivo fromJson$Enum$EstadoArchivo(String value) {
  switch (value) {
    case r'PENDIENTE':
      return Enum$EstadoArchivo.PENDIENTE;
    case r'DISPONIBLE':
      return Enum$EstadoArchivo.DISPONIBLE;
    case r'RECHAZADO':
      return Enum$EstadoArchivo.RECHAZADO;
    case r'ELIMINADO':
      return Enum$EstadoArchivo.ELIMINADO;
    default:
      return Enum$EstadoArchivo.$unknown;
  }
}

enum Enum$EstadoOnboarding {
  INICIADO,
  EN_VERIFICACION,
  VERIFICADA,
  RECHAZADA,
  EN_REVISION,
  $unknown;

  factory Enum$EstadoOnboarding.fromJson(String value) =>
      fromJson$Enum$EstadoOnboarding(value);

  String toJson() => toJson$Enum$EstadoOnboarding(this);
}

String toJson$Enum$EstadoOnboarding(Enum$EstadoOnboarding e) {
  switch (e) {
    case Enum$EstadoOnboarding.INICIADO:
      return r'INICIADO';
    case Enum$EstadoOnboarding.EN_VERIFICACION:
      return r'EN_VERIFICACION';
    case Enum$EstadoOnboarding.VERIFICADA:
      return r'VERIFICADA';
    case Enum$EstadoOnboarding.RECHAZADA:
      return r'RECHAZADA';
    case Enum$EstadoOnboarding.EN_REVISION:
      return r'EN_REVISION';
    case Enum$EstadoOnboarding.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoOnboarding fromJson$Enum$EstadoOnboarding(String value) {
  switch (value) {
    case r'INICIADO':
      return Enum$EstadoOnboarding.INICIADO;
    case r'EN_VERIFICACION':
      return Enum$EstadoOnboarding.EN_VERIFICACION;
    case r'VERIFICADA':
      return Enum$EstadoOnboarding.VERIFICADA;
    case r'RECHAZADA':
      return Enum$EstadoOnboarding.RECHAZADA;
    case r'EN_REVISION':
      return Enum$EstadoOnboarding.EN_REVISION;
    default:
      return Enum$EstadoOnboarding.$unknown;
  }
}

enum Enum$MotivoOnboarding {
  ILEGIBLE,
  SUPLANTACION,
  ROSTRO_NO_COINCIDE,
  MENOR_DE_EDAD,
  DOCUMENTO_YA_REGISTRADO,
  PROVEEDOR_NO_DISPONIBLE,
  IMAGEN_NO_DISPONIBLE,
  $unknown;

  factory Enum$MotivoOnboarding.fromJson(String value) =>
      fromJson$Enum$MotivoOnboarding(value);

  String toJson() => toJson$Enum$MotivoOnboarding(this);
}

String toJson$Enum$MotivoOnboarding(Enum$MotivoOnboarding e) {
  switch (e) {
    case Enum$MotivoOnboarding.ILEGIBLE:
      return r'ILEGIBLE';
    case Enum$MotivoOnboarding.SUPLANTACION:
      return r'SUPLANTACION';
    case Enum$MotivoOnboarding.ROSTRO_NO_COINCIDE:
      return r'ROSTRO_NO_COINCIDE';
    case Enum$MotivoOnboarding.MENOR_DE_EDAD:
      return r'MENOR_DE_EDAD';
    case Enum$MotivoOnboarding.DOCUMENTO_YA_REGISTRADO:
      return r'DOCUMENTO_YA_REGISTRADO';
    case Enum$MotivoOnboarding.PROVEEDOR_NO_DISPONIBLE:
      return r'PROVEEDOR_NO_DISPONIBLE';
    case Enum$MotivoOnboarding.IMAGEN_NO_DISPONIBLE:
      return r'IMAGEN_NO_DISPONIBLE';
    case Enum$MotivoOnboarding.$unknown:
      return r'$unknown';
  }
}

Enum$MotivoOnboarding fromJson$Enum$MotivoOnboarding(String value) {
  switch (value) {
    case r'ILEGIBLE':
      return Enum$MotivoOnboarding.ILEGIBLE;
    case r'SUPLANTACION':
      return Enum$MotivoOnboarding.SUPLANTACION;
    case r'ROSTRO_NO_COINCIDE':
      return Enum$MotivoOnboarding.ROSTRO_NO_COINCIDE;
    case r'MENOR_DE_EDAD':
      return Enum$MotivoOnboarding.MENOR_DE_EDAD;
    case r'DOCUMENTO_YA_REGISTRADO':
      return Enum$MotivoOnboarding.DOCUMENTO_YA_REGISTRADO;
    case r'PROVEEDOR_NO_DISPONIBLE':
      return Enum$MotivoOnboarding.PROVEEDOR_NO_DISPONIBLE;
    case r'IMAGEN_NO_DISPONIBLE':
      return Enum$MotivoOnboarding.IMAGEN_NO_DISPONIBLE;
    default:
      return Enum$MotivoOnboarding.$unknown;
  }
}

enum Enum$PasoOnboarding {
  ANVERSO,
  REVERSO,
  ROSTRO,
  VIDEO,
  $unknown;

  factory Enum$PasoOnboarding.fromJson(String value) =>
      fromJson$Enum$PasoOnboarding(value);

  String toJson() => toJson$Enum$PasoOnboarding(this);
}

String toJson$Enum$PasoOnboarding(Enum$PasoOnboarding e) {
  switch (e) {
    case Enum$PasoOnboarding.ANVERSO:
      return r'ANVERSO';
    case Enum$PasoOnboarding.REVERSO:
      return r'REVERSO';
    case Enum$PasoOnboarding.ROSTRO:
      return r'ROSTRO';
    case Enum$PasoOnboarding.VIDEO:
      return r'VIDEO';
    case Enum$PasoOnboarding.$unknown:
      return r'$unknown';
  }
}

Enum$PasoOnboarding fromJson$Enum$PasoOnboarding(String value) {
  switch (value) {
    case r'ANVERSO':
      return Enum$PasoOnboarding.ANVERSO;
    case r'REVERSO':
      return Enum$PasoOnboarding.REVERSO;
    case r'ROSTRO':
      return Enum$PasoOnboarding.ROSTRO;
    case r'VIDEO':
      return Enum$PasoOnboarding.VIDEO;
    default:
      return Enum$PasoOnboarding.$unknown;
  }
}

enum Enum$TipoDocumentoOnboarding {
  CC,
  CE,
  $unknown;

  factory Enum$TipoDocumentoOnboarding.fromJson(String value) =>
      fromJson$Enum$TipoDocumentoOnboarding(value);

  String toJson() => toJson$Enum$TipoDocumentoOnboarding(this);
}

String toJson$Enum$TipoDocumentoOnboarding(Enum$TipoDocumentoOnboarding e) {
  switch (e) {
    case Enum$TipoDocumentoOnboarding.CC:
      return r'CC';
    case Enum$TipoDocumentoOnboarding.CE:
      return r'CE';
    case Enum$TipoDocumentoOnboarding.$unknown:
      return r'$unknown';
  }
}

Enum$TipoDocumentoOnboarding fromJson$Enum$TipoDocumentoOnboarding(
  String value,
) {
  switch (value) {
    case r'CC':
      return Enum$TipoDocumentoOnboarding.CC;
    case r'CE':
      return Enum$TipoDocumentoOnboarding.CE;
    default:
      return Enum$TipoDocumentoOnboarding.$unknown;
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
  'ResultadoAceptacion': {'Propuesta', 'ErrorAceptacion'},
  'ResultadoFirma': {'FirmaRegistrada', 'ErrorFirma'},
  'ResultadoEnvioCodigo': {'CodigoEnviado', 'ErrorCodigo'},
  'ResultadoVerificacion': {'Propuesta', 'ErrorCodigo'},
  'ResultadoEmision': {'EnlaceEnviado', 'Propuesta', 'ErrorEmision'},
  'ResultadoInicioPago': {'SesionPago', 'ErrorPago'},
  'ResultadoPago': {'Poliza', 'ErrorPago'},
  'ResultadoSesion': {'Sesion', 'ErrorAutenticacion'},
  'ResultadoUsuario': {'Usuario', 'ErrorUsuario'},
  'ResultadoSubidaArchivo': {'SubidaArchivo', 'ErrorArchivo'},
  'ResultadoArchivo': {'Archivo', 'ErrorArchivo'},
  'ResultadoDescargaArchivo': {'DescargaArchivo', 'ErrorArchivo'},
  'ResultadoInicioOnboarding': {'InicioOnboarding', 'ErrorOnboarding'},
  'ResultadoOnboarding': {'Onboarding', 'ErrorOnboarding'},
  'ResultadoSubidaOnboarding': {'SubidaArchivo', 'ErrorOnboarding'},
  'ResultadoCuentaOnboarding': {'CuentaOnboarding', 'ErrorOnboarding'},
};
