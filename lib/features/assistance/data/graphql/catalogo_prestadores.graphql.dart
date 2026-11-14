// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import '../../../../core/contrato/schema.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$CatalogoPrestadores {
  factory Variables$Query$CatalogoPrestadores({String? versionLocal}) =>
      Variables$Query$CatalogoPrestadores._({
        if (versionLocal != null) r'versionLocal': versionLocal,
      });

  Variables$Query$CatalogoPrestadores._(this._$data);

  factory Variables$Query$CatalogoPrestadores.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('versionLocal')) {
      final l$versionLocal = data['versionLocal'];
      result$data['versionLocal'] = (l$versionLocal as String?);
    }
    return Variables$Query$CatalogoPrestadores._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get versionLocal => (_$data['versionLocal'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('versionLocal')) {
      final l$versionLocal = versionLocal;
      result$data['versionLocal'] = l$versionLocal;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$CatalogoPrestadores ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$versionLocal = versionLocal;
    final lOther$versionLocal = other.versionLocal;
    if (_$data.containsKey('versionLocal') !=
        other._$data.containsKey('versionLocal')) {
      return false;
    }
    if (l$versionLocal != lOther$versionLocal) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$versionLocal = versionLocal;
    return Object.hashAll([
      _$data.containsKey('versionLocal') ? l$versionLocal : const {},
    ]);
  }
}

class Query$CatalogoPrestadores {
  Query$CatalogoPrestadores({
    required this.catalogoPrestadores,
    this.$__typename = 'Query',
  });

  factory Query$CatalogoPrestadores.fromJson(Map<String, dynamic> json) {
    final l$catalogoPrestadores = json['catalogoPrestadores'];
    final l$$__typename = json['__typename'];
    return Query$CatalogoPrestadores(
      catalogoPrestadores:
          Query$CatalogoPrestadores$catalogoPrestadores.fromJson(
            (l$catalogoPrestadores as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$CatalogoPrestadores$catalogoPrestadores catalogoPrestadores;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$catalogoPrestadores = catalogoPrestadores;
    _resultData['catalogoPrestadores'] = l$catalogoPrestadores.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$catalogoPrestadores = catalogoPrestadores;
    final l$$__typename = $__typename;
    return Object.hashAll([l$catalogoPrestadores, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$CatalogoPrestadores ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$catalogoPrestadores = catalogoPrestadores;
    final lOther$catalogoPrestadores = other.catalogoPrestadores;
    if (l$catalogoPrestadores != lOther$catalogoPrestadores) {
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

const documentNodeQueryCatalogoPrestadores = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'CatalogoPrestadores'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'versionLocal')),
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
            name: NameNode(value: 'catalogoPrestadores'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'versionLocal'),
                value: VariableNode(name: NameNode(value: 'versionLocal')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'version'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'vigente'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'prestadores'),
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

class Query$CatalogoPrestadores$catalogoPrestadores {
  Query$CatalogoPrestadores$catalogoPrestadores({
    required this.version,
    required this.vigente,
    required this.prestadores,
    this.$__typename = 'CatalogoPrestadores',
  });

  factory Query$CatalogoPrestadores$catalogoPrestadores.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$version = json['version'];
    final l$vigente = json['vigente'];
    final l$prestadores = json['prestadores'];
    final l$$__typename = json['__typename'];
    return Query$CatalogoPrestadores$catalogoPrestadores(
      version: (l$version as String),
      vigente: (l$vigente as bool),
      prestadores: (l$prestadores as List<dynamic>)
          .map(
            (e) =>
                Query$CatalogoPrestadores$catalogoPrestadores$prestadores.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String version;

  final bool vigente;

  final List<Query$CatalogoPrestadores$catalogoPrestadores$prestadores>
  prestadores;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$version = version;
    _resultData['version'] = l$version;
    final l$vigente = vigente;
    _resultData['vigente'] = l$vigente;
    final l$prestadores = prestadores;
    _resultData['prestadores'] = l$prestadores.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$version = version;
    final l$vigente = vigente;
    final l$prestadores = prestadores;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$version,
      l$vigente,
      Object.hashAll(l$prestadores.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$CatalogoPrestadores$catalogoPrestadores ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
      return false;
    }
    final l$vigente = vigente;
    final lOther$vigente = other.vigente;
    if (l$vigente != lOther$vigente) {
      return false;
    }
    final l$prestadores = prestadores;
    final lOther$prestadores = other.prestadores;
    if (l$prestadores.length != lOther$prestadores.length) {
      return false;
    }
    for (int i = 0; i < l$prestadores.length; i++) {
      final l$prestadores$entry = l$prestadores[i];
      final lOther$prestadores$entry = lOther$prestadores[i];
      if (l$prestadores$entry != lOther$prestadores$entry) {
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

class Query$CatalogoPrestadores$catalogoPrestadores$prestadores {
  Query$CatalogoPrestadores$catalogoPrestadores$prestadores({
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

  factory Query$CatalogoPrestadores$catalogoPrestadores$prestadores.fromJson(
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
    return Query$CatalogoPrestadores$catalogoPrestadores$prestadores(
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
    if (other is! Query$CatalogoPrestadores$catalogoPrestadores$prestadores ||
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
