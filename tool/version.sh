#!/usr/bin/env bash
# Calcula la versión del próximo build. La versión vive en el tag (v1.3.0+57) y en el Release, no en un commit:
# el ruleset de main no deja pushear a bots. Se pasa al build con --build-name y --build-number.
#
# Uso: tool/version.sh prod             -> versión 1.3.0, build = mayor build de los tags + 1, tag v1.3.0+57
#      tool/version.sh rollback <tag>   -> versión del tag a restaurar, build nuevo, tag rollback-1.2.0+58
#      tool/version.sh dev <ejecución>  -> versión 1.3.0-dev.<ejecución>, build = <ejecución>
#
# El build (versionCode) de prod siempre crece, también en un rollback: Android no instala un versionCode menor.
# Los tags de rollback no empiezan con v para que git-cliff no los tome como la última versión.
#
# Escribe `nombre`, `build` y `tag` en $GITHUB_OUTPUT si existe; si no, en la salida.
# Necesita el historial completo y los tags (actions/checkout con fetch-depth: 0) y git-cliff.
set -euo pipefail
cd "$(dirname "$0")/.."

ambiente="${1:?Uso: tool/version.sh prod | rollback <tag> | dev <ejecución>}"

siguiente_build() {
  local ultimo
  ultimo=$(git tag -l 'v*+*' 'rollback-*+*' | sed 's/.*+//' | grep -E '^[0-9]+$' | sort -n | tail -1 || true)
  echo $(( ${ultimo:-0} + 1 ))
}

# git-cliff calcula la próxima versión desde los títulos de PR desde el último tag. Sin tags parte de 0.1.0.
proxima=$(git-cliff --bumped-version 2>/dev/null)
proxima="${proxima#v}"
proxima="${proxima%%+*}"

case "$ambiente" in
  prod)
    build=$(siguiente_build)
    nombre="$proxima"
    tag="v${nombre}+${build}"
    ;;
  rollback)
    restaurar="${2:?Falta el tag a restaurar (p. ej. v1.2.0+45)}"
    git rev-parse -q --verify "refs/tags/$restaurar" > /dev/null || { echo "No existe el tag $restaurar" >&2; exit 1; }
    build=$(siguiente_build)
    nombre="${restaurar#v}"
    nombre="${nombre%%+*}"
    tag="rollback-${nombre}+${build}"
    ;;
  dev)
    build="${2:?Falta el número de ejecución}"
    nombre="${proxima}-dev.${build}"
    tag=""
    ;;
  *) echo "Ambiente desconocido: $ambiente" >&2; exit 1 ;;
esac

salida="${GITHUB_OUTPUT:-/dev/stdout}"
{
  echo "nombre=$nombre"
  echo "build=$build"
  echo "tag=$tag"
} >> "$salida"
