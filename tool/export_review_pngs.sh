#!/usr/bin/env bash
# Genera los goldens legibles (Inter real) y copia los de 390 dp a una
# carpeta de revisión para el diseñador UX.
#
# Uso: tool/export_review_pngs.sh [carpeta_destino]
set -euo pipefail
cd "$(dirname "$0")/.."
DEST="${1:-../review}"
mkdir -p "$DEST"
SOL_PLATFORM_GOLDENS=1 flutter test --tags golden --update-goldens test/goldens
for f in test/goldens/platform/*_390_x1.png; do
  base="$(basename "$f" _390_x1.png)"
  cp "$f" "$DEST/${base}_390.png"
done
for f in test/goldens/platform/*_390_x2.png; do
  base="$(basename "$f" _390_x2.png)"
  cp "$f" "$DEST/${base}_390_texto200.png"
done
echo "PNG de revisión en $DEST"
