#!/usr/bin/env bash
# Falla si la versión de Flutter no es la misma en la imagen, en pubspec.yaml y en el SDK que está corriendo.
# Corre en tool/post-create.sh, en el CI y en el job de emuladores (que no usa la imagen).
set -euo pipefail
cd "$(dirname "$0")/.."

dockerfile=$(sed -n 's/^ARG FLUTTER_VERSION=//p' .devcontainer/Dockerfile)
pubspec=$(sed -n 's/^  flutter: *//p' pubspec.yaml | head -1 | tr -d "'\"")
instalada=$(flutter --version --machine 2>/dev/null | sed -n 's/.*"frameworkVersion": *"\([^"]*\)".*/\1/p')

echo "Flutter en .devcontainer/Dockerfile: $dockerfile"
echo "Flutter en pubspec.yaml:             $pubspec"
echo "Flutter instalado:                   $instalada"

if [ -z "$dockerfile" ] || [ "$dockerfile" != "$pubspec" ]; then
  echo "::error title=Versión de Flutter::FLUTTER_VERSION del Dockerfile ($dockerfile) y environment.flutter de pubspec.yaml ($pubspec) deben ser iguales."
  exit 1
fi
if [ "$instalada" != "$pubspec" ]; then
  echo "::error title=Versión de Flutter::Estás usando Flutter $instalada y el proyecto usa $pubspec. Trabaja dentro del devcontainer (docs/entorno-local.md)."
  exit 1
fi
