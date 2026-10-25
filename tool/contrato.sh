#!/usr/bin/env bash
# Mantiene al día la copia versionada del contrato GraphQL del backend (lib/core/contrato/schema.graphql).
# Equivale a scripts/contrato.mjs de solventa-frontend-web.
#
#   tool/contrato.sh verificar     falla (exit 1) si la copia difiere del backend
#   tool/contrato.sh sincronizar   sobrescribe la copia con la del backend
#
# Origen del esquema del backend, en este orden:
#   1. BACKEND_SCHEMA_PATH  (ruta local; el CI usa un checkout de solventa-backend)
#   2. BACKEND_SCHEMA_URL   (URL "raw" del archivo; para repos privados agregar BACKEND_SCHEMA_TOKEN)
#   3. ../solventa-backend/contracts/graphql/schema.graphql  (repo hermano en tu máquina)
set -euo pipefail

raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
copia="$raiz/lib/core/contrato/schema.graphql"
hermano="$raiz/../solventa-backend/contracts/graphql/schema.graphql"

modo="${1:-}"
if [[ "$modo" != "verificar" && "$modo" != "sincronizar" ]]; then
  echo "Uso: tool/contrato.sh <verificar|sincronizar>" >&2
  exit 2
fi

# Mismo criterio que la web: finales de línea LF y un solo salto al final.
normalizar() { tr -d '\r' | sed -e ':a' -e '/^\n*$/{$d;N;ba' -e '}'; }

temporal="$(mktemp)"
trap 'rm -f "$temporal"' EXIT

if [[ -n "${BACKEND_SCHEMA_PATH:-}" ]]; then
  origen="$BACKEND_SCHEMA_PATH"
  normalizar <"$origen" >"$temporal"
elif [[ -n "${BACKEND_SCHEMA_URL:-}" ]]; then
  origen="$BACKEND_SCHEMA_URL"
  cabecera=()
  [[ -n "${BACKEND_SCHEMA_TOKEN:-}" ]] && cabecera=(-H "Authorization: Bearer $BACKEND_SCHEMA_TOKEN")
  curl -fsSL "${cabecera[@]}" "$origen" | normalizar >"$temporal"
else
  origen="$hermano"
  if [[ ! -f "$origen" ]]; then
    echo "No encuentro el esquema del backend en $origen. Define BACKEND_SCHEMA_PATH o BACKEND_SCHEMA_URL." >&2
    exit 2
  fi
  normalizar <"$origen" >"$temporal"
fi

if [[ "$modo" == "sincronizar" ]]; then
  cp "$temporal" "$copia"
  echo "Contrato sincronizado desde $origen."
  echo "Ahora corre: dart run build_runner build --delete-conflicting-outputs && flutter test"
  exit 0
fi

if ! normalizar <"$copia" | cmp -s - "$temporal"; then
  echo "El contrato local difiere del backend ($origen)." >&2
  echo "Corre: tool/contrato.sh sincronizar" >&2
  exit 1
fi
echo "Contrato al día con $origen."
