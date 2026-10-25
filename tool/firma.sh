#!/usr/bin/env bash
# Restaura la llave de firmado de un ambiente desde los secretos del CI. Nunca se usa en local.
# Uso: KEYSTORE_BASE64=… KEYSTORE_PASSWORD=… KEY_ALIAS=… KEY_PASSWORD=… tool/firma.sh dev|prod
# Sin KEYSTORE_BASE64 no hace nada: el build de release queda firmado con la llave de debug
# (sirve para compilar, no para instalar encima de una versión publicada).
set -euo pipefail
cd "$(dirname "$0")/.."

ambiente="${1:?Uso: tool/firma.sh dev|prod}"
case "$ambiente" in
  dev) propiedades=android/key-dev.properties ;;
  prod) propiedades=android/key.properties ;;
  *) echo "Ambiente desconocido: $ambiente" >&2; exit 1 ;;
esac

if [ -z "${KEYSTORE_BASE64:-}" ]; then
  echo "::warning title=Firmado::Sin llave de $ambiente en los secretos: el APK queda firmado con la llave de debug."
  exit 0
fi

llave="android/app/${ambiente}.jks"
printf '%s' "$KEYSTORE_BASE64" | base64 --decode > "$llave"
cat > "$propiedades" <<PROPS
storePassword=$KEYSTORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=${ambiente}.jks
PROPS
echo "Llave de $ambiente lista."
