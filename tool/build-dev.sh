#!/usr/bin/env bash
# APK de dev firmado para QA (App Distribution) y MobSF, dentro del devcontainer, contra el gateway de
# staging (config/dev.json).
# Uso: tool/build-dev.sh <versión> <build>    p. ej. tool/build-dev.sh 1.3.0-dev.214 214
set -euo pipefail
cd "$(dirname "$0")/.."

nombre="${1:?Falta la versión}"
build="${2:?Falta el build}"

flutter build apk --release --flavor dev --dart-define-from-file=config/dev.json \
  --build-name="$nombre" --build-number="$build"

rm -rf dist && mkdir -p dist
cp build/app/outputs/flutter-apk/app-dev-release.apk "dist/solventa-dev-${nombre}.apk"
ls -lh dist
