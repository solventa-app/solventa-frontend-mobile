#!/usr/bin/env bash
# Corre una vez al crear el devcontainer (local y CI).
set -euo pipefail
cd "$(dirname "$0")/.."

# Los volúmenes nacen a nombre de root o del uid de la imagen; en Linux y en CI el uid de `dev` es otro.
sudo chown -R "$(id -u):$(id -g)" "$HOME/.gradle" "$HOME/.pub-cache"

tool/verificar-versiones.sh
flutter pub get

# Hook de pre-push solo en local (en CI no hay push).
if [ -z "${CI:-}" ]; then
  lefthook install
fi
