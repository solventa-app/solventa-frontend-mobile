// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import '../../contrato/schema.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$ConvertirMontos {
  factory Variables$Query$ConvertirMontos({
    required List<Input$MontoInput> montos,
    required String moneda,
  }) =>
      Variables$Query$ConvertirMontos._({r'montos': montos, r'moneda': moneda});

  Variables$Query$ConvertirMontos._(this._$data);

  factory Variables$Query$ConvertirMontos.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$montos = data['montos'];
    result$data['montos'] = (l$montos as List<dynamic>)
        .map((e) => Input$MontoInput.fromJson((e as Map<String, dynamic>)))
        .toList();
    final l$moneda = data['moneda'];
    result$data['moneda'] = (l$moneda as String);
    return Variables$Query$ConvertirMontos._(result$data);
  }

  Map<String, dynamic> _$data;

  List<Input$MontoInput> get montos =>
      (_$data['montos'] as List<Input$MontoInput>);

  String get moneda => (_$data['moneda'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$montos = montos;
    result$data['montos'] = l$montos.map((e) => e.toJson()).toList();
    final l$moneda = moneda;
    result$data['moneda'] = l$moneda;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$ConvertirMontos ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$montos = montos;
    final lOther$montos = other.montos;
    if (l$montos.length != lOther$montos.length) {
      return false;
    }
    for (int i = 0; i < l$montos.length; i++) {
      final l$montos$entry = l$montos[i];
      final lOther$montos$entry = lOther$montos[i];
      if (l$montos$entry != lOther$montos$entry) {
        return false;
      }
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
    final l$montos = montos;
    final l$moneda = moneda;
    return Object.hashAll([Object.hashAll(l$montos.map((v) => v)), l$moneda]);
  }
}

class Query$ConvertirMontos {
  Query$ConvertirMontos({
    required this.convertirMontos,
    this.$__typename = 'Query',
  });

  factory Query$ConvertirMontos.fromJson(Map<String, dynamic> json) {
    final l$convertirMontos = json['convertirMontos'];
    final l$$__typename = json['__typename'];
    return Query$ConvertirMontos(
      convertirMontos: (l$convertirMontos as List<dynamic>)
          .map(
            (e) => Query$ConvertirMontos$convertirMontos.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$ConvertirMontos$convertirMontos> convertirMontos;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$convertirMontos = convertirMontos;
    _resultData['convertirMontos'] = l$convertirMontos
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$convertirMontos = convertirMontos;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$convertirMontos.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ConvertirMontos || runtimeType != other.runtimeType) {
      return false;
    }
    final l$convertirMontos = convertirMontos;
    final lOther$convertirMontos = other.convertirMontos;
    if (l$convertirMontos.length != lOther$convertirMontos.length) {
      return false;
    }
    for (int i = 0; i < l$convertirMontos.length; i++) {
      final l$convertirMontos$entry = l$convertirMontos[i];
      final lOther$convertirMontos$entry = lOther$convertirMontos[i];
      if (l$convertirMontos$entry != lOther$convertirMontos$entry) {
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

const documentNodeQueryConvertirMontos = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'ConvertirMontos'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'montos')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'MontoInput'),
              isNonNull: true,
            ),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'moneda')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'convertirMontos'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'montos'),
                value: VariableNode(name: NameNode(value: 'montos')),
              ),
              ArgumentNode(
                name: NameNode(value: 'moneda'),
                value: VariableNode(name: NameNode(value: 'moneda')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'valor'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'moneda'),
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

class Query$ConvertirMontos$convertirMontos {
  Query$ConvertirMontos$convertirMontos({
    required this.valor,
    required this.moneda,
    this.$__typename = 'Monto',
  });

  factory Query$ConvertirMontos$convertirMontos.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$valor = json['valor'];
    final l$moneda = json['moneda'];
    final l$$__typename = json['__typename'];
    return Query$ConvertirMontos$convertirMontos(
      valor: (l$valor as String),
      moneda: (l$moneda as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String valor;

  final String moneda;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$valor = valor;
    _resultData['valor'] = l$valor;
    final l$moneda = moneda;
    _resultData['moneda'] = l$moneda;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$valor = valor;
    final l$moneda = moneda;
    final l$$__typename = $__typename;
    return Object.hashAll([l$valor, l$moneda, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ConvertirMontos$convertirMontos ||
        runtimeType != other.runtimeType) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}
