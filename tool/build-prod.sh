#!/usr/bin/env bash
# Build de prod para el CD y el rollback, dentro del devcontainer.
# Uso: tool/build-prod.sh <versión> <build>    p. ej. tool/build-prod.sh 1.3.0 57
#
# Deja en dist/: APK, AAB, mapping de R8 y símbolos de Dart (para leer errores ofuscados, docs/ci-cd.md,
# "R8, ofuscación y símbolos").
set -euo pipefail
cd "$(dirname "$0")/.."

nombre="${1:?Falta la versión}"
build="${2:?Falta el build}"
opciones=(
  --release
  --flavor prod
  --dart-define-from-file=config/prod.json
  --obfuscate
  --split-debug-info=build-symbols
  --build-name="$nombre"
  --build-number="$build"
)

tool/verificar.sh
flutter build apk "${opciones[@]}"
flutter build appbundle "${opciones[@]}"

base="solventa-${nombre}+${build}"
rm -rf dist && mkdir -p dist
cp build/app/outputs/flutter-apk/app-prod-release.apk "dist/${base}.apk"
cp build/app/outputs/bundle/prodRelease/app-prod-release.aab "dist/${base}.aab"
cp build/app/outputs/mapping/prodRelease/mapping.txt "dist/${base}-mapping.txt"
(cd build-symbols && zip -qr "../dist/${base}-simbolos-dart.zip" .)
ls -lh dist
