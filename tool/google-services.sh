#!/usr/bin/env bash
# Restaura android/app/google-services.json desde el secreto del CI (push de HU-M04, KAN-259).
# Uso: GOOGLE_SERVICES_JSON_BASE64=… tool/google-services.sh
# Sin el secreto no hace nada: la app compila igual y el push queda apagado. Nunca se sube al repo.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -z "${GOOGLE_SERVICES_JSON_BASE64:-}" ]; then
  echo "::warning title=Push::Sin GOOGLE_SERVICES_JSON_BASE64: el APK sale sin Firebase y el push queda apagado."
  exit 0
fi

printf '%s' "$GOOGLE_SERVICES_JSON_BASE64" | base64 --decode > android/app/google-services.json
echo "google-services.json listo."
