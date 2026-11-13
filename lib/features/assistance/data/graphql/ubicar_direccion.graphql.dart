// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import '../../../../core/contrato/schema.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$AutocompletarDireccion {
  factory Variables$Query$AutocompletarDireccion({
    required String texto,
    String? pais,
  }) => Variables$Query$AutocompletarDireccion._({
    r'texto': texto,
    if (pais != null) r'pais': pais,
  });

  Variables$Query$AutocompletarDireccion._(this._$data);

  factory Variables$Query$AutocompletarDireccion.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$texto = data['texto'];
    result$data['texto'] = (l$texto as String);
    if (data.containsKey('pais')) {
      final l$pais = data['pais'];
      result$data['pais'] = (l$pais as String?);
    }
    return Variables$Query$AutocompletarDireccion._(result$data);
  }

  Map<String, dynamic> _$data;

  String get texto => (_$data['texto'] as String);

  String? get pais => (_$data['pais'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$texto = texto;
    result$data['texto'] = l$texto;
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
    if (other is! Variables$Query$AutocompletarDireccion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$texto = texto;
    final lOther$texto = other.texto;
    if (l$texto != lOther$texto) {
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
    final l$texto = texto;
    final l$pais = pais;
    return Object.hashAll([
      l$texto,
      _$data.containsKey('pais') ? l$pais : const {},
    ]);
  }
}

class Query$AutocompletarDireccion {
  Query$AutocompletarDireccion({
    required this.autocompletarDireccion,
    this.$__typename = 'Query',
  });

  factory Query$AutocompletarDireccion.fromJson(Map<String, dynamic> json) {
    final l$autocompletarDireccion = json['autocompletarDireccion'];
    final l$$__typename = json['__typename'];
    return Query$AutocompletarDireccion(
      autocompletarDireccion: (l$autocompletarDireccion as List<dynamic>)
          .map(
            (e) => Query$AutocompletarDireccion$autocompletarDireccion.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$AutocompletarDireccion$autocompletarDireccion>
  autocompletarDireccion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$autocompletarDireccion = autocompletarDireccion;
    _resultData['autocompletarDireccion'] = l$autocompletarDireccion
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$autocompletarDireccion = autocompletarDireccion;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$autocompletarDireccion.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AutocompletarDireccion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$autocompletarDireccion = autocompletarDireccion;
    final lOther$autocompletarDireccion = other.autocompletarDireccion;
    if (l$autocompletarDireccion.length !=
        lOther$autocompletarDireccion.length) {
      return false;
    }
    for (int i = 0; i < l$autocompletarDireccion.length; i++) {
      final l$autocompletarDireccion$entry = l$autocompletarDireccion[i];
      final lOther$autocompletarDireccion$entry =
          lOther$autocompletarDireccion[i];
      if (l$autocompletarDireccion$entry !=
          lOther$autocompletarDireccion$entry) {
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

const documentNodeQueryAutocompletarDireccion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'AutocompletarDireccion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'texto')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'pais')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'autocompletarDireccion'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'texto'),
                value: VariableNode(name: NameNode(value: 'texto')),
              ),
              ArgumentNode(
                name: NameNode(value: 'pais'),
                value: VariableNode(name: NameNode(value: 'pais')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'placeId'),
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

class Query$AutocompletarDireccion$autocompletarDireccion {
  Query$AutocompletarDireccion$autocompletarDireccion({
    required this.placeId,
    required this.descripcion,
    this.$__typename = 'SugerenciaDireccion',
  });

  factory Query$AutocompletarDireccion$autocompletarDireccion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$placeId = json['placeId'];
    final l$descripcion = json['descripcion'];
    final l$$__typename = json['__typename'];
    return Query$AutocompletarDireccion$autocompletarDireccion(
      placeId: (l$placeId as String),
      descripcion: (l$descripcion as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String placeId;

  final String descripcion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$placeId = placeId;
    _resultData['placeId'] = l$placeId;
    final l$descripcion = descripcion;
    _resultData['descripcion'] = l$descripcion;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$placeId = placeId;
    final l$descripcion = descripcion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$placeId, l$descripcion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$AutocompletarDireccion$autocompletarDireccion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$placeId = placeId;
    final lOther$placeId = other.placeId;
    if (l$placeId != lOther$placeId) {
      return false;
    }
    final l$descripcion = descripcion;
    final lOther$descripcion = other.descripcion;
    if (l$descripcion != lOther$descripcion) {
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

class Variables$Query$UbicarDireccion {
  factory Variables$Query$UbicarDireccion({String? placeId, String? texto}) =>
      Variables$Query$UbicarDireccion._({
        if (placeId != null) r'placeId': placeId,
        if (texto != null) r'texto': texto,
      });

  Variables$Query$UbicarDireccion._(this._$data);

  factory Variables$Query$UbicarDireccion.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('placeId')) {
      final l$placeId = data['placeId'];
      result$data['placeId'] = (l$placeId as String?);
    }
    if (data.containsKey('texto')) {
      final l$texto = data['texto'];
      result$data['texto'] = (l$texto as String?);
    }
    return Variables$Query$UbicarDireccion._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get placeId => (_$data['placeId'] as String?);

  String? get texto => (_$data['texto'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('placeId')) {
      final l$placeId = placeId;
      result$data['placeId'] = l$placeId;
    }
    if (_$data.containsKey('texto')) {
      final l$texto = texto;
      result$data['texto'] = l$texto;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$UbicarDireccion ||
        runtimeType != other.runtimeType) {
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
    final l$texto = texto;
    final lOther$texto = other.texto;
    if (_$data.containsKey('texto') != other._$data.containsKey('texto')) {
      return false;
    }
    if (l$texto != lOther$texto) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$placeId = placeId;
    final l$texto = texto;
    return Object.hashAll([
      _$data.containsKey('placeId') ? l$placeId : const {},
      _$data.containsKey('texto') ? l$texto : const {},
    ]);
  }
}

class Query$UbicarDireccion {
  Query$UbicarDireccion({
    required this.ubicarDireccion,
    this.$__typename = 'Query',
  });

  factory Query$UbicarDireccion.fromJson(Map<String, dynamic> json) {
    final l$ubicarDireccion = json['ubicarDireccion'];
    final l$$__typename = json['__typename'];
    return Query$UbicarDireccion(
      ubicarDireccion: Query$UbicarDireccion$ubicarDireccion.fromJson(
        (l$ubicarDireccion as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$UbicarDireccion$ubicarDireccion ubicarDireccion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$ubicarDireccion = ubicarDireccion;
    _resultData['ubicarDireccion'] = l$ubicarDireccion.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$ubicarDireccion = ubicarDireccion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$ubicarDireccion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$UbicarDireccion || runtimeType != other.runtimeType) {
      return false;
    }
    final l$ubicarDireccion = ubicarDireccion;
    final lOther$ubicarDireccion = other.ubicarDireccion;
    if (l$ubicarDireccion != lOther$ubicarDireccion) {
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

const documentNodeQueryUbicarDireccion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'UbicarDireccion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'placeId')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'texto')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'ubicarDireccion'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'placeId'),
                value: VariableNode(name: NameNode(value: 'placeId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'texto'),
                value: VariableNode(name: NameNode(value: 'texto')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'encontrada'),
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
                  name: NameNode(value: 'direccion'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'codigo'),
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

class Query$UbicarDireccion$ubicarDireccion {
  Query$UbicarDireccion$ubicarDireccion({
    required this.encontrada,
    this.latitud,
    this.longitud,
    this.direccion,
    this.codigo,
    this.$__typename = 'UbicacionDireccion',
  });

  factory Query$UbicarDireccion$ubicarDireccion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$encontrada = json['encontrada'];
    final l$latitud = json['latitud'];
    final l$longitud = json['longitud'];
    final l$direccion = json['direccion'];
    final l$codigo = json['codigo'];
    final l$$__typename = json['__typename'];
    return Query$UbicarDireccion$ubicarDireccion(
      encontrada: (l$encontrada as bool),
      latitud: (l$latitud as num?)?.toDouble(),
      longitud: (l$longitud as num?)?.toDouble(),
      direccion: (l$direccion as String?),
      codigo: l$codigo == null
          ? null
          : fromJson$Enum$CodigoUbicacion((l$codigo as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final bool encontrada;

  final double? latitud;

  final double? longitud;

  final String? direccion;

  final Enum$CodigoUbicacion? codigo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$encontrada = encontrada;
    _resultData['encontrada'] = l$encontrada;
    final l$latitud = latitud;
    _resultData['latitud'] = l$latitud;
    final l$longitud = longitud;
    _resultData['longitud'] = l$longitud;
    final l$direccion = direccion;
    _resultData['direccion'] = l$direccion;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo == null
        ? null
        : toJson$Enum$CodigoUbicacion(l$codigo);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$encontrada = encontrada;
    final l$latitud = latitud;
    final l$longitud = longitud;
    final l$direccion = direccion;
    final l$codigo = codigo;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$encontrada,
      l$latitud,
      l$longitud,
      l$direccion,
      l$codigo,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$UbicarDireccion$ubicarDireccion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$encontrada = encontrada;
    final lOther$encontrada = other.encontrada;
    if (l$encontrada != lOther$encontrada) {
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
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
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
