// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import '../../../../core/contrato/schema.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Mutation$SolicitarAsistencia {
  factory Variables$Mutation$SolicitarAsistencia({
    required Input$SolicitudAsistenciaInput entrada,
  }) => Variables$Mutation$SolicitarAsistencia._({r'entrada': entrada});

  Variables$Mutation$SolicitarAsistencia._(this._$data);

  factory Variables$Mutation$SolicitarAsistencia.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$entrada = data['entrada'];
    result$data['entrada'] = Input$SolicitudAsistenciaInput.fromJson(
      (l$entrada as Map<String, dynamic>),
    );
    return Variables$Mutation$SolicitarAsistencia._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$SolicitudAsistenciaInput get entrada =>
      (_$data['entrada'] as Input$SolicitudAsistenciaInput);

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
    if (other is! Variables$Mutation$SolicitarAsistencia ||
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

class Mutation$SolicitarAsistencia {
  Mutation$SolicitarAsistencia({
    required this.solicitarAsistencia,
    this.$__typename = 'Mutation',
  });

  factory Mutation$SolicitarAsistencia.fromJson(Map<String, dynamic> json) {
    final l$solicitarAsistencia = json['solicitarAsistencia'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarAsistencia(
      solicitarAsistencia:
          Mutation$SolicitarAsistencia$solicitarAsistencia.fromJson(
            (l$solicitarAsistencia as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SolicitarAsistencia$solicitarAsistencia solicitarAsistencia;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$solicitarAsistencia = solicitarAsistencia;
    _resultData['solicitarAsistencia'] = l$solicitarAsistencia.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$solicitarAsistencia = solicitarAsistencia;
    final l$$__typename = $__typename;
    return Object.hashAll([l$solicitarAsistencia, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SolicitarAsistencia ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$solicitarAsistencia = solicitarAsistencia;
    final lOther$solicitarAsistencia = other.solicitarAsistencia;
    if (l$solicitarAsistencia != lOther$solicitarAsistencia) {
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

const documentNodeMutationSolicitarAsistencia = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SolicitarAsistencia'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'entrada')),
          type: NamedTypeNode(
            name: NameNode(value: 'SolicitudAsistenciaInput'),
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
            name: NameNode(value: 'solicitarAsistencia'),
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

class Mutation$SolicitarAsistencia$solicitarAsistencia {
  Mutation$SolicitarAsistencia$solicitarAsistencia({required this.$__typename});

  factory Mutation$SolicitarAsistencia$solicitarAsistencia.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Asistencia":
        return Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia.fromJson(
          json,
        );

      case "ErrorAsistencia":
        return Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$SolicitarAsistencia$solicitarAsistencia(
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
    if (other is! Mutation$SolicitarAsistencia$solicitarAsistencia ||
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

extension UtilityExtension$Mutation$SolicitarAsistencia$solicitarAsistencia
    on Mutation$SolicitarAsistencia$solicitarAsistencia {
  _T when<_T>({
    required _T Function(
      Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia,
    )
    asistencia,
    required _T Function(
      Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia,
    )
    errorAsistencia,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Asistencia":
        return asistencia(
          this as Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia,
        );

      case "ErrorAsistencia":
        return errorAsistencia(
          this
              as Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia)?
    asistencia,
    _T Function(
      Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia,
    )?
    errorAsistencia,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Asistencia":
        if (asistencia != null) {
          return asistencia(
            this
                as Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia,
          );
        } else {
          return orElse();
        }

      case "ErrorAsistencia":
        if (errorAsistencia != null) {
          return errorAsistencia(
            this
                as Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia
    implements Mutation$SolicitarAsistencia$solicitarAsistencia {
  Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia({
    required this.id,
    required this.estado,
    required this.tipoAsistencia,
    this.minutosEstimados,
    this.motivo,
    required this.solicitadaEn,
    this.canceladaEn,
    this.confirmadaEn,
    this.llegadaEstimada,
    required this.prestador,
    this.$__typename = 'Asistencia',
  });

  factory Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia.fromJson(
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
    final l$prestador = json['prestador'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia(
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
      prestador:
          Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia$prestador.fromJson(
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

  final Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia$prestador
  prestador;

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
      l$prestador,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia ||
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

class Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia$prestador {
  Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia$prestador({
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

  factory Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia$prestador.fromJson(
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
    return Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia$prestador(
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
    if (other
            is! Mutation$SolicitarAsistencia$solicitarAsistencia$$Asistencia$prestador ||
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

class Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia
    implements Mutation$SolicitarAsistencia$solicitarAsistencia {
  Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia({
    required this.codigo,
    required this.mensaje,
    this.$__typename = 'ErrorAsistencia',
  });

  factory Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$codigo = json['codigo'];
    final l$mensaje = json['mensaje'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia(
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
    if (other
            is! Mutation$SolicitarAsistencia$solicitarAsistencia$$ErrorAsistencia ||
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

class Variables$Mutation$CancelarAsistencia {
  factory Variables$Mutation$CancelarAsistencia({required String id}) =>
      Variables$Mutation$CancelarAsistencia._({r'id': id});

  Variables$Mutation$CancelarAsistencia._(this._$data);

  factory Variables$Mutation$CancelarAsistencia.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$CancelarAsistencia._(result$data);
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
    if (other is! Variables$Mutation$CancelarAsistencia ||
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

class Mutation$CancelarAsistencia {
  Mutation$CancelarAsistencia({
    required this.cancelarAsistencia,
    this.$__typename = 'Mutation',
  });

  factory Mutation$CancelarAsistencia.fromJson(Map<String, dynamic> json) {
    final l$cancelarAsistencia = json['cancelarAsistencia'];
    final l$$__typename = json['__typename'];
    return Mutation$CancelarAsistencia(
      cancelarAsistencia:
          Mutation$CancelarAsistencia$cancelarAsistencia.fromJson(
            (l$cancelarAsistencia as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$CancelarAsistencia$cancelarAsistencia cancelarAsistencia;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cancelarAsistencia = cancelarAsistencia;
    _resultData['cancelarAsistencia'] = l$cancelarAsistencia.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cancelarAsistencia = cancelarAsistencia;
    final l$$__typename = $__typename;
    return Object.hashAll([l$cancelarAsistencia, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CancelarAsistencia ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$cancelarAsistencia = cancelarAsistencia;
    final lOther$cancelarAsistencia = other.cancelarAsistencia;
    if (l$cancelarAsistencia != lOther$cancelarAsistencia) {
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

const documentNodeMutationCancelarAsistencia = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CancelarAsistencia'),
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
            name: NameNode(value: 'cancelarAsistencia'),
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

class Mutation$CancelarAsistencia$cancelarAsistencia {
  Mutation$CancelarAsistencia$cancelarAsistencia({required this.$__typename});

  factory Mutation$CancelarAsistencia$cancelarAsistencia.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Asistencia":
        return Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia.fromJson(
          json,
        );

      case "ErrorAsistencia":
        return Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$CancelarAsistencia$cancelarAsistencia(
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
    if (other is! Mutation$CancelarAsistencia$cancelarAsistencia ||
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

extension UtilityExtension$Mutation$CancelarAsistencia$cancelarAsistencia
    on Mutation$CancelarAsistencia$cancelarAsistencia {
  _T when<_T>({
    required _T Function(
      Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia,
    )
    asistencia,
    required _T Function(
      Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia,
    )
    errorAsistencia,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Asistencia":
        return asistencia(
          this as Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia,
        );

      case "ErrorAsistencia":
        return errorAsistencia(
          this
              as Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia)?
    asistencia,
    _T Function(
      Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia,
    )?
    errorAsistencia,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Asistencia":
        if (asistencia != null) {
          return asistencia(
            this as Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia,
          );
        } else {
          return orElse();
        }

      case "ErrorAsistencia":
        if (errorAsistencia != null) {
          return errorAsistencia(
            this
                as Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia
    implements Mutation$CancelarAsistencia$cancelarAsistencia {
  Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia({
    required this.id,
    required this.estado,
    required this.tipoAsistencia,
    this.minutosEstimados,
    this.motivo,
    required this.solicitadaEn,
    this.canceladaEn,
    this.confirmadaEn,
    this.llegadaEstimada,
    required this.prestador,
    this.$__typename = 'Asistencia',
  });

  factory Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia.fromJson(
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
    final l$prestador = json['prestador'];
    final l$$__typename = json['__typename'];
    return Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia(
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
      prestador:
          Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia$prestador.fromJson(
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

  final Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia$prestador
  prestador;

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
      l$prestador,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia ||
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

class Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia$prestador {
  Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia$prestador({
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

  factory Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia$prestador.fromJson(
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
    return Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia$prestador(
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
    if (other
            is! Mutation$CancelarAsistencia$cancelarAsistencia$$Asistencia$prestador ||
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

class Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia
    implements Mutation$CancelarAsistencia$cancelarAsistencia {
  Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia({
    required this.codigo,
    required this.mensaje,
    this.$__typename = 'ErrorAsistencia',
  });

  factory Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$codigo = json['codigo'];
    final l$mensaje = json['mensaje'];
    final l$$__typename = json['__typename'];
    return Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia(
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
    if (other
            is! Mutation$CancelarAsistencia$cancelarAsistencia$$ErrorAsistencia ||
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
