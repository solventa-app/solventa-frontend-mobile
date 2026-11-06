// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import 'package:gql/ast.dart';

class Variables$Mutation$RenovarSesion {
  factory Variables$Mutation$RenovarSesion({String? refreshToken}) =>
      Variables$Mutation$RenovarSesion._({
        if (refreshToken != null) r'refreshToken': refreshToken,
      });

  Variables$Mutation$RenovarSesion._(this._$data);

  factory Variables$Mutation$RenovarSesion.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('refreshToken')) {
      final l$refreshToken = data['refreshToken'];
      result$data['refreshToken'] = (l$refreshToken as String?);
    }
    return Variables$Mutation$RenovarSesion._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get refreshToken => (_$data['refreshToken'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('refreshToken')) {
      final l$refreshToken = refreshToken;
      result$data['refreshToken'] = l$refreshToken;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RenovarSesion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (_$data.containsKey('refreshToken') !=
        other._$data.containsKey('refreshToken')) {
      return false;
    }
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$refreshToken = refreshToken;
    return Object.hashAll([
      _$data.containsKey('refreshToken') ? l$refreshToken : const {},
    ]);
  }
}

class Mutation$RenovarSesion {
  Mutation$RenovarSesion({
    required this.renovarSesion,
    this.$__typename = 'Mutation',
  });

  factory Mutation$RenovarSesion.fromJson(Map<String, dynamic> json) {
    final l$renovarSesion = json['renovarSesion'];
    final l$$__typename = json['__typename'];
    return Mutation$RenovarSesion(
      renovarSesion: Mutation$RenovarSesion$renovarSesion.fromJson(
        (l$renovarSesion as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$RenovarSesion$renovarSesion renovarSesion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$renovarSesion = renovarSesion;
    _resultData['renovarSesion'] = l$renovarSesion.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$renovarSesion = renovarSesion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$renovarSesion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RenovarSesion || runtimeType != other.runtimeType) {
      return false;
    }
    final l$renovarSesion = renovarSesion;
    final lOther$renovarSesion = other.renovarSesion;
    if (l$renovarSesion != lOther$renovarSesion) {
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

const documentNodeMutationRenovarSesion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RenovarSesion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'refreshToken')),
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
            name: NameNode(value: 'renovarSesion'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'refreshToken'),
                value: VariableNode(name: NameNode(value: 'refreshToken')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'Sesion'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'token'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'expiraEn'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'refreshToken'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'refreshExpiraEn'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'ErrorAutenticacion'),
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

class Mutation$RenovarSesion$renovarSesion {
  Mutation$RenovarSesion$renovarSesion({required this.$__typename});

  factory Mutation$RenovarSesion$renovarSesion.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Sesion":
        return Mutation$RenovarSesion$renovarSesion$$Sesion.fromJson(json);

      case "ErrorAutenticacion":
        return Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$RenovarSesion$renovarSesion(
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
    if (other is! Mutation$RenovarSesion$renovarSesion ||
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

extension UtilityExtension$Mutation$RenovarSesion$renovarSesion
    on Mutation$RenovarSesion$renovarSesion {
  _T when<_T>({
    required _T Function(Mutation$RenovarSesion$renovarSesion$$Sesion) sesion,
    required _T Function(
      Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion,
    )
    errorAutenticacion,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Sesion":
        return sesion(this as Mutation$RenovarSesion$renovarSesion$$Sesion);

      case "ErrorAutenticacion":
        return errorAutenticacion(
          this as Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$RenovarSesion$renovarSesion$$Sesion)? sesion,
    _T Function(Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion)?
    errorAutenticacion,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Sesion":
        if (sesion != null) {
          return sesion(this as Mutation$RenovarSesion$renovarSesion$$Sesion);
        } else {
          return orElse();
        }

      case "ErrorAutenticacion":
        if (errorAutenticacion != null) {
          return errorAutenticacion(
            this as Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$RenovarSesion$renovarSesion$$Sesion
    implements Mutation$RenovarSesion$renovarSesion {
  Mutation$RenovarSesion$renovarSesion$$Sesion({
    required this.token,
    required this.expiraEn,
    this.refreshToken,
    this.refreshExpiraEn,
    this.$__typename = 'Sesion',
  });

  factory Mutation$RenovarSesion$renovarSesion$$Sesion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$token = json['token'];
    final l$expiraEn = json['expiraEn'];
    final l$refreshToken = json['refreshToken'];
    final l$refreshExpiraEn = json['refreshExpiraEn'];
    final l$$__typename = json['__typename'];
    return Mutation$RenovarSesion$renovarSesion$$Sesion(
      token: (l$token as String),
      expiraEn: DateTime.parse((l$expiraEn as String)),
      refreshToken: (l$refreshToken as String?),
      refreshExpiraEn: l$refreshExpiraEn == null
          ? null
          : DateTime.parse((l$refreshExpiraEn as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String token;

  final DateTime expiraEn;

  final String? refreshToken;

  final DateTime? refreshExpiraEn;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$token = token;
    _resultData['token'] = l$token;
    final l$expiraEn = expiraEn;
    _resultData['expiraEn'] = l$expiraEn.toIso8601String();
    final l$refreshToken = refreshToken;
    _resultData['refreshToken'] = l$refreshToken;
    final l$refreshExpiraEn = refreshExpiraEn;
    _resultData['refreshExpiraEn'] = l$refreshExpiraEn?.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$token = token;
    final l$expiraEn = expiraEn;
    final l$refreshToken = refreshToken;
    final l$refreshExpiraEn = refreshExpiraEn;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$token,
      l$expiraEn,
      l$refreshToken,
      l$refreshExpiraEn,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RenovarSesion$renovarSesion$$Sesion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$token = token;
    final lOther$token = other.token;
    if (l$token != lOther$token) {
      return false;
    }
    final l$expiraEn = expiraEn;
    final lOther$expiraEn = other.expiraEn;
    if (l$expiraEn != lOther$expiraEn) {
      return false;
    }
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    final l$refreshExpiraEn = refreshExpiraEn;
    final lOther$refreshExpiraEn = other.refreshExpiraEn;
    if (l$refreshExpiraEn != lOther$refreshExpiraEn) {
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

class Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion
    implements Mutation$RenovarSesion$renovarSesion {
  Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion({
    this.codigo,
    this.$__typename = 'ErrorAutenticacion',
  });

  factory Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$codigo = json['codigo'];
    final l$$__typename = json['__typename'];
    return Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion(
      codigo: (l$codigo as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? codigo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$codigo = codigo;
    final l$$__typename = $__typename;
    return Object.hashAll([l$codigo, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RenovarSesion$renovarSesion$$ErrorAutenticacion ||
        runtimeType != other.runtimeType) {
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

class Variables$Mutation$CerrarSesion {
  factory Variables$Mutation$CerrarSesion({String? refreshToken}) =>
      Variables$Mutation$CerrarSesion._({
        if (refreshToken != null) r'refreshToken': refreshToken,
      });

  Variables$Mutation$CerrarSesion._(this._$data);

  factory Variables$Mutation$CerrarSesion.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('refreshToken')) {
      final l$refreshToken = data['refreshToken'];
      result$data['refreshToken'] = (l$refreshToken as String?);
    }
    return Variables$Mutation$CerrarSesion._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get refreshToken => (_$data['refreshToken'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('refreshToken')) {
      final l$refreshToken = refreshToken;
      result$data['refreshToken'] = l$refreshToken;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CerrarSesion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshToken = refreshToken;
    final lOther$refreshToken = other.refreshToken;
    if (_$data.containsKey('refreshToken') !=
        other._$data.containsKey('refreshToken')) {
      return false;
    }
    if (l$refreshToken != lOther$refreshToken) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$refreshToken = refreshToken;
    return Object.hashAll([
      _$data.containsKey('refreshToken') ? l$refreshToken : const {},
    ]);
  }
}

class Mutation$CerrarSesion {
  Mutation$CerrarSesion({
    required this.cerrarSesion,
    this.$__typename = 'Mutation',
  });

  factory Mutation$CerrarSesion.fromJson(Map<String, dynamic> json) {
    final l$cerrarSesion = json['cerrarSesion'];
    final l$$__typename = json['__typename'];
    return Mutation$CerrarSesion(
      cerrarSesion: (l$cerrarSesion as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool cerrarSesion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cerrarSesion = cerrarSesion;
    _resultData['cerrarSesion'] = l$cerrarSesion;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cerrarSesion = cerrarSesion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$cerrarSesion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CerrarSesion || runtimeType != other.runtimeType) {
      return false;
    }
    final l$cerrarSesion = cerrarSesion;
    final lOther$cerrarSesion = other.cerrarSesion;
    if (l$cerrarSesion != lOther$cerrarSesion) {
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

const documentNodeMutationCerrarSesion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CerrarSesion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'refreshToken')),
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
            name: NameNode(value: 'cerrarSesion'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'refreshToken'),
                value: VariableNode(name: NameNode(value: 'refreshToken')),
              ),
            ],
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
  ],
);
