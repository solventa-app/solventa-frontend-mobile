// GENERADO por graphql_codegen desde lib/core/contrato/schema.graphql. No editar.
// ignore_for_file: type=lint
import '../../../../core/contrato/schema.graphql.dart';

import 'package:gql/ast.dart';

class Fragment$MontoCampos {
  Fragment$MontoCampos({
    required this.valor,
    required this.moneda,
    this.$__typename = 'Monto',
  });

  factory Fragment$MontoCampos.fromJson(Map<String, dynamic> json) {
    final l$valor = json['valor'];
    final l$moneda = json['moneda'];
    final l$$__typename = json['__typename'];
    return Fragment$MontoCampos(
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
    if (other is! Fragment$MontoCampos || runtimeType != other.runtimeType) {
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

const fragmentDefinitionMontoCampos = FragmentDefinitionNode(
  name: NameNode(value: 'MontoCampos'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Monto'), isNonNull: false),
  ),
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
);
const documentNodeFragmentMontoCampos = DocumentNode(
  definitions: [fragmentDefinitionMontoCampos],
);

class Fragment$IndemnizacionCampos {
  Fragment$IndemnizacionCampos({
    required this.id,
    required this.tipo,
    required this.referenciaEvento,
    required this.detalleEvento,
    required this.fechaEvento,
    required this.pagadoEn,
    required this.estado,
    this.metodoTransferencia,
    required this.polizaAnterior,
    required this.monto,
    this.$__typename = 'Indemnizacion',
  });

  factory Fragment$IndemnizacionCampos.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$tipo = json['tipo'];
    final l$referenciaEvento = json['referenciaEvento'];
    final l$detalleEvento = json['detalleEvento'];
    final l$fechaEvento = json['fechaEvento'];
    final l$pagadoEn = json['pagadoEn'];
    final l$estado = json['estado'];
    final l$metodoTransferencia = json['metodoTransferencia'];
    final l$polizaAnterior = json['polizaAnterior'];
    final l$monto = json['monto'];
    final l$$__typename = json['__typename'];
    return Fragment$IndemnizacionCampos(
      id: (l$id as String),
      tipo: fromJson$Enum$TipoEventoParametrico((l$tipo as String)),
      referenciaEvento: (l$referenciaEvento as String),
      detalleEvento: (l$detalleEvento as String),
      fechaEvento: DateTime.parse((l$fechaEvento as String)),
      pagadoEn: DateTime.parse((l$pagadoEn as String)),
      estado: fromJson$Enum$EstadoIndemnizacion((l$estado as String)),
      metodoTransferencia: (l$metodoTransferencia as String?),
      polizaAnterior: (l$polizaAnterior as bool),
      monto: Fragment$MontoCampos.fromJson((l$monto as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$TipoEventoParametrico tipo;

  final String referenciaEvento;

  final String detalleEvento;

  final DateTime fechaEvento;

  final DateTime pagadoEn;

  final Enum$EstadoIndemnizacion estado;

  final String? metodoTransferencia;

  final bool polizaAnterior;

  final Fragment$MontoCampos monto;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$tipo = tipo;
    _resultData['tipo'] = toJson$Enum$TipoEventoParametrico(l$tipo);
    final l$referenciaEvento = referenciaEvento;
    _resultData['referenciaEvento'] = l$referenciaEvento;
    final l$detalleEvento = detalleEvento;
    _resultData['detalleEvento'] = l$detalleEvento;
    final l$fechaEvento = fechaEvento;
    _resultData['fechaEvento'] = l$fechaEvento.toIso8601String();
    final l$pagadoEn = pagadoEn;
    _resultData['pagadoEn'] = l$pagadoEn.toIso8601String();
    final l$estado = estado;
    _resultData['estado'] = toJson$Enum$EstadoIndemnizacion(l$estado);
    final l$metodoTransferencia = metodoTransferencia;
    _resultData['metodoTransferencia'] = l$metodoTransferencia;
    final l$polizaAnterior = polizaAnterior;
    _resultData['polizaAnterior'] = l$polizaAnterior;
    final l$monto = monto;
    _resultData['monto'] = l$monto.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$tipo = tipo;
    final l$referenciaEvento = referenciaEvento;
    final l$detalleEvento = detalleEvento;
    final l$fechaEvento = fechaEvento;
    final l$pagadoEn = pagadoEn;
    final l$estado = estado;
    final l$metodoTransferencia = metodoTransferencia;
    final l$polizaAnterior = polizaAnterior;
    final l$monto = monto;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$tipo,
      l$referenciaEvento,
      l$detalleEvento,
      l$fechaEvento,
      l$pagadoEn,
      l$estado,
      l$metodoTransferencia,
      l$polizaAnterior,
      l$monto,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$IndemnizacionCampos ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$tipo = tipo;
    final lOther$tipo = other.tipo;
    if (l$tipo != lOther$tipo) {
      return false;
    }
    final l$referenciaEvento = referenciaEvento;
    final lOther$referenciaEvento = other.referenciaEvento;
    if (l$referenciaEvento != lOther$referenciaEvento) {
      return false;
    }
    final l$detalleEvento = detalleEvento;
    final lOther$detalleEvento = other.detalleEvento;
    if (l$detalleEvento != lOther$detalleEvento) {
      return false;
    }
    final l$fechaEvento = fechaEvento;
    final lOther$fechaEvento = other.fechaEvento;
    if (l$fechaEvento != lOther$fechaEvento) {
      return false;
    }
    final l$pagadoEn = pagadoEn;
    final lOther$pagadoEn = other.pagadoEn;
    if (l$pagadoEn != lOther$pagadoEn) {
      return false;
    }
    final l$estado = estado;
    final lOther$estado = other.estado;
    if (l$estado != lOther$estado) {
      return false;
    }
    final l$metodoTransferencia = metodoTransferencia;
    final lOther$metodoTransferencia = other.metodoTransferencia;
    if (l$metodoTransferencia != lOther$metodoTransferencia) {
      return false;
    }
    final l$polizaAnterior = polizaAnterior;
    final lOther$polizaAnterior = other.polizaAnterior;
    if (l$polizaAnterior != lOther$polizaAnterior) {
      return false;
    }
    final l$monto = monto;
    final lOther$monto = other.monto;
    if (l$monto != lOther$monto) {
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

const fragmentDefinitionIndemnizacionCampos = FragmentDefinitionNode(
  name: NameNode(value: 'IndemnizacionCampos'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Indemnizacion'), isNonNull: false),
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
        name: NameNode(value: 'tipo'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'referenciaEvento'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'detalleEvento'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'fechaEvento'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'pagadoEn'),
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
        name: NameNode(value: 'metodoTransferencia'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'polizaAnterior'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'monto'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'MontoCampos'),
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
);
const documentNodeFragmentIndemnizacionCampos = DocumentNode(
  definitions: [
    fragmentDefinitionIndemnizacionCampos,
    fragmentDefinitionMontoCampos,
  ],
);

class Variables$Query$Indemnizacion {
  factory Variables$Query$Indemnizacion({required String id}) =>
      Variables$Query$Indemnizacion._({r'id': id});

  Variables$Query$Indemnizacion._(this._$data);

  factory Variables$Query$Indemnizacion.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$Indemnizacion._(result$data);
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
    if (other is! Variables$Query$Indemnizacion ||
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

class Query$Indemnizacion {
  Query$Indemnizacion({this.indemnizacion, this.$__typename = 'Query'});

  factory Query$Indemnizacion.fromJson(Map<String, dynamic> json) {
    final l$indemnizacion = json['indemnizacion'];
    final l$$__typename = json['__typename'];
    return Query$Indemnizacion(
      indemnizacion: l$indemnizacion == null
          ? null
          : Fragment$IndemnizacionCampos.fromJson(
              (l$indemnizacion as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$IndemnizacionCampos? indemnizacion;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$indemnizacion = indemnizacion;
    _resultData['indemnizacion'] = l$indemnizacion?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$indemnizacion = indemnizacion;
    final l$$__typename = $__typename;
    return Object.hashAll([l$indemnizacion, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Indemnizacion || runtimeType != other.runtimeType) {
      return false;
    }
    final l$indemnizacion = indemnizacion;
    final lOther$indemnizacion = other.indemnizacion;
    if (l$indemnizacion != lOther$indemnizacion) {
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

const documentNodeQueryIndemnizacion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Indemnizacion'),
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
            name: NameNode(value: 'indemnizacion'),
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
                  name: NameNode(value: 'IndemnizacionCampos'),
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
    fragmentDefinitionIndemnizacionCampos,
    fragmentDefinitionMontoCampos,
  ],
);

class Query$MiCoberturaParametrica {
  Query$MiCoberturaParametrica({
    this.miCoberturaParametrica,
    this.$__typename = 'Query',
  });

  factory Query$MiCoberturaParametrica.fromJson(Map<String, dynamic> json) {
    final l$miCoberturaParametrica = json['miCoberturaParametrica'];
    final l$$__typename = json['__typename'];
    return Query$MiCoberturaParametrica(
      miCoberturaParametrica: l$miCoberturaParametrica == null
          ? null
          : Query$MiCoberturaParametrica$miCoberturaParametrica.fromJson(
              (l$miCoberturaParametrica as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$MiCoberturaParametrica$miCoberturaParametrica?
  miCoberturaParametrica;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$miCoberturaParametrica = miCoberturaParametrica;
    _resultData['miCoberturaParametrica'] = l$miCoberturaParametrica?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$miCoberturaParametrica = miCoberturaParametrica;
    final l$$__typename = $__typename;
    return Object.hashAll([l$miCoberturaParametrica, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MiCoberturaParametrica ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$miCoberturaParametrica = miCoberturaParametrica;
    final lOther$miCoberturaParametrica = other.miCoberturaParametrica;
    if (l$miCoberturaParametrica != lOther$miCoberturaParametrica) {
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

const documentNodeQueryMiCoberturaParametrica = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MiCoberturaParametrica'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'miCoberturaParametrica'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'producto'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'numeroPoliza'),
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
                  name: NameNode(value: 'vigenteHasta'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'tope'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'MontoCampos'),
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
                  name: NameNode(value: 'movimientos'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'IndemnizacionCampos'),
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
    fragmentDefinitionMontoCampos,
    fragmentDefinitionIndemnizacionCampos,
  ],
);

class Query$MiCoberturaParametrica$miCoberturaParametrica {
  Query$MiCoberturaParametrica$miCoberturaParametrica({
    required this.producto,
    required this.numeroPoliza,
    required this.vigente,
    required this.vigenteHasta,
    required this.tope,
    required this.movimientos,
    this.$__typename = 'ResumenCobertura',
  });

  factory Query$MiCoberturaParametrica$miCoberturaParametrica.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$producto = json['producto'];
    final l$numeroPoliza = json['numeroPoliza'];
    final l$vigente = json['vigente'];
    final l$vigenteHasta = json['vigenteHasta'];
    final l$tope = json['tope'];
    final l$movimientos = json['movimientos'];
    final l$$__typename = json['__typename'];
    return Query$MiCoberturaParametrica$miCoberturaParametrica(
      producto: (l$producto as String),
      numeroPoliza: (l$numeroPoliza as String),
      vigente: (l$vigente as bool),
      vigenteHasta: DateTime.parse((l$vigenteHasta as String)),
      tope: Fragment$MontoCampos.fromJson((l$tope as Map<String, dynamic>)),
      movimientos: (l$movimientos as List<dynamic>)
          .map(
            (e) => Fragment$IndemnizacionCampos.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String producto;

  final String numeroPoliza;

  final bool vigente;

  final DateTime vigenteHasta;

  final Fragment$MontoCampos tope;

  final List<Fragment$IndemnizacionCampos> movimientos;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$producto = producto;
    _resultData['producto'] = l$producto;
    final l$numeroPoliza = numeroPoliza;
    _resultData['numeroPoliza'] = l$numeroPoliza;
    final l$vigente = vigente;
    _resultData['vigente'] = l$vigente;
    final l$vigenteHasta = vigenteHasta;
    _resultData['vigenteHasta'] = l$vigenteHasta.toIso8601String();
    final l$tope = tope;
    _resultData['tope'] = l$tope.toJson();
    final l$movimientos = movimientos;
    _resultData['movimientos'] = l$movimientos.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$producto = producto;
    final l$numeroPoliza = numeroPoliza;
    final l$vigente = vigente;
    final l$vigenteHasta = vigenteHasta;
    final l$tope = tope;
    final l$movimientos = movimientos;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$producto,
      l$numeroPoliza,
      l$vigente,
      l$vigenteHasta,
      l$tope,
      Object.hashAll(l$movimientos.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MiCoberturaParametrica$miCoberturaParametrica ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$producto = producto;
    final lOther$producto = other.producto;
    if (l$producto != lOther$producto) {
      return false;
    }
    final l$numeroPoliza = numeroPoliza;
    final lOther$numeroPoliza = other.numeroPoliza;
    if (l$numeroPoliza != lOther$numeroPoliza) {
      return false;
    }
    final l$vigente = vigente;
    final lOther$vigente = other.vigente;
    if (l$vigente != lOther$vigente) {
      return false;
    }
    final l$vigenteHasta = vigenteHasta;
    final lOther$vigenteHasta = other.vigenteHasta;
    if (l$vigenteHasta != lOther$vigenteHasta) {
      return false;
    }
    final l$tope = tope;
    final lOther$tope = other.tope;
    if (l$tope != lOther$tope) {
      return false;
    }
    final l$movimientos = movimientos;
    final lOther$movimientos = other.movimientos;
    if (l$movimientos.length != lOther$movimientos.length) {
      return false;
    }
    for (int i = 0; i < l$movimientos.length; i++) {
      final l$movimientos$entry = l$movimientos[i];
      final lOther$movimientos$entry = lOther$movimientos[i];
      if (l$movimientos$entry != lOther$movimientos$entry) {
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
