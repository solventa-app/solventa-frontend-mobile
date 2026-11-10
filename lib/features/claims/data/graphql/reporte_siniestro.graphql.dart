// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import '../../../../core/contrato/schema.graphql.dart';

import 'package:gql/ast.dart';

class Fragment$SiniestroReportadoCampos {
  Fragment$SiniestroReportadoCampos({
    required this.id,
    required this.radicado,
    required this.estado,
    required this.polizaId,
    required this.ocurridoEn,
    required this.notificadoEn,
    required this.venceDictamenEn,
    required this.fotos,
    this.tipoSiniestroAuto,
    this.$__typename = 'SiniestroReportado',
  });

  factory Fragment$SiniestroReportadoCampos.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$radicado = json['radicado'];
    final l$estado = json['estado'];
    final l$polizaId = json['polizaId'];
    final l$ocurridoEn = json['ocurridoEn'];
    final l$notificadoEn = json['notificadoEn'];
    final l$venceDictamenEn = json['venceDictamenEn'];
    final l$fotos = json['fotos'];
    final l$tipoSiniestroAuto = json['tipoSiniestroAuto'];
    final l$$__typename = json['__typename'];
    return Fragment$SiniestroReportadoCampos(
      id: (l$id as String),
      radicado: (l$radicado as String),
      estado: fromJson$Enum$EstadoSiniestro((l$estado as String)),
      polizaId: (l$polizaId as String),
      ocurridoEn: DateTime.parse((l$ocurridoEn as String)),
      notificadoEn: DateTime.parse((l$notificadoEn as String)),
      venceDictamenEn: DateTime.parse((l$venceDictamenEn as String)),
      fotos: (l$fotos as int),
      tipoSiniestroAuto: l$tipoSiniestroAuto == null
          ? null
          : fromJson$Enum$TipoSiniestroAuto((l$tipoSiniestroAuto as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String radicado;

  final Enum$EstadoSiniestro estado;

  final String polizaId;

  final DateTime ocurridoEn;

  final DateTime notificadoEn;

  final DateTime venceDictamenEn;

  final int fotos;

  final Enum$TipoSiniestroAuto? tipoSiniestroAuto;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$radicado = radicado;
    _resultData['radicado'] = l$radicado;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoSiniestro(l$estado);
    final l$polizaId = polizaId;
    _resultData['polizaId'] = l$polizaId;
    final l$ocurridoEn = ocurridoEn;
    _resultData['ocurridoEn'] = l$ocurridoEn.toIso8601String();
    final l$notificadoEn = notificadoEn;
    _resultData['notificadoEn'] = l$notificadoEn.toIso8601String();
    final l$venceDictamenEn = venceDictamenEn;
    _resultData['venceDictamenEn'] = l$venceDictamenEn.toIso8601String();
    final l$fotos = fotos;
    _resultData['fotos'] = l$fotos;
    final l$tipoSiniestroAuto = tipoSiniestroAuto;
    _resultData['tipoSiniestroAuto'] = l$tipoSiniestroAuto == null
        ? null
        : toJson$Enum$TipoSiniestroAuto(l$tipoSiniestroAuto);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$radicado = radicado;
    final l$estado = estado;
    final l$polizaId = polizaId;
    final l$ocurridoEn = ocurridoEn;
    final l$notificadoEn = notificadoEn;
    final l$venceDictamenEn = venceDictamenEn;
    final l$fotos = fotos;
    final l$tipoSiniestroAuto = tipoSiniestroAuto;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$radicado,
      l$estado,
      l$polizaId,
      l$ocurridoEn,
      l$notificadoEn,
      l$venceDictamenEn,
      l$fotos,
      l$tipoSiniestroAuto,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SiniestroReportadoCampos ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$radicado = radicado;
    final lOther$radicado = other.radicado;
    if (l$radicado != lOther$radicado) {
      return false;
    }
    final l$estado = estado;
    final lOther$estado = other.estado;
    if (l$estado != lOther$estado) {
      return false;
    }
    final l$polizaId = polizaId;
    final lOther$polizaId = other.polizaId;
    if (l$polizaId != lOther$polizaId) {
      return false;
    }
    final l$ocurridoEn = ocurridoEn;
    final lOther$ocurridoEn = other.ocurridoEn;
    if (l$ocurridoEn != lOther$ocurridoEn) {
      return false;
    }
    final l$notificadoEn = notificadoEn;
    final lOther$notificadoEn = other.notificadoEn;
    if (l$notificadoEn != lOther$notificadoEn) {
      return false;
    }
    final l$venceDictamenEn = venceDictamenEn;
    final lOther$venceDictamenEn = other.venceDictamenEn;
    if (l$venceDictamenEn != lOther$venceDictamenEn) {
      return false;
    }
    final l$fotos = fotos;
    final lOther$fotos = other.fotos;
    if (l$fotos != lOther$fotos) {
      return false;
    }
    final l$tipoSiniestroAuto = tipoSiniestroAuto;
    final lOther$tipoSiniestroAuto = other.tipoSiniestroAuto;
    if (l$tipoSiniestroAuto != lOther$tipoSiniestroAuto) {
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

const fragmentDefinitionSiniestroReportadoCampos = FragmentDefinitionNode(
  name: NameNode(value: 'SiniestroReportadoCampos'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'SiniestroReportado'),
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
        name: NameNode(value: 'radicado'),
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
        name: NameNode(value: 'polizaId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'ocurridoEn'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'notificadoEn'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'venceDictamenEn'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'fotos'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'tipoSiniestroAuto'),
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
const documentNodeFragmentSiniestroReportadoCampos = DocumentNode(
  definitions: [fragmentDefinitionSiniestroReportadoCampos],
);

class Query$PolizasParaReporte {
  Query$PolizasParaReporte({
    required this.propuestas,
    this.$__typename = 'Query',
  });

  factory Query$PolizasParaReporte.fromJson(Map<String, dynamic> json) {
    final l$propuestas = json['propuestas'];
    final l$$__typename = json['__typename'];
    return Query$PolizasParaReporte(
      propuestas: Query$PolizasParaReporte$propuestas.fromJson(
        (l$propuestas as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$PolizasParaReporte$propuestas propuestas;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$propuestas = propuestas;
    _resultData['propuestas'] = l$propuestas.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$propuestas = propuestas;
    final l$$__typename = $__typename;
    return Object.hashAll([l$propuestas, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PolizasParaReporte ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$propuestas = propuestas;
    final lOther$propuestas = other.propuestas;
    if (l$propuestas != lOther$propuestas) {
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

const documentNodeQueryPolizasParaReporte = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'PolizasParaReporte'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'propuestas'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'estado'),
                value: EnumValueNode(name: NameNode(value: 'EMITIDA')),
              ),
              ArgumentNode(
                name: NameNode(value: 'pagina'),
                value: IntValueNode(value: '1'),
              ),
              ArgumentNode(
                name: NameNode(value: 'tamano'),
                value: IntValueNode(value: '20'),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'propuestas'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'poliza'),
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
                              name: NameNode(value: 'numero'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'vigenciaDesde'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'vigenciaHasta'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'producto'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'vehiculo'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FieldNode(
                                    name: NameNode(value: 'marca'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: null,
                                  ),
                                  FieldNode(
                                    name: NameNode(value: 'placaEnmascarada'),
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

class Query$PolizasParaReporte$propuestas {
  Query$PolizasParaReporte$propuestas({
    required this.propuestas,
    this.$__typename = 'PaginaPropuestas',
  });

  factory Query$PolizasParaReporte$propuestas.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$propuestas = json['propuestas'];
    final l$$__typename = json['__typename'];
    return Query$PolizasParaReporte$propuestas(
      propuestas: (l$propuestas as List<dynamic>)
          .map(
            (e) => Query$PolizasParaReporte$propuestas$propuestas.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$PolizasParaReporte$propuestas$propuestas> propuestas;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$propuestas = propuestas;
    _resultData['propuestas'] = l$propuestas.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$propuestas = propuestas;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$propuestas.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PolizasParaReporte$propuestas ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$propuestas = propuestas;
    final lOther$propuestas = other.propuestas;
    if (l$propuestas.length != lOther$propuestas.length) {
      return false;
    }
    for (int i = 0; i < l$propuestas.length; i++) {
      final l$propuestas$entry = l$propuestas[i];
      final lOther$propuestas$entry = lOther$propuestas[i];
      if (l$propuestas$entry != lOther$propuestas$entry) {
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

class Query$PolizasParaReporte$propuestas$propuestas {
  Query$PolizasParaReporte$propuestas$propuestas({
    this.poliza,
    this.$__typename = 'Propuesta',
  });

  factory Query$PolizasParaReporte$propuestas$propuestas.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$poliza = json['poliza'];
    final l$$__typename = json['__typename'];
    return Query$PolizasParaReporte$propuestas$propuestas(
      poliza: l$poliza == null
          ? null
          : Query$PolizasParaReporte$propuestas$propuestas$poliza.fromJson(
              (l$poliza as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$PolizasParaReporte$propuestas$propuestas$poliza? poliza;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$poliza = poliza;
    _resultData['poliza'] = l$poliza?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$poliza = poliza;
    final l$$__typename = $__typename;
    return Object.hashAll([l$poliza, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PolizasParaReporte$propuestas$propuestas ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$poliza = poliza;
    final lOther$poliza = other.poliza;
    if (l$poliza != lOther$poliza) {
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

class Query$PolizasParaReporte$propuestas$propuestas$poliza {
  Query$PolizasParaReporte$propuestas$propuestas$poliza({
    required this.id,
    required this.numero,
    required this.vigenciaDesde,
    required this.vigenciaHasta,
    required this.producto,
    this.vehiculo,
    this.$__typename = 'Poliza',
  });

  factory Query$PolizasParaReporte$propuestas$propuestas$poliza.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$numero = json['numero'];
    final l$vigenciaDesde = json['vigenciaDesde'];
    final l$vigenciaHasta = json['vigenciaHasta'];
    final l$producto = json['producto'];
    final l$vehiculo = json['vehiculo'];
    final l$$__typename = json['__typename'];
    return Query$PolizasParaReporte$propuestas$propuestas$poliza(
      id: (l$id as String),
      numero: (l$numero as String),
      vigenciaDesde: DateTime.parse((l$vigenciaDesde as String)),
      vigenciaHasta: DateTime.parse((l$vigenciaHasta as String)),
      producto: fromJson$Enum$Producto((l$producto as String)),
      vehiculo: l$vehiculo == null
          ? null
          : Query$PolizasParaReporte$propuestas$propuestas$poliza$vehiculo.fromJson(
              (l$vehiculo as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String numero;

  final DateTime vigenciaDesde;

  final DateTime vigenciaHasta;

  final Enum$Producto producto;

  final Query$PolizasParaReporte$propuestas$propuestas$poliza$vehiculo?
  vehiculo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$numero = numero;
    _resultData['numero'] = l$numero;
    final l$vigenciaDesde = vigenciaDesde;
    _resultData['vigenciaDesde'] = l$vigenciaDesde.toIso8601String();
    final l$vigenciaHasta = vigenciaHasta;
    _resultData['vigenciaHasta'] = l$vigenciaHasta.toIso8601String();
    final l$producto = producto;
    _resultData['producto'] = toJson$Enum$Producto(l$producto);
    final l$vehiculo = vehiculo;
    _resultData['vehiculo'] = l$vehiculo?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$numero = numero;
    final l$vigenciaDesde = vigenciaDesde;
    final l$vigenciaHasta = vigenciaHasta;
    final l$producto = producto;
    final l$vehiculo = vehiculo;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$numero,
      l$vigenciaDesde,
      l$vigenciaHasta,
      l$producto,
      l$vehiculo,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PolizasParaReporte$propuestas$propuestas$poliza ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$numero = numero;
    final lOther$numero = other.numero;
    if (l$numero != lOther$numero) {
      return false;
    }
    final l$vigenciaDesde = vigenciaDesde;
    final lOther$vigenciaDesde = other.vigenciaDesde;
    if (l$vigenciaDesde != lOther$vigenciaDesde) {
      return false;
    }
    final l$vigenciaHasta = vigenciaHasta;
    final lOther$vigenciaHasta = other.vigenciaHasta;
    if (l$vigenciaHasta != lOther$vigenciaHasta) {
      return false;
    }
    final l$producto = producto;
    final lOther$producto = other.producto;
    if (l$producto != lOther$producto) {
      return false;
    }
    final l$vehiculo = vehiculo;
    final lOther$vehiculo = other.vehiculo;
    if (l$vehiculo != lOther$vehiculo) {
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

class Query$PolizasParaReporte$propuestas$propuestas$poliza$vehiculo {
  Query$PolizasParaReporte$propuestas$propuestas$poliza$vehiculo({
    required this.marca,
    required this.placaEnmascarada,
    this.$__typename = 'VehiculoAsegurado',
  });

  factory Query$PolizasParaReporte$propuestas$propuestas$poliza$vehiculo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$marca = json['marca'];
    final l$placaEnmascarada = json['placaEnmascarada'];
    final l$$__typename = json['__typename'];
    return Query$PolizasParaReporte$propuestas$propuestas$poliza$vehiculo(
      marca: (l$marca as String),
      placaEnmascarada: (l$placaEnmascarada as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String marca;

  final String placaEnmascarada;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$marca = marca;
    _resultData['marca'] = l$marca;
    final l$placaEnmascarada = placaEnmascarada;
    _resultData['placaEnmascarada'] = l$placaEnmascarada;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$marca = marca;
    final l$placaEnmascarada = placaEnmascarada;
    final l$$__typename = $__typename;
    return Object.hashAll([l$marca, l$placaEnmascarada, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$PolizasParaReporte$propuestas$propuestas$poliza$vehiculo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$marca = marca;
    final lOther$marca = other.marca;
    if (l$marca != lOther$marca) {
      return false;
    }
    final l$placaEnmascarada = placaEnmascarada;
    final lOther$placaEnmascarada = other.placaEnmascarada;
    if (l$placaEnmascarada != lOther$placaEnmascarada) {
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

class Variables$Mutation$SolicitarSubidaEvidenciaSiniestro {
  factory Variables$Mutation$SolicitarSubidaEvidenciaSiniestro({
    required String idReporte,
    required String tipoContenido,
    required int tamanoBytes,
  }) => Variables$Mutation$SolicitarSubidaEvidenciaSiniestro._({
    r'idReporte': idReporte,
    r'tipoContenido': tipoContenido,
    r'tamanoBytes': tamanoBytes,
  });

  Variables$Mutation$SolicitarSubidaEvidenciaSiniestro._(this._$data);

  factory Variables$Mutation$SolicitarSubidaEvidenciaSiniestro.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$idReporte = data['idReporte'];
    result$data['idReporte'] = (l$idReporte as String);
    final l$tipoContenido = data['tipoContenido'];
    result$data['tipoContenido'] = (l$tipoContenido as String);
    final l$tamanoBytes = data['tamanoBytes'];
    result$data['tamanoBytes'] = (l$tamanoBytes as int);
    return Variables$Mutation$SolicitarSubidaEvidenciaSiniestro._(result$data);
  }

  Map<String, dynamic> _$data;

  String get idReporte => (_$data['idReporte'] as String);

  String get tipoContenido => (_$data['tipoContenido'] as String);

  int get tamanoBytes => (_$data['tamanoBytes'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$idReporte = idReporte;
    result$data['idReporte'] = l$idReporte;
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
    if (other is! Variables$Mutation$SolicitarSubidaEvidenciaSiniestro ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$idReporte = idReporte;
    final lOther$idReporte = other.idReporte;
    if (l$idReporte != lOther$idReporte) {
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
    final l$idReporte = idReporte;
    final l$tipoContenido = tipoContenido;
    final l$tamanoBytes = tamanoBytes;
    return Object.hashAll([l$idReporte, l$tipoContenido, l$tamanoBytes]);
  }
}

class Mutation$SolicitarSubidaEvidenciaSiniestro {
  Mutation$SolicitarSubidaEvidenciaSiniestro({
    required this.solicitarSubidaEvidenciaSiniestro,
    this.$__typename = 'Mutation',
  });

  factory Mutation$SolicitarSubidaEvidenciaSiniestro.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$solicitarSubidaEvidenciaSiniestro =
        json['solicitarSubidaEvidenciaSiniestro'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarSubidaEvidenciaSiniestro(
      solicitarSubidaEvidenciaSiniestro:
          Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro.fromJson(
            (l$solicitarSubidaEvidenciaSiniestro as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro
  solicitarSubidaEvidenciaSiniestro;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$solicitarSubidaEvidenciaSiniestro =
        solicitarSubidaEvidenciaSiniestro;
    _resultData['solicitarSubidaEvidenciaSiniestro'] =
        l$solicitarSubidaEvidenciaSiniestro.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$solicitarSubidaEvidenciaSiniestro =
        solicitarSubidaEvidenciaSiniestro;
    final l$$__typename = $__typename;
    return Object.hashAll([l$solicitarSubidaEvidenciaSiniestro, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SolicitarSubidaEvidenciaSiniestro ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$solicitarSubidaEvidenciaSiniestro =
        solicitarSubidaEvidenciaSiniestro;
    final lOther$solicitarSubidaEvidenciaSiniestro =
        other.solicitarSubidaEvidenciaSiniestro;
    if (l$solicitarSubidaEvidenciaSiniestro !=
        lOther$solicitarSubidaEvidenciaSiniestro) {
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

const documentNodeMutationSolicitarSubidaEvidenciaSiniestro = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SolicitarSubidaEvidenciaSiniestro'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'idReporte')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
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
            name: NameNode(value: 'solicitarSubidaEvidenciaSiniestro'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'idReporte'),
                value: VariableNode(name: NameNode(value: 'idReporte')),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'ErrorArchivo'),
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

class Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro {
  Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro({
    required this.$__typename,
  });

  factory Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "SubidaArchivo":
        return Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo.fromJson(
          json,
        );

      case "ErrorArchivo":
        return Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro(
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
            is! Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro ||
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

extension UtilityExtension$Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro
    on Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro {
  _T when<_T>({
    required _T Function(
      Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo,
    )
    subidaArchivo,
    required _T Function(
      Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo,
    )
    errorArchivo,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "SubidaArchivo":
        return subidaArchivo(
          this
              as Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo,
        );

      case "ErrorArchivo":
        return errorArchivo(
          this
              as Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo,
    )?
    subidaArchivo,
    _T Function(
      Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo,
    )?
    errorArchivo,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "SubidaArchivo":
        if (subidaArchivo != null) {
          return subidaArchivo(
            this
                as Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo,
          );
        } else {
          return orElse();
        }

      case "ErrorArchivo":
        if (errorArchivo != null) {
          return errorArchivo(
            this
                as Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo
    implements
        Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro {
  Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo({
    required this.url,
    required this.metodo,
    required this.encabezados,
    required this.archivo,
    this.$__typename = 'SubidaArchivo',
  });

  factory Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$metodo = json['metodo'];
    final l$encabezados = json['encabezados'];
    final l$archivo = json['archivo'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo(
      url: (l$url as String),
      metodo: (l$metodo as String),
      encabezados: (l$encabezados as List<dynamic>)
          .map(
            (e) =>
                Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$encabezados.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      archivo:
          Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$archivo.fromJson(
            (l$archivo as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final String url;

  final String metodo;

  final List<
    Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$encabezados
  >
  encabezados;

  final Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$archivo
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
            is! Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo ||
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

class Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$encabezados {
  Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$encabezados({
    required this.nombre,
    required this.valor,
    this.$__typename = 'EncabezadoSubida',
  });

  factory Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$encabezados.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$nombre = json['nombre'];
    final l$valor = json['valor'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$encabezados(
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
            is! Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$encabezados ||
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

class Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$archivo {
  Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$archivo({
    required this.id,
    this.$__typename = 'Archivo',
  });

  factory Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$archivo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$archivo(
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
            is! Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo$archivo ||
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

class Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo
    implements
        Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro {
  Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo({
    required this.codigo,
    this.$__typename = 'ErrorArchivo',
  });

  factory Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$codigo = json['codigo'];
    final l$$__typename = json['__typename'];
    return Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo(
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
    if (other
            is! Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo ||
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

class Variables$Mutation$ConfirmarSubidaEvidencia {
  factory Variables$Mutation$ConfirmarSubidaEvidencia({required String id}) =>
      Variables$Mutation$ConfirmarSubidaEvidencia._({r'id': id});

  Variables$Mutation$ConfirmarSubidaEvidencia._(this._$data);

  factory Variables$Mutation$ConfirmarSubidaEvidencia.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$ConfirmarSubidaEvidencia._(result$data);
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
    if (other is! Variables$Mutation$ConfirmarSubidaEvidencia ||
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

class Mutation$ConfirmarSubidaEvidencia {
  Mutation$ConfirmarSubidaEvidencia({
    required this.confirmarSubidaArchivo,
    this.$__typename = 'Mutation',
  });

  factory Mutation$ConfirmarSubidaEvidencia.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$confirmarSubidaArchivo = json['confirmarSubidaArchivo'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmarSubidaEvidencia(
      confirmarSubidaArchivo:
          Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo.fromJson(
            (l$confirmarSubidaArchivo as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo
  confirmarSubidaArchivo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$confirmarSubidaArchivo = confirmarSubidaArchivo;
    _resultData['confirmarSubidaArchivo'] = l$confirmarSubidaArchivo.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$confirmarSubidaArchivo = confirmarSubidaArchivo;
    final l$$__typename = $__typename;
    return Object.hashAll([l$confirmarSubidaArchivo, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmarSubidaEvidencia ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$confirmarSubidaArchivo = confirmarSubidaArchivo;
    final lOther$confirmarSubidaArchivo = other.confirmarSubidaArchivo;
    if (l$confirmarSubidaArchivo != lOther$confirmarSubidaArchivo) {
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

const documentNodeMutationConfirmarSubidaEvidencia = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ConfirmarSubidaEvidencia'),
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
            name: NameNode(value: 'confirmarSubidaArchivo'),
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
                      name: NameNode(value: 'Archivo'),
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
                      name: NameNode(value: 'ErrorArchivo'),
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

class Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo {
  Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo({
    required this.$__typename,
  });

  factory Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Archivo":
        return Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo.fromJson(
          json,
        );

      case "ErrorArchivo":
        return Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo(
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
    if (other is! Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo ||
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

extension UtilityExtension$Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo
    on Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo {
  _T when<_T>({
    required _T Function(
      Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo,
    )
    archivo,
    required _T Function(
      Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo,
    )
    errorArchivo,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Archivo":
        return archivo(
          this
              as Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo,
        );

      case "ErrorArchivo":
        return errorArchivo(
          this
              as Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo,
    )?
    archivo,
    _T Function(
      Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo,
    )?
    errorArchivo,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Archivo":
        if (archivo != null) {
          return archivo(
            this
                as Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo,
          );
        } else {
          return orElse();
        }

      case "ErrorArchivo":
        if (errorArchivo != null) {
          return errorArchivo(
            this
                as Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo
    implements Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo {
  Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo({
    required this.id,
    required this.estado,
    this.$__typename = 'Archivo',
  });

  factory Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$estado = json['estado'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo(
      id: (l$id as String),
      estado: fromJson$Enum$EstadoArchivo((l$estado as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$EstadoArchivo estado;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoArchivo(l$estado);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$estado = estado;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$estado, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo
    implements Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo {
  Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo({
    required this.codigo,
    this.$__typename = 'ErrorArchivo',
  });

  factory Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$codigo = json['codigo'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo(
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
    if (other
            is! Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$ErrorArchivo ||
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

class Variables$Mutation$ReportarSiniestro {
  factory Variables$Mutation$ReportarSiniestro({
    required Input$ReporteSiniestroInput entrada,
  }) => Variables$Mutation$ReportarSiniestro._({r'entrada': entrada});

  Variables$Mutation$ReportarSiniestro._(this._$data);

  factory Variables$Mutation$ReportarSiniestro.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$entrada = data['entrada'];
    result$data['entrada'] = Input$ReporteSiniestroInput.fromJson(
      (l$entrada as Map<String, dynamic>),
    );
    return Variables$Mutation$ReportarSiniestro._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ReporteSiniestroInput get entrada =>
      (_$data['entrada'] as Input$ReporteSiniestroInput);

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
    if (other is! Variables$Mutation$ReportarSiniestro ||
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

class Mutation$ReportarSiniestro {
  Mutation$ReportarSiniestro({
    required this.reportarSiniestro,
    this.$__typename = 'Mutation',
  });

  factory Mutation$ReportarSiniestro.fromJson(Map<String, dynamic> json) {
    final l$reportarSiniestro = json['reportarSiniestro'];
    final l$$__typename = json['__typename'];
    return Mutation$ReportarSiniestro(
      reportarSiniestro: Mutation$ReportarSiniestro$reportarSiniestro.fromJson(
        (l$reportarSiniestro as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$ReportarSiniestro$reportarSiniestro reportarSiniestro;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$reportarSiniestro = reportarSiniestro;
    _resultData['reportarSiniestro'] = l$reportarSiniestro.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$reportarSiniestro = reportarSiniestro;
    final l$$__typename = $__typename;
    return Object.hashAll([l$reportarSiniestro, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ReportarSiniestro ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$reportarSiniestro = reportarSiniestro;
    final lOther$reportarSiniestro = other.reportarSiniestro;
    if (l$reportarSiniestro != lOther$reportarSiniestro) {
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

const documentNodeMutationReportarSiniestro = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ReportarSiniestro'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'entrada')),
          type: NamedTypeNode(
            name: NameNode(value: 'ReporteSiniestroInput'),
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
            name: NameNode(value: 'reportarSiniestro'),
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
                      name: NameNode(value: 'SiniestroReportado'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'SiniestroReportadoCampos'),
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
                      name: NameNode(value: 'ErrorSiniestro'),
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
    fragmentDefinitionSiniestroReportadoCampos,
  ],
);

class Mutation$ReportarSiniestro$reportarSiniestro {
  Mutation$ReportarSiniestro$reportarSiniestro({required this.$__typename});

  factory Mutation$ReportarSiniestro$reportarSiniestro.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "SiniestroReportado":
        return Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado.fromJson(
          json,
        );

      case "ErrorSiniestro":
        return Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$ReportarSiniestro$reportarSiniestro(
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
    if (other is! Mutation$ReportarSiniestro$reportarSiniestro ||
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

extension UtilityExtension$Mutation$ReportarSiniestro$reportarSiniestro
    on Mutation$ReportarSiniestro$reportarSiniestro {
  _T when<_T>({
    required _T Function(
      Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado,
    )
    siniestroReportado,
    required _T Function(
      Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro,
    )
    errorSiniestro,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "SiniestroReportado":
        return siniestroReportado(
          this
              as Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado,
        );

      case "ErrorSiniestro":
        return errorSiniestro(
          this as Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
      Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado,
    )?
    siniestroReportado,
    _T Function(Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro)?
    errorSiniestro,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "SiniestroReportado":
        if (siniestroReportado != null) {
          return siniestroReportado(
            this
                as Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado,
          );
        } else {
          return orElse();
        }

      case "ErrorSiniestro":
        if (errorSiniestro != null) {
          return errorSiniestro(
            this
                as Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado
    implements
        Fragment$SiniestroReportadoCampos,
        Mutation$ReportarSiniestro$reportarSiniestro {
  Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado({
    required this.id,
    required this.radicado,
    required this.estado,
    required this.polizaId,
    required this.ocurridoEn,
    required this.notificadoEn,
    required this.venceDictamenEn,
    required this.fotos,
    this.tipoSiniestroAuto,
    this.$__typename = 'SiniestroReportado',
  });

  factory Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$radicado = json['radicado'];
    final l$estado = json['estado'];
    final l$polizaId = json['polizaId'];
    final l$ocurridoEn = json['ocurridoEn'];
    final l$notificadoEn = json['notificadoEn'];
    final l$venceDictamenEn = json['venceDictamenEn'];
    final l$fotos = json['fotos'];
    final l$tipoSiniestroAuto = json['tipoSiniestroAuto'];
    final l$$__typename = json['__typename'];
    return Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado(
      id: (l$id as String),
      radicado: (l$radicado as String),
      estado: fromJson$Enum$EstadoSiniestro((l$estado as String)),
      polizaId: (l$polizaId as String),
      ocurridoEn: DateTime.parse((l$ocurridoEn as String)),
      notificadoEn: DateTime.parse((l$notificadoEn as String)),
      venceDictamenEn: DateTime.parse((l$venceDictamenEn as String)),
      fotos: (l$fotos as int),
      tipoSiniestroAuto: l$tipoSiniestroAuto == null
          ? null
          : fromJson$Enum$TipoSiniestroAuto((l$tipoSiniestroAuto as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String radicado;

  final Enum$EstadoSiniestro estado;

  final String polizaId;

  final DateTime ocurridoEn;

  final DateTime notificadoEn;

  final DateTime venceDictamenEn;

  final int fotos;

  final Enum$TipoSiniestroAuto? tipoSiniestroAuto;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$radicado = radicado;
    _resultData['radicado'] = l$radicado;
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoSiniestro(l$estado);
    final l$polizaId = polizaId;
    _resultData['polizaId'] = l$polizaId;
    final l$ocurridoEn = ocurridoEn;
    _resultData['ocurridoEn'] = l$ocurridoEn.toIso8601String();
    final l$notificadoEn = notificadoEn;
    _resultData['notificadoEn'] = l$notificadoEn.toIso8601String();
    final l$venceDictamenEn = venceDictamenEn;
    _resultData['venceDictamenEn'] = l$venceDictamenEn.toIso8601String();
    final l$fotos = fotos;
    _resultData['fotos'] = l$fotos;
    final l$tipoSiniestroAuto = tipoSiniestroAuto;
    _resultData['tipoSiniestroAuto'] = l$tipoSiniestroAuto == null
        ? null
        : toJson$Enum$TipoSiniestroAuto(l$tipoSiniestroAuto);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$radicado = radicado;
    final l$estado = estado;
    final l$polizaId = polizaId;
    final l$ocurridoEn = ocurridoEn;
    final l$notificadoEn = notificadoEn;
    final l$venceDictamenEn = venceDictamenEn;
    final l$fotos = fotos;
    final l$tipoSiniestroAuto = tipoSiniestroAuto;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$radicado,
      l$estado,
      l$polizaId,
      l$ocurridoEn,
      l$notificadoEn,
      l$venceDictamenEn,
      l$fotos,
      l$tipoSiniestroAuto,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$radicado = radicado;
    final lOther$radicado = other.radicado;
    if (l$radicado != lOther$radicado) {
      return false;
    }
    final l$estado = estado;
    final lOther$estado = other.estado;
    if (l$estado != lOther$estado) {
      return false;
    }
    final l$polizaId = polizaId;
    final lOther$polizaId = other.polizaId;
    if (l$polizaId != lOther$polizaId) {
      return false;
    }
    final l$ocurridoEn = ocurridoEn;
    final lOther$ocurridoEn = other.ocurridoEn;
    if (l$ocurridoEn != lOther$ocurridoEn) {
      return false;
    }
    final l$notificadoEn = notificadoEn;
    final lOther$notificadoEn = other.notificadoEn;
    if (l$notificadoEn != lOther$notificadoEn) {
      return false;
    }
    final l$venceDictamenEn = venceDictamenEn;
    final lOther$venceDictamenEn = other.venceDictamenEn;
    if (l$venceDictamenEn != lOther$venceDictamenEn) {
      return false;
    }
    final l$fotos = fotos;
    final lOther$fotos = other.fotos;
    if (l$fotos != lOther$fotos) {
      return false;
    }
    final l$tipoSiniestroAuto = tipoSiniestroAuto;
    final lOther$tipoSiniestroAuto = other.tipoSiniestroAuto;
    if (l$tipoSiniestroAuto != lOther$tipoSiniestroAuto) {
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

class Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro
    implements Mutation$ReportarSiniestro$reportarSiniestro {
  Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro({
    required this.mensaje,
    this.$__typename = 'ErrorSiniestro',
  });

  factory Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$mensaje = json['mensaje'];
    final l$$__typename = json['__typename'];
    return Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro(
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
            is! Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro ||
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

class Query$MisSiniestros {
  Query$MisSiniestros({
    required this.misSiniestros,
    this.$__typename = 'Query',
  });

  factory Query$MisSiniestros.fromJson(Map<String, dynamic> json) {
    final l$misSiniestros = json['misSiniestros'];
    final l$$__typename = json['__typename'];
    return Query$MisSiniestros(
      misSiniestros: (l$misSiniestros as List<dynamic>)
          .map(
            (e) => Fragment$SiniestroReportadoCampos.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$SiniestroReportadoCampos> misSiniestros;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$misSiniestros = misSiniestros;
    _resultData['misSiniestros'] = l$misSiniestros
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$misSiniestros = misSiniestros;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$misSiniestros.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MisSiniestros || runtimeType != other.runtimeType) {
      return false;
    }
    final l$misSiniestros = misSiniestros;
    final lOther$misSiniestros = other.misSiniestros;
    if (l$misSiniestros.length != lOther$misSiniestros.length) {
      return false;
    }
    for (int i = 0; i < l$misSiniestros.length; i++) {
      final l$misSiniestros$entry = l$misSiniestros[i];
      final lOther$misSiniestros$entry = lOther$misSiniestros[i];
      if (l$misSiniestros$entry != lOther$misSiniestros$entry) {
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

const documentNodeQueryMisSiniestros = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MisSiniestros'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'misSiniestros'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'SiniestroReportadoCampos'),
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
    fragmentDefinitionSiniestroReportadoCampos,
  ],
);
