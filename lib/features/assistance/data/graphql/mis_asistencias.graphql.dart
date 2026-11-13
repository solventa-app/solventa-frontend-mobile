// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import '../../../../core/contrato/schema.graphql.dart';

import 'package:gql/ast.dart';

class Query$MisAsistencias {
  Query$MisAsistencias({
    required this.misAsistencias,
    this.$__typename = 'Query',
  });

  factory Query$MisAsistencias.fromJson(Map<String, dynamic> json) {
    final l$misAsistencias = json['misAsistencias'];
    final l$$__typename = json['__typename'];
    return Query$MisAsistencias(
      misAsistencias: (l$misAsistencias as List<dynamic>)
          .map(
            (e) => Query$MisAsistencias$misAsistencias.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$MisAsistencias$misAsistencias> misAsistencias;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$misAsistencias = misAsistencias;
    _resultData['misAsistencias'] = l$misAsistencias
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$misAsistencias = misAsistencias;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$misAsistencias.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MisAsistencias || runtimeType != other.runtimeType) {
      return false;
    }
    final l$misAsistencias = misAsistencias;
    final lOther$misAsistencias = other.misAsistencias;
    if (l$misAsistencias.length != lOther$misAsistencias.length) {
      return false;
    }
    for (int i = 0; i < l$misAsistencias.length; i++) {
      final l$misAsistencias$entry = l$misAsistencias[i];
      final lOther$misAsistencias$entry = lOther$misAsistencias[i];
      if (l$misAsistencias$entry != lOther$misAsistencias$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const documentNodeQueryMisAsistencias = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MisAsistencias'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'misAsistencias'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'estado'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'tipoAsistencia'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'minutosEstimados'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'motivo'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'solicitadaEn'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'canceladaEn'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'confirmadaEn'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'llegadaEstimada'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'descripcion'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'ubicacion'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'latitud'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'longitud'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'direccion'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'origen'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: 'prestador'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'nombre'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'tipo'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'ciudad'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'latitud'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'longitud'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'activo'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'aliado'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'especialidad'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'direccion'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'horario'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'fotoUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
  ],
);

class Query$MisAsistencias$misAsistencias {
  Query$MisAsistencias$misAsistencias({
    required this.id,
    required this.estado,
    required this.tipoAsistencia,
    this.minutosEstimados,
    this.motivo,
    required this.solicitadaEn,
    this.canceladaEn,
    this.confirmadaEn,
    this.llegadaEstimada,
    this.descripcion,
    this.ubicacion,
    required this.prestador,
    this.$__typename = 'Asistencia',
  });

  factory Query$MisAsistencias$misAsistencias.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$estado = json['estado'];
    final l$tipoAsistencia = json['tipoAsistencia'];
    final l$minutosEstimados = json['minutosEstimados'];
    final l$motivo = json['motivo'];
    final l$solicitadaEn = json['solicitadaEn'];
    final l$canceladaEn = json['canceladaEn'];
    final l$confirmadaEn = json['confirmadaEn'];
    final l$llegadaEstimada = json['llegadaEstimada'];
    final l$descripcion = json['descripcion'];
    final l$ubicacion = json['ubicacion'];
    final l$prestador = json['prestador'];
    final l$$__typename = json['__typename'];
    return Query$MisAsistencias$misAsistencias(
      id: (l$id as String),
      estado: fromJson$Enum$EstadoAsistencia((l$estado as String)),
      tipoAsistencia: fromJson$Enum$TipoPrestador((l$tipoAsistencia as String)),
      minutosEstimados: (l$minutosEstimados as int?),
      motivo: l$motivo == null
          ? null
          : fromJson$Enum$MotivoNoConfirmada((l$motivo as String)),
      solicitadaEn: DateTime.parse((l$solicitadaEn as String)),
      canceladaEn: l$canceladaEn == null
          ? null
          : DateTime.parse((l$canceladaEn as String)),
      confirmadaEn: l$confirmadaEn == null
          ? null
          : DateTime.parse((l$confirmadaEn as String)),
      llegadaEstimada: l$llegadaEstimada == null
          ? null
          : DateTime.parse((l$llegadaEstimada as String)),
      descripcion: (l$descripcion as String?),
      ubicacion: l$ubicacion == null
          ? null
          : Query$MisAsistencias$misAsistencias$ubicacion.fromJson(
              (l$ubicacion as Map<String, dynamic>),
            ),
      prestador: Query$MisAsistencias$misAsistencias$prestador.fromJson(
        (l$prestador as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$EstadoAsistencia estado;

  final Enum$TipoPrestador tipoAsistencia;

  final int? minutosEstimados;

  final Enum$MotivoNoConfirmada? motivo;

  final DateTime solicitadaEn;

  final DateTime? canceladaEn;

  final DateTime? confirmadaEn;

  final DateTime? llegadaEstimada;

  final String? descripcion;

  final Query$MisAsistencias$misAsistencias$ubicacion? ubicacion;

  final Query$MisAsistencias$misAsistencias$prestador prestador;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoAsistencia(l$estado);
    final l$tipoAsistencia = tipoAsistencia;
    _resultData['tipoAsistencia'] = toJson$Enum$TipoPrestador(l$tipoAsistencia);
    final l$minutosEstimados = minutosEstimados;
    _resultData['minutosEstimados'] = l$minutosEstimados;
    final l$motivo = motivo;
    _resultData['motivo'] = l$motivo == null
        ? null
        : toJson$Enum$MotivoNoConfirmada(l$motivo);
    final l$solicitadaEn = solicitadaEn;
    _resultData['solicitadaEn'] = l$solicitadaEn.toIso8601String();
    final l$canceladaEn = canceladaEn;
    _resultData['canceladaEn'] = l$canceladaEn?.toIso8601String();
    final l$confirmadaEn = confirmadaEn;
    _resultData['confirmadaEn'] = l$confirmadaEn?.toIso8601String();
    final l$llegadaEstimada = llegadaEstimada;
    _resultData['llegadaEstimada'] = l$llegadaEstimada?.toIso8601String();
    final l$descripcion = descripcion;
    _resultData['descripcion'] = l$descripcion;
    final l$ubicacion = ubicacion;
    _resultData['ubicacion'] = l$ubicacion?.toJson();
    final l$prestador = prestador;
    _resultData['prestador'] = l$prestador.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$estado = estado;
    final l$tipoAsistencia = tipoAsistencia;
    final l$minutosEstimados = minutosEstimados;
    final l$motivo = motivo;
    final l$solicitadaEn = solicitadaEn;
    final l$canceladaEn = canceladaEn;
    final l$confirmadaEn = confirmadaEn;
    final l$llegadaEstimada = llegadaEstimada;
    final l$descripcion = descripcion;
    final l$ubicacion = ubicacion;
    final l$prestador = prestador;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$estado,
      l$tipoAsistencia,
      l$minutosEstimados,
      l$motivo,
      l$solicitadaEn,
      l$canceladaEn,
      l$confirmadaEn,
      l$llegadaEstimada,
      l$descripcion,
      l$ubicacion,
      l$prestador,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MisAsistencias$misAsistencias ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$estado = estado;
    final lOther$estado = other.estado;
    if (l$estado != lOther$estado) {
      return false;
    }
    final l$tipoAsistencia = tipoAsistencia;
    final lOther$tipoAsistencia = other.tipoAsistencia;
    if (l$tipoAsistencia != lOther$tipoAsistencia) {
      return false;
    }
    final l$minutosEstimados = minutosEstimados;
    final lOther$minutosEstimados = other.minutosEstimados;
    if (l$minutosEstimados != lOther$minutosEstimados) {
      return false;
    }
    final l$motivo = motivo;
    final lOther$motivo = other.motivo;
    if (l$motivo != lOther$motivo) {
      return false;
    }
    final l$solicitadaEn = solicitadaEn;
    final lOther$solicitadaEn = other.solicitadaEn;
    if (l$solicitadaEn != lOther$solicitadaEn) {
      return false;
    }
    final l$canceladaEn = canceladaEn;
    final lOther$canceladaEn = other.canceladaEn;
    if (l$canceladaEn != lOther$canceladaEn) {
      return false;
    }
    final l$confirmadaEn = confirmadaEn;
    final lOther$confirmadaEn = other.confirmadaEn;
    if (l$confirmadaEn != lOther$confirmadaEn) {
      return false;
    }
    final l$llegadaEstimada = llegadaEstimada;
    final lOther$llegadaEstimada = other.llegadaEstimada;
    if (l$llegadaEstimada != lOther$llegadaEstimada) {
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
    final l$prestador = prestador;
    final lOther$prestador = other.prestador;
    if (l$prestador != lOther$prestador) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Query$MisAsistencias$misAsistencias$ubicacion {
  Query$MisAsistencias$misAsistencias$ubicacion({
    this.latitud,
    this.longitud,
    this.direccion,
    required this.origen,
    this.$__typename = 'UbicacionAsistencia',
  });

  factory Query$MisAsistencias$misAsistencias$ubicacion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$latitud = json['latitud'];
    final l$longitud = json['longitud'];
    final l$direccion = json['direccion'];
    final l$origen = json['origen'];
    final l$$__typename = json['__typename'];
    return Query$MisAsistencias$misAsistencias$ubicacion(
      latitud: (l$latitud as num?)?.toDouble(),
      longitud: (l$longitud as num?)?.toDouble(),
      direccion: (l$direccion as String?),
      origen: fromJson$Enum$OrigenUbicacion((l$origen as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final double? latitud;

  final double? longitud;

  final String? direccion;

  final Enum$OrigenUbicacion origen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$latitud = latitud;
    _resultData['latitud'] = l$latitud;
    final l$longitud = longitud;
    _resultData['longitud'] = l$longitud;
    final l$direccion = direccion;
    _resultData['direccion'] = l$direccion;
    final l$origen = origen;
    _resultData['origen'] = toJson$Enum$OrigenUbicacion(l$origen);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$latitud = latitud;
    final l$longitud = longitud;
    final l$direccion = direccion;
    final l$origen = origen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$latitud,
      l$longitud,
      l$direccion,
      l$origen,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MisAsistencias$misAsistencias$ubicacion ||
        runtimeType != other.runtimeType) {
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
    final l$direccion = direccion;
    final lOther$direccion = other.direccion;
    if (l$direccion != lOther$direccion) {
      return false;
    }
    final l$origen = origen;
    final lOther$origen = other.origen;
    if (l$origen != lOther$origen) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Query$MisAsistencias$misAsistencias$prestador {
  Query$MisAsistencias$misAsistencias$prestador({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.ciudad,
    required this.latitud,
    required this.longitud,
    required this.activo,
    required this.aliado,
    required this.especialidad,
    required this.direccion,
    this.horario,
    this.fotoUrl,
    this.$__typename = 'Prestador',
  });

  factory Query$MisAsistencias$misAsistencias$prestador.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$nombre = json['nombre'];
    final l$tipo = json['tipo'];
    final l$ciudad = json['ciudad'];
    final l$latitud = json['latitud'];
    final l$longitud = json['longitud'];
    final l$activo = json['activo'];
    final l$aliado = json['aliado'];
    final l$especialidad = json['especialidad'];
    final l$direccion = json['direccion'];
    final l$horario = json['horario'];
    final l$fotoUrl = json['fotoUrl'];
    final l$$__typename = json['__typename'];
    return Query$MisAsistencias$misAsistencias$prestador(
      id: (l$id as String),
      nombre: (l$nombre as String),
      tipo: fromJson$Enum$TipoPrestador((l$tipo as String)),
      ciudad: (l$ciudad as String),
      latitud: (l$latitud as num).toDouble(),
      longitud: (l$longitud as num).toDouble(),
      activo: (l$activo as bool),
      aliado: (l$aliado as bool),
      especialidad: (l$especialidad as String),
      direccion: (l$direccion as String),
      horario: (l$horario as String?),
      fotoUrl: (l$fotoUrl as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String nombre;

  final Enum$TipoPrestador tipo;

  final String ciudad;

  final double latitud;

  final double longitud;

  final bool activo;

  final bool aliado;

  final String especialidad;

  final String direccion;

  final String? horario;

  final String? fotoUrl;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$nombre = nombre;
    _resultData['nombre'] = l$nombre;
    final l$tipo = tipo;
    _resultData['tipo'] = toJson$Enum$TipoPrestador(l$tipo);
    final l$ciudad = ciudad;
    _resultData['ciudad'] = l$ciudad;
    final l$latitud = latitud;
    _resultData['latitud'] = l$latitud;
    final l$longitud = longitud;
    _resultData['longitud'] = l$longitud;
    final l$activo = activo;
    _resultData['activo'] = l$activo;
    final l$aliado = aliado;
    _resultData['aliado'] = l$aliado;
    final l$especialidad = especialidad;
    _resultData['especialidad'] = l$especialidad;
    final l$direccion = direccion;
    _resultData['direccion'] = l$direccion;
    final l$horario = horario;
    _resultData['horario'] = l$horario;
    final l$fotoUrl = fotoUrl;
    _resultData['fotoUrl'] = l$fotoUrl;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$nombre = nombre;
    final l$tipo = tipo;
    final l$ciudad = ciudad;
    final l$latitud = latitud;
    final l$longitud = longitud;
    final l$activo = activo;
    final l$aliado = aliado;
    final l$especialidad = especialidad;
    final l$direccion = direccion;
    final l$horario = horario;
    final l$fotoUrl = fotoUrl;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$nombre,
      l$tipo,
      l$ciudad,
      l$latitud,
      l$longitud,
      l$activo,
      l$aliado,
      l$especialidad,
      l$direccion,
      l$horario,
      l$fotoUrl,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MisAsistencias$misAsistencias$prestador ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$nombre = nombre;
    final lOther$nombre = other.nombre;
    if (l$nombre != lOther$nombre) {
      return false;
    }
    final l$tipo = tipo;
    final lOther$tipo = other.tipo;
    if (l$tipo != lOther$tipo) {
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
    final l$activo = activo;
    final lOther$activo = other.activo;
    if (l$activo != lOther$activo) {
      return false;
    }
    final l$aliado = aliado;
    final lOther$aliado = other.aliado;
    if (l$aliado != lOther$aliado) {
      return false;
    }
    final l$especialidad = especialidad;
    final lOther$especialidad = other.especialidad;
    if (l$especialidad != lOther$especialidad) {
      return false;
    }
    final l$direccion = direccion;
    final lOther$direccion = other.direccion;
    if (l$direccion != lOther$direccion) {
      return false;
    }
    final l$horario = horario;
    final lOther$horario = other.horario;
    if (l$horario != lOther$horario) {
      return false;
    }
    final l$fotoUrl = fotoUrl;
    final lOther$fotoUrl = other.fotoUrl;
    if (l$fotoUrl != lOther$fotoUrl) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Variables$Query$AsistenciaPorId {
  factory Variables$Query$AsistenciaPorId({required String id}) =>
      Variables$Query$AsistenciaPorId._({r'id': id});

  Variables$Query$AsistenciaPorId._(this._$data);

  factory Variables$Query$AsistenciaPorId.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$AsistenciaPorId._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$AsistenciaPorId ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

class Query$AsistenciaPorId {
  Query$AsistenciaPorId({required this.asistencia, this.$__typename = 'Query'});

  factory Query$AsistenciaPorId.fromJson(Map<String, dynamic> json) {
    final l$asistencia = json['asistencia'];
    final l$$__typename = json['__typename'];
    return Query$AsistenciaPorId(
      asistencia: Query$AsistenciaPorId$asistencia.fromJson(
        (l$asistencia as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$AsistenciaPorId$asistencia asistencia;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$asistencia = asistencia;
    _resultData['asistencia'] = l$asistencia.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$asistencia = asistencia;
    final l$$__typename = $__typename;
    return Object.hashAll([l$asistencia, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AsistenciaPorId || runtimeType != other.runtimeType) {
      return false;
    }
    final l$asistencia = asistencia;
    final lOther$asistencia = other.asistencia;
    if (l$asistencia != lOther$asistencia) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const documentNodeQueryAsistenciaPorId = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AsistenciaPorId'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'asistencia'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'Asistencia'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'estado'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'tipoAsistencia'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'minutosEstimados'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'motivo'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'solicitadaEn'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'canceladaEn'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'confirmadaEn'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'llegadaEstimada'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'descripcion'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'ubicacion'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'latitud'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'longitud'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'direccion'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'origen'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: 'prestador'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'nombre'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'tipo'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'ciudad'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'latitud'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'longitud'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'activo'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'aliado'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'especialidad'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'direccion'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'horario'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'fotoUrl'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'ErrorAsistencia'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'codigo'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'mensaje'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
  ],
);

class Query$AsistenciaPorId$asistencia {
  Query$AsistenciaPorId$asistencia({required this.$__typename});

  factory Query$AsistenciaPorId$asistencia.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Asistencia":
        return Query$AsistenciaPorId$asistencia$$Asistencia.fromJson(json);

      case "ErrorAsistencia":
        return Query$AsistenciaPorId$asistencia$$ErrorAsistencia.fromJson(json);

      default:
        final l$$__typename = json['__typename'];
        return Query$AsistenciaPorId$asistencia(
          $__typename: (l$$__typename as String),
        );
    }
  }

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    return Object.hashAll([l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AsistenciaPorId$asistencia ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$AsistenciaPorId$asistencia
    on Query$AsistenciaPorId$asistencia {
  _T when<_T>({
    required _T Function(Query$AsistenciaPorId$asistencia$$Asistencia)
    asistencia,
    required _T Function(Query$AsistenciaPorId$asistencia$$ErrorAsistencia)
    errorAsistencia,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Asistencia":
        return asistencia(this as Query$AsistenciaPorId$asistencia$$Asistencia);

      case "ErrorAsistencia":
        return errorAsistencia(
          this as Query$AsistenciaPorId$asistencia$$ErrorAsistencia,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query$AsistenciaPorId$asistencia$$Asistencia)? asistencia,
    _T Function(Query$AsistenciaPorId$asistencia$$ErrorAsistencia)?
    errorAsistencia,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Asistencia":
        if (asistencia != null) {
          return asistencia(
            this as Query$AsistenciaPorId$asistencia$$Asistencia,
          );
        } else {
          return orElse();
        }

      case "ErrorAsistencia":
        if (errorAsistencia != null) {
          return errorAsistencia(
            this as Query$AsistenciaPorId$asistencia$$ErrorAsistencia,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Query$AsistenciaPorId$asistencia$$Asistencia
    implements Query$AsistenciaPorId$asistencia {
  Query$AsistenciaPorId$asistencia$$Asistencia({
    required this.id,
    required this.estado,
    required this.tipoAsistencia,
    this.minutosEstimados,
    this.motivo,
    required this.solicitadaEn,
    this.canceladaEn,
    this.confirmadaEn,
    this.llegadaEstimada,
    this.descripcion,
    this.ubicacion,
    required this.prestador,
    this.$__typename = 'Asistencia',
  });

  factory Query$AsistenciaPorId$asistencia$$Asistencia.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$estado = json['estado'];
    final l$tipoAsistencia = json['tipoAsistencia'];
    final l$minutosEstimados = json['minutosEstimados'];
    final l$motivo = json['motivo'];
    final l$solicitadaEn = json['solicitadaEn'];
    final l$canceladaEn = json['canceladaEn'];
    final l$confirmadaEn = json['confirmadaEn'];
    final l$llegadaEstimada = json['llegadaEstimada'];
    final l$descripcion = json['descripcion'];
    final l$ubicacion = json['ubicacion'];
    final l$prestador = json['prestador'];
    final l$$__typename = json['__typename'];
    return Query$AsistenciaPorId$asistencia$$Asistencia(
      id: (l$id as String),
      estado: fromJson$Enum$EstadoAsistencia((l$estado as String)),
      tipoAsistencia: fromJson$Enum$TipoPrestador((l$tipoAsistencia as String)),
      minutosEstimados: (l$minutosEstimados as int?),
      motivo: l$motivo == null
          ? null
          : fromJson$Enum$MotivoNoConfirmada((l$motivo as String)),
      solicitadaEn: DateTime.parse((l$solicitadaEn as String)),
      canceladaEn: l$canceladaEn == null
          ? null
          : DateTime.parse((l$canceladaEn as String)),
      confirmadaEn: l$confirmadaEn == null
          ? null
          : DateTime.parse((l$confirmadaEn as String)),
      llegadaEstimada: l$llegadaEstimada == null
          ? null
          : DateTime.parse((l$llegadaEstimada as String)),
      descripcion: (l$descripcion as String?),
      ubicacion: l$ubicacion == null
          ? null
          : Query$AsistenciaPorId$asistencia$$Asistencia$ubicacion.fromJson(
              (l$ubicacion as Map<String, dynamic>),
            ),
      prestador:
          Query$AsistenciaPorId$asistencia$$Asistencia$prestador.fromJson(
            (l$prestador as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$EstadoAsistencia estado;

  final Enum$TipoPrestador tipoAsistencia;

  final int? minutosEstimados;

  final Enum$MotivoNoConfirmada? motivo;

  final DateTime solicitadaEn;

  final DateTime? canceladaEn;

  final DateTime? confirmadaEn;

  final DateTime? llegadaEstimada;

  final String? descripcion;

  final Query$AsistenciaPorId$asistencia$$Asistencia$ubicacion? ubicacion;

  final Query$AsistenciaPorId$asistencia$$Asistencia$prestador prestador;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoAsistencia(l$estado);
    final l$tipoAsistencia = tipoAsistencia;
    _resultData['tipoAsistencia'] = toJson$Enum$TipoPrestador(l$tipoAsistencia);
    final l$minutosEstimados = minutosEstimados;
    _resultData['minutosEstimados'] = l$minutosEstimados;
    final l$motivo = motivo;
    _resultData['motivo'] = l$motivo == null
        ? null
        : toJson$Enum$MotivoNoConfirmada(l$motivo);
    final l$solicitadaEn = solicitadaEn;
    _resultData['solicitadaEn'] = l$solicitadaEn.toIso8601String();
    final l$canceladaEn = canceladaEn;
    _resultData['canceladaEn'] = l$canceladaEn?.toIso8601String();
    final l$confirmadaEn = confirmadaEn;
    _resultData['confirmadaEn'] = l$confirmadaEn?.toIso8601String();
    final l$llegadaEstimada = llegadaEstimada;
    _resultData['llegadaEstimada'] = l$llegadaEstimada?.toIso8601String();
    final l$descripcion = descripcion;
    _resultData['descripcion'] = l$descripcion;
    final l$ubicacion = ubicacion;
    _resultData['ubicacion'] = l$ubicacion?.toJson();
    final l$prestador = prestador;
    _resultData['prestador'] = l$prestador.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$estado = estado;
    final l$tipoAsistencia = tipoAsistencia;
    final l$minutosEstimados = minutosEstimados;
    final l$motivo = motivo;
    final l$solicitadaEn = solicitadaEn;
    final l$canceladaEn = canceladaEn;
    final l$confirmadaEn = confirmadaEn;
    final l$llegadaEstimada = llegadaEstimada;
    final l$descripcion = descripcion;
    final l$ubicacion = ubicacion;
    final l$prestador = prestador;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$estado,
      l$tipoAsistencia,
      l$minutosEstimados,
      l$motivo,
      l$solicitadaEn,
      l$canceladaEn,
      l$confirmadaEn,
      l$llegadaEstimada,
      l$descripcion,
      l$ubicacion,
      l$prestador,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AsistenciaPorId$asistencia$$Asistencia ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$estado = estado;
    final lOther$estado = other.estado;
    if (l$estado != lOther$estado) {
      return false;
    }
    final l$tipoAsistencia = tipoAsistencia;
    final lOther$tipoAsistencia = other.tipoAsistencia;
    if (l$tipoAsistencia != lOther$tipoAsistencia) {
      return false;
    }
    final l$minutosEstimados = minutosEstimados;
    final lOther$minutosEstimados = other.minutosEstimados;
    if (l$minutosEstimados != lOther$minutosEstimados) {
      return false;
    }
    final l$motivo = motivo;
    final lOther$motivo = other.motivo;
    if (l$motivo != lOther$motivo) {
      return false;
    }
    final l$solicitadaEn = solicitadaEn;
    final lOther$solicitadaEn = other.solicitadaEn;
    if (l$solicitadaEn != lOther$solicitadaEn) {
      return false;
    }
    final l$canceladaEn = canceladaEn;
    final lOther$canceladaEn = other.canceladaEn;
    if (l$canceladaEn != lOther$canceladaEn) {
      return false;
    }
    final l$confirmadaEn = confirmadaEn;
    final lOther$confirmadaEn = other.confirmadaEn;
    if (l$confirmadaEn != lOther$confirmadaEn) {
      return false;
    }
    final l$llegadaEstimada = llegadaEstimada;
    final lOther$llegadaEstimada = other.llegadaEstimada;
    if (l$llegadaEstimada != lOther$llegadaEstimada) {
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
    final l$prestador = prestador;
    final lOther$prestador = other.prestador;
    if (l$prestador != lOther$prestador) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Query$AsistenciaPorId$asistencia$$Asistencia$ubicacion {
  Query$AsistenciaPorId$asistencia$$Asistencia$ubicacion({
    this.latitud,
    this.longitud,
    this.direccion,
    required this.origen,
    this.$__typename = 'UbicacionAsistencia',
  });

  factory Query$AsistenciaPorId$asistencia$$Asistencia$ubicacion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$latitud = json['latitud'];
    final l$longitud = json['longitud'];
    final l$direccion = json['direccion'];
    final l$origen = json['origen'];
    final l$$__typename = json['__typename'];
    return Query$AsistenciaPorId$asistencia$$Asistencia$ubicacion(
      latitud: (l$latitud as num?)?.toDouble(),
      longitud: (l$longitud as num?)?.toDouble(),
      direccion: (l$direccion as String?),
      origen: fromJson$Enum$OrigenUbicacion((l$origen as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final double? latitud;

  final double? longitud;

  final String? direccion;

  final Enum$OrigenUbicacion origen;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$latitud = latitud;
    _resultData['latitud'] = l$latitud;
    final l$longitud = longitud;
    _resultData['longitud'] = l$longitud;
    final l$direccion = direccion;
    _resultData['direccion'] = l$direccion;
    final l$origen = origen;
    _resultData['origen'] = toJson$Enum$OrigenUbicacion(l$origen);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$latitud = latitud;
    final l$longitud = longitud;
    final l$direccion = direccion;
    final l$origen = origen;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$latitud,
      l$longitud,
      l$direccion,
      l$origen,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AsistenciaPorId$asistencia$$Asistencia$ubicacion ||
        runtimeType != other.runtimeType) {
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
    final l$direccion = direccion;
    final lOther$direccion = other.direccion;
    if (l$direccion != lOther$direccion) {
      return false;
    }
    final l$origen = origen;
    final lOther$origen = other.origen;
    if (l$origen != lOther$origen) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Query$AsistenciaPorId$asistencia$$Asistencia$prestador {
  Query$AsistenciaPorId$asistencia$$Asistencia$prestador({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.ciudad,
    required this.latitud,
    required this.longitud,
    required this.activo,
    required this.aliado,
    required this.especialidad,
    required this.direccion,
    this.horario,
    this.fotoUrl,
    this.$__typename = 'Prestador',
  });

  factory Query$AsistenciaPorId$asistencia$$Asistencia$prestador.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$nombre = json['nombre'];
    final l$tipo = json['tipo'];
    final l$ciudad = json['ciudad'];
    final l$latitud = json['latitud'];
    final l$longitud = json['longitud'];
    final l$activo = json['activo'];
    final l$aliado = json['aliado'];
    final l$especialidad = json['especialidad'];
    final l$direccion = json['direccion'];
    final l$horario = json['horario'];
    final l$fotoUrl = json['fotoUrl'];
    final l$$__typename = json['__typename'];
    return Query$AsistenciaPorId$asistencia$$Asistencia$prestador(
      id: (l$id as String),
      nombre: (l$nombre as String),
      tipo: fromJson$Enum$TipoPrestador((l$tipo as String)),
      ciudad: (l$ciudad as String),
      latitud: (l$latitud as num).toDouble(),
      longitud: (l$longitud as num).toDouble(),
      activo: (l$activo as bool),
      aliado: (l$aliado as bool),
      especialidad: (l$especialidad as String),
      direccion: (l$direccion as String),
      horario: (l$horario as String?),
      fotoUrl: (l$fotoUrl as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String nombre;

  final Enum$TipoPrestador tipo;

  final String ciudad;

  final double latitud;

  final double longitud;

  final bool activo;

  final bool aliado;

  final String especialidad;

  final String direccion;

  final String? horario;

  final String? fotoUrl;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$nombre = nombre;
    _resultData['nombre'] = l$nombre;
    final l$tipo = tipo;
    _resultData['tipo'] = toJson$Enum$TipoPrestador(l$tipo);
    final l$ciudad = ciudad;
    _resultData['ciudad'] = l$ciudad;
    final l$latitud = latitud;
    _resultData['latitud'] = l$latitud;
    final l$longitud = longitud;
    _resultData['longitud'] = l$longitud;
    final l$activo = activo;
    _resultData['activo'] = l$activo;
    final l$aliado = aliado;
    _resultData['aliado'] = l$aliado;
    final l$especialidad = especialidad;
    _resultData['especialidad'] = l$especialidad;
    final l$direccion = direccion;
    _resultData['direccion'] = l$direccion;
    final l$horario = horario;
    _resultData['horario'] = l$horario;
    final l$fotoUrl = fotoUrl;
    _resultData['fotoUrl'] = l$fotoUrl;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$nombre = nombre;
    final l$tipo = tipo;
    final l$ciudad = ciudad;
    final l$latitud = latitud;
    final l$longitud = longitud;
    final l$activo = activo;
    final l$aliado = aliado;
    final l$especialidad = especialidad;
    final l$direccion = direccion;
    final l$horario = horario;
    final l$fotoUrl = fotoUrl;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$nombre,
      l$tipo,
      l$ciudad,
      l$latitud,
      l$longitud,
      l$activo,
      l$aliado,
      l$especialidad,
      l$direccion,
      l$horario,
      l$fotoUrl,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AsistenciaPorId$asistencia$$Asistencia$prestador ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$nombre = nombre;
    final lOther$nombre = other.nombre;
    if (l$nombre != lOther$nombre) {
      return false;
    }
    final l$tipo = tipo;
    final lOther$tipo = other.tipo;
    if (l$tipo != lOther$tipo) {
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
    final l$activo = activo;
    final lOther$activo = other.activo;
    if (l$activo != lOther$activo) {
      return false;
    }
    final l$aliado = aliado;
    final lOther$aliado = other.aliado;
    if (l$aliado != lOther$aliado) {
      return false;
    }
    final l$especialidad = especialidad;
    final lOther$especialidad = other.especialidad;
    if (l$especialidad != lOther$especialidad) {
      return false;
    }
    final l$direccion = direccion;
    final lOther$direccion = other.direccion;
    if (l$direccion != lOther$direccion) {
      return false;
    }
    final l$horario = horario;
    final lOther$horario = other.horario;
    if (l$horario != lOther$horario) {
      return false;
    }
    final l$fotoUrl = fotoUrl;
    final lOther$fotoUrl = other.fotoUrl;
    if (l$fotoUrl != lOther$fotoUrl) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Query$AsistenciaPorId$asistencia$$ErrorAsistencia
    implements Query$AsistenciaPorId$asistencia {
  Query$AsistenciaPorId$asistencia$$ErrorAsistencia({
    required this.codigo,
    required this.mensaje,
    this.$__typename = 'ErrorAsistencia',
  });

  factory Query$AsistenciaPorId$asistencia$$ErrorAsistencia.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$codigo = json['codigo'];
    final l$mensaje = json['mensaje'];
    final l$$__typename = json['__typename'];
    return Query$AsistenciaPorId$asistencia$$ErrorAsistencia(
      codigo: fromJson$Enum$CodigoErrorAsistencia((l$codigo as String)),
      mensaje: (l$mensaje as String),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$CodigoErrorAsistencia codigo;

  final String mensaje;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$codigo = codigo;
    _resultData['codigo'] = toJson$Enum$CodigoErrorAsistencia(l$codigo);
    final l$mensaje = mensaje;
    _resultData['mensaje'] = l$mensaje;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$codigo = codigo;
    final l$mensaje = mensaje;
    final l$$__typename = $__typename;
    return Object.hashAll([l$codigo, l$mensaje, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AsistenciaPorId$asistencia$$ErrorAsistencia ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    final l$mensaje = mensaje;
    final lOther$mensaje = other.mensaje;
    if (l$mensaje != lOther$mensaje) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}
