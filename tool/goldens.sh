#!/usr/bin/env bash
# Regenera los goldens. Solo dentro del devcontainer: fuera, el render cambia y el CI los rechaza.
# Uso: tool/goldens.sh [ruta de pruebas]   (por defecto test/)
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -f /.dockerenv ] && [ -z "${REMOTE_CONTAINERS:-}" ] && [ -z "${CI:-}" ]; then
  echo "Corre tool/goldens.sh dentro del devcontainer (docs/entorno-local.md)." >&2
  exit 1
fi
tool/verificar-versiones.sh
flutter test --update-goldens "${1:-test/}"
