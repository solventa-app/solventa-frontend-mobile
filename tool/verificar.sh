#!/usr/bin/env bash
# Lo mismo que el job `mobile` del CI. Correr dentro del devcontainer antes de abrir el PR.
# Uso: tool/verificar.sh          formato, análisis y pruebas
#      tool/verificar.sh --apk    además compila el APK de dev en release (lo que hace el CI)
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== Versiones";  tool/verificar-versiones.sh
echo "== Dependencias"; flutter pub get
echo "== Formato";    dart format --output=none --set-exit-if-changed .
echo "== Análisis";   flutter analyze
echo "== Pruebas";    flutter test --coverage

if [ "${1:-}" = "--apk" ]; then
  echo "== APK dev"
  flutter build apk --release --flavor dev --dart-define-from-file=config/mock.json
fi
