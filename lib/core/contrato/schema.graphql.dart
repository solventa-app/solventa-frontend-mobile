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
    String? tipoDocumento,
    String? pais,
  }) => Input$ConsentimientoInput._({
    r'finalidad': finalidad,
    r'versionTexto': versionTexto,
    if (documentoIdentidad != null) r'documentoIdentidad': documentoIdentidad,
    if (tipoDato != null) r'tipoDato': tipoDato,
    if (fuenteDatos != null) r'fuenteDatos': fuenteDatos,
    if (canal != null) r'canal': canal,
    if (tipoDocumento != null) r'tipoDocumento': tipoDocumento,
    if (pais != null) r'pais': pais,
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
    if (data.containsKey('tipoDocumento')) {
      final l$tipoDocumento = data['tipoDocumento'];
      result$data['tipoDocumento'] = (l$tipoDocumento as String?);
    }
    if (data.containsKey('pais')) {
      final l$pais = data['pais'];
      result$data['pais'] = (l$pais as String?);
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

  String? get tipoDocumento => (_$data['tipoDocumento'] as String?);

  String? get pais => (_$data['pais'] as String?);

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
    if (_$data.containsKey('tipoDocumento')) {
      final l$tipoDocumento = tipoDocumento;
      result$data['tipoDocumento'] = l$tipoDocumento;
    }
    if (_$data.containsKey('pais')) {
      final l$pais = pais;
      result$data['pais'] = l$pais;
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
    final l$tipoDocumento = tipoDocumento;
    final lOther$tipoDocumento = other.tipoDocumento;
    if (_$data.containsKey('tipoDocumento') !=
        other._$data.containsKey('tipoDocumento')) {
      return false;
    }
    if (l$tipoDocumento != lOther$tipoDocumento) {
      return false;
    }
    final l$pais = pais;
    final lOther$pais = other.pais;
    if (_$data.containsKey('pais') != other._$data.containsKey('pais')) {
      return false;
    }
    if (l$pais != lOther$pais) {
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
    final l$tipoDocumento = tipoDocumento;
    final l$pais = pais;
    return Object.hashAll([
      l$finalidad,
      l$versionTexto,
      _$data.containsKey('documentoIdentidad')
          ? l$documentoIdentidad
          : const {},
      _$data.containsKey('tipoDato') ? l$tipoDato : const {},
      _$data.containsKey('fuenteDatos') ? l$fuenteDatos : const {},
      _$data.containsKey('canal') ? l$canal : const {},
      _$data.containsKey('tipoDocumento') ? l$tipoDocumento : const {},
      _$data.containsKey('pais') ? l$pais : const {},
    ]);
  }
}

class Input$SolicitudOfertaAutoInput {
  factory Input$SolicitudOfertaAutoInput({
    required String consentimientoId,
    String? documentoIdentidad,
    String? tipoDocumento,
    String? pais,
    required String placa,
    required int kilometrajeAnual,
    required String ciudadCirculacion,
    Enum$UsoVehiculo? uso,
    Enum$DeducibleAuto? deducible,
  }) => Input$SolicitudOfertaAutoInput._({
    r'consentimientoId': consentimientoId,
    if (documentoIdentidad != null) r'documentoIdentidad': documentoIdentidad,
    if (tipoDocumento != null) r'tipoDocumento': tipoDocumento,
    if (pais != null) r'pais': pais,
    r'placa': placa,
    r'kilometrajeAnual': kilometrajeAnual,
    r'ciudadCirculacion': ciudadCirculacion,
    if (uso != null) r'uso': uso,
    if (deducible != null) r'deducible': deducible,
  });

  Input$SolicitudOfertaAutoInput._(this._$data);

  factory Input$SolicitudOfertaAutoInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$consentimientoId = data['consentimientoId'];
    result$data['consentimientoId'] = (l$consentimientoId as String);
    if (data.containsKey('documentoIdentidad')) {
      final l$documentoIdentidad = data['documentoIdentidad'];
      result$data['documentoIdentidad'] = (l$documentoIdentidad as String?);
    }
    if (data.containsKey('tipoDocumento')) {
      final l$tipoDocumento = data['tipoDocumento'];
      result$data['tipoDocumento'] = (l$tipoDocumento as String?);
    }
    if (data.containsKey('pais')) {
      final l$pais = data['pais'];
      result$data['pais'] = (l$pais as String?);
    }
    final l$placa = data['placa'];
    result$data['placa'] = (l$placa as String);
    final l$kilometrajeAnual = data['kilometrajeAnual'];
    result$data['kilometrajeAnual'] = (l$kilometrajeAnual as int);
    final l$ciudadCirculacion = data['ciudadCirculacion'];
    result$data['ciudadCirculacion'] = (l$ciudadCirculacion as String);
    if (data.containsKey('uso')) {
      final l$uso = data['uso'];
      result$data['uso'] = fromJson$Enum$UsoVehiculo((l$uso as String));
    }
    if (data.containsKey('deducible')) {
      final l$deducible = data['deducible'];
      result$data['deducible'] = fromJson$Enum$DeducibleAuto(
        (l$deducible as String),
      );
    }
    return Input$SolicitudOfertaAutoInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get consentimientoId => (_$data['consentimientoId'] as String);

  String? get documentoIdentidad => (_$data['documentoIdentidad'] as String?);

  String? get tipoDocumento => (_$data['tipoDocumento'] as String?);

  String? get pais => (_$data['pais'] as String?);

  String get placa => (_$data['placa'] as String);

  int get kilometrajeAnual => (_$data['kilometrajeAnual'] as int);

  String get ciudadCirculacion => (_$data['ciudadCirculacion'] as String);

  Enum$UsoVehiculo? get uso => (_$data['uso'] as Enum$UsoVehiculo?);

  Enum$DeducibleAuto? get deducible =>
      (_$data['deducible'] as Enum$DeducibleAuto?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$consentimientoId = consentimientoId;
    result$data['consentimientoId'] = l$consentimientoId;
    if (_$data.containsKey('documentoIdentidad')) {
      final l$documentoIdentidad = documentoIdentidad;
      result$data['documentoIdentidad'] = l$documentoIdentidad;
    }
    if (_$data.containsKey('tipoDocumento')) {
      final l$tipoDocumento = tipoDocumento;
      result$data['tipoDocumento'] = l$tipoDocumento;
    }
    if (_$data.containsKey('pais')) {
      final l$pais = pais;
      result$data['pais'] = l$pais;
    }
    final l$placa = placa;
    result$data['placa'] = l$placa;
    final l$kilometrajeAnual = kilometrajeAnual;
    result$data['kilometrajeAnual'] = l$kilometrajeAnual;
    final l$ciudadCirculacion = ciudadCirculacion;
    result$data['ciudadCirculacion'] = l$ciudadCirculacion;
    if (_$data.containsKey('uso')) {
      final l$uso = uso;
      result$data['uso'] = toJson$Enum$UsoVehiculo((l$uso as Enum$UsoVehiculo));
    }
    if (_$data.containsKey('deducible')) {
      final l$deducible = deducible;
      result$data['deducible'] = toJson$Enum$DeducibleAuto(
        (l$deducible as Enum$DeducibleAuto),
      );
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$SolicitudOfertaAutoInput ||
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
    final l$tipoDocumento = tipoDocumento;
    final lOther$tipoDocumento = other.tipoDocumento;
    if (_$data.containsKey('tipoDocumento') !=
        other._$data.containsKey('tipoDocumento')) {
      return false;
    }
    if (l$tipoDocumento != lOther$tipoDocumento) {
      return false;
    }
    final l$pais = pais;
    final lOther$pais = other.pais;
    if (_$data.containsKey('pais') != other._$data.containsKey('pais')) {
      return false;
    }
    if (l$pais != lOther$pais) {
      return false;
    }
    final l$placa = placa;
    final lOther$placa = other.placa;
    if (l$placa != lOther$placa) {
      return false;
    }
    final l$kilometrajeAnual = kilometrajeAnual;
    final lOther$kilometrajeAnual = other.kilometrajeAnual;
    if (l$kilometrajeAnual != lOther$kilometrajeAnual) {
      return false;
    }
    final l$ciudadCirculacion = ciudadCirculacion;
    final lOther$ciudadCirculacion = other.ciudadCirculacion;
    if (l$ciudadCirculacion != lOther$ciudadCirculacion) {
      return false;
    }
    final l$uso = uso;
    final lOther$uso = other.uso;
    if (_$data.containsKey('uso') != other._$data.containsKey('uso')) {
      return false;
    }
    if (l$uso != lOther$uso) {
      return false;
    }
    final l$deducible = deducible;
    final lOther$deducible = other.deducible;
    if (_$data.containsKey('deducible') !=
        other._$data.containsKey('deducible')) {
      return false;
    }
    if (l$deducible != lOther$deducible) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$consentimientoId = consentimientoId;
    final l$documentoIdentidad = documentoIdentidad;
    final l$tipoDocumento = tipoDocumento;
    final l$pais = pais;
    final l$placa = placa;
    final l$kilometrajeAnual = kilometrajeAnual;
    final l$ciudadCirculacion = ciudadCirculacion;
    final l$uso = uso;
    final l$deducible = deducible;
    return Object.hashAll([
      l$consentimientoId,
      _$data.containsKey('documentoIdentidad')
          ? l$documentoIdentidad
          : const {},
      _$data.containsKey('tipoDocumento') ? l$tipoDocumento : const {},
      _$data.containsKey('pais') ? l$pais : const {},
      l$placa,
      l$kilometrajeAnual,
      l$ciudadCirculacion,
      _$data.containsKey('uso') ? l$uso : const {},
      _$data.containsKey('deducible') ? l$deducible : const {},
    ]);
  }
}

class Input$SolicitudOfertaInput {
  factory Input$SolicitudOfertaInput({
    required String consentimientoId,
    String? documentoIdentidad,
    String? tipoDocumento,
    String? pais,
    String? placeId,
    required String valorCredito,
    required int plazoMeses,
    required String direccionInmueble,
  }) => Input$SolicitudOfertaInput._({
    r'consentimientoId': consentimientoId,
    if (documentoIdentidad != null) r'documentoIdentidad': documentoIdentidad,
    if (tipoDocumento != null) r'tipoDocumento': tipoDocumento,
    if (pais != null) r'pais': pais,
    if (placeId != null) r'placeId': placeId,
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
    if (data.containsKey('tipoDocumento')) {
      final l$tipoDocumento = data['tipoDocumento'];
      result$data['tipoDocumento'] = (l$tipoDocumento as String?);
    }
    if (data.containsKey('pais')) {
      final l$pais = data['pais'];
      result$data['pais'] = (l$pais as String?);
    }
    if (data.containsKey('placeId')) {
      final l$placeId = data['placeId'];
      result$data['placeId'] = (l$placeId as String?);
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

  String? get tipoDocumento => (_$data['tipoDocumento'] as String?);

  String? get pais => (_$data['pais'] as String?);

  String? get placeId => (_$data['placeId'] as String?);

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
    if (_$data.containsKey('tipoDocumento')) {
      final l$tipoDocumento = tipoDocumento;
      result$data['tipoDocumento'] = l$tipoDocumento;
    }
    if (_$data.containsKey('pais')) {
      final l$pais = pais;
      result$data['pais'] = l$pais;
    }
    if (_$data.containsKey('placeId')) {
      final l$placeId = placeId;
      result$data['placeId'] = l$placeId;
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
    final l$tipoDocumento = tipoDocumento;
    final lOther$tipoDocumento = other.tipoDocumento;
    if (_$data.containsKey('tipoDocumento') !=
        other._$data.containsKey('tipoDocumento')) {
      return false;
    }
    if (l$tipoDocumento != lOther$tipoDocumento) {
      return false;
    }
    final l$pais = pais;
    final lOther$pais = other.pais;
    if (_$data.containsKey('pais') != other._$data.containsKey('pais')) {
      return false;
    }
    if (l$pais != lOther$pais) {
      return false;
    }
    final l$placeId = placeId;
    final lOther$placeId = other.placeId;
    if (_$data.containsKey('placeId') != other._$data.containsKey('placeId')) {
      return false;
    }
    if (l$placeId != lOther$placeId) {
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
    final l$tipoDocumento = tipoDocumento;
    final l$pais = pais;
    final l$placeId = placeId;
    final l$valorCredito = valorCredito;
    final l$plazoMeses = plazoMeses;
    final l$direccionInmueble = direccionInmueble;
    return Object.hashAll([
      l$consentimientoId,
      _$data.containsKey('documentoIdentidad')
          ? l$documentoIdentidad
          : const {},
      _$data.containsKey('tipoDocumento') ? l$tipoDocumento : const {},
      _$data.containsKey('pais') ? l$pais : const {},
      _$data.containsKey('placeId') ? l$placeId : const {},
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

class Input$DispositivoPushInput {
  factory Input$DispositivoPushInput({
    required String instalacionId,
    required Enum$PlataformaMovil plataforma,
  }) => Input$DispositivoPushInput._({
    r'instalacionId': instalacionId,
    r'plataforma': plataforma,
  });

  Input$DispositivoPushInput._(this._$data);

  factory Input$DispositivoPushInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$instalacionId = data['instalacionId'];
    result$data['instalacionId'] = (l$instalacionId as String);
    final l$plataforma = data['plataforma'];
    result$data['plataforma'] = fromJson$Enum$PlataformaMovil(
      (l$plataforma as String),
    );
    return Input$DispositivoPushInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get instalacionId => (_$data['instalacionId'] as String);

  Enum$PlataformaMovil get plataforma =>
      (_$data['plataforma'] as Enum$PlataformaMovil);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$instalacionId = instalacionId;
    result$data['instalacionId'] = l$instalacionId;
    final l$plataforma = plataforma;
    result$data['plataforma'] = toJson$Enum$PlataformaMovil(l$plataforma);
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$DispositivoPushInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$instalacionId = instalacionId;
    final lOther$instalacionId = other.instalacionId;
    if (l$instalacionId != lOther$instalacionId) {
      return false;
    }
    final l$plataforma = plataforma;
    final lOther$plataforma = other.plataforma;
    if (l$plataforma != lOther$plataforma) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$instalacionId = instalacionId;
    final l$plataforma = plataforma;
    return Object.hashAll([l$instalacionId, l$plataforma]);
  }
}

class Input$CredencialesInput {
  factory Input$CredencialesInput({
    required String usuario,
    required String clave,
    Enum$RolUsuario? rol,
    Input$DispositivoPushInput? dispositivo,
  }) => Input$CredencialesInput._({
    r'usuario': usuario,
    r'clave': clave,
    if (rol != null) r'rol': rol,
    if (dispositivo != null) r'dispositivo': dispositivo,
  });

  Input$CredencialesInput._(this._$data);

  factory Input$CredencialesInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$usuario = data['usuario'];
    result$data['usuario'] = (l$usuario as String);
    final l$clave = data['clave'];
    result$data['clave'] = (l$clave as String);
    if (data.containsKey('rol')) {
      final l$rol = data['rol'];
      result$data['rol'] = l$rol == null
          ? null
          : fromJson$Enum$RolUsuario((l$rol as String));
    }
    if (data.containsKey('dispositivo')) {
      final l$dispositivo = data['dispositivo'];
      result$data['dispositivo'] = l$dispositivo == null
          ? null
          : Input$DispositivoPushInput.fromJson(
              (l$dispositivo as Map<String, dynamic>),
            );
    }
    return Input$CredencialesInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get usuario => (_$data['usuario'] as String);

  String get clave => (_$data['clave'] as String);

  Enum$RolUsuario? get rol => (_$data['rol'] as Enum$RolUsuario?);

  Input$DispositivoPushInput? get dispositivo =>
      (_$data['dispositivo'] as Input$DispositivoPushInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$usuario = usuario;
    result$data['usuario'] = l$usuario;
    final l$clave = clave;
    result$data['clave'] = l$clave;
    if (_$data.containsKey('rol')) {
      final l$rol = rol;
      result$data['rol'] = l$rol == null ? null : toJson$Enum$RolUsuario(l$rol);
    }
    if (_$data.containsKey('dispositivo')) {
      final l$dispositivo = dispositivo;
      result$data['dispositivo'] = l$dispositivo?.toJson();
    }
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
    final l$rol = rol;
    final lOther$rol = other.rol;
    if (_$data.containsKey('rol') != other._$data.containsKey('rol')) {
      return false;
    }
    if (l$rol != lOther$rol) {
      return false;
    }
    final l$dispositivo = dispositivo;
    final lOther$dispositivo = other.dispositivo;
    if (_$data.containsKey('dispositivo') !=
        other._$data.containsKey('dispositivo')) {
      return false;
    }
    if (l$dispositivo != lOther$dispositivo) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$usuario = usuario;
    final l$clave = clave;
    final l$rol = rol;
    final l$dispositivo = dispositivo;
    return Object.hashAll([
      l$usuario,
      l$clave,
      _$data.containsKey('rol') ? l$rol : const {},
      _$data.containsKey('dispositivo') ? l$dispositivo : const {},
    ]);
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
    String? tipoDocumento,
    String? pais,
  }) => Input$CrearUsuarioInput._({
    r'usuario': usuario,
    r'clave': clave,
    r'rol': rol,
    if (nombre != null) r'nombre': nombre,
    if (correo != null) r'correo': correo,
    if (telefono != null) r'telefono': telefono,
    if (documentoIdentidad != null) r'documentoIdentidad': documentoIdentidad,
    if (tipoDocumento != null) r'tipoDocumento': tipoDocumento,
    if (pais != null) r'pais': pais,
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
    if (data.containsKey('tipoDocumento')) {
      final l$tipoDocumento = data['tipoDocumento'];
      result$data['tipoDocumento'] = (l$tipoDocumento as String?);
    }
    if (data.containsKey('pais')) {
      final l$pais = data['pais'];
      result$data['pais'] = (l$pais as String?);
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

  String? get tipoDocumento => (_$data['tipoDocumento'] as String?);

  String? get pais => (_$data['pais'] as String?);

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
    if (_$data.containsKey('tipoDocumento')) {
      final l$tipoDocumento = tipoDocumento;
      result$data['tipoDocumento'] = l$tipoDocumento;
    }
    if (_$data.containsKey('pais')) {
      final l$pais = pais;
      result$data['pais'] = l$pais;
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
    final l$tipoDocumento = tipoDocumento;
    final lOther$tipoDocumento = other.tipoDocumento;
    if (_$data.containsKey('tipoDocumento') !=
        other._$data.containsKey('tipoDocumento')) {
      return false;
    }
    if (l$tipoDocumento != lOther$tipoDocumento) {
      return false;
    }
    final l$pais = pais;
    final lOther$pais = other.pais;
    if (_$data.containsKey('pais') != other._$data.containsKey('pais')) {
      return false;
    }
    if (l$pais != lOther$pais) {
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
    final l$tipoDocumento = tipoDocumento;
    final l$pais = pais;
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
      _$data.containsKey('tipoDocumento') ? l$tipoDocumento : const {},
      _$data.containsKey('pais') ? l$pais : const {},
    ]);
  }
}

class Input$PreferenciasInput {
  factory Input$PreferenciasInput({
    required String idioma,
    required String moneda,
    String? pais,
  }) => Input$PreferenciasInput._({
    r'idioma': idioma,
    r'moneda': moneda,
    if (pais != null) r'pais': pais,
  });

  Input$PreferenciasInput._(this._$data);

  factory Input$PreferenciasInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$idioma = data['idioma'];
    result$data['idioma'] = (l$idioma as String);
    final l$moneda = data['moneda'];
    result$data['moneda'] = (l$moneda as String);
    if (data.containsKey('pais')) {
      final l$pais = data['pais'];
      result$data['pais'] = (l$pais as String?);
    }
    return Input$PreferenciasInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get idioma => (_$data['idioma'] as String);

  String get moneda => (_$data['moneda'] as String);

  String? get pais => (_$data['pais'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$idioma = idioma;
    result$data['idioma'] = l$idioma;
    final l$moneda = moneda;
    result$data['moneda'] = l$moneda;
    if (_$data.containsKey('pais')) {
      final l$pais = pais;
      result$data['pais'] = l$pais;
    }
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
    final l$pais = pais;
    final lOther$pais = other.pais;
    if (_$data.containsKey('pais') != other._$data.containsKey('pais')) {
      return false;
    }
    if (l$pais != lOther$pais) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$idioma = idioma;
    final l$moneda = moneda;
    final l$pais = pais;
    return Object.hashAll([
      l$idioma,
      l$moneda,
      _$data.containsKey('pais') ? l$pais : const {},
    ]);
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

class Input$UbicacionReporteInput {
  factory Input$UbicacionReporteInput({
    required String descripcion,
    required String ciudad,
    required double latitud,
    required double longitud,
  }) => Input$UbicacionReporteInput._({
    r'descripcion': descripcion,
    r'ciudad': ciudad,
    r'latitud': latitud,
    r'longitud': longitud,
  });

  Input$UbicacionReporteInput._(this._$data);

  factory Input$UbicacionReporteInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$descripcion = data['descripcion'];
    result$data['descripcion'] = (l$descripcion as String);
    final l$ciudad = data['ciudad'];
    result$data['ciudad'] = (l$ciudad as String);
    final l$latitud = data['latitud'];
    result$data['latitud'] = (l$latitud as num).toDouble();
    final l$longitud = data['longitud'];
    result$data['longitud'] = (l$longitud as num).toDouble();
    return Input$UbicacionReporteInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get descripcion => (_$data['descripcion'] as String);

  String get ciudad => (_$data['ciudad'] as String);

  double get latitud => (_$data['latitud'] as double);

  double get longitud => (_$data['longitud'] as double);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$descripcion = descripcion;
    result$data['descripcion'] = l$descripcion;
    final l$ciudad = ciudad;
    result$data['ciudad'] = l$ciudad;
    final l$latitud = latitud;
    result$data['latitud'] = l$latitud;
    final l$longitud = longitud;
    result$data['longitud'] = l$longitud;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UbicacionReporteInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$descripcion = descripcion;
    final lOther$descripcion = other.descripcion;
    if (l$descripcion != lOther$descripcion) {
      return false;
    }
    final l$ciudad = ciudad;
    final lOther$ciudad = other.ciudad;
    if (l$ciudad != lOther$ciudad) {
      return false;
    }
    final l$latitud = latitud;
    final lOther$latitud = other.latitud;
    if (l$latitud != lOther$latitud) {
      return false;
    }
    final l$longitud = longitud;
    final lOther$longitud = other.longitud;
    if (l$longitud != lOther$longitud) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$descripcion = descripcion;
    final l$ciudad = ciudad;
    final l$latitud = latitud;
    final l$longitud = longitud;
    return Object.hashAll([l$descripcion, l$ciudad, l$latitud, l$longitud]);
  }
}

class Input$FotoReporteInput {
  factory Input$FotoReporteInput({
    required String archivoId,
    required DateTime tomadaEn,
    double? latitud,
    double? longitud,
  }) => Input$FotoReporteInput._({
    r'archivoId': archivoId,
    r'tomadaEn': tomadaEn,
    if (latitud != null) r'latitud': latitud,
    if (longitud != null) r'longitud': longitud,
  });

  Input$FotoReporteInput._(this._$data);

  factory Input$FotoReporteInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$archivoId = data['archivoId'];
    result$data['archivoId'] = (l$archivoId as String);
    final l$tomadaEn = data['tomadaEn'];
    result$data['tomadaEn'] = DateTime.parse((l$tomadaEn as String));
    if (data.containsKey('latitud')) {
      final l$latitud = data['latitud'];
      result$data['latitud'] = (l$latitud as num?)?.toDouble();
    }
    if (data.containsKey('longitud')) {
      final l$longitud = data['longitud'];
      result$data['longitud'] = (l$longitud as num?)?.toDouble();
    }
    return Input$FotoReporteInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get archivoId => (_$data['archivoId'] as String);

  DateTime get tomadaEn => (_$data['tomadaEn'] as DateTime);

  double? get latitud => (_$data['latitud'] as double?);

  double? get longitud => (_$data['longitud'] as double?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$archivoId = archivoId;
    result$data['archivoId'] = l$archivoId;
    final l$tomadaEn = tomadaEn;
    result$data['tomadaEn'] = l$tomadaEn.toIso8601String();
    if (_$data.containsKey('latitud')) {
      final l$latitud = latitud;
      result$data['latitud'] = l$latitud;
    }
    if (_$data.containsKey('longitud')) {
      final l$longitud = longitud;
      result$data['longitud'] = l$longitud;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$FotoReporteInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$archivoId = archivoId;
    final lOther$archivoId = other.archivoId;
    if (l$archivoId != lOther$archivoId) {
      return false;
    }
    final l$tomadaEn = tomadaEn;
    final lOther$tomadaEn = other.tomadaEn;
    if (l$tomadaEn != lOther$tomadaEn) {
      return false;
    }
    final l$latitud = latitud;
    final lOther$latitud = other.latitud;
    if (_$data.containsKey('latitud') != other._$data.containsKey('latitud')) {
      return false;
    }
    if (l$latitud != lOther$latitud) {
      return false;
    }
    final l$longitud = longitud;
    final lOther$longitud = other.longitud;
    if (_$data.containsKey('longitud') !=
        other._$data.containsKey('longitud')) {
      return false;
    }
    if (l$longitud != lOther$longitud) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$archivoId = archivoId;
    final l$tomadaEn = tomadaEn;
    final l$latitud = latitud;
    final l$longitud = longitud;
    return Object.hashAll([
      l$archivoId,
      l$tomadaEn,
      _$data.containsKey('latitud') ? l$latitud : const {},
      _$data.containsKey('longitud') ? l$longitud : const {},
    ]);
  }
}

class Input$ReporteSiniestroInput {
  factory Input$ReporteSiniestroInput({
    required String idReporte,
    required String polizaId,
    Enum$TipoSiniestroAuto? tipoSiniestroAuto,
    required DateTime ocurridoEn,
    required String descripcion,
    required Input$UbicacionReporteInput ubicacion,
    required List<Input$FotoReporteInput> fotos,
  }) => Input$ReporteSiniestroInput._({
    r'idReporte': idReporte,
    r'polizaId': polizaId,
    if (tipoSiniestroAuto != null) r'tipoSiniestroAuto': tipoSiniestroAuto,
    r'ocurridoEn': ocurridoEn,
    r'descripcion': descripcion,
    r'ubicacion': ubicacion,
    r'fotos': fotos,
  });

  Input$ReporteSiniestroInput._(this._$data);

  factory Input$ReporteSiniestroInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$idReporte = data['idReporte'];
    result$data['idReporte'] = (l$idReporte as String);
    final l$polizaId = data['polizaId'];
    result$data['polizaId'] = (l$polizaId as String);
    if (data.containsKey('tipoSiniestroAuto')) {
      final l$tipoSiniestroAuto = data['tipoSiniestroAuto'];
      result$data['tipoSiniestroAuto'] = l$tipoSiniestroAuto == null
          ? null
          : fromJson$Enum$TipoSiniestroAuto((l$tipoSiniestroAuto as String));
    }
    final l$ocurridoEn = data['ocurridoEn'];
    result$data['ocurridoEn'] = DateTime.parse((l$ocurridoEn as String));
    final l$descripcion = data['descripcion'];
    result$data['descripcion'] = (l$descripcion as String);
    final l$ubicacion = data['ubicacion'];
    result$data['ubicacion'] = Input$UbicacionReporteInput.fromJson(
      (l$ubicacion as Map<String, dynamic>),
    );
    final l$fotos = data['fotos'];
    result$data['fotos'] = (l$fotos as List<dynamic>)
        .map(
          (e) => Input$FotoReporteInput.fromJson((e as Map<String, dynamic>)),
        )
        .toList();
    return Input$ReporteSiniestroInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get idReporte => (_$data['idReporte'] as String);

  String get polizaId => (_$data['polizaId'] as String);

  Enum$TipoSiniestroAuto? get tipoSiniestroAuto =>
      (_$data['tipoSiniestroAuto'] as Enum$TipoSiniestroAuto?);

  DateTime get ocurridoEn => (_$data['ocurridoEn'] as DateTime);

  String get descripcion => (_$data['descripcion'] as String);

  Input$UbicacionReporteInput get ubicacion =>
      (_$data['ubicacion'] as Input$UbicacionReporteInput);

  List<Input$FotoReporteInput> get fotos =>
      (_$data['fotos'] as List<Input$FotoReporteInput>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$idReporte = idReporte;
    result$data['idReporte'] = l$idReporte;
    final l$polizaId = polizaId;
    result$data['polizaId'] = l$polizaId;
    if (_$data.containsKey('tipoSiniestroAuto')) {
      final l$tipoSiniestroAuto = tipoSiniestroAuto;
      result$data['tipoSiniestroAuto'] = l$tipoSiniestroAuto == null
          ? null
          : toJson$Enum$TipoSiniestroAuto(l$tipoSiniestroAuto);
    }
    final l$ocurridoEn = ocurridoEn;
    result$data['ocurridoEn'] = l$ocurridoEn.toIso8601String();
    final l$descripcion = descripcion;
    result$data['descripcion'] = l$descripcion;
    final l$ubicacion = ubicacion;
    result$data['ubicacion'] = l$ubicacion.toJson();
    final l$fotos = fotos;
    result$data['fotos'] = l$fotos.map((e) => e.toJson()).toList();
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$ReporteSiniestroInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$idReporte = idReporte;
    final lOther$idReporte = other.idReporte;
    if (l$idReporte != lOther$idReporte) {
      return false;
    }
    final l$polizaId = polizaId;
    final lOther$polizaId = other.polizaId;
    if (l$polizaId != lOther$polizaId) {
      return false;
    }
    final l$tipoSiniestroAuto = tipoSiniestroAuto;
    final lOther$tipoSiniestroAuto = other.tipoSiniestroAuto;
    if (_$data.containsKey('tipoSiniestroAuto') !=
        other._$data.containsKey('tipoSiniestroAuto')) {
      return false;
    }
    if (l$tipoSiniestroAuto != lOther$tipoSiniestroAuto) {
      return false;
    }
    final l$ocurridoEn = ocurridoEn;
    final lOther$ocurridoEn = other.ocurridoEn;
    if (l$ocurridoEn != lOther$ocurridoEn) {
      return false;
    }
    final l$descripcion = descripcion;
    final lOther$descripcion = other.descripcion;
    if (l$descripcion != lOther$descripcion) {
      return false;
    }
    final l$ubicacion = ubicacion;
    final lOther$ubicacion = other.ubicacion;
    if (l$ubicacion != lOther$ubicacion) {
      return false;
    }
    final l$fotos = fotos;
    final lOther$fotos = other.fotos;
    if (l$fotos.length != lOther$fotos.length) {
      return false;
    }
    for (int i = 0; i < l$fotos.length; i++) {
      final l$fotos$entry = l$fotos[i];
      final lOther$fotos$entry = lOther$fotos[i];
      if (l$fotos$entry != lOther$fotos$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$idReporte = idReporte;
    final l$polizaId = polizaId;
    final l$tipoSiniestroAuto = tipoSiniestroAuto;
    final l$ocurridoEn = ocurridoEn;
    final l$descripcion = descripcion;
    final l$ubicacion = ubicacion;
    final l$fotos = fotos;
    return Object.hashAll([
      l$idReporte,
      l$polizaId,
      _$data.containsKey('tipoSiniestroAuto') ? l$tipoSiniestroAuto : const {},
      l$ocurridoEn,
      l$descripcion,
      l$ubicacion,
      Object.hashAll(l$fotos.map((v) => v)),
    ]);
  }
}

class Input$SolicitudAsistenciaInput {
  factory Input$SolicitudAsistenciaInput({
    required String idSolicitud,
    required String prestadorId,
    required Enum$TipoPrestador tipoAsistencia,
    String? descripcion,
    String? direccion,
    required double latitud,
    required double longitud,
  }) => Input$SolicitudAsistenciaInput._({
    r'idSolicitud': idSolicitud,
    r'prestadorId': prestadorId,
    r'tipoAsistencia': tipoAsistencia,
    if (descripcion != null) r'descripcion': descripcion,
    if (direccion != null) r'direccion': direccion,
    r'latitud': latitud,
    r'longitud': longitud,
  });

  Input$SolicitudAsistenciaInput._(this._$data);

  factory Input$SolicitudAsistenciaInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$idSolicitud = data['idSolicitud'];
    result$data['idSolicitud'] = (l$idSolicitud as String);
    final l$prestadorId = data['prestadorId'];
    result$data['prestadorId'] = (l$prestadorId as String);
    final l$tipoAsistencia = data['tipoAsistencia'];
    result$data['tipoAsistencia'] = fromJson$Enum$TipoPrestador(
      (l$tipoAsistencia as String),
    );
    if (data.containsKey('descripcion')) {
      final l$descripcion = data['descripcion'];
      result$data['descripcion'] = (l$descripcion as String?);
    }
    if (data.containsKey('direccion')) {
      final l$direccion = data['direccion'];
      result$data['direccion'] = (l$direccion as String?);
    }
    final l$latitud = data['latitud'];
    result$data['latitud'] = (l$latitud as num).toDouble();
    final l$longitud = data['longitud'];
    result$data['longitud'] = (l$longitud as num).toDouble();
    return Input$SolicitudAsistenciaInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get idSolicitud => (_$data['idSolicitud'] as String);

  String get prestadorId => (_$data['prestadorId'] as String);

  Enum$TipoPrestador get tipoAsistencia =>
      (_$data['tipoAsistencia'] as Enum$TipoPrestador);

  String? get descripcion => (_$data['descripcion'] as String?);

  String? get direccion => (_$data['direccion'] as String?);

  double get latitud => (_$data['latitud'] as double);

  double get longitud => (_$data['longitud'] as double);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$idSolicitud = idSolicitud;
    result$data['idSolicitud'] = l$idSolicitud;
    final l$prestadorId = prestadorId;
    result$data['prestadorId'] = l$prestadorId;
    final l$tipoAsistencia = tipoAsistencia;
    result$data['tipoAsistencia'] = toJson$Enum$TipoPrestador(l$tipoAsistencia);
    if (_$data.containsKey('descripcion')) {
      final l$descripcion = descripcion;
      result$data['descripcion'] = l$descripcion;
    }
    if (_$data.containsKey('direccion')) {
      final l$direccion = direccion;
      result$data['direccion'] = l$direccion;
    }
    final l$latitud = latitud;
    result$data['latitud'] = l$latitud;
    final l$longitud = longitud;
    result$data['longitud'] = l$longitud;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$SolicitudAsistenciaInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$idSolicitud = idSolicitud;
    final lOther$idSolicitud = other.idSolicitud;
    if (l$idSolicitud != lOther$idSolicitud) {
      return false;
    }
    final l$prestadorId = prestadorId;
    final lOther$prestadorId = other.prestadorId;
    if (l$prestadorId != lOther$prestadorId) {
      return false;
    }
    final l$tipoAsistencia = tipoAsistencia;
    final lOther$tipoAsistencia = other.tipoAsistencia;
    if (l$tipoAsistencia != lOther$tipoAsistencia) {
      return false;
    }
    final l$descripcion = descripcion;
    final lOther$descripcion = other.descripcion;
    if (_$data.containsKey('descripcion') !=
        other._$data.containsKey('descripcion')) {
      return false;
    }
    if (l$descripcion != lOther$descripcion) {
      return false;
    }
    final l$direccion = direccion;
    final lOther$direccion = other.direccion;
    if (_$data.containsKey('direccion') !=
        other._$data.containsKey('direccion')) {
      return false;
    }
    if (l$direccion != lOther$direccion) {
      return false;
    }
    final l$latitud = latitud;
    final lOther$latitud = other.latitud;
    if (l$latitud != lOther$latitud) {
      return false;
    }
    final l$longitud = longitud;
    final lOther$longitud = other.longitud;
    if (l$longitud != lOther$longitud) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$idSolicitud = idSolicitud;
    final l$prestadorId = prestadorId;
    final l$tipoAsistencia = tipoAsistencia;
    final l$descripcion = descripcion;
    final l$direccion = direccion;
    final l$latitud = latitud;
    final l$longitud = longitud;
    return Object.hashAll([
      l$idSolicitud,
      l$prestadorId,
      l$tipoAsistencia,
      _$data.containsKey('descripcion') ? l$descripcion : const {},
      _$data.containsKey('direccion') ? l$direccion : const {},
      l$latitud,
      l$longitud,
    ]);
  }
}

class Input$SolicitudAsistenciaDireccionInput {
  factory Input$SolicitudAsistenciaDireccionInput({
    required String idSolicitud,
    required String prestadorId,
    required Enum$TipoPrestador tipoAsistencia,
    required String direccion,
    String? descripcion,
  }) => Input$SolicitudAsistenciaDireccionInput._({
    r'idSolicitud': idSolicitud,
    r'prestadorId': prestadorId,
    r'tipoAsistencia': tipoAsistencia,
    r'direccion': direccion,
    if (descripcion != null) r'descripcion': descripcion,
  });

  Input$SolicitudAsistenciaDireccionInput._(this._$data);

  factory Input$SolicitudAsistenciaDireccionInput.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$idSolicitud = data['idSolicitud'];
    result$data['idSolicitud'] = (l$idSolicitud as String);
    final l$prestadorId = data['prestadorId'];
    result$data['prestadorId'] = (l$prestadorId as String);
    final l$tipoAsistencia = data['tipoAsistencia'];
    result$data['tipoAsistencia'] = fromJson$Enum$TipoPrestador(
      (l$tipoAsistencia as String),
    );
    final l$direccion = data['direccion'];
    result$data['direccion'] = (l$direccion as String);
    if (data.containsKey('descripcion')) {
      final l$descripcion = data['descripcion'];
      result$data['descripcion'] = (l$descripcion as String?);
    }
    return Input$SolicitudAsistenciaDireccionInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get idSolicitud => (_$data['idSolicitud'] as String);

  String get prestadorId => (_$data['prestadorId'] as String);

  Enum$TipoPrestador get tipoAsistencia =>
      (_$data['tipoAsistencia'] as Enum$TipoPrestador);

  String get direccion => (_$data['direccion'] as String);

  String? get descripcion => (_$data['descripcion'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$idSolicitud = idSolicitud;
    result$data['idSolicitud'] = l$idSolicitud;
    final l$prestadorId = prestadorId;
    result$data['prestadorId'] = l$prestadorId;
    final l$tipoAsistencia = tipoAsistencia;
    result$data['tipoAsistencia'] = toJson$Enum$TipoPrestador(l$tipoAsistencia);
    final l$direccion = direccion;
    result$data['direccion'] = l$direccion;
    if (_$data.containsKey('descripcion')) {
      final l$descripcion = descripcion;
      result$data['descripcion'] = l$descripcion;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$SolicitudAsistenciaDireccionInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$idSolicitud = idSolicitud;
    final lOther$idSolicitud = other.idSolicitud;
    if (l$idSolicitud != lOther$idSolicitud) {
      return false;
    }
    final l$prestadorId = prestadorId;
    final lOther$prestadorId = other.prestadorId;
    if (l$prestadorId != lOther$prestadorId) {
      return false;
    }
    final l$tipoAsistencia = tipoAsistencia;
    final lOther$tipoAsistencia = other.tipoAsistencia;
    if (l$tipoAsistencia != lOther$tipoAsistencia) {
      return false;
    }
    final l$direccion = direccion;
    final lOther$direccion = other.direccion;
    if (l$direccion != lOther$direccion) {
      return false;
    }
    final l$descripcion = descripcion;
    final lOther$descripcion = other.descripcion;
    if (_$data.containsKey('descripcion') !=
        other._$data.containsKey('descripcion')) {
      return false;
    }
    if (l$descripcion != lOther$descripcion) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$idSolicitud = idSolicitud;
    final l$prestadorId = prestadorId;
    final l$tipoAsistencia = tipoAsistencia;
    final l$direccion = direccion;
    final l$descripcion = descripcion;
    return Object.hashAll([
      l$idSolicitud,
      l$prestadorId,
      l$tipoAsistencia,
      l$direccion,
      _$data.containsKey('descripcion') ? l$descripcion : const {},
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
  VEHICULO_NO_ENCONTRADO,
  VEHICULO_NO_ASEGURABLE,
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
    case Enum$MotivoErrorOferta.VEHICULO_NO_ENCONTRADO:
      return r'VEHICULO_NO_ENCONTRADO';
    case Enum$MotivoErrorOferta.VEHICULO_NO_ASEGURABLE:
      return r'VEHICULO_NO_ASEGURABLE';
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
    case r'VEHICULO_NO_ENCONTRADO':
      return Enum$MotivoErrorOferta.VEHICULO_NO_ENCONTRADO;
    case r'VEHICULO_NO_ASEGURABLE':
      return Enum$MotivoErrorOferta.VEHICULO_NO_ASEGURABLE;
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

enum Enum$Producto {
  VIDA_DEUDOR,
  AUTO,
  $unknown;

  factory Enum$Producto.fromJson(String value) => fromJson$Enum$Producto(value);

  String toJson() => toJson$Enum$Producto(this);
}

String toJson$Enum$Producto(Enum$Producto e) {
  switch (e) {
    case Enum$Producto.VIDA_DEUDOR:
      return r'VIDA_DEUDOR';
    case Enum$Producto.AUTO:
      return r'AUTO';
    case Enum$Producto.$unknown:
      return r'$unknown';
  }
}

Enum$Producto fromJson$Enum$Producto(String value) {
  switch (value) {
    case r'VIDA_DEUDOR':
      return Enum$Producto.VIDA_DEUDOR;
    case r'AUTO':
      return Enum$Producto.AUTO;
    default:
      return Enum$Producto.$unknown;
  }
}

enum Enum$UsoVehiculo {
  PARTICULAR,
  COMERCIAL,
  $unknown;

  factory Enum$UsoVehiculo.fromJson(String value) =>
      fromJson$Enum$UsoVehiculo(value);

  String toJson() => toJson$Enum$UsoVehiculo(this);
}

String toJson$Enum$UsoVehiculo(Enum$UsoVehiculo e) {
  switch (e) {
    case Enum$UsoVehiculo.PARTICULAR:
      return r'PARTICULAR';
    case Enum$UsoVehiculo.COMERCIAL:
      return r'COMERCIAL';
    case Enum$UsoVehiculo.$unknown:
      return r'$unknown';
  }
}

Enum$UsoVehiculo fromJson$Enum$UsoVehiculo(String value) {
  switch (value) {
    case r'PARTICULAR':
      return Enum$UsoVehiculo.PARTICULAR;
    case r'COMERCIAL':
      return Enum$UsoVehiculo.COMERCIAL;
    default:
      return Enum$UsoVehiculo.$unknown;
  }
}

enum Enum$DeducibleAuto {
  DIEZ_POR_CIENTO,
  SIN_DEDUCIBLE,
  $unknown;

  factory Enum$DeducibleAuto.fromJson(String value) =>
      fromJson$Enum$DeducibleAuto(value);

  String toJson() => toJson$Enum$DeducibleAuto(this);
}

String toJson$Enum$DeducibleAuto(Enum$DeducibleAuto e) {
  switch (e) {
    case Enum$DeducibleAuto.DIEZ_POR_CIENTO:
      return r'DIEZ_POR_CIENTO';
    case Enum$DeducibleAuto.SIN_DEDUCIBLE:
      return r'SIN_DEDUCIBLE';
    case Enum$DeducibleAuto.$unknown:
      return r'$unknown';
  }
}

Enum$DeducibleAuto fromJson$Enum$DeducibleAuto(String value) {
  switch (value) {
    case r'DIEZ_POR_CIENTO':
      return Enum$DeducibleAuto.DIEZ_POR_CIENTO;
    case r'SIN_DEDUCIBLE':
      return Enum$DeducibleAuto.SIN_DEDUCIBLE;
    default:
      return Enum$DeducibleAuto.$unknown;
  }
}

enum Enum$TipoCobertura {
  RESPONSABILIDAD_CIVIL,
  PERDIDA_TOTAL_DANOS,
  PERDIDA_PARCIAL_DANOS,
  PERDIDA_TOTAL_HURTO,
  PERDIDA_PARCIAL_HURTO,
  ASISTENCIA,
  $unknown;

  factory Enum$TipoCobertura.fromJson(String value) =>
      fromJson$Enum$TipoCobertura(value);

  String toJson() => toJson$Enum$TipoCobertura(this);
}

String toJson$Enum$TipoCobertura(Enum$TipoCobertura e) {
  switch (e) {
    case Enum$TipoCobertura.RESPONSABILIDAD_CIVIL:
      return r'RESPONSABILIDAD_CIVIL';
    case Enum$TipoCobertura.PERDIDA_TOTAL_DANOS:
      return r'PERDIDA_TOTAL_DANOS';
    case Enum$TipoCobertura.PERDIDA_PARCIAL_DANOS:
      return r'PERDIDA_PARCIAL_DANOS';
    case Enum$TipoCobertura.PERDIDA_TOTAL_HURTO:
      return r'PERDIDA_TOTAL_HURTO';
    case Enum$TipoCobertura.PERDIDA_PARCIAL_HURTO:
      return r'PERDIDA_PARCIAL_HURTO';
    case Enum$TipoCobertura.ASISTENCIA:
      return r'ASISTENCIA';
    case Enum$TipoCobertura.$unknown:
      return r'$unknown';
  }
}

Enum$TipoCobertura fromJson$Enum$TipoCobertura(String value) {
  switch (value) {
    case r'RESPONSABILIDAD_CIVIL':
      return Enum$TipoCobertura.RESPONSABILIDAD_CIVIL;
    case r'PERDIDA_TOTAL_DANOS':
      return Enum$TipoCobertura.PERDIDA_TOTAL_DANOS;
    case r'PERDIDA_PARCIAL_DANOS':
      return Enum$TipoCobertura.PERDIDA_PARCIAL_DANOS;
    case r'PERDIDA_TOTAL_HURTO':
      return Enum$TipoCobertura.PERDIDA_TOTAL_HURTO;
    case r'PERDIDA_PARCIAL_HURTO':
      return Enum$TipoCobertura.PERDIDA_PARCIAL_HURTO;
    case r'ASISTENCIA':
      return Enum$TipoCobertura.ASISTENCIA;
    default:
      return Enum$TipoCobertura.$unknown;
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

enum Enum$PlataformaMovil {
  ANDROID,
  IOS,
  $unknown;

  factory Enum$PlataformaMovil.fromJson(String value) =>
      fromJson$Enum$PlataformaMovil(value);

  String toJson() => toJson$Enum$PlataformaMovil(this);
}

String toJson$Enum$PlataformaMovil(Enum$PlataformaMovil e) {
  switch (e) {
    case Enum$PlataformaMovil.ANDROID:
      return r'ANDROID';
    case Enum$PlataformaMovil.IOS:
      return r'IOS';
    case Enum$PlataformaMovil.$unknown:
      return r'$unknown';
  }
}

Enum$PlataformaMovil fromJson$Enum$PlataformaMovil(String value) {
  switch (value) {
    case r'ANDROID':
      return Enum$PlataformaMovil.ANDROID;
    case r'IOS':
      return Enum$PlataformaMovil.IOS;
    default:
      return Enum$PlataformaMovil.$unknown;
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

enum Enum$EstadoSiniestro {
  PENDIENTE,
  EN_REVISION,
  APROBADO,
  RECHAZADO,
  $unknown;

  factory Enum$EstadoSiniestro.fromJson(String value) =>
      fromJson$Enum$EstadoSiniestro(value);

  String toJson() => toJson$Enum$EstadoSiniestro(this);
}

String toJson$Enum$EstadoSiniestro(Enum$EstadoSiniestro e) {
  switch (e) {
    case Enum$EstadoSiniestro.PENDIENTE:
      return r'PENDIENTE';
    case Enum$EstadoSiniestro.EN_REVISION:
      return r'EN_REVISION';
    case Enum$EstadoSiniestro.APROBADO:
      return r'APROBADO';
    case Enum$EstadoSiniestro.RECHAZADO:
      return r'RECHAZADO';
    case Enum$EstadoSiniestro.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoSiniestro fromJson$Enum$EstadoSiniestro(String value) {
  switch (value) {
    case r'PENDIENTE':
      return Enum$EstadoSiniestro.PENDIENTE;
    case r'EN_REVISION':
      return Enum$EstadoSiniestro.EN_REVISION;
    case r'APROBADO':
      return Enum$EstadoSiniestro.APROBADO;
    case r'RECHAZADO':
      return Enum$EstadoSiniestro.RECHAZADO;
    default:
      return Enum$EstadoSiniestro.$unknown;
  }
}

enum Enum$TipoEvidencia {
  FOTO,
  DOCUMENTO,
  $unknown;

  factory Enum$TipoEvidencia.fromJson(String value) =>
      fromJson$Enum$TipoEvidencia(value);

  String toJson() => toJson$Enum$TipoEvidencia(this);
}

String toJson$Enum$TipoEvidencia(Enum$TipoEvidencia e) {
  switch (e) {
    case Enum$TipoEvidencia.FOTO:
      return r'FOTO';
    case Enum$TipoEvidencia.DOCUMENTO:
      return r'DOCUMENTO';
    case Enum$TipoEvidencia.$unknown:
      return r'$unknown';
  }
}

Enum$TipoEvidencia fromJson$Enum$TipoEvidencia(String value) {
  switch (value) {
    case r'FOTO':
      return Enum$TipoEvidencia.FOTO;
    case r'DOCUMENTO':
      return Enum$TipoEvidencia.DOCUMENTO;
    default:
      return Enum$TipoEvidencia.$unknown;
  }
}

enum Enum$TipoResolucion {
  APROBACION,
  RECHAZO,
  DERIVACION,
  $unknown;

  factory Enum$TipoResolucion.fromJson(String value) =>
      fromJson$Enum$TipoResolucion(value);

  String toJson() => toJson$Enum$TipoResolucion(this);
}

String toJson$Enum$TipoResolucion(Enum$TipoResolucion e) {
  switch (e) {
    case Enum$TipoResolucion.APROBACION:
      return r'APROBACION';
    case Enum$TipoResolucion.RECHAZO:
      return r'RECHAZO';
    case Enum$TipoResolucion.DERIVACION:
      return r'DERIVACION';
    case Enum$TipoResolucion.$unknown:
      return r'$unknown';
  }
}

Enum$TipoResolucion fromJson$Enum$TipoResolucion(String value) {
  switch (value) {
    case r'APROBACION':
      return Enum$TipoResolucion.APROBACION;
    case r'RECHAZO':
      return Enum$TipoResolucion.RECHAZO;
    case r'DERIVACION':
      return Enum$TipoResolucion.DERIVACION;
    default:
      return Enum$TipoResolucion.$unknown;
  }
}

enum Enum$MotivoRechazo {
  EVIDENCIA_INSUFICIENTE,
  FUERA_DE_COBERTURA,
  POLIZA_NO_VIGENTE,
  INCONSISTENCIA_EN_RELATO,
  OTRO,
  $unknown;

  factory Enum$MotivoRechazo.fromJson(String value) =>
      fromJson$Enum$MotivoRechazo(value);

  String toJson() => toJson$Enum$MotivoRechazo(this);
}

String toJson$Enum$MotivoRechazo(Enum$MotivoRechazo e) {
  switch (e) {
    case Enum$MotivoRechazo.EVIDENCIA_INSUFICIENTE:
      return r'EVIDENCIA_INSUFICIENTE';
    case Enum$MotivoRechazo.FUERA_DE_COBERTURA:
      return r'FUERA_DE_COBERTURA';
    case Enum$MotivoRechazo.POLIZA_NO_VIGENTE:
      return r'POLIZA_NO_VIGENTE';
    case Enum$MotivoRechazo.INCONSISTENCIA_EN_RELATO:
      return r'INCONSISTENCIA_EN_RELATO';
    case Enum$MotivoRechazo.OTRO:
      return r'OTRO';
    case Enum$MotivoRechazo.$unknown:
      return r'$unknown';
  }
}

Enum$MotivoRechazo fromJson$Enum$MotivoRechazo(String value) {
  switch (value) {
    case r'EVIDENCIA_INSUFICIENTE':
      return Enum$MotivoRechazo.EVIDENCIA_INSUFICIENTE;
    case r'FUERA_DE_COBERTURA':
      return Enum$MotivoRechazo.FUERA_DE_COBERTURA;
    case r'POLIZA_NO_VIGENTE':
      return Enum$MotivoRechazo.POLIZA_NO_VIGENTE;
    case r'INCONSISTENCIA_EN_RELATO':
      return Enum$MotivoRechazo.INCONSISTENCIA_EN_RELATO;
    case r'OTRO':
      return Enum$MotivoRechazo.OTRO;
    default:
      return Enum$MotivoRechazo.$unknown;
  }
}

enum Enum$TipoEventoParametrico {
  VUELO_RETRASO,
  VUELO_CANCELADO,
  CLIMA,
  $unknown;

  factory Enum$TipoEventoParametrico.fromJson(String value) =>
      fromJson$Enum$TipoEventoParametrico(value);

  String toJson() => toJson$Enum$TipoEventoParametrico(this);
}

String toJson$Enum$TipoEventoParametrico(Enum$TipoEventoParametrico e) {
  switch (e) {
    case Enum$TipoEventoParametrico.VUELO_RETRASO:
      return r'VUELO_RETRASO';
    case Enum$TipoEventoParametrico.VUELO_CANCELADO:
      return r'VUELO_CANCELADO';
    case Enum$TipoEventoParametrico.CLIMA:
      return r'CLIMA';
    case Enum$TipoEventoParametrico.$unknown:
      return r'$unknown';
  }
}

Enum$TipoEventoParametrico fromJson$Enum$TipoEventoParametrico(String value) {
  switch (value) {
    case r'VUELO_RETRASO':
      return Enum$TipoEventoParametrico.VUELO_RETRASO;
    case r'VUELO_CANCELADO':
      return Enum$TipoEventoParametrico.VUELO_CANCELADO;
    case r'CLIMA':
      return Enum$TipoEventoParametrico.CLIMA;
    default:
      return Enum$TipoEventoParametrico.$unknown;
  }
}

enum Enum$EstadoIndemnizacion {
  EN_PROCESO,
  PAGADA,
  $unknown;

  factory Enum$EstadoIndemnizacion.fromJson(String value) =>
      fromJson$Enum$EstadoIndemnizacion(value);

  String toJson() => toJson$Enum$EstadoIndemnizacion(this);
}

String toJson$Enum$EstadoIndemnizacion(Enum$EstadoIndemnizacion e) {
  switch (e) {
    case Enum$EstadoIndemnizacion.EN_PROCESO:
      return r'EN_PROCESO';
    case Enum$EstadoIndemnizacion.PAGADA:
      return r'PAGADA';
    case Enum$EstadoIndemnizacion.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoIndemnizacion fromJson$Enum$EstadoIndemnizacion(String value) {
  switch (value) {
    case r'EN_PROCESO':
      return Enum$EstadoIndemnizacion.EN_PROCESO;
    case r'PAGADA':
      return Enum$EstadoIndemnizacion.PAGADA;
    default:
      return Enum$EstadoIndemnizacion.$unknown;
  }
}

enum Enum$TipoSiniestroAuto {
  CHOQUE_PARCIAL,
  PERDIDA_TOTAL_DANOS,
  HURTO_TOTAL,
  HURTO_PARCIAL,
  RESPONSABILIDAD_CIVIL,
  $unknown;

  factory Enum$TipoSiniestroAuto.fromJson(String value) =>
      fromJson$Enum$TipoSiniestroAuto(value);

  String toJson() => toJson$Enum$TipoSiniestroAuto(this);
}

String toJson$Enum$TipoSiniestroAuto(Enum$TipoSiniestroAuto e) {
  switch (e) {
    case Enum$TipoSiniestroAuto.CHOQUE_PARCIAL:
      return r'CHOQUE_PARCIAL';
    case Enum$TipoSiniestroAuto.PERDIDA_TOTAL_DANOS:
      return r'PERDIDA_TOTAL_DANOS';
    case Enum$TipoSiniestroAuto.HURTO_TOTAL:
      return r'HURTO_TOTAL';
    case Enum$TipoSiniestroAuto.HURTO_PARCIAL:
      return r'HURTO_PARCIAL';
    case Enum$TipoSiniestroAuto.RESPONSABILIDAD_CIVIL:
      return r'RESPONSABILIDAD_CIVIL';
    case Enum$TipoSiniestroAuto.$unknown:
      return r'$unknown';
  }
}

Enum$TipoSiniestroAuto fromJson$Enum$TipoSiniestroAuto(String value) {
  switch (value) {
    case r'CHOQUE_PARCIAL':
      return Enum$TipoSiniestroAuto.CHOQUE_PARCIAL;
    case r'PERDIDA_TOTAL_DANOS':
      return Enum$TipoSiniestroAuto.PERDIDA_TOTAL_DANOS;
    case r'HURTO_TOTAL':
      return Enum$TipoSiniestroAuto.HURTO_TOTAL;
    case r'HURTO_PARCIAL':
      return Enum$TipoSiniestroAuto.HURTO_PARCIAL;
    case r'RESPONSABILIDAD_CIVIL':
      return Enum$TipoSiniestroAuto.RESPONSABILIDAD_CIVIL;
    default:
      return Enum$TipoSiniestroAuto.$unknown;
  }
}

enum Enum$ColorSalud {
  VERDE,
  AMARILLO,
  ROJO,
  $unknown;

  factory Enum$ColorSalud.fromJson(String value) =>
      fromJson$Enum$ColorSalud(value);

  String toJson() => toJson$Enum$ColorSalud(this);
}

String toJson$Enum$ColorSalud(Enum$ColorSalud e) {
  switch (e) {
    case Enum$ColorSalud.VERDE:
      return r'VERDE';
    case Enum$ColorSalud.AMARILLO:
      return r'AMARILLO';
    case Enum$ColorSalud.ROJO:
      return r'ROJO';
    case Enum$ColorSalud.$unknown:
      return r'$unknown';
  }
}

Enum$ColorSalud fromJson$Enum$ColorSalud(String value) {
  switch (value) {
    case r'VERDE':
      return Enum$ColorSalud.VERDE;
    case r'AMARILLO':
      return Enum$ColorSalud.AMARILLO;
    case r'ROJO':
      return Enum$ColorSalud.ROJO;
    default:
      return Enum$ColorSalud.$unknown;
  }
}

enum Enum$EstadoCircuito {
  CERRADO,
  SEMIABIERTO,
  ABIERTO,
  DESCONOCIDO,
  $unknown;

  factory Enum$EstadoCircuito.fromJson(String value) =>
      fromJson$Enum$EstadoCircuito(value);

  String toJson() => toJson$Enum$EstadoCircuito(this);
}

String toJson$Enum$EstadoCircuito(Enum$EstadoCircuito e) {
  switch (e) {
    case Enum$EstadoCircuito.CERRADO:
      return r'CERRADO';
    case Enum$EstadoCircuito.SEMIABIERTO:
      return r'SEMIABIERTO';
    case Enum$EstadoCircuito.ABIERTO:
      return r'ABIERTO';
    case Enum$EstadoCircuito.DESCONOCIDO:
      return r'DESCONOCIDO';
    case Enum$EstadoCircuito.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoCircuito fromJson$Enum$EstadoCircuito(String value) {
  switch (value) {
    case r'CERRADO':
      return Enum$EstadoCircuito.CERRADO;
    case r'SEMIABIERTO':
      return Enum$EstadoCircuito.SEMIABIERTO;
    case r'ABIERTO':
      return Enum$EstadoCircuito.ABIERTO;
    case r'DESCONOCIDO':
      return Enum$EstadoCircuito.DESCONOCIDO;
    default:
      return Enum$EstadoCircuito.$unknown;
  }
}

enum Enum$TipoPrestador {
  MEDICO,
  MECANICO,
  GRUA,
  $unknown;

  factory Enum$TipoPrestador.fromJson(String value) =>
      fromJson$Enum$TipoPrestador(value);

  String toJson() => toJson$Enum$TipoPrestador(this);
}

String toJson$Enum$TipoPrestador(Enum$TipoPrestador e) {
  switch (e) {
    case Enum$TipoPrestador.MEDICO:
      return r'MEDICO';
    case Enum$TipoPrestador.MECANICO:
      return r'MECANICO';
    case Enum$TipoPrestador.GRUA:
      return r'GRUA';
    case Enum$TipoPrestador.$unknown:
      return r'$unknown';
  }
}

Enum$TipoPrestador fromJson$Enum$TipoPrestador(String value) {
  switch (value) {
    case r'MEDICO':
      return Enum$TipoPrestador.MEDICO;
    case r'MECANICO':
      return Enum$TipoPrestador.MECANICO;
    case r'GRUA':
      return Enum$TipoPrestador.GRUA;
    default:
      return Enum$TipoPrestador.$unknown;
  }
}

enum Enum$EstadoAsistencia {
  CONFIRMADA,
  NO_CONFIRMADA,
  CANCELADA,
  $unknown;

  factory Enum$EstadoAsistencia.fromJson(String value) =>
      fromJson$Enum$EstadoAsistencia(value);

  String toJson() => toJson$Enum$EstadoAsistencia(this);
}

String toJson$Enum$EstadoAsistencia(Enum$EstadoAsistencia e) {
  switch (e) {
    case Enum$EstadoAsistencia.CONFIRMADA:
      return r'CONFIRMADA';
    case Enum$EstadoAsistencia.NO_CONFIRMADA:
      return r'NO_CONFIRMADA';
    case Enum$EstadoAsistencia.CANCELADA:
      return r'CANCELADA';
    case Enum$EstadoAsistencia.$unknown:
      return r'$unknown';
  }
}

Enum$EstadoAsistencia fromJson$Enum$EstadoAsistencia(String value) {
  switch (value) {
    case r'CONFIRMADA':
      return Enum$EstadoAsistencia.CONFIRMADA;
    case r'NO_CONFIRMADA':
      return Enum$EstadoAsistencia.NO_CONFIRMADA;
    case r'CANCELADA':
      return Enum$EstadoAsistencia.CANCELADA;
    default:
      return Enum$EstadoAsistencia.$unknown;
  }
}

enum Enum$MotivoNoConfirmada {
  PRESTADOR_SIN_RESPUESTA,
  $unknown;

  factory Enum$MotivoNoConfirmada.fromJson(String value) =>
      fromJson$Enum$MotivoNoConfirmada(value);

  String toJson() => toJson$Enum$MotivoNoConfirmada(this);
}

String toJson$Enum$MotivoNoConfirmada(Enum$MotivoNoConfirmada e) {
  switch (e) {
    case Enum$MotivoNoConfirmada.PRESTADOR_SIN_RESPUESTA:
      return r'PRESTADOR_SIN_RESPUESTA';
    case Enum$MotivoNoConfirmada.$unknown:
      return r'$unknown';
  }
}

Enum$MotivoNoConfirmada fromJson$Enum$MotivoNoConfirmada(String value) {
  switch (value) {
    case r'PRESTADOR_SIN_RESPUESTA':
      return Enum$MotivoNoConfirmada.PRESTADOR_SIN_RESPUESTA;
    default:
      return Enum$MotivoNoConfirmada.$unknown;
  }
}

enum Enum$CodigoErrorAsistencia {
  PRESTADOR_NO_DISPONIBLE,
  TIPO_NO_ATENDIDO,
  DATOS_INVALIDOS,
  NO_ENCONTRADA,
  $unknown;

  factory Enum$CodigoErrorAsistencia.fromJson(String value) =>
      fromJson$Enum$CodigoErrorAsistencia(value);

  String toJson() => toJson$Enum$CodigoErrorAsistencia(this);
}

String toJson$Enum$CodigoErrorAsistencia(Enum$CodigoErrorAsistencia e) {
  switch (e) {
    case Enum$CodigoErrorAsistencia.PRESTADOR_NO_DISPONIBLE:
      return r'PRESTADOR_NO_DISPONIBLE';
    case Enum$CodigoErrorAsistencia.TIPO_NO_ATENDIDO:
      return r'TIPO_NO_ATENDIDO';
    case Enum$CodigoErrorAsistencia.DATOS_INVALIDOS:
      return r'DATOS_INVALIDOS';
    case Enum$CodigoErrorAsistencia.NO_ENCONTRADA:
      return r'NO_ENCONTRADA';
    case Enum$CodigoErrorAsistencia.$unknown:
      return r'$unknown';
  }
}

Enum$CodigoErrorAsistencia fromJson$Enum$CodigoErrorAsistencia(String value) {
  switch (value) {
    case r'PRESTADOR_NO_DISPONIBLE':
      return Enum$CodigoErrorAsistencia.PRESTADOR_NO_DISPONIBLE;
    case r'TIPO_NO_ATENDIDO':
      return Enum$CodigoErrorAsistencia.TIPO_NO_ATENDIDO;
    case r'DATOS_INVALIDOS':
      return Enum$CodigoErrorAsistencia.DATOS_INVALIDOS;
    case r'NO_ENCONTRADA':
      return Enum$CodigoErrorAsistencia.NO_ENCONTRADA;
    default:
      return Enum$CodigoErrorAsistencia.$unknown;
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
  'ResultadoRestablecimiento': {
    'RestablecimientoExitoso',
    'ErrorAutenticacion',
  },
  'ResultadoUsuario': {'Usuario', 'ErrorUsuario'},
  'ResultadoSubidaArchivo': {'SubidaArchivo', 'ErrorArchivo'},
  'ResultadoArchivo': {'Archivo', 'ErrorArchivo'},
  'ResultadoDescargaArchivo': {'DescargaArchivo', 'ErrorArchivo'},
  'ResultadoInicioOnboarding': {'InicioOnboarding', 'ErrorOnboarding'},
  'ResultadoOnboarding': {'Onboarding', 'ErrorOnboarding'},
  'ResultadoSubidaOnboarding': {'SubidaArchivo', 'ErrorOnboarding'},
  'ResultadoCuentaOnboarding': {'CuentaOnboarding', 'ErrorOnboarding'},
  'ResultadoCodigoOnboarding': {'CodigoOnboardingEnviado', 'ErrorOnboarding'},
  'ResultadoResolucion': {'Siniestro', 'ErrorSiniestro'},
  'ResultadoReporteSiniestro': {'SiniestroReportado', 'ErrorSiniestro'},
  'ResultadoAsistencia': {'Asistencia', 'ErrorAsistencia'},
};
