// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import '../../../../core/contrato/schema.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Mutation$RegistrarConsentimiento {
  factory Variables$Mutation$RegistrarConsentimiento({
    required Input$ConsentimientoInput entrada,
  }) => Variables$Mutation$RegistrarConsentimiento._({r'entrada': entrada});

  Variables$Mutation$RegistrarConsentimiento._(this._$data);

  factory Variables$Mutation$RegistrarConsentimiento.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$entrada = data['entrada'];
    result$data['entrada'] = Input$ConsentimientoInput.fromJson(
      (l$entrada as Map<String, dynamic>),
    );
    return Variables$Mutation$RegistrarConsentimiento._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ConsentimientoInput get entrada =>
      (_$data['entrada'] as Input$ConsentimientoInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$entrada = entrada;
    result$data['entrada'] = l$entrada.toJson();
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RegistrarConsentimiento ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$entrada = entrada;
    final lOther$entrada = other.entrada;
    if (l$entrada != lOther$entrada) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$entrada = entrada;
    return Object.hashAll([l$entrada]);
  }
}

class Mutation$RegistrarConsentimiento {
  Mutation$RegistrarConsentimiento({
    required this.registrarConsentimiento,
    this.$__typename = 'Mutation',
  });

  factory Mutation$RegistrarConsentimiento.fromJson(Map<String, dynamic> json) {
    final l$registrarConsentimiento = json['registrarConsentimiento'];
    final l$$__typename = json['__typename'];
    return Mutation$RegistrarConsentimiento(
      registrarConsentimiento:
          Mutation$RegistrarConsentimiento$registrarConsentimiento.fromJson(
            (l$registrarConsentimiento as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$RegistrarConsentimiento$registrarConsentimiento
  registrarConsentimiento;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$registrarConsentimiento = registrarConsentimiento;
    _resultData['registrarConsentimiento'] = l$registrarConsentimiento.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$registrarConsentimiento = registrarConsentimiento;
    final l$$__typename = $__typename;
    return Object.hashAll([l$registrarConsentimiento, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegistrarConsentimiento ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$registrarConsentimiento = registrarConsentimiento;
    final lOther$registrarConsentimiento = other.registrarConsentimiento;
    if (l$registrarConsentimiento != lOther$registrarConsentimiento) {
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

const documentNodeMutationRegistrarConsentimiento = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RegistrarConsentimiento'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'entrada')),
          type: NamedTypeNode(
            name: NameNode(value: 'ConsentimientoInput'),
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
            name: NameNode(value: 'registrarConsentimiento'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'entrada'),
                value: VariableNode(name: NameNode(value: 'entrada')),
              ),
            ],
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
                  name: NameNode(value: 'finalidad'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'versionTexto'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'otorgadoEn'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'venceEn'),
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

class Mutation$RegistrarConsentimiento$registrarConsentimiento {
  Mutation$RegistrarConsentimiento$registrarConsentimiento({
    required this.id,
    required this.finalidad,
    required this.versionTexto,
    required this.otorgadoEn,
    required this.venceEn,
    required this.estado,
    this.$__typename = 'Consentimiento',
  });

  factory Mutation$RegistrarConsentimiento$registrarConsentimiento.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$finalidad = json['finalidad'];
    final l$versionTexto = json['versionTexto'];
    final l$otorgadoEn = json['otorgadoEn'];
    final l$venceEn = json['venceEn'];
    final l$estado = json['estado'];
    final l$$__typename = json['__typename'];
    return Mutation$RegistrarConsentimiento$registrarConsentimiento(
      id: (l$id as String),
      finalidad: (l$finalidad as String),
      versionTexto: (l$versionTexto as String),
      otorgadoEn: DateTime.parse((l$otorgadoEn as String)),
      venceEn: DateTime.parse((l$venceEn as String)),
      estado: fromJson$Enum$EstadoConsentimiento((l$estado as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String finalidad;

  final String versionTexto;

  final DateTime otorgadoEn;

  final DateTime venceEn;

  final Enum$EstadoConsentimiento estado;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$finalidad = finalidad;
    _resultData['finalidad'] = l$finalidad;
    final l$versionTexto = versionTexto;
    _resultData['versionTexto'] = l$versionTexto;
    final l$otorgadoEn = otorgadoEn;
    _resultData['otorgadoEn'] = l$otorgadoEn.toIso8601String();
    final l$venceEn = venceEn;
    _resultData['venceEn'] = l$venceEn.toIso8601String();
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoConsentimiento(l$estado);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$finalidad = finalidad;
    final l$versionTexto = versionTexto;
    final l$otorgadoEn = otorgadoEn;
    final l$venceEn = venceEn;
    final l$estado = estado;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$finalidad,
      l$versionTexto,
      l$otorgadoEn,
      l$venceEn,
      l$estado,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegistrarConsentimiento$registrarConsentimiento ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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
    final l$otorgadoEn = otorgadoEn;
    final lOther$otorgadoEn = other.otorgadoEn;
    if (l$otorgadoEn != lOther$otorgadoEn) {
      return false;
    }
    final l$venceEn = venceEn;
    final lOther$venceEn = other.venceEn;
    if (l$venceEn != lOther$venceEn) {
      return false;
    }
    final l$estado = estado;
    final lOther$estado = other.estado;
    if (l$estado != lOther$estado) {
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
