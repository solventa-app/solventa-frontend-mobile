// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import '../../../../core/contrato/schema.graphql.dart';

import 'package:gql/ast.dart';

class Fragment$OnboardingCampos {
  Fragment$OnboardingCampos({
    required this.id,
    required this.estado,
    this.motivo,
    required this.intento,
    required this.intentosRestantes,
    this.$__typename = 'Onboarding',
  });

  factory Fragment$OnboardingCampos.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$estado = json['estado'];
    final l$motivo = json['motivo'];
    final l$intento = json['intento'];
    final l$intentosRestantes = json['intentosRestantes'];
    final l$$__typename = json['__typename'];
    return Fragment$OnboardingCampos(
      id: (l$id as String),
      estado: fromJson$Enum$EstadoOnboarding((l$estado as String)),
      motivo: l$motivo == null
          ? null
          : fromJson$Enum$MotivoOnboarding((l$motivo as String)),
      intento: (l$intento as int),
      intentosRestantes: (l$intentosRestantes as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$EstadoOnboarding estado;

  final Enum$MotivoOnboarding? motivo;

  final int intento;

  final int intentosRestantes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoOnboarding(l$estado);
    final l$motivo = motivo;
    _resultData['motivo'] = l$motivo == null
        ? null
        : toJson$Enum$MotivoOnboarding(l$motivo);
    final l$intento = intento;
    _resultData['intento'] = l$intento;
    final l$intentosRestantes = intentosRestantes;
    _resultData['intentosRestantes'] = l$intentosRestantes;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$estado = estado;
    final l$motivo = motivo;
    final l$intento = intento;
    final l$intentosRestantes = intentosRestantes;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$estado,
      l$motivo,
      l$intento,
      l$intentosRestantes,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$OnboardingCampos ||
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
    final l$motivo = motivo;
    final lOther$motivo = other.motivo;
    if (l$motivo != lOther$motivo) {
      return false;
    }
    final l$intento = intento;
    final lOther$intento = other.intento;
    if (l$intento != lOther$intento) {
      return false;
    }
    final l$intentosRestantes = intentosRestantes;
    final lOther$intentosRestantes = other.intentosRestantes;
    if (l$intentosRestantes != lOther$intentosRestantes) {
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

const fragmentDefinitionOnboardingCampos = FragmentDefinitionNode(
  name: NameNode(value: 'OnboardingCampos'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Onboarding'), isNonNull: false),
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
        name: NameNode(value: 'motivo'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'intento'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'intentosRestantes'),
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
);
const documentNodeFragmentOnboardingCampos = DocumentNode(
  definitions: [fragmentDefinitionOnboardingCampos],
);

class Fragment$ErrorOnboardingCampos {
  Fragment$ErrorOnboardingCampos({
    required this.codigo,
    this.$__typename = 'ErrorOnboarding',
  });

  factory Fragment$ErrorOnboardingCampos.fromJson(Map<String, dynamic> json) {
    final l$codigo = json['codigo'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorOnboardingCampos(
      codigo: (l$codigo as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String codigo;

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
    if (other is! Fragment$ErrorOnboardingCampos ||
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

const fragmentDefinitionErrorOnboardingCampos = FragmentDefinitionNode(
  name: NameNode(value: 'ErrorOnboardingCampos'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'ErrorOnboarding'),
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
);
const documentNodeFragmentErrorOnboardingCampos = DocumentNode(
  definitions: [fragmentDefinitionErrorOnboardingCampos],
);

class Variables$Mutation$IniciarOnboarding {
  factory Variables$Mutation$IniciarOnboarding({
    required Input$IniciarOnboardingInput entrada,
  }) => Variables$Mutation$IniciarOnboarding._({r'entrada': entrada});

  Variables$Mutation$IniciarOnboarding._(this._$data);

  factory Variables$Mutation$IniciarOnboarding.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$entrada = data['entrada'];
    result$data['entrada'] = Input$IniciarOnboardingInput.fromJson(
      (l$entrada as Map<String, dynamic>),
    );
    return Variables$Mutation$IniciarOnboarding._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$IniciarOnboardingInput get entrada =>
      (_$data['entrada'] as Input$IniciarOnboardingInput);

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
    if (other is! Variables$Mutation$IniciarOnboarding ||
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

class Mutation$IniciarOnboarding {
  Mutation$IniciarOnboarding({
    required this.iniciarOnboarding,
    this.$__typename = 'Mutation',
  });

  factory Mutation$IniciarOnboarding.fromJson(Map<String, dynamic> json) {
    final l$iniciarOnboarding = json['iniciarOnboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$IniciarOnboarding(
      iniciarOnboarding: Mutation$IniciarOnboarding$iniciarOnboarding.fromJson(
        (l$iniciarOnboarding as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$IniciarOnboarding$iniciarOnboarding iniciarOnboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$iniciarOnboarding = iniciarOnboarding;
    _resultData['iniciarOnboarding'] = l$iniciarOnboarding.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$iniciarOnboarding = iniciarOnboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$iniciarOnboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$IniciarOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$iniciarOnboarding = iniciarOnboarding;
    final lOther$iniciarOnboarding = other.iniciarOnboarding;
    if (l$iniciarOnboarding != lOther$iniciarOnboarding) {
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

const documentNodeMutationIniciarOnboarding = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'IniciarOnboarding'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'entrada')),
          type: NamedTypeNode(
            name: NameNode(value: 'IniciarOnboardingInput'),
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
            name: NameNode(value: 'iniciarOnboarding'),
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
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'InicioOnboarding'),
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
                        name: NameNode(value: 'tokenVenceEn'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'onboarding'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'OnboardingCampos'),
                              directives: [],
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
                FragmentSpreadNode(
                  name: NameNode(value: 'ErrorOnboardingCampos'),
                  directives: [],
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
    fragmentDefinitionOnboardingCampos,
    fragmentDefinitionErrorOnboardingCampos,
  ],
);

class Mutation$IniciarOnboarding$iniciarOnboarding {
  Mutation$IniciarOnboarding$iniciarOnboarding({required this.$__typename});

  factory Mutation$IniciarOnboarding$iniciarOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "InicioOnboarding":
        return Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding.fromJson(
          json,
        );

      case "ErrorOnboarding":
        return Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$IniciarOnboarding$iniciarOnboarding(
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
    if (other is! Mutation$IniciarOnboarding$iniciarOnboarding ||
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

extension UtilityExtension$Mutation$IniciarOnboarding$iniciarOnboarding
    on Mutation$IniciarOnboarding$iniciarOnboarding {
  _T when<_T>({
    required _T Function(
      Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding,
    )
    inicioOnboarding,
    required _T Function(
      Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding,
    )
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "InicioOnboarding":
        return inicioOnboarding(
          this
              as Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding,
        );

      case "ErrorOnboarding":
        return errorOnboarding(
          this as Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding)?
    inicioOnboarding,
    _T Function(Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding)?
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "InicioOnboarding":
        if (inicioOnboarding != null) {
          return inicioOnboarding(
            this
                as Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding,
          );
        } else {
          return orElse();
        }

      case "ErrorOnboarding":
        if (errorOnboarding != null) {
          return errorOnboarding(
            this
                as Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding
    implements Mutation$IniciarOnboarding$iniciarOnboarding {
  Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding({
    required this.token,
    required this.tokenVenceEn,
    required this.onboarding,
    this.$__typename = 'InicioOnboarding',
  });

  factory Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$token = json['token'];
    final l$tokenVenceEn = json['tokenVenceEn'];
    final l$onboarding = json['onboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding(
      token: (l$token as String),
      tokenVenceEn: DateTime.parse((l$tokenVenceEn as String)),
      onboarding: Fragment$OnboardingCampos.fromJson(
        (l$onboarding as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String token;

  final DateTime tokenVenceEn;

  final Fragment$OnboardingCampos onboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$token = token;
    _resultData['token'] = l$token;
    final l$tokenVenceEn = tokenVenceEn;
    _resultData['tokenVenceEn'] = l$tokenVenceEn.toIso8601String();
    final l$onboarding = onboarding;
    _resultData['onboarding'] = l$onboarding.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$token = token;
    final l$tokenVenceEn = tokenVenceEn;
    final l$onboarding = onboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$token,
      l$tokenVenceEn,
      l$onboarding,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$token = token;
    final lOther$token = other.token;
    if (l$token != lOther$token) {
      return false;
    }
    final l$tokenVenceEn = tokenVenceEn;
    final lOther$tokenVenceEn = other.tokenVenceEn;
    if (l$tokenVenceEn != lOther$tokenVenceEn) {
      return false;
    }
    final l$onboarding = onboarding;
    final lOther$onboarding = other.onboarding;
    if (l$onboarding != lOther$onboarding) {
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

class Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$IniciarOnboarding$iniciarOnboarding {
  Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
  });

  factory Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    return Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
    );
  }

  final String $__typename;

  final String codigo;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    return Object.hashAll([l$$__typename, l$codigo]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$RegistrarConsentimientoOnboarding {
  factory Variables$Mutation$RegistrarConsentimientoOnboarding({
    required String onboardingId,
    required String versionTexto,
  }) => Variables$Mutation$RegistrarConsentimientoOnboarding._({
    r'onboardingId': onboardingId,
    r'versionTexto': versionTexto,
  });

  Variables$Mutation$RegistrarConsentimientoOnboarding._(this._$data);

  factory Variables$Mutation$RegistrarConsentimientoOnboarding.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$onboardingId = data['onboardingId'];
    result$data['onboardingId'] = (l$onboardingId as String);
    final l$versionTexto = data['versionTexto'];
    result$data['versionTexto'] = (l$versionTexto as String);
    return Variables$Mutation$RegistrarConsentimientoOnboarding._(result$data);
  }

  Map<String, dynamic> _$data;

  String get onboardingId => (_$data['onboardingId'] as String);

  String get versionTexto => (_$data['versionTexto'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$onboardingId = onboardingId;
    result$data['onboardingId'] = l$onboardingId;
    final l$versionTexto = versionTexto;
    result$data['versionTexto'] = l$versionTexto;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RegistrarConsentimientoOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$onboardingId = onboardingId;
    final lOther$onboardingId = other.onboardingId;
    if (l$onboardingId != lOther$onboardingId) {
      return false;
    }
    final l$versionTexto = versionTexto;
    final lOther$versionTexto = other.versionTexto;
    if (l$versionTexto != lOther$versionTexto) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$onboardingId = onboardingId;
    final l$versionTexto = versionTexto;
    return Object.hashAll([l$onboardingId, l$versionTexto]);
  }
}

class Mutation$RegistrarConsentimientoOnboarding {
  Mutation$RegistrarConsentimientoOnboarding({
    required this.registrarConsentimientoOnboarding,
    this.$__typename = 'Mutation',
  });

  factory Mutation$RegistrarConsentimientoOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$registrarConsentimientoOnboarding =
        json['registrarConsentimientoOnboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$RegistrarConsentimientoOnboarding(
      registrarConsentimientoOnboarding:
          Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding.fromJson(
            (l$registrarConsentimientoOnboarding as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding
  registrarConsentimientoOnboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$registrarConsentimientoOnboarding =
        registrarConsentimientoOnboarding;
    _resultData['registrarConsentimientoOnboarding'] =
        l$registrarConsentimientoOnboarding.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$registrarConsentimientoOnboarding =
        registrarConsentimientoOnboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$registrarConsentimientoOnboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegistrarConsentimientoOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$registrarConsentimientoOnboarding =
        registrarConsentimientoOnboarding;
    final lOther$registrarConsentimientoOnboarding =
        other.registrarConsentimientoOnboarding;
    if (l$registrarConsentimientoOnboarding !=
        lOther$registrarConsentimientoOnboarding) {
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

const documentNodeMutationRegistrarConsentimientoOnboarding = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RegistrarConsentimientoOnboarding'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'onboardingId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'versionTexto')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'registrarConsentimientoOnboarding'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'onboardingId'),
                value: VariableNode(name: NameNode(value: 'onboardingId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'versionTexto'),
                value: VariableNode(name: NameNode(value: 'versionTexto')),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'OnboardingCampos'),
                  directives: [],
                ),
                FragmentSpreadNode(
                  name: NameNode(value: 'ErrorOnboardingCampos'),
                  directives: [],
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
    fragmentDefinitionOnboardingCampos,
    fragmentDefinitionErrorOnboardingCampos,
  ],
);

class Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding {
  Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding({
    required this.$__typename,
  });

  factory Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Onboarding":
        return Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding.fromJson(
          json,
        );

      case "ErrorOnboarding":
        return Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding(
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
    if (other
            is! Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding ||
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

extension UtilityExtension$Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding
    on Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding {
  _T when<_T>({
    required _T Function(
      Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding,
    )
    onboarding,
    required _T Function(
      Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding,
    )
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Onboarding":
        return onboarding(
          this
              as Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding,
        );

      case "ErrorOnboarding":
        return errorOnboarding(
          this
              as Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding,
    )?
    onboarding,
    _T Function(
      Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding,
    )?
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Onboarding":
        if (onboarding != null) {
          return onboarding(
            this
                as Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding,
          );
        } else {
          return orElse();
        }

      case "ErrorOnboarding":
        if (errorOnboarding != null) {
          return errorOnboarding(
            this
                as Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding
    implements
        Fragment$OnboardingCampos,
        Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding {
  Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding({
    this.$__typename = 'Onboarding',
    required this.id,
    required this.estado,
    this.motivo,
    required this.intento,
    required this.intentosRestantes,
  });

  factory Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$estado = json['estado'];
    final l$motivo = json['motivo'];
    final l$intento = json['intento'];
    final l$intentosRestantes = json['intentosRestantes'];
    return Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      estado: fromJson$Enum$EstadoOnboarding((l$estado as String)),
      motivo: l$motivo == null
          ? null
          : fromJson$Enum$MotivoOnboarding((l$motivo as String)),
      intento: (l$intento as int),
      intentosRestantes: (l$intentosRestantes as int),
    );
  }

  final String $__typename;

  final String id;

  final Enum$EstadoOnboarding estado;

  final Enum$MotivoOnboarding? motivo;

  final int intento;

  final int intentosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoOnboarding(l$estado);
    final l$motivo = motivo;
    _resultData['motivo'] = l$motivo == null
        ? null
        : toJson$Enum$MotivoOnboarding(l$motivo);
    final l$intento = intento;
    _resultData['intento'] = l$intento;
    final l$intentosRestantes = intentosRestantes;
    _resultData['intentosRestantes'] = l$intentosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$estado = estado;
    final l$motivo = motivo;
    final l$intento = intento;
    final l$intentosRestantes = intentosRestantes;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$estado,
      l$motivo,
      l$intento,
      l$intentosRestantes,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$Onboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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
    final l$motivo = motivo;
    final lOther$motivo = other.motivo;
    if (l$motivo != lOther$motivo) {
      return false;
    }
    final l$intento = intento;
    final lOther$intento = other.intento;
    if (l$intento != lOther$intento) {
      return false;
    }
    final l$intentosRestantes = intentosRestantes;
    final lOther$intentosRestantes = other.intentosRestantes;
    if (l$intentosRestantes != lOther$intentosRestantes) {
      return false;
    }
    return true;
  }
}

class Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding {
  Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
  });

  factory Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    return Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
    );
  }

  final String $__typename;

  final String codigo;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    return Object.hashAll([l$$__typename, l$codigo]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$SolicitarSubidaOnboarding {
  factory Variables$Mutation$SolicitarSubidaOnboarding({
    required String onboardingId,
    required Enum$PasoOnboarding paso,
    required String tipoContenido,
    required int tamanoBytes,
  }) => Variables$Mutation$SolicitarSubidaOnboarding._({
    r'onboardingId': onboardingId,
    r'paso': paso,
    r'tipoContenido': tipoContenido,
    r'tamanoBytes': tamanoBytes,
  });

  Variables$Mutation$SolicitarSubidaOnboarding._(this._$data);

  factory Variables$Mutation$SolicitarSubidaOnboarding.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$onboardingId = data['onboardingId'];
    result$data['onboardingId'] = (l$onboardingId as String);
    final l$paso = data['paso'];
    result$data['paso'] = fromJson$Enum$PasoOnboarding((l$paso as String));
    final l$tipoContenido = data['tipoContenido'];
    result$data['tipoContenido'] = (l$tipoContenido as String);
    final l$tamanoBytes = data['tamanoBytes'];
    result$data['tamanoBytes'] = (l$tamanoBytes as int);
    return Variables$Mutation$SolicitarSubidaOnboarding._(result$data);
  }

  Map<String, dynamic> _$data;

  String get onboardingId => (_$data['onboardingId'] as String);

  Enum$PasoOnboarding get paso => (_$data['paso'] as Enum$PasoOnboarding);

  String get tipoContenido => (_$data['tipoContenido'] as String);

  int get tamanoBytes => (_$data['tamanoBytes'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$onboardingId = onboardingId;
    result$data['onboardingId'] = l$onboardingId;
    final l$paso = paso;
    result$data['paso'] = toJson$Enum$PasoOnboarding(l$paso);
    final l$tipoContenido = tipoContenido;
    result$data['tipoContenido'] = l$tipoContenido;
    final l$tamanoBytes = tamanoBytes;
    result$data['tamanoBytes'] = l$tamanoBytes;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$SolicitarSubidaOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$onboardingId = onboardingId;
    final lOther$onboardingId = other.onboardingId;
    if (l$onboardingId != lOther$onboardingId) {
      return false;
    }
    final l$paso = paso;
    final lOther$paso = other.paso;
    if (l$paso != lOther$paso) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$onboardingId = onboardingId;
    final l$paso = paso;
    final l$tipoContenido = tipoContenido;
    final l$tamanoBytes = tamanoBytes;
    return Object.hashAll([
      l$onboardingId,
      l$paso,
      l$tipoContenido,
      l$tamanoBytes,
    ]);
  }
}

class Mutation$SolicitarSubidaOnboarding {
  Mutation$SolicitarSubidaOnboarding({
    required this.solicitarSubidaOnboarding,
    this.$__typename = 'Mutation',
  });

  factory Mutation$SolicitarSubidaOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$solicitarSubidaOnboarding = json['solicitarSubidaOnboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarSubidaOnboarding(
      solicitarSubidaOnboarding:
          Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding.fromJson(
            (l$solicitarSubidaOnboarding as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding
  solicitarSubidaOnboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$solicitarSubidaOnboarding = solicitarSubidaOnboarding;
    _resultData['solicitarSubidaOnboarding'] = l$solicitarSubidaOnboarding
        .toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$solicitarSubidaOnboarding = solicitarSubidaOnboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$solicitarSubidaOnboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SolicitarSubidaOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$solicitarSubidaOnboarding = solicitarSubidaOnboarding;
    final lOther$solicitarSubidaOnboarding = other.solicitarSubidaOnboarding;
    if (l$solicitarSubidaOnboarding != lOther$solicitarSubidaOnboarding) {
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

const documentNodeMutationSolicitarSubidaOnboarding = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SolicitarSubidaOnboarding'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'onboardingId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'paso')),
          type: NamedTypeNode(
            name: NameNode(value: 'PasoOnboarding'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'tipoContenido')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'tamanoBytes')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'solicitarSubidaOnboarding'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'onboardingId'),
                value: VariableNode(name: NameNode(value: 'onboardingId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'paso'),
                value: VariableNode(name: NameNode(value: 'paso')),
              ),
              ArgumentNode(
                name: NameNode(value: 'tipoContenido'),
                value: VariableNode(name: NameNode(value: 'tipoContenido')),
              ),
              ArgumentNode(
                name: NameNode(value: 'tamanoBytes'),
                value: VariableNode(name: NameNode(value: 'tamanoBytes')),
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
                      name: NameNode(value: 'SubidaArchivo'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'url'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'metodo'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'encabezados'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'nombre'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'valor'),
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
                        name: NameNode(value: 'archivo'),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'ErrorOnboardingCampos'),
                  directives: [],
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
    fragmentDefinitionErrorOnboardingCampos,
  ],
);

class Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding {
  Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding({
    required this.$__typename,
  });

  factory Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "SubidaArchivo":
        return Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo.fromJson(
          json,
        );

      case "ErrorOnboarding":
        return Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding(
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
    if (other
            is! Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding ||
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

extension UtilityExtension$Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding
    on Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding {
  _T when<_T>({
    required _T Function(
      Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo,
    )
    subidaArchivo,
    required _T Function(
      Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding,
    )
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "SubidaArchivo":
        return subidaArchivo(
          this
              as Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo,
        );

      case "ErrorOnboarding":
        return errorOnboarding(
          this
              as Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo,
    )?
    subidaArchivo,
    _T Function(
      Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding,
    )?
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "SubidaArchivo":
        if (subidaArchivo != null) {
          return subidaArchivo(
            this
                as Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo,
          );
        } else {
          return orElse();
        }

      case "ErrorOnboarding":
        if (errorOnboarding != null) {
          return errorOnboarding(
            this
                as Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo
    implements Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding {
  Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo({
    required this.url,
    required this.metodo,
    required this.encabezados,
    required this.archivo,
    this.$__typename = 'SubidaArchivo',
  });

  factory Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$metodo = json['metodo'];
    final l$encabezados = json['encabezados'];
    final l$archivo = json['archivo'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo(
      url: (l$url as String),
      metodo: (l$metodo as String),
      encabezados: (l$encabezados as List<dynamic>)
          .map(
            (e) =>
                Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$encabezados.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      archivo:
          Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$archivo.fromJson(
            (l$archivo as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final String url;

  final String metodo;

  final List<
    Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$encabezados
  >
  encabezados;

  final Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$archivo
  archivo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$url = url;
    _resultData['url'] = l$url;
    final l$metodo = metodo;
    _resultData['metodo'] = l$metodo;
    final l$encabezados = encabezados;
    _resultData['encabezados'] = l$encabezados.map((e) => e.toJson()).toList();
    final l$archivo = archivo;
    _resultData['archivo'] = l$archivo.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$url = url;
    final l$metodo = metodo;
    final l$encabezados = encabezados;
    final l$archivo = archivo;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$url,
      l$metodo,
      Object.hashAll(l$encabezados.map((v) => v)),
      l$archivo,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    final l$metodo = metodo;
    final lOther$metodo = other.metodo;
    if (l$metodo != lOther$metodo) {
      return false;
    }
    final l$encabezados = encabezados;
    final lOther$encabezados = other.encabezados;
    if (l$encabezados.length != lOther$encabezados.length) {
      return false;
    }
    for (int i = 0; i < l$encabezados.length; i++) {
      final l$encabezados$entry = l$encabezados[i];
      final lOther$encabezados$entry = lOther$encabezados[i];
      if (l$encabezados$entry != lOther$encabezados$entry) {
        return false;
      }
    }
    final l$archivo = archivo;
    final lOther$archivo = other.archivo;
    if (l$archivo != lOther$archivo) {
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

class Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$encabezados {
  Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$encabezados({
    required this.nombre,
    required this.valor,
    this.$__typename = 'EncabezadoSubida',
  });

  factory Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$encabezados.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$nombre = json['nombre'];
    final l$valor = json['valor'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$encabezados(
      nombre: (l$nombre as String),
      valor: (l$valor as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String nombre;

  final String valor;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$nombre = nombre;
    _resultData['nombre'] = l$nombre;
    final l$valor = valor;
    _resultData['valor'] = l$valor;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$nombre = nombre;
    final l$valor = valor;
    final l$$__typename = $__typename;
    return Object.hashAll([l$nombre, l$valor, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$encabezados ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$nombre = nombre;
    final lOther$nombre = other.nombre;
    if (l$nombre != lOther$nombre) {
      return false;
    }
    final l$valor = valor;
    final lOther$valor = other.valor;
    if (l$valor != lOther$valor) {
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

class Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$archivo {
  Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$archivo({
    required this.id,
    this.$__typename = 'Archivo',
  });

  factory Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$archivo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$archivo(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo$archivo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

class Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding {
  Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
  });

  factory Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    return Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
    );
  }

  final String $__typename;

  final String codigo;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    return Object.hashAll([l$$__typename, l$codigo]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$ConfirmarSubidaOnboarding {
  factory Variables$Mutation$ConfirmarSubidaOnboarding({
    required String onboardingId,
    required String archivoId,
  }) => Variables$Mutation$ConfirmarSubidaOnboarding._({
    r'onboardingId': onboardingId,
    r'archivoId': archivoId,
  });

  Variables$Mutation$ConfirmarSubidaOnboarding._(this._$data);

  factory Variables$Mutation$ConfirmarSubidaOnboarding.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$onboardingId = data['onboardingId'];
    result$data['onboardingId'] = (l$onboardingId as String);
    final l$archivoId = data['archivoId'];
    result$data['archivoId'] = (l$archivoId as String);
    return Variables$Mutation$ConfirmarSubidaOnboarding._(result$data);
  }

  Map<String, dynamic> _$data;

  String get onboardingId => (_$data['onboardingId'] as String);

  String get archivoId => (_$data['archivoId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$onboardingId = onboardingId;
    result$data['onboardingId'] = l$onboardingId;
    final l$archivoId = archivoId;
    result$data['archivoId'] = l$archivoId;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ConfirmarSubidaOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$onboardingId = onboardingId;
    final lOther$onboardingId = other.onboardingId;
    if (l$onboardingId != lOther$onboardingId) {
      return false;
    }
    final l$archivoId = archivoId;
    final lOther$archivoId = other.archivoId;
    if (l$archivoId != lOther$archivoId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$onboardingId = onboardingId;
    final l$archivoId = archivoId;
    return Object.hashAll([l$onboardingId, l$archivoId]);
  }
}

class Mutation$ConfirmarSubidaOnboarding {
  Mutation$ConfirmarSubidaOnboarding({
    required this.confirmarSubidaOnboarding,
    this.$__typename = 'Mutation',
  });

  factory Mutation$ConfirmarSubidaOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$confirmarSubidaOnboarding = json['confirmarSubidaOnboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmarSubidaOnboarding(
      confirmarSubidaOnboarding:
          Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding.fromJson(
            (l$confirmarSubidaOnboarding as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding
  confirmarSubidaOnboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$confirmarSubidaOnboarding = confirmarSubidaOnboarding;
    _resultData['confirmarSubidaOnboarding'] = l$confirmarSubidaOnboarding
        .toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$confirmarSubidaOnboarding = confirmarSubidaOnboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$confirmarSubidaOnboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmarSubidaOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$confirmarSubidaOnboarding = confirmarSubidaOnboarding;
    final lOther$confirmarSubidaOnboarding = other.confirmarSubidaOnboarding;
    if (l$confirmarSubidaOnboarding != lOther$confirmarSubidaOnboarding) {
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

const documentNodeMutationConfirmarSubidaOnboarding = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ConfirmarSubidaOnboarding'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'onboardingId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'archivoId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'confirmarSubidaOnboarding'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'onboardingId'),
                value: VariableNode(name: NameNode(value: 'onboardingId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'archivoId'),
                value: VariableNode(name: NameNode(value: 'archivoId')),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'OnboardingCampos'),
                  directives: [],
                ),
                FragmentSpreadNode(
                  name: NameNode(value: 'ErrorOnboardingCampos'),
                  directives: [],
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
    fragmentDefinitionOnboardingCampos,
    fragmentDefinitionErrorOnboardingCampos,
  ],
);

class Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding {
  Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding({
    required this.$__typename,
  });

  factory Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Onboarding":
        return Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding.fromJson(
          json,
        );

      case "ErrorOnboarding":
        return Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding(
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
    if (other
            is! Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding ||
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

extension UtilityExtension$Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding
    on Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding {
  _T when<_T>({
    required _T Function(
      Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding,
    )
    onboarding,
    required _T Function(
      Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding,
    )
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Onboarding":
        return onboarding(
          this
              as Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding,
        );

      case "ErrorOnboarding":
        return errorOnboarding(
          this
              as Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding,
    )?
    onboarding,
    _T Function(
      Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding,
    )?
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Onboarding":
        if (onboarding != null) {
          return onboarding(
            this
                as Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding,
          );
        } else {
          return orElse();
        }

      case "ErrorOnboarding":
        if (errorOnboarding != null) {
          return errorOnboarding(
            this
                as Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding
    implements
        Fragment$OnboardingCampos,
        Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding {
  Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding({
    this.$__typename = 'Onboarding',
    required this.id,
    required this.estado,
    this.motivo,
    required this.intento,
    required this.intentosRestantes,
  });

  factory Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$estado = json['estado'];
    final l$motivo = json['motivo'];
    final l$intento = json['intento'];
    final l$intentosRestantes = json['intentosRestantes'];
    return Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      estado: fromJson$Enum$EstadoOnboarding((l$estado as String)),
      motivo: l$motivo == null
          ? null
          : fromJson$Enum$MotivoOnboarding((l$motivo as String)),
      intento: (l$intento as int),
      intentosRestantes: (l$intentosRestantes as int),
    );
  }

  final String $__typename;

  final String id;

  final Enum$EstadoOnboarding estado;

  final Enum$MotivoOnboarding? motivo;

  final int intento;

  final int intentosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoOnboarding(l$estado);
    final l$motivo = motivo;
    _resultData['motivo'] = l$motivo == null
        ? null
        : toJson$Enum$MotivoOnboarding(l$motivo);
    final l$intento = intento;
    _resultData['intento'] = l$intento;
    final l$intentosRestantes = intentosRestantes;
    _resultData['intentosRestantes'] = l$intentosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$estado = estado;
    final l$motivo = motivo;
    final l$intento = intento;
    final l$intentosRestantes = intentosRestantes;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$estado,
      l$motivo,
      l$intento,
      l$intentosRestantes,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$Onboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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
    final l$motivo = motivo;
    final lOther$motivo = other.motivo;
    if (l$motivo != lOther$motivo) {
      return false;
    }
    final l$intento = intento;
    final lOther$intento = other.intento;
    if (l$intento != lOther$intento) {
      return false;
    }
    final l$intentosRestantes = intentosRestantes;
    final lOther$intentosRestantes = other.intentosRestantes;
    if (l$intentosRestantes != lOther$intentosRestantes) {
      return false;
    }
    return true;
  }
}

class Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding {
  Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
  });

  factory Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    return Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
    );
  }

  final String $__typename;

  final String codigo;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    return Object.hashAll([l$$__typename, l$codigo]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$CrearCuentaOnboarding {
  factory Variables$Mutation$CrearCuentaOnboarding({
    required String onboardingId,
    required Input$CuentaOnboardingInput entrada,
  }) => Variables$Mutation$CrearCuentaOnboarding._({
    r'onboardingId': onboardingId,
    r'entrada': entrada,
  });

  Variables$Mutation$CrearCuentaOnboarding._(this._$data);

  factory Variables$Mutation$CrearCuentaOnboarding.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$onboardingId = data['onboardingId'];
    result$data['onboardingId'] = (l$onboardingId as String);
    final l$entrada = data['entrada'];
    result$data['entrada'] = Input$CuentaOnboardingInput.fromJson(
      (l$entrada as Map<String, dynamic>),
    );
    return Variables$Mutation$CrearCuentaOnboarding._(result$data);
  }

  Map<String, dynamic> _$data;

  String get onboardingId => (_$data['onboardingId'] as String);

  Input$CuentaOnboardingInput get entrada =>
      (_$data['entrada'] as Input$CuentaOnboardingInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$onboardingId = onboardingId;
    result$data['onboardingId'] = l$onboardingId;
    final l$entrada = entrada;
    result$data['entrada'] = l$entrada.toJson();
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$CrearCuentaOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$onboardingId = onboardingId;
    final lOther$onboardingId = other.onboardingId;
    if (l$onboardingId != lOther$onboardingId) {
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
    final l$onboardingId = onboardingId;
    final l$entrada = entrada;
    return Object.hashAll([l$onboardingId, l$entrada]);
  }
}

class Mutation$CrearCuentaOnboarding {
  Mutation$CrearCuentaOnboarding({
    required this.crearCuentaOnboarding,
    this.$__typename = 'Mutation',
  });

  factory Mutation$CrearCuentaOnboarding.fromJson(Map<String, dynamic> json) {
    final l$crearCuentaOnboarding = json['crearCuentaOnboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$CrearCuentaOnboarding(
      crearCuentaOnboarding:
          Mutation$CrearCuentaOnboarding$crearCuentaOnboarding.fromJson(
            (l$crearCuentaOnboarding as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$CrearCuentaOnboarding$crearCuentaOnboarding
  crearCuentaOnboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$crearCuentaOnboarding = crearCuentaOnboarding;
    _resultData['crearCuentaOnboarding'] = l$crearCuentaOnboarding.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$crearCuentaOnboarding = crearCuentaOnboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$crearCuentaOnboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CrearCuentaOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$crearCuentaOnboarding = crearCuentaOnboarding;
    final lOther$crearCuentaOnboarding = other.crearCuentaOnboarding;
    if (l$crearCuentaOnboarding != lOther$crearCuentaOnboarding) {
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

const documentNodeMutationCrearCuentaOnboarding = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CrearCuentaOnboarding'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'onboardingId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'entrada')),
          type: NamedTypeNode(
            name: NameNode(value: 'CuentaOnboardingInput'),
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
            name: NameNode(value: 'crearCuentaOnboarding'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'onboardingId'),
                value: VariableNode(name: NameNode(value: 'onboardingId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'entrada'),
                value: VariableNode(name: NameNode(value: 'entrada')),
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
                      name: NameNode(value: 'CuentaOnboarding'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'sesion'),
                        alias: null,
                        arguments: [],
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
                        name: NameNode(value: 'onboarding'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'OnboardingCampos'),
                              directives: [],
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
                FragmentSpreadNode(
                  name: NameNode(value: 'ErrorOnboardingCampos'),
                  directives: [],
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
    fragmentDefinitionOnboardingCampos,
    fragmentDefinitionErrorOnboardingCampos,
  ],
);

class Mutation$CrearCuentaOnboarding$crearCuentaOnboarding {
  Mutation$CrearCuentaOnboarding$crearCuentaOnboarding({
    required this.$__typename,
  });

  factory Mutation$CrearCuentaOnboarding$crearCuentaOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "CuentaOnboarding":
        return Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding.fromJson(
          json,
        );

      case "ErrorOnboarding":
        return Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$CrearCuentaOnboarding$crearCuentaOnboarding(
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
    if (other is! Mutation$CrearCuentaOnboarding$crearCuentaOnboarding ||
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

extension UtilityExtension$Mutation$CrearCuentaOnboarding$crearCuentaOnboarding
    on Mutation$CrearCuentaOnboarding$crearCuentaOnboarding {
  _T when<_T>({
    required _T Function(
      Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding,
    )
    cuentaOnboarding,
    required _T Function(
      Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding,
    )
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CuentaOnboarding":
        return cuentaOnboarding(
          this
              as Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding,
        );

      case "ErrorOnboarding":
        return errorOnboarding(
          this
              as Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding,
    )?
    cuentaOnboarding,
    _T Function(
      Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding,
    )?
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CuentaOnboarding":
        if (cuentaOnboarding != null) {
          return cuentaOnboarding(
            this
                as Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding,
          );
        } else {
          return orElse();
        }

      case "ErrorOnboarding":
        if (errorOnboarding != null) {
          return errorOnboarding(
            this
                as Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding
    implements Mutation$CrearCuentaOnboarding$crearCuentaOnboarding {
  Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding({
    required this.sesion,
    required this.onboarding,
    this.$__typename = 'CuentaOnboarding',
  });

  factory Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$sesion = json['sesion'];
    final l$onboarding = json['onboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding(
      sesion:
          Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding$sesion.fromJson(
            (l$sesion as Map<String, dynamic>),
          ),
      onboarding: Fragment$OnboardingCampos.fromJson(
        (l$onboarding as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding$sesion
  sesion;

  final Fragment$OnboardingCampos onboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sesion = sesion;
    _resultData['sesion'] = l$sesion.toJson();
    final l$onboarding = onboarding;
    _resultData['onboarding'] = l$onboarding.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sesion = sesion;
    final l$onboarding = onboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sesion, l$onboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sesion = sesion;
    final lOther$sesion = other.sesion;
    if (l$sesion != lOther$sesion) {
      return false;
    }
    final l$onboarding = onboarding;
    final lOther$onboarding = other.onboarding;
    if (l$onboarding != lOther$onboarding) {
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

class Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding$sesion {
  Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding$sesion({
    required this.token,
    required this.expiraEn,
    this.$__typename = 'Sesion',
  });

  factory Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding$sesion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$token = json['token'];
    final l$expiraEn = json['expiraEn'];
    final l$$__typename = json['__typename'];
    return Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding$sesion(
      token: (l$token as String),
      expiraEn: DateTime.parse((l$expiraEn as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String token;

  final DateTime expiraEn;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$token = token;
    _resultData['token'] = l$token;
    final l$expiraEn = expiraEn;
    _resultData['expiraEn'] = l$expiraEn.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$token = token;
    final l$expiraEn = expiraEn;
    final l$$__typename = $__typename;
    return Object.hashAll([l$token, l$expiraEn, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding$sesion ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$CrearCuentaOnboarding$crearCuentaOnboarding {
  Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
  });

  factory Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    return Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
    );
  }

  final String $__typename;

  final String codigo;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    return Object.hashAll([l$$__typename, l$codigo]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$EnviarVerificacion {
  factory Variables$Mutation$EnviarVerificacion({
    required String onboardingId,
  }) =>
      Variables$Mutation$EnviarVerificacion._({r'onboardingId': onboardingId});

  Variables$Mutation$EnviarVerificacion._(this._$data);

  factory Variables$Mutation$EnviarVerificacion.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$onboardingId = data['onboardingId'];
    result$data['onboardingId'] = (l$onboardingId as String);
    return Variables$Mutation$EnviarVerificacion._(result$data);
  }

  Map<String, dynamic> _$data;

  String get onboardingId => (_$data['onboardingId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$onboardingId = onboardingId;
    result$data['onboardingId'] = l$onboardingId;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$EnviarVerificacion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$onboardingId = onboardingId;
    final lOther$onboardingId = other.onboardingId;
    if (l$onboardingId != lOther$onboardingId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$onboardingId = onboardingId;
    return Object.hashAll([l$onboardingId]);
  }
}

class Mutation$EnviarVerificacion {
  Mutation$EnviarVerificacion({
    required this.enviarVerificacion,
    this.$__typename = 'Mutation',
  });

  factory Mutation$EnviarVerificacion.fromJson(Map<String, dynamic> json) {
    final l$enviarVerificacion = json['enviarVerificacion'];
    final l$$__typename = json['__typename'];
    return Mutation$EnviarVerificacion(
      enviarVerificacion:
          Mutation$EnviarVerificacion$enviarVerificacion.fromJson(
            (l$enviarVerificacion as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$EnviarVerificacion$enviarVerificacion enviarVerificacion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$enviarVerificacion = enviarVerificacion;
    _resultData['enviarVerificacion'] = l$enviarVerificacion.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$enviarVerificacion = enviarVerificacion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$enviarVerificacion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$EnviarVerificacion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$enviarVerificacion = enviarVerificacion;
    final lOther$enviarVerificacion = other.enviarVerificacion;
    if (l$enviarVerificacion != lOther$enviarVerificacion) {
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

const documentNodeMutationEnviarVerificacion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'EnviarVerificacion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'onboardingId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'enviarVerificacion'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'onboardingId'),
                value: VariableNode(name: NameNode(value: 'onboardingId')),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'OnboardingCampos'),
                  directives: [],
                ),
                FragmentSpreadNode(
                  name: NameNode(value: 'ErrorOnboardingCampos'),
                  directives: [],
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
    fragmentDefinitionOnboardingCampos,
    fragmentDefinitionErrorOnboardingCampos,
  ],
);

class Mutation$EnviarVerificacion$enviarVerificacion {
  Mutation$EnviarVerificacion$enviarVerificacion({required this.$__typename});

  factory Mutation$EnviarVerificacion$enviarVerificacion.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Onboarding":
        return Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding.fromJson(
          json,
        );

      case "ErrorOnboarding":
        return Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$EnviarVerificacion$enviarVerificacion(
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
    if (other is! Mutation$EnviarVerificacion$enviarVerificacion ||
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

extension UtilityExtension$Mutation$EnviarVerificacion$enviarVerificacion
    on Mutation$EnviarVerificacion$enviarVerificacion {
  _T when<_T>({
    required _T Function(
      Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding,
    )
    onboarding,
    required _T Function(
      Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding,
    )
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Onboarding":
        return onboarding(
          this as Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding,
        );

      case "ErrorOnboarding":
        return errorOnboarding(
          this
              as Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding)?
    onboarding,
    _T Function(
      Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding,
    )?
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Onboarding":
        if (onboarding != null) {
          return onboarding(
            this as Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding,
          );
        } else {
          return orElse();
        }

      case "ErrorOnboarding":
        if (errorOnboarding != null) {
          return errorOnboarding(
            this
                as Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding
    implements
        Fragment$OnboardingCampos,
        Mutation$EnviarVerificacion$enviarVerificacion {
  Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding({
    this.$__typename = 'Onboarding',
    required this.id,
    required this.estado,
    this.motivo,
    required this.intento,
    required this.intentosRestantes,
  });

  factory Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$estado = json['estado'];
    final l$motivo = json['motivo'];
    final l$intento = json['intento'];
    final l$intentosRestantes = json['intentosRestantes'];
    return Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      estado: fromJson$Enum$EstadoOnboarding((l$estado as String)),
      motivo: l$motivo == null
          ? null
          : fromJson$Enum$MotivoOnboarding((l$motivo as String)),
      intento: (l$intento as int),
      intentosRestantes: (l$intentosRestantes as int),
    );
  }

  final String $__typename;

  final String id;

  final Enum$EstadoOnboarding estado;

  final Enum$MotivoOnboarding? motivo;

  final int intento;

  final int intentosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoOnboarding(l$estado);
    final l$motivo = motivo;
    _resultData['motivo'] = l$motivo == null
        ? null
        : toJson$Enum$MotivoOnboarding(l$motivo);
    final l$intento = intento;
    _resultData['intento'] = l$intento;
    final l$intentosRestantes = intentosRestantes;
    _resultData['intentosRestantes'] = l$intentosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$estado = estado;
    final l$motivo = motivo;
    final l$intento = intento;
    final l$intentosRestantes = intentosRestantes;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$estado,
      l$motivo,
      l$intento,
      l$intentosRestantes,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$EnviarVerificacion$enviarVerificacion$$Onboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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
    final l$motivo = motivo;
    final lOther$motivo = other.motivo;
    if (l$motivo != lOther$motivo) {
      return false;
    }
    final l$intento = intento;
    final lOther$intento = other.intento;
    if (l$intento != lOther$intento) {
      return false;
    }
    final l$intentosRestantes = intentosRestantes;
    final lOther$intentosRestantes = other.intentosRestantes;
    if (l$intentosRestantes != lOther$intentosRestantes) {
      return false;
    }
    return true;
  }
}

class Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$EnviarVerificacion$enviarVerificacion {
  Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
  });

  factory Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    return Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
    );
  }

  final String $__typename;

  final String codigo;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    return Object.hashAll([l$$__typename, l$codigo]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$ReintentarOnboarding {
  factory Variables$Mutation$ReintentarOnboarding({
    required String onboardingId,
  }) => Variables$Mutation$ReintentarOnboarding._({
    r'onboardingId': onboardingId,
  });

  Variables$Mutation$ReintentarOnboarding._(this._$data);

  factory Variables$Mutation$ReintentarOnboarding.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$onboardingId = data['onboardingId'];
    result$data['onboardingId'] = (l$onboardingId as String);
    return Variables$Mutation$ReintentarOnboarding._(result$data);
  }

  Map<String, dynamic> _$data;

  String get onboardingId => (_$data['onboardingId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$onboardingId = onboardingId;
    result$data['onboardingId'] = l$onboardingId;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ReintentarOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$onboardingId = onboardingId;
    final lOther$onboardingId = other.onboardingId;
    if (l$onboardingId != lOther$onboardingId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$onboardingId = onboardingId;
    return Object.hashAll([l$onboardingId]);
  }
}

class Mutation$ReintentarOnboarding {
  Mutation$ReintentarOnboarding({
    required this.reintentarOnboarding,
    this.$__typename = 'Mutation',
  });

  factory Mutation$ReintentarOnboarding.fromJson(Map<String, dynamic> json) {
    final l$reintentarOnboarding = json['reintentarOnboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$ReintentarOnboarding(
      reintentarOnboarding:
          Mutation$ReintentarOnboarding$reintentarOnboarding.fromJson(
            (l$reintentarOnboarding as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$ReintentarOnboarding$reintentarOnboarding reintentarOnboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$reintentarOnboarding = reintentarOnboarding;
    _resultData['reintentarOnboarding'] = l$reintentarOnboarding.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$reintentarOnboarding = reintentarOnboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$reintentarOnboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ReintentarOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$reintentarOnboarding = reintentarOnboarding;
    final lOther$reintentarOnboarding = other.reintentarOnboarding;
    if (l$reintentarOnboarding != lOther$reintentarOnboarding) {
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

const documentNodeMutationReintentarOnboarding = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ReintentarOnboarding'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'onboardingId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'reintentarOnboarding'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'onboardingId'),
                value: VariableNode(name: NameNode(value: 'onboardingId')),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'OnboardingCampos'),
                  directives: [],
                ),
                FragmentSpreadNode(
                  name: NameNode(value: 'ErrorOnboardingCampos'),
                  directives: [],
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
    fragmentDefinitionOnboardingCampos,
    fragmentDefinitionErrorOnboardingCampos,
  ],
);

class Mutation$ReintentarOnboarding$reintentarOnboarding {
  Mutation$ReintentarOnboarding$reintentarOnboarding({
    required this.$__typename,
  });

  factory Mutation$ReintentarOnboarding$reintentarOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Onboarding":
        return Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding.fromJson(
          json,
        );

      case "ErrorOnboarding":
        return Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$ReintentarOnboarding$reintentarOnboarding(
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
    if (other is! Mutation$ReintentarOnboarding$reintentarOnboarding ||
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

extension UtilityExtension$Mutation$ReintentarOnboarding$reintentarOnboarding
    on Mutation$ReintentarOnboarding$reintentarOnboarding {
  _T when<_T>({
    required _T Function(
      Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding,
    )
    onboarding,
    required _T Function(
      Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding,
    )
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Onboarding":
        return onboarding(
          this
              as Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding,
        );

      case "ErrorOnboarding":
        return errorOnboarding(
          this
              as Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding)?
    onboarding,
    _T Function(
      Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding,
    )?
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Onboarding":
        if (onboarding != null) {
          return onboarding(
            this
                as Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding,
          );
        } else {
          return orElse();
        }

      case "ErrorOnboarding":
        if (errorOnboarding != null) {
          return errorOnboarding(
            this
                as Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding
    implements
        Fragment$OnboardingCampos,
        Mutation$ReintentarOnboarding$reintentarOnboarding {
  Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding({
    this.$__typename = 'Onboarding',
    required this.id,
    required this.estado,
    this.motivo,
    required this.intento,
    required this.intentosRestantes,
  });

  factory Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    final l$estado = json['estado'];
    final l$motivo = json['motivo'];
    final l$intento = json['intento'];
    final l$intentosRestantes = json['intentosRestantes'];
    return Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding(
      $__typename: (l$$__typename as String),
      id: (l$id as String),
      estado: fromJson$Enum$EstadoOnboarding((l$estado as String)),
      motivo: l$motivo == null
          ? null
          : fromJson$Enum$MotivoOnboarding((l$motivo as String)),
      intento: (l$intento as int),
      intentosRestantes: (l$intentosRestantes as int),
    );
  }

  final String $__typename;

  final String id;

  final Enum$EstadoOnboarding estado;

  final Enum$MotivoOnboarding? motivo;

  final int intento;

  final int intentosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoOnboarding(l$estado);
    final l$motivo = motivo;
    _resultData['motivo'] = l$motivo == null
        ? null
        : toJson$Enum$MotivoOnboarding(l$motivo);
    final l$intento = intento;
    _resultData['intento'] = l$intento;
    final l$intentosRestantes = intentosRestantes;
    _resultData['intentosRestantes'] = l$intentosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$id = id;
    final l$estado = estado;
    final l$motivo = motivo;
    final l$intento = intento;
    final l$intentosRestantes = intentosRestantes;
    return Object.hashAll([
      l$$__typename,
      l$id,
      l$estado,
      l$motivo,
      l$intento,
      l$intentosRestantes,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ReintentarOnboarding$reintentarOnboarding$$Onboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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
    final l$motivo = motivo;
    final lOther$motivo = other.motivo;
    if (l$motivo != lOther$motivo) {
      return false;
    }
    final l$intento = intento;
    final lOther$intento = other.intento;
    if (l$intento != lOther$intento) {
      return false;
    }
    final l$intentosRestantes = intentosRestantes;
    final lOther$intentosRestantes = other.intentosRestantes;
    if (l$intentosRestantes != lOther$intentosRestantes) {
      return false;
    }
    return true;
  }
}

class Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$ReintentarOnboarding$reintentarOnboarding {
  Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
  });

  factory Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    return Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
    );
  }

  final String $__typename;

  final String codigo;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    return Object.hashAll([l$$__typename, l$codigo]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    return true;
  }
}

class Variables$Query$ConsultarOnboarding {
  factory Variables$Query$ConsultarOnboarding({required String id}) =>
      Variables$Query$ConsultarOnboarding._({r'id': id});

  Variables$Query$ConsultarOnboarding._(this._$data);

  factory Variables$Query$ConsultarOnboarding.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$ConsultarOnboarding._(result$data);
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
    if (other is! Variables$Query$ConsultarOnboarding ||
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

class Query$ConsultarOnboarding {
  Query$ConsultarOnboarding({this.onboarding, this.$__typename = 'Query'});

  factory Query$ConsultarOnboarding.fromJson(Map<String, dynamic> json) {
    final l$onboarding = json['onboarding'];
    final l$$__typename = json['__typename'];
    return Query$ConsultarOnboarding(
      onboarding: l$onboarding == null
          ? null
          : Fragment$OnboardingCampos.fromJson(
              (l$onboarding as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$OnboardingCampos? onboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$onboarding = onboarding;
    _resultData['onboarding'] = l$onboarding?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$onboarding = onboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$onboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ConsultarOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$onboarding = onboarding;
    final lOther$onboarding = other.onboarding;
    if (l$onboarding != lOther$onboarding) {
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

const documentNodeQueryConsultarOnboarding = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'ConsultarOnboarding'),
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
            name: NameNode(value: 'onboarding'),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'OnboardingCampos'),
                  directives: [],
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
    fragmentDefinitionOnboardingCampos,
  ],
);

class Query$MiVerificacion {
  Query$MiVerificacion({this.miVerificacion, this.$__typename = 'Query'});

  factory Query$MiVerificacion.fromJson(Map<String, dynamic> json) {
    final l$miVerificacion = json['miVerificacion'];
    final l$$__typename = json['__typename'];
    return Query$MiVerificacion(
      miVerificacion: l$miVerificacion == null
          ? null
          : Fragment$OnboardingCampos.fromJson(
              (l$miVerificacion as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$OnboardingCampos? miVerificacion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$miVerificacion = miVerificacion;
    _resultData['miVerificacion'] = l$miVerificacion?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$miVerificacion = miVerificacion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$miVerificacion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MiVerificacion || runtimeType != other.runtimeType) {
      return false;
    }
    final l$miVerificacion = miVerificacion;
    final lOther$miVerificacion = other.miVerificacion;
    if (l$miVerificacion != lOther$miVerificacion) {
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

const documentNodeQueryMiVerificacion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MiVerificacion'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'miVerificacion'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'OnboardingCampos'),
                  directives: [],
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
    fragmentDefinitionOnboardingCampos,
  ],
);

class Mutation$ActualizarSesion {
  Mutation$ActualizarSesion({
    required this.actualizarSesion,
    this.$__typename = 'Mutation',
  });

  factory Mutation$ActualizarSesion.fromJson(Map<String, dynamic> json) {
    final l$actualizarSesion = json['actualizarSesion'];
    final l$$__typename = json['__typename'];
    return Mutation$ActualizarSesion(
      actualizarSesion: Mutation$ActualizarSesion$actualizarSesion.fromJson(
        (l$actualizarSesion as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$ActualizarSesion$actualizarSesion actualizarSesion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$actualizarSesion = actualizarSesion;
    _resultData['actualizarSesion'] = l$actualizarSesion.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$actualizarSesion = actualizarSesion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$actualizarSesion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ActualizarSesion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$actualizarSesion = actualizarSesion;
    final lOther$actualizarSesion = other.actualizarSesion;
    if (l$actualizarSesion != lOther$actualizarSesion) {
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

const documentNodeMutationActualizarSesion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ActualizarSesion'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'actualizarSesion'),
            alias: null,
            arguments: [],
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

class Mutation$ActualizarSesion$actualizarSesion {
  Mutation$ActualizarSesion$actualizarSesion({required this.$__typename});

  factory Mutation$ActualizarSesion$actualizarSesion.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Sesion":
        return Mutation$ActualizarSesion$actualizarSesion$$Sesion.fromJson(
          json,
        );

      case "ErrorAutenticacion":
        return Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$ActualizarSesion$actualizarSesion(
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
    if (other is! Mutation$ActualizarSesion$actualizarSesion ||
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

extension UtilityExtension$Mutation$ActualizarSesion$actualizarSesion
    on Mutation$ActualizarSesion$actualizarSesion {
  _T when<_T>({
    required _T Function(Mutation$ActualizarSesion$actualizarSesion$$Sesion)
    sesion,
    required _T Function(
      Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion,
    )
    errorAutenticacion,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Sesion":
        return sesion(
          this as Mutation$ActualizarSesion$actualizarSesion$$Sesion,
        );

      case "ErrorAutenticacion":
        return errorAutenticacion(
          this
              as Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$ActualizarSesion$actualizarSesion$$Sesion)? sesion,
    _T Function(Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion)?
    errorAutenticacion,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Sesion":
        if (sesion != null) {
          return sesion(
            this as Mutation$ActualizarSesion$actualizarSesion$$Sesion,
          );
        } else {
          return orElse();
        }

      case "ErrorAutenticacion":
        if (errorAutenticacion != null) {
          return errorAutenticacion(
            this
                as Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$ActualizarSesion$actualizarSesion$$Sesion
    implements Mutation$ActualizarSesion$actualizarSesion {
  Mutation$ActualizarSesion$actualizarSesion$$Sesion({
    required this.token,
    required this.expiraEn,
    this.$__typename = 'Sesion',
  });

  factory Mutation$ActualizarSesion$actualizarSesion$$Sesion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$token = json['token'];
    final l$expiraEn = json['expiraEn'];
    final l$$__typename = json['__typename'];
    return Mutation$ActualizarSesion$actualizarSesion$$Sesion(
      token: (l$token as String),
      expiraEn: DateTime.parse((l$expiraEn as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String token;

  final DateTime expiraEn;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$token = token;
    _resultData['token'] = l$token;
    final l$expiraEn = expiraEn;
    _resultData['expiraEn'] = l$expiraEn.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$token = token;
    final l$expiraEn = expiraEn;
    final l$$__typename = $__typename;
    return Object.hashAll([l$token, l$expiraEn, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ActualizarSesion$actualizarSesion$$Sesion ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion
    implements Mutation$ActualizarSesion$actualizarSesion {
  Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion({
    this.codigo,
    this.$__typename = 'ErrorAutenticacion',
  });

  factory Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$codigo = json['codigo'];
    final l$$__typename = json['__typename'];
    return Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion(
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
    if (other
            is! Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion ||
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
