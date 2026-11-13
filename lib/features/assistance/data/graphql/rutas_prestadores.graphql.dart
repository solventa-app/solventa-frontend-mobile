// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import 'package:gql/ast.dart';

class Variables$Query$RutasPrestadores {
  factory Variables$Query$RutasPrestadores({
    required double latitud,
    required double longitud,
    required List<String> prestadorIds,
  }) => Variables$Query$RutasPrestadores._({
    r'latitud': latitud,
    r'longitud': longitud,
    r'prestadorIds': prestadorIds,
  });

  Variables$Query$RutasPrestadores._(this._$data);

  factory Variables$Query$RutasPrestadores.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$latitud = data['latitud'];
    result$data['latitud'] = (l$latitud as num).toDouble();
    final l$longitud = data['longitud'];
    result$data['longitud'] = (l$longitud as num).toDouble();
    final l$prestadorIds = data['prestadorIds'];
    result$data['prestadorIds'] = (l$prestadorIds as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Variables$Query$RutasPrestadores._(result$data);
  }

  Map<String, dynamic> _$data;

  double get latitud => (_$data['latitud'] as double);

  double get longitud => (_$data['longitud'] as double);

  List<String> get prestadorIds => (_$data['prestadorIds'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$latitud = latitud;
    result$data['latitud'] = l$latitud;
    final l$longitud = longitud;
    result$data['longitud'] = l$longitud;
    final l$prestadorIds = prestadorIds;
    result$data['prestadorIds'] = l$prestadorIds.map((e) => e).toList();
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$RutasPrestadores ||
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
    final l$prestadorIds = prestadorIds;
    final lOther$prestadorIds = other.prestadorIds;
    if (l$prestadorIds.length != lOther$prestadorIds.length) {
      return false;
    }
    for (int i = 0; i < l$prestadorIds.length; i++) {
      final l$prestadorIds$entry = l$prestadorIds[i];
      final lOther$prestadorIds$entry = lOther$prestadorIds[i];
      if (l$prestadorIds$entry != lOther$prestadorIds$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$latitud = latitud;
    final l$longitud = longitud;
    final l$prestadorIds = prestadorIds;
    return Object.hashAll([
      l$latitud,
      l$longitud,
      Object.hashAll(l$prestadorIds.map((v) => v)),
    ]);
  }
}

class Query$RutasPrestadores {
  Query$RutasPrestadores({
    required this.rutasPrestadores,
    this.$__typename = 'Query',
  });

  factory Query$RutasPrestadores.fromJson(Map<String, dynamic> json) {
    final l$rutasPrestadores = json['rutasPrestadores'];
    final l$$__typename = json['__typename'];
    return Query$RutasPrestadores(
      rutasPrestadores: (l$rutasPrestadores as List<dynamic>)
          .map(
            (e) => Query$RutasPrestadores$rutasPrestadores.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$RutasPrestadores$rutasPrestadores> rutasPrestadores;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$rutasPrestadores = rutasPrestadores;
    _resultData['rutasPrestadores'] = l$rutasPrestadores
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$rutasPrestadores = rutasPrestadores;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$rutasPrestadores.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$RutasPrestadores || runtimeType != other.runtimeType) {
      return false;
    }
    final l$rutasPrestadores = rutasPrestadores;
    final lOther$rutasPrestadores = other.rutasPrestadores;
    if (l$rutasPrestadores.length != lOther$rutasPrestadores.length) {
      return false;
    }
    for (int i = 0; i < l$rutasPrestadores.length; i++) {
      final l$rutasPrestadores$entry = l$rutasPrestadores[i];
      final lOther$rutasPrestadores$entry = lOther$rutasPrestadores[i];
      if (l$rutasPrestadores$entry != lOther$rutasPrestadores$entry) {
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

const documentNodeQueryRutasPrestadores = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'RutasPrestadores'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'latitud')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'longitud')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'prestadorIds')),
          type: ListTypeNode(
            type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'rutasPrestadores'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'latitud'),
                value: VariableNode(name: NameNode(value: 'latitud')),
              ),
              ArgumentNode(
                name: NameNode(value: 'longitud'),
                value: VariableNode(name: NameNode(value: 'longitud')),
              ),
              ArgumentNode(
                name: NameNode(value: 'prestadorIds'),
                value: VariableNode(name: NameNode(value: 'prestadorIds')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'prestadorId'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'distanciaMetros'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'duracionSegundos'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'geometria'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'estimado'),
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
  ],
);

class Query$RutasPrestadores$rutasPrestadores {
  Query$RutasPrestadores$rutasPrestadores({
    required this.prestadorId,
    required this.distanciaMetros,
    required this.duracionSegundos,
    this.geometria,
    required this.estimado,
    this.$__typename = 'RutaPrestador',
  });

  factory Query$RutasPrestadores$rutasPrestadores.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$prestadorId = json['prestadorId'];
    final l$distanciaMetros = json['distanciaMetros'];
    final l$duracionSegundos = json['duracionSegundos'];
    final l$geometria = json['geometria'];
    final l$estimado = json['estimado'];
    final l$$__typename = json['__typename'];
    return Query$RutasPrestadores$rutasPrestadores(
      prestadorId: (l$prestadorId as String),
      distanciaMetros: (l$distanciaMetros as int),
      duracionSegundos: (l$duracionSegundos as int),
      geometria: (l$geometria as String?),
      estimado: (l$estimado as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String prestadorId;

  final int distanciaMetros;

  final int duracionSegundos;

  final String? geometria;

  final bool estimado;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$prestadorId = prestadorId;
    _resultData['prestadorId'] = l$prestadorId;
    final l$distanciaMetros = distanciaMetros;
    _resultData['distanciaMetros'] = l$distanciaMetros;
    final l$duracionSegundos = duracionSegundos;
    _resultData['duracionSegundos'] = l$duracionSegundos;
    final l$geometria = geometria;
    _resultData['geometria'] = l$geometria;
    final l$estimado = estimado;
    _resultData['estimado'] = l$estimado;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$prestadorId = prestadorId;
    final l$distanciaMetros = distanciaMetros;
    final l$duracionSegundos = duracionSegundos;
    final l$geometria = geometria;
    final l$estimado = estimado;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$prestadorId,
      l$distanciaMetros,
      l$duracionSegundos,
      l$geometria,
      l$estimado,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$RutasPrestadores$rutasPrestadores ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$prestadorId = prestadorId;
    final lOther$prestadorId = other.prestadorId;
    if (l$prestadorId != lOther$prestadorId) {
      return false;
    }
    final l$distanciaMetros = distanciaMetros;
    final lOther$distanciaMetros = other.distanciaMetros;
    if (l$distanciaMetros != lOther$distanciaMetros) {
      return false;
    }
    final l$duracionSegundos = duracionSegundos;
    final lOther$duracionSegundos = other.duracionSegundos;
    if (l$duracionSegundos != lOther$duracionSegundos) {
      return false;
    }
    final l$geometria = geometria;
    final lOther$geometria = other.geometria;
    if (l$geometria != lOther$geometria) {
      return false;
    }
    final l$estimado = estimado;
    final lOther$estimado = other.estimado;
    if (l$estimado != lOther$estimado) {
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
