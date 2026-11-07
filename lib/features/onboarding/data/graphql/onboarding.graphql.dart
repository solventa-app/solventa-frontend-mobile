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
    this.segundosRestantes,
    this.$__typename = 'ErrorOnboarding',
  });

  factory Fragment$ErrorOnboardingCampos.fromJson(Map<String, dynamic> json) {
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    final l$$__typename = json['__typename'];
    return Fragment$ErrorOnboardingCampos(
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String codigo;

  final int? segundosRestantes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    final l$$__typename = $__typename;
    return Object.hashAll([l$codigo, l$segundosRestantes, l$$__typename]);
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
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
        name: NameNode(value: 'segundosRestantes'),
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

class Fragment$UsuarioCampos {
  Fragment$UsuarioCampos({
    required this.id,
    required this.usuario,
    required this.rol,
    required this.estado,
    required this.creadoEn,
    this.nombre,
    required this.idioma,
    required this.moneda,
    required this.tieneContacto,
    this.documentoEnmascarado,
    this.$__typename = 'Usuario',
  });

  factory Fragment$UsuarioCampos.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$usuario = json['usuario'];
    final l$rol = json['rol'];
    final l$estado = json['estado'];
    final l$creadoEn = json['creadoEn'];
    final l$nombre = json['nombre'];
    final l$idioma = json['idioma'];
    final l$moneda = json['moneda'];
    final l$tieneContacto = json['tieneContacto'];
    final l$documentoEnmascarado = json['documentoEnmascarado'];
    final l$$__typename = json['__typename'];
    return Fragment$UsuarioCampos(
      id: (l$id as String),
      usuario: (l$usuario as String),
      rol: fromJson$Enum$RolUsuario((l$rol as String)),
      estado: fromJson$Enum$EstadoUsuario((l$estado as String)),
      creadoEn: DateTime.parse((l$creadoEn as String)),
      nombre: (l$nombre as String?),
      idioma: (l$idioma as String),
      moneda: (l$moneda as String),
      tieneContacto: (l$tieneContacto as bool),
      documentoEnmascarado: (l$documentoEnmascarado as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String usuario;

  final Enum$RolUsuario rol;

  final Enum$EstadoUsuario estado;

  final DateTime creadoEn;

  final String? nombre;

  final String idioma;

  final String moneda;

  final bool tieneContacto;

  final String? documentoEnmascarado;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$usuario = usuario;
    _resultData['usuario'] = l$usuario;
    final l$rol = rol;
    _resultData['rol'] = toJson$Enum$RolUsuario(l$rol);
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoUsuario(l$estado);
    final l$creadoEn = creadoEn;
    _resultData['creadoEn'] = l$creadoEn.toIso8601String();
    final l$nombre = nombre;
    _resultData['nombre'] = l$nombre;
    final l$idioma = idioma;
    _resultData['idioma'] = l$idioma;
    final l$moneda = moneda;
    _resultData['moneda'] = l$moneda;
    final l$tieneContacto = tieneContacto;
    _resultData['tieneContacto'] = l$tieneContacto;
    final l$documentoEnmascarado = documentoEnmascarado;
    _resultData['documentoEnmascarado'] = l$documentoEnmascarado;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$usuario = usuario;
    final l$rol = rol;
    final l$estado = estado;
    final l$creadoEn = creadoEn;
    final l$nombre = nombre;
    final l$idioma = idioma;
    final l$moneda = moneda;
    final l$tieneContacto = tieneContacto;
    final l$documentoEnmascarado = documentoEnmascarado;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$usuario,
      l$rol,
      l$estado,
      l$creadoEn,
      l$nombre,
      l$idioma,
      l$moneda,
      l$tieneContacto,
      l$documentoEnmascarado,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$UsuarioCampos || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$usuario = usuario;
    final lOther$usuario = other.usuario;
    if (l$usuario != lOther$usuario) {
      return false;
    }
    final l$rol = rol;
    final lOther$rol = other.rol;
    if (l$rol != lOther$rol) {
      return false;
    }
    final l$estado = estado;
    final lOther$estado = other.estado;
    if (l$estado != lOther$estado) {
      return false;
    }
    final l$creadoEn = creadoEn;
    final lOther$creadoEn = other.creadoEn;
    if (l$creadoEn != lOther$creadoEn) {
      return false;
    }
    final l$nombre = nombre;
    final lOther$nombre = other.nombre;
    if (l$nombre != lOther$nombre) {
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
    final l$tieneContacto = tieneContacto;
    final lOther$tieneContacto = other.tieneContacto;
    if (l$tieneContacto != lOther$tieneContacto) {
      return false;
    }
    final l$documentoEnmascarado = documentoEnmascarado;
    final lOther$documentoEnmascarado = other.documentoEnmascarado;
    if (l$documentoEnmascarado != lOther$documentoEnmascarado) {
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

const fragmentDefinitionUsuarioCampos = FragmentDefinitionNode(
  name: NameNode(value: 'UsuarioCampos'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Usuario'), isNonNull: false),
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
        name: NameNode(value: 'usuario'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'rol'),
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
        name: NameNode(value: 'creadoEn'),
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
        name: NameNode(value: 'idioma'),
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
        name: NameNode(value: 'tieneContacto'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'documentoEnmascarado'),
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
const documentNodeFragmentUsuarioCampos = DocumentNode(
  definitions: [fragmentDefinitionUsuarioCampos],
);

class Fragment$CodigoOnboardingCampos {
  Fragment$CodigoOnboardingCampos({
    required this.correoEnmascarado,
    required this.venceEn,
    this.$__typename = 'CodigoOnboardingEnviado',
  });

  factory Fragment$CodigoOnboardingCampos.fromJson(Map<String, dynamic> json) {
    final l$correoEnmascarado = json['correoEnmascarado'];
    final l$venceEn = json['venceEn'];
    final l$$__typename = json['__typename'];
    return Fragment$CodigoOnboardingCampos(
      correoEnmascarado: (l$correoEnmascarado as String),
      venceEn: DateTime.parse((l$venceEn as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String correoEnmascarado;

  final DateTime venceEn;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$correoEnmascarado = correoEnmascarado;
    _resultData['correoEnmascarado'] = l$correoEnmascarado;
    final l$venceEn = venceEn;
    _resultData['venceEn'] = l$venceEn.toIso8601String();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$correoEnmascarado = correoEnmascarado;
    final l$venceEn = venceEn;
    final l$$__typename = $__typename;
    return Object.hashAll([l$correoEnmascarado, l$venceEn, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$CodigoOnboardingCampos ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$correoEnmascarado = correoEnmascarado;
    final lOther$correoEnmascarado = other.correoEnmascarado;
    if (l$correoEnmascarado != lOther$correoEnmascarado) {
      return false;
    }
    final l$venceEn = venceEn;
    final lOther$venceEn = other.venceEn;
    if (l$venceEn != lOther$venceEn) {
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

const fragmentDefinitionCodigoOnboardingCampos = FragmentDefinitionNode(
  name: NameNode(value: 'CodigoOnboardingCampos'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'CodigoOnboardingEnviado'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'correoEnmascarado'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentCodigoOnboardingCampos = DocumentNode(
  definitions: [fragmentDefinitionCodigoOnboardingCampos],
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
    this.segundosRestantes,
  });

  factory Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    return Mutation$IniciarOnboarding$iniciarOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
    );
  }

  final String $__typename;

  final String codigo;

  final int? segundosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    return Object.hashAll([l$$__typename, l$codigo, l$segundosRestantes]);
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
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
    this.segundosRestantes,
  });

  factory Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    return Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
    );
  }

  final String $__typename;

  final String codigo;

  final int? segundosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    return Object.hashAll([l$$__typename, l$codigo, l$segundosRestantes]);
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
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
    this.segundosRestantes,
  });

  factory Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    return Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
    );
  }

  final String $__typename;

  final String codigo;

  final int? segundosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    return Object.hashAll([l$$__typename, l$codigo, l$segundosRestantes]);
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
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
    this.segundosRestantes,
  });

  factory Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    return Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
    );
  }

  final String $__typename;

  final String codigo;

  final int? segundosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    return Object.hashAll([l$$__typename, l$codigo, l$segundosRestantes]);
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
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
    this.refreshToken,
    this.refreshExpiraEn,
    this.$__typename = 'Sesion',
  });

  factory Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding$sesion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$token = json['token'];
    final l$expiraEn = json['expiraEn'];
    final l$refreshToken = json['refreshToken'];
    final l$refreshExpiraEn = json['refreshExpiraEn'];
    final l$$__typename = json['__typename'];
    return Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding$sesion(
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

class Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$CrearCuentaOnboarding$crearCuentaOnboarding {
  Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
    this.segundosRestantes,
  });

  factory Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    return Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
    );
  }

  final String $__typename;

  final String codigo;

  final int? segundosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    return Object.hashAll([l$$__typename, l$codigo, l$segundosRestantes]);
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
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
    this.segundosRestantes,
  });

  factory Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    return Mutation$EnviarVerificacion$enviarVerificacion$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
    );
  }

  final String $__typename;

  final String codigo;

  final int? segundosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    return Object.hashAll([l$$__typename, l$codigo, l$segundosRestantes]);
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
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
    this.segundosRestantes,
  });

  factory Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    return Mutation$ReintentarOnboarding$reintentarOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
    );
  }

  final String $__typename;

  final String codigo;

  final int? segundosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    return Object.hashAll([l$$__typename, l$codigo, l$segundosRestantes]);
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
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

class Variables$Mutation$EnviarCodigoOnboarding {
  factory Variables$Mutation$EnviarCodigoOnboarding({required String correo}) =>
      Variables$Mutation$EnviarCodigoOnboarding._({r'correo': correo});

  Variables$Mutation$EnviarCodigoOnboarding._(this._$data);

  factory Variables$Mutation$EnviarCodigoOnboarding.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$correo = data['correo'];
    result$data['correo'] = (l$correo as String);
    return Variables$Mutation$EnviarCodigoOnboarding._(result$data);
  }

  Map<String, dynamic> _$data;

  String get correo => (_$data['correo'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$correo = correo;
    result$data['correo'] = l$correo;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$EnviarCodigoOnboarding ||
        runtimeType != other.runtimeType) {
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
    final l$correo = correo;
    return Object.hashAll([l$correo]);
  }
}

class Mutation$EnviarCodigoOnboarding {
  Mutation$EnviarCodigoOnboarding({
    required this.enviarCodigoOnboarding,
    this.$__typename = 'Mutation',
  });

  factory Mutation$EnviarCodigoOnboarding.fromJson(Map<String, dynamic> json) {
    final l$enviarCodigoOnboarding = json['enviarCodigoOnboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$EnviarCodigoOnboarding(
      enviarCodigoOnboarding:
          Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding.fromJson(
            (l$enviarCodigoOnboarding as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding
  enviarCodigoOnboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$enviarCodigoOnboarding = enviarCodigoOnboarding;
    _resultData['enviarCodigoOnboarding'] = l$enviarCodigoOnboarding.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$enviarCodigoOnboarding = enviarCodigoOnboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$enviarCodigoOnboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$EnviarCodigoOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$enviarCodigoOnboarding = enviarCodigoOnboarding;
    final lOther$enviarCodigoOnboarding = other.enviarCodigoOnboarding;
    if (l$enviarCodigoOnboarding != lOther$enviarCodigoOnboarding) {
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

const documentNodeMutationEnviarCodigoOnboarding = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'EnviarCodigoOnboarding'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'correo')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'enviarCodigoOnboarding'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'correo'),
                value: VariableNode(name: NameNode(value: 'correo')),
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
                  name: NameNode(value: 'CodigoOnboardingCampos'),
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
    fragmentDefinitionCodigoOnboardingCampos,
    fragmentDefinitionErrorOnboardingCampos,
  ],
);

class Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding {
  Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding({
    required this.$__typename,
  });

  factory Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "CodigoOnboardingEnviado":
        return Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado.fromJson(
          json,
        );

      case "ErrorOnboarding":
        return Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding(
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
    if (other is! Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding ||
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

extension UtilityExtension$Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding
    on Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding {
  _T when<_T>({
    required _T Function(
      Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado,
    )
    codigoOnboardingEnviado,
    required _T Function(
      Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding,
    )
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CodigoOnboardingEnviado":
        return codigoOnboardingEnviado(
          this
              as Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado,
        );

      case "ErrorOnboarding":
        return errorOnboarding(
          this
              as Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado,
    )?
    codigoOnboardingEnviado,
    _T Function(
      Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding,
    )?
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CodigoOnboardingEnviado":
        if (codigoOnboardingEnviado != null) {
          return codigoOnboardingEnviado(
            this
                as Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado,
          );
        } else {
          return orElse();
        }

      case "ErrorOnboarding":
        if (errorOnboarding != null) {
          return errorOnboarding(
            this
                as Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado
    implements
        Fragment$CodigoOnboardingCampos,
        Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding {
  Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado({
    this.$__typename = 'CodigoOnboardingEnviado',
    required this.correoEnmascarado,
    required this.venceEn,
  });

  factory Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$correoEnmascarado = json['correoEnmascarado'];
    final l$venceEn = json['venceEn'];
    return Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado(
      $__typename: (l$$__typename as String),
      correoEnmascarado: (l$correoEnmascarado as String),
      venceEn: DateTime.parse((l$venceEn as String)),
    );
  }

  final String $__typename;

  final String correoEnmascarado;

  final DateTime venceEn;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$correoEnmascarado = correoEnmascarado;
    _resultData['correoEnmascarado'] = l$correoEnmascarado;
    final l$venceEn = venceEn;
    _resultData['venceEn'] = l$venceEn.toIso8601String();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$correoEnmascarado = correoEnmascarado;
    final l$venceEn = venceEn;
    return Object.hashAll([l$$__typename, l$correoEnmascarado, l$venceEn]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$CodigoOnboardingEnviado ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$correoEnmascarado = correoEnmascarado;
    final lOther$correoEnmascarado = other.correoEnmascarado;
    if (l$correoEnmascarado != lOther$correoEnmascarado) {
      return false;
    }
    final l$venceEn = venceEn;
    final lOther$venceEn = other.venceEn;
    if (l$venceEn != lOther$venceEn) {
      return false;
    }
    return true;
  }
}

class Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding {
  Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
    this.segundosRestantes,
  });

  factory Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    return Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
    );
  }

  final String $__typename;

  final String codigo;

  final int? segundosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    return Object.hashAll([l$$__typename, l$codigo, l$segundosRestantes]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding$$ErrorOnboarding ||
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$VerificarCodigoOnboarding {
  factory Variables$Mutation$VerificarCodigoOnboarding({
    required String correo,
    required String codigo,
  }) => Variables$Mutation$VerificarCodigoOnboarding._({
    r'correo': correo,
    r'codigo': codigo,
  });

  Variables$Mutation$VerificarCodigoOnboarding._(this._$data);

  factory Variables$Mutation$VerificarCodigoOnboarding.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$correo = data['correo'];
    result$data['correo'] = (l$correo as String);
    final l$codigo = data['codigo'];
    result$data['codigo'] = (l$codigo as String);
    return Variables$Mutation$VerificarCodigoOnboarding._(result$data);
  }

  Map<String, dynamic> _$data;

  String get correo => (_$data['correo'] as String);

  String get codigo => (_$data['codigo'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$correo = correo;
    result$data['correo'] = l$correo;
    final l$codigo = codigo;
    result$data['codigo'] = l$codigo;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$VerificarCodigoOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$correo = correo;
    final lOther$correo = other.correo;
    if (l$correo != lOther$correo) {
      return false;
    }
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$correo = correo;
    final l$codigo = codigo;
    return Object.hashAll([l$correo, l$codigo]);
  }
}

class Mutation$VerificarCodigoOnboarding {
  Mutation$VerificarCodigoOnboarding({
    required this.verificarCodigoOnboarding,
    this.$__typename = 'Mutation',
  });

  factory Mutation$VerificarCodigoOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$verificarCodigoOnboarding = json['verificarCodigoOnboarding'];
    final l$$__typename = json['__typename'];
    return Mutation$VerificarCodigoOnboarding(
      verificarCodigoOnboarding:
          Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding.fromJson(
            (l$verificarCodigoOnboarding as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding
  verificarCodigoOnboarding;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$verificarCodigoOnboarding = verificarCodigoOnboarding;
    _resultData['verificarCodigoOnboarding'] = l$verificarCodigoOnboarding
        .toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$verificarCodigoOnboarding = verificarCodigoOnboarding;
    final l$$__typename = $__typename;
    return Object.hashAll([l$verificarCodigoOnboarding, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$VerificarCodigoOnboarding ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$verificarCodigoOnboarding = verificarCodigoOnboarding;
    final lOther$verificarCodigoOnboarding = other.verificarCodigoOnboarding;
    if (l$verificarCodigoOnboarding != lOther$verificarCodigoOnboarding) {
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

const documentNodeMutationVerificarCodigoOnboarding = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'VerificarCodigoOnboarding'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'correo')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'codigo')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'verificarCodigoOnboarding'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'correo'),
                value: VariableNode(name: NameNode(value: 'correo')),
              ),
              ArgumentNode(
                name: NameNode(value: 'codigo'),
                value: VariableNode(name: NameNode(value: 'codigo')),
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
                  name: NameNode(value: 'CodigoOnboardingCampos'),
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
    fragmentDefinitionCodigoOnboardingCampos,
    fragmentDefinitionErrorOnboardingCampos,
  ],
);

class Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding {
  Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding({
    required this.$__typename,
  });

  factory Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "CodigoOnboardingEnviado":
        return Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado.fromJson(
          json,
        );

      case "ErrorOnboarding":
        return Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding(
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
            is! Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding ||
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

extension UtilityExtension$Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding
    on Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding {
  _T when<_T>({
    required _T Function(
      Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado,
    )
    codigoOnboardingEnviado,
    required _T Function(
      Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding,
    )
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CodigoOnboardingEnviado":
        return codigoOnboardingEnviado(
          this
              as Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado,
        );

      case "ErrorOnboarding":
        return errorOnboarding(
          this
              as Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado,
    )?
    codigoOnboardingEnviado,
    _T Function(
      Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding,
    )?
    errorOnboarding,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CodigoOnboardingEnviado":
        if (codigoOnboardingEnviado != null) {
          return codigoOnboardingEnviado(
            this
                as Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado,
          );
        } else {
          return orElse();
        }

      case "ErrorOnboarding":
        if (errorOnboarding != null) {
          return errorOnboarding(
            this
                as Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado
    implements
        Fragment$CodigoOnboardingCampos,
        Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding {
  Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado({
    this.$__typename = 'CodigoOnboardingEnviado',
    required this.correoEnmascarado,
    required this.venceEn,
  });

  factory Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$correoEnmascarado = json['correoEnmascarado'];
    final l$venceEn = json['venceEn'];
    return Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado(
      $__typename: (l$$__typename as String),
      correoEnmascarado: (l$correoEnmascarado as String),
      venceEn: DateTime.parse((l$venceEn as String)),
    );
  }

  final String $__typename;

  final String correoEnmascarado;

  final DateTime venceEn;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$correoEnmascarado = correoEnmascarado;
    _resultData['correoEnmascarado'] = l$correoEnmascarado;
    final l$venceEn = venceEn;
    _resultData['venceEn'] = l$venceEn.toIso8601String();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$correoEnmascarado = correoEnmascarado;
    final l$venceEn = venceEn;
    return Object.hashAll([l$$__typename, l$correoEnmascarado, l$venceEn]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$CodigoOnboardingEnviado ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$correoEnmascarado = correoEnmascarado;
    final lOther$correoEnmascarado = other.correoEnmascarado;
    if (l$correoEnmascarado != lOther$correoEnmascarado) {
      return false;
    }
    final l$venceEn = venceEn;
    final lOther$venceEn = other.venceEn;
    if (l$venceEn != lOther$venceEn) {
      return false;
    }
    return true;
  }
}

class Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding
    implements
        Fragment$ErrorOnboardingCampos,
        Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding {
  Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding({
    this.$__typename = 'ErrorOnboarding',
    required this.codigo,
    this.segundosRestantes,
  });

  factory Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$$__typename = json['__typename'];
    final l$codigo = json['codigo'];
    final l$segundosRestantes = json['segundosRestantes'];
    return Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding(
      $__typename: (l$$__typename as String),
      codigo: (l$codigo as String),
      segundosRestantes: (l$segundosRestantes as int?),
    );
  }

  final String $__typename;

  final String codigo;

  final int? segundosRestantes;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$segundosRestantes = segundosRestantes;
    _resultData['segundosRestantes'] = l$segundosRestantes;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    final l$codigo = codigo;
    final l$segundosRestantes = segundosRestantes;
    return Object.hashAll([l$$__typename, l$codigo, l$segundosRestantes]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding$$ErrorOnboarding ||
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
    final l$segundosRestantes = segundosRestantes;
    final lOther$segundosRestantes = other.segundosRestantes;
    if (l$segundosRestantes != lOther$segundosRestantes) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$RegistrarCuenta {
  factory Variables$Mutation$RegistrarCuenta({
    required String correo,
    required String clave,
    required String codigo,
  }) => Variables$Mutation$RegistrarCuenta._({
    r'correo': correo,
    r'clave': clave,
    r'codigo': codigo,
  });

  Variables$Mutation$RegistrarCuenta._(this._$data);

  factory Variables$Mutation$RegistrarCuenta.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$correo = data['correo'];
    result$data['correo'] = (l$correo as String);
    final l$clave = data['clave'];
    result$data['clave'] = (l$clave as String);
    final l$codigo = data['codigo'];
    result$data['codigo'] = (l$codigo as String);
    return Variables$Mutation$RegistrarCuenta._(result$data);
  }

  Map<String, dynamic> _$data;

  String get correo => (_$data['correo'] as String);

  String get clave => (_$data['clave'] as String);

  String get codigo => (_$data['codigo'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$correo = correo;
    result$data['correo'] = l$correo;
    final l$clave = clave;
    result$data['clave'] = l$clave;
    final l$codigo = codigo;
    result$data['codigo'] = l$codigo;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$RegistrarCuenta ||
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
    final l$codigo = codigo;
    final lOther$codigo = other.codigo;
    if (l$codigo != lOther$codigo) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$correo = correo;
    final l$clave = clave;
    final l$codigo = codigo;
    return Object.hashAll([l$correo, l$clave, l$codigo]);
  }
}

class Mutation$RegistrarCuenta {
  Mutation$RegistrarCuenta({
    required this.registrarCuenta,
    this.$__typename = 'Mutation',
  });

  factory Mutation$RegistrarCuenta.fromJson(Map<String, dynamic> json) {
    final l$registrarCuenta = json['registrarCuenta'];
    final l$$__typename = json['__typename'];
    return Mutation$RegistrarCuenta(
      registrarCuenta: Mutation$RegistrarCuenta$registrarCuenta.fromJson(
        (l$registrarCuenta as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$RegistrarCuenta$registrarCuenta registrarCuenta;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$registrarCuenta = registrarCuenta;
    _resultData['registrarCuenta'] = l$registrarCuenta.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$registrarCuenta = registrarCuenta;
    final l$$__typename = $__typename;
    return Object.hashAll([l$registrarCuenta, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegistrarCuenta ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$registrarCuenta = registrarCuenta;
    final lOther$registrarCuenta = other.registrarCuenta;
    if (l$registrarCuenta != lOther$registrarCuenta) {
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

const documentNodeMutationRegistrarCuenta = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'RegistrarCuenta'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'correo')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'clave')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'codigo')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'registrarCuenta'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'correo'),
                value: VariableNode(name: NameNode(value: 'correo')),
              ),
              ArgumentNode(
                name: NameNode(value: 'clave'),
                value: VariableNode(name: NameNode(value: 'clave')),
              ),
              ArgumentNode(
                name: NameNode(value: 'codigo'),
                value: VariableNode(name: NameNode(value: 'codigo')),
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
                        name: NameNode(value: 'usuario'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'UsuarioCampos'),
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
                        name: NameNode(value: 'mensaje'),
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
    fragmentDefinitionUsuarioCampos,
  ],
);

class Mutation$RegistrarCuenta$registrarCuenta {
  Mutation$RegistrarCuenta$registrarCuenta({required this.$__typename});

  factory Mutation$RegistrarCuenta$registrarCuenta.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Sesion":
        return Mutation$RegistrarCuenta$registrarCuenta$$Sesion.fromJson(json);

      case "ErrorAutenticacion":
        return Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$RegistrarCuenta$registrarCuenta(
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
    if (other is! Mutation$RegistrarCuenta$registrarCuenta ||
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

extension UtilityExtension$Mutation$RegistrarCuenta$registrarCuenta
    on Mutation$RegistrarCuenta$registrarCuenta {
  _T when<_T>({
    required _T Function(Mutation$RegistrarCuenta$registrarCuenta$$Sesion)
    sesion,
    required _T Function(
      Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion,
    )
    errorAutenticacion,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Sesion":
        return sesion(this as Mutation$RegistrarCuenta$registrarCuenta$$Sesion);

      case "ErrorAutenticacion":
        return errorAutenticacion(
          this as Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$RegistrarCuenta$registrarCuenta$$Sesion)? sesion,
    _T Function(Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion)?
    errorAutenticacion,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Sesion":
        if (sesion != null) {
          return sesion(
            this as Mutation$RegistrarCuenta$registrarCuenta$$Sesion,
          );
        } else {
          return orElse();
        }

      case "ErrorAutenticacion":
        if (errorAutenticacion != null) {
          return errorAutenticacion(
            this
                as Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$RegistrarCuenta$registrarCuenta$$Sesion
    implements Mutation$RegistrarCuenta$registrarCuenta {
  Mutation$RegistrarCuenta$registrarCuenta$$Sesion({
    required this.token,
    required this.expiraEn,
    this.refreshToken,
    this.refreshExpiraEn,
    required this.usuario,
    this.$__typename = 'Sesion',
  });

  factory Mutation$RegistrarCuenta$registrarCuenta$$Sesion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$token = json['token'];
    final l$expiraEn = json['expiraEn'];
    final l$refreshToken = json['refreshToken'];
    final l$refreshExpiraEn = json['refreshExpiraEn'];
    final l$usuario = json['usuario'];
    final l$$__typename = json['__typename'];
    return Mutation$RegistrarCuenta$registrarCuenta$$Sesion(
      token: (l$token as String),
      expiraEn: DateTime.parse((l$expiraEn as String)),
      refreshToken: (l$refreshToken as String?),
      refreshExpiraEn: l$refreshExpiraEn == null
          ? null
          : DateTime.parse((l$refreshExpiraEn as String)),
      usuario: Fragment$UsuarioCampos.fromJson(
        (l$usuario as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String token;

  final DateTime expiraEn;

  final String? refreshToken;

  final DateTime? refreshExpiraEn;

  final Fragment$UsuarioCampos usuario;

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
    final l$usuario = usuario;
    _resultData['usuario'] = l$usuario.toJson();
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
    final l$usuario = usuario;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$token,
      l$expiraEn,
      l$refreshToken,
      l$refreshExpiraEn,
      l$usuario,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$RegistrarCuenta$registrarCuenta$$Sesion ||
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
    final l$usuario = usuario;
    final lOther$usuario = other.usuario;
    if (l$usuario != lOther$usuario) {
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

class Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion
    implements Mutation$RegistrarCuenta$registrarCuenta {
  Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion({
    required this.mensaje,
    this.codigo,
    this.$__typename = 'ErrorAutenticacion',
  });

  factory Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$mensaje = json['mensaje'];
    final l$codigo = json['codigo'];
    final l$$__typename = json['__typename'];
    return Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion(
      mensaje: (l$mensaje as String),
      codigo: (l$codigo as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String mensaje;

  final String? codigo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$mensaje = mensaje;
    _resultData['mensaje'] = l$mensaje;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$mensaje = mensaje;
    final l$codigo = codigo;
    final l$$__typename = $__typename;
    return Object.hashAll([l$mensaje, l$codigo, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$mensaje = mensaje;
    final lOther$mensaje = other.mensaje;
    if (l$mensaje != lOther$mensaje) {
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

class Variables$Mutation$IniciarSesion {
  factory Variables$Mutation$IniciarSesion({
    required Input$CredencialesInput entrada,
  }) => Variables$Mutation$IniciarSesion._({r'entrada': entrada});

  Variables$Mutation$IniciarSesion._(this._$data);

  factory Variables$Mutation$IniciarSesion.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$entrada = data['entrada'];
    result$data['entrada'] = Input$CredencialesInput.fromJson(
      (l$entrada as Map<String, dynamic>),
    );
    return Variables$Mutation$IniciarSesion._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$CredencialesInput get entrada =>
      (_$data['entrada'] as Input$CredencialesInput);

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
    if (other is! Variables$Mutation$IniciarSesion ||
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

class Mutation$IniciarSesion {
  Mutation$IniciarSesion({
    required this.iniciarSesion,
    this.$__typename = 'Mutation',
  });

  factory Mutation$IniciarSesion.fromJson(Map<String, dynamic> json) {
    final l$iniciarSesion = json['iniciarSesion'];
    final l$$__typename = json['__typename'];
    return Mutation$IniciarSesion(
      iniciarSesion: Mutation$IniciarSesion$iniciarSesion.fromJson(
        (l$iniciarSesion as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$IniciarSesion$iniciarSesion iniciarSesion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$iniciarSesion = iniciarSesion;
    _resultData['iniciarSesion'] = l$iniciarSesion.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$iniciarSesion = iniciarSesion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$iniciarSesion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$IniciarSesion || runtimeType != other.runtimeType) {
      return false;
    }
    final l$iniciarSesion = iniciarSesion;
    final lOther$iniciarSesion = other.iniciarSesion;
    if (l$iniciarSesion != lOther$iniciarSesion) {
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

const documentNodeMutationIniciarSesion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'IniciarSesion'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'entrada')),
          type: NamedTypeNode(
            name: NameNode(value: 'CredencialesInput'),
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
            name: NameNode(value: 'iniciarSesion'),
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
                        name: NameNode(value: 'usuario'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'UsuarioCampos'),
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
                        name: NameNode(value: 'mensaje'),
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
    fragmentDefinitionUsuarioCampos,
  ],
);

class Mutation$IniciarSesion$iniciarSesion {
  Mutation$IniciarSesion$iniciarSesion({required this.$__typename});

  factory Mutation$IniciarSesion$iniciarSesion.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Sesion":
        return Mutation$IniciarSesion$iniciarSesion$$Sesion.fromJson(json);

      case "ErrorAutenticacion":
        return Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$IniciarSesion$iniciarSesion(
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
    if (other is! Mutation$IniciarSesion$iniciarSesion ||
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

extension UtilityExtension$Mutation$IniciarSesion$iniciarSesion
    on Mutation$IniciarSesion$iniciarSesion {
  _T when<_T>({
    required _T Function(Mutation$IniciarSesion$iniciarSesion$$Sesion) sesion,
    required _T Function(
      Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion,
    )
    errorAutenticacion,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Sesion":
        return sesion(this as Mutation$IniciarSesion$iniciarSesion$$Sesion);

      case "ErrorAutenticacion":
        return errorAutenticacion(
          this as Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$IniciarSesion$iniciarSesion$$Sesion)? sesion,
    _T Function(Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion)?
    errorAutenticacion,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Sesion":
        if (sesion != null) {
          return sesion(this as Mutation$IniciarSesion$iniciarSesion$$Sesion);
        } else {
          return orElse();
        }

      case "ErrorAutenticacion":
        if (errorAutenticacion != null) {
          return errorAutenticacion(
            this as Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$IniciarSesion$iniciarSesion$$Sesion
    implements Mutation$IniciarSesion$iniciarSesion {
  Mutation$IniciarSesion$iniciarSesion$$Sesion({
    required this.token,
    required this.expiraEn,
    this.refreshToken,
    this.refreshExpiraEn,
    required this.usuario,
    this.$__typename = 'Sesion',
  });

  factory Mutation$IniciarSesion$iniciarSesion$$Sesion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$token = json['token'];
    final l$expiraEn = json['expiraEn'];
    final l$refreshToken = json['refreshToken'];
    final l$refreshExpiraEn = json['refreshExpiraEn'];
    final l$usuario = json['usuario'];
    final l$$__typename = json['__typename'];
    return Mutation$IniciarSesion$iniciarSesion$$Sesion(
      token: (l$token as String),
      expiraEn: DateTime.parse((l$expiraEn as String)),
      refreshToken: (l$refreshToken as String?),
      refreshExpiraEn: l$refreshExpiraEn == null
          ? null
          : DateTime.parse((l$refreshExpiraEn as String)),
      usuario: Fragment$UsuarioCampos.fromJson(
        (l$usuario as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String token;

  final DateTime expiraEn;

  final String? refreshToken;

  final DateTime? refreshExpiraEn;

  final Fragment$UsuarioCampos usuario;

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
    final l$usuario = usuario;
    _resultData['usuario'] = l$usuario.toJson();
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
    final l$usuario = usuario;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$token,
      l$expiraEn,
      l$refreshToken,
      l$refreshExpiraEn,
      l$usuario,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$IniciarSesion$iniciarSesion$$Sesion ||
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
    final l$usuario = usuario;
    final lOther$usuario = other.usuario;
    if (l$usuario != lOther$usuario) {
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

class Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion
    implements Mutation$IniciarSesion$iniciarSesion {
  Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion({
    required this.mensaje,
    this.codigo,
    this.$__typename = 'ErrorAutenticacion',
  });

  factory Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$mensaje = json['mensaje'];
    final l$codigo = json['codigo'];
    final l$$__typename = json['__typename'];
    return Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion(
      mensaje: (l$mensaje as String),
      codigo: (l$codigo as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String mensaje;

  final String? codigo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$mensaje = mensaje;
    _resultData['mensaje'] = l$mensaje;
    final l$codigo = codigo;
    _resultData['codigo'] = l$codigo;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$mensaje = mensaje;
    final l$codigo = codigo;
    final l$$__typename = $__typename;
    return Object.hashAll([l$mensaje, l$codigo, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$mensaje = mensaje;
    final lOther$mensaje = other.mensaje;
    if (l$mensaje != lOther$mensaje) {
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

class Query$Yo {
  Query$Yo({this.yo, this.$__typename = 'Query'});

  factory Query$Yo.fromJson(Map<String, dynamic> json) {
    final l$yo = json['yo'];
    final l$$__typename = json['__typename'];
    return Query$Yo(
      yo: l$yo == null
          ? null
          : Fragment$UsuarioCampos.fromJson((l$yo as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$UsuarioCampos? yo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$yo = yo;
    _resultData['yo'] = l$yo?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$yo = yo;
    final l$$__typename = $__typename;
    return Object.hashAll([l$yo, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Yo || runtimeType != other.runtimeType) {
      return false;
    }
    final l$yo = yo;
    final lOther$yo = other.yo;
    if (l$yo != lOther$yo) {
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

const documentNodeQueryYo = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Yo'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'yo'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'UsuarioCampos'),
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
    fragmentDefinitionUsuarioCampos,
  ],
);

class Variables$Mutation$ActualizarPreferencias {
  factory Variables$Mutation$ActualizarPreferencias({
    required Input$PreferenciasInput entrada,
  }) => Variables$Mutation$ActualizarPreferencias._({r'entrada': entrada});

  Variables$Mutation$ActualizarPreferencias._(this._$data);

  factory Variables$Mutation$ActualizarPreferencias.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$entrada = data['entrada'];
    result$data['entrada'] = Input$PreferenciasInput.fromJson(
      (l$entrada as Map<String, dynamic>),
    );
    return Variables$Mutation$ActualizarPreferencias._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$PreferenciasInput get entrada =>
      (_$data['entrada'] as Input$PreferenciasInput);

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
    if (other is! Variables$Mutation$ActualizarPreferencias ||
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

class Mutation$ActualizarPreferencias {
  Mutation$ActualizarPreferencias({
    required this.actualizarPreferencias,
    this.$__typename = 'Mutation',
  });

  factory Mutation$ActualizarPreferencias.fromJson(Map<String, dynamic> json) {
    final l$actualizarPreferencias = json['actualizarPreferencias'];
    final l$$__typename = json['__typename'];
    return Mutation$ActualizarPreferencias(
      actualizarPreferencias:
          Mutation$ActualizarPreferencias$actualizarPreferencias.fromJson(
            (l$actualizarPreferencias as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$ActualizarPreferencias$actualizarPreferencias
  actualizarPreferencias;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$actualizarPreferencias = actualizarPreferencias;
    _resultData['actualizarPreferencias'] = l$actualizarPreferencias.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$actualizarPreferencias = actualizarPreferencias;
    final l$$__typename = $__typename;
    return Object.hashAll([l$actualizarPreferencias, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ActualizarPreferencias ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$actualizarPreferencias = actualizarPreferencias;
    final lOther$actualizarPreferencias = other.actualizarPreferencias;
    if (l$actualizarPreferencias != lOther$actualizarPreferencias) {
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

const documentNodeMutationActualizarPreferencias = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ActualizarPreferencias'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'entrada')),
          type: NamedTypeNode(
            name: NameNode(value: 'PreferenciasInput'),
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
            name: NameNode(value: 'actualizarPreferencias'),
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
                      name: NameNode(value: 'Usuario'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'UsuarioCampos'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'ErrorUsuario'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
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
    fragmentDefinitionUsuarioCampos,
  ],
);

class Mutation$ActualizarPreferencias$actualizarPreferencias {
  Mutation$ActualizarPreferencias$actualizarPreferencias({
    required this.$__typename,
  });

  factory Mutation$ActualizarPreferencias$actualizarPreferencias.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Usuario":
        return Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario.fromJson(
          json,
        );

      case "ErrorUsuario":
        return Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$ActualizarPreferencias$actualizarPreferencias(
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
    if (other is! Mutation$ActualizarPreferencias$actualizarPreferencias ||
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

extension UtilityExtension$Mutation$ActualizarPreferencias$actualizarPreferencias
    on Mutation$ActualizarPreferencias$actualizarPreferencias {
  _T when<_T>({
    required _T Function(
      Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario,
    )
    usuario,
    required _T Function(
      Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario,
    )
    errorUsuario,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Usuario":
        return usuario(
          this
              as Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario,
        );

      case "ErrorUsuario":
        return errorUsuario(
          this
              as Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario,
    )?
    usuario,
    _T Function(
      Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario,
    )?
    errorUsuario,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Usuario":
        if (usuario != null) {
          return usuario(
            this
                as Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario,
          );
        } else {
          return orElse();
        }

      case "ErrorUsuario":
        if (errorUsuario != null) {
          return errorUsuario(
            this
                as Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario
    implements
        Fragment$UsuarioCampos,
        Mutation$ActualizarPreferencias$actualizarPreferencias {
  Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario({
    required this.id,
    required this.usuario,
    required this.rol,
    required this.estado,
    required this.creadoEn,
    this.nombre,
    required this.idioma,
    required this.moneda,
    required this.tieneContacto,
    this.documentoEnmascarado,
    this.$__typename = 'Usuario',
  });

  factory Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$usuario = json['usuario'];
    final l$rol = json['rol'];
    final l$estado = json['estado'];
    final l$creadoEn = json['creadoEn'];
    final l$nombre = json['nombre'];
    final l$idioma = json['idioma'];
    final l$moneda = json['moneda'];
    final l$tieneContacto = json['tieneContacto'];
    final l$documentoEnmascarado = json['documentoEnmascarado'];
    final l$$__typename = json['__typename'];
    return Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario(
      id: (l$id as String),
      usuario: (l$usuario as String),
      rol: fromJson$Enum$RolUsuario((l$rol as String)),
      estado: fromJson$Enum$EstadoUsuario((l$estado as String)),
      creadoEn: DateTime.parse((l$creadoEn as String)),
      nombre: (l$nombre as String?),
      idioma: (l$idioma as String),
      moneda: (l$moneda as String),
      tieneContacto: (l$tieneContacto as bool),
      documentoEnmascarado: (l$documentoEnmascarado as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String usuario;

  final Enum$RolUsuario rol;

  final Enum$EstadoUsuario estado;

  final DateTime creadoEn;

  final String? nombre;

  final String idioma;

  final String moneda;

  final bool tieneContacto;

  final String? documentoEnmascarado;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$usuario = usuario;
    _resultData['usuario'] = l$usuario;
    final l$rol = rol;
    _resultData['rol'] = toJson$Enum$RolUsuario(l$rol);
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoUsuario(l$estado);
    final l$creadoEn = creadoEn;
    _resultData['creadoEn'] = l$creadoEn.toIso8601String();
    final l$nombre = nombre;
    _resultData['nombre'] = l$nombre;
    final l$idioma = idioma;
    _resultData['idioma'] = l$idioma;
    final l$moneda = moneda;
    _resultData['moneda'] = l$moneda;
    final l$tieneContacto = tieneContacto;
    _resultData['tieneContacto'] = l$tieneContacto;
    final l$documentoEnmascarado = documentoEnmascarado;
    _resultData['documentoEnmascarado'] = l$documentoEnmascarado;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$usuario = usuario;
    final l$rol = rol;
    final l$estado = estado;
    final l$creadoEn = creadoEn;
    final l$nombre = nombre;
    final l$idioma = idioma;
    final l$moneda = moneda;
    final l$tieneContacto = tieneContacto;
    final l$documentoEnmascarado = documentoEnmascarado;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$usuario,
      l$rol,
      l$estado,
      l$creadoEn,
      l$nombre,
      l$idioma,
      l$moneda,
      l$tieneContacto,
      l$documentoEnmascarado,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ActualizarPreferencias$actualizarPreferencias$$Usuario ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$usuario = usuario;
    final lOther$usuario = other.usuario;
    if (l$usuario != lOther$usuario) {
      return false;
    }
    final l$rol = rol;
    final lOther$rol = other.rol;
    if (l$rol != lOther$rol) {
      return false;
    }
    final l$estado = estado;
    final lOther$estado = other.estado;
    if (l$estado != lOther$estado) {
      return false;
    }
    final l$creadoEn = creadoEn;
    final lOther$creadoEn = other.creadoEn;
    if (l$creadoEn != lOther$creadoEn) {
      return false;
    }
    final l$nombre = nombre;
    final lOther$nombre = other.nombre;
    if (l$nombre != lOther$nombre) {
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
    final l$tieneContacto = tieneContacto;
    final lOther$tieneContacto = other.tieneContacto;
    if (l$tieneContacto != lOther$tieneContacto) {
      return false;
    }
    final l$documentoEnmascarado = documentoEnmascarado;
    final lOther$documentoEnmascarado = other.documentoEnmascarado;
    if (l$documentoEnmascarado != lOther$documentoEnmascarado) {
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

class Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario
    implements Mutation$ActualizarPreferencias$actualizarPreferencias {
  Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario({
    required this.mensaje,
    this.$__typename = 'ErrorUsuario',
  });

  factory Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$mensaje = json['mensaje'];
    final l$$__typename = json['__typename'];
    return Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario(
      mensaje: (l$mensaje as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String mensaje;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$mensaje = mensaje;
    _resultData['mensaje'] = l$mensaje;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$mensaje = mensaje;
    final l$$__typename = $__typename;
    return Object.hashAll([l$mensaje, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ActualizarPreferencias$actualizarPreferencias$$ErrorUsuario ||
        runtimeType != other.runtimeType) {
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
