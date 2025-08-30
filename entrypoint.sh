#!/usr/bin/env bash
set -e

echo "🚀 Iniciando TShock Server..."
echo "🌍 Mundo configurado: ${WORLD_NAME:-World}.wld"
echo "👥 Jugadores máximos: ${MAX_PLAYERS:-8}"
echo "📡 Puerto: ${PORT:-7777}"

PORT="${PORT:-7777}"
WORLD_DIR="/data/worlds"
CONFIG_DIR="/data/config"
LOG_DIR="/data/logs"
PLUGINS_DIR="/data/plugins"

mkdir -p "$WORLD_DIR" "$CONFIG_DIR" "$LOG_DIR" "$PLUGINS_DIR"

ARGS=(
  -ip 0.0.0.0
  -port "$PORT"
  -maxplayers "${MAX_PLAYERS:-8}"
  -configpath "$CONFIG_DIR"
  -logpath "$LOG_DIR"
)

WORLD_NAME_ACTUAL="${WORLD_NAME:-World}.wld"
WORLD_PATH="$WORLD_DIR/$WORLD_NAME_ACTUAL"
DEFAULT_WORLD_PATH="/tshock/worlds/$WORLD_NAME_ACTUAL"

# ✅ Solo copiar si no existe aún
if [[ ! -f "$WORLD_PATH" ]]; then
  if [[ -f "$DEFAULT_WORLD_PATH" ]]; then
    echo "📁 Copiando mundo preexistente desde la imagen..."
    cp "$DEFAULT_WORLD_PATH" "$WORLD_PATH"
  else
    echo "⚒️ No existe el mundo en $WORLD_PATH ni en la imagen, creando uno nuevo..."
    [[ -n "$SEED" ]] && ARGS+=(-seed "$SEED")
    ARGS+=(-autocreate "${AUTOCREATE:-2}")
  fi
else
  echo "✅ Cargando mundo existente: $WORLD_PATH"
fi

ARGS+=(-world "$WORLD_PATH")

[[ -n "$PASSWORD" ]] && echo "🔒 Contraseña habilitada" && ARGS+=(-password "$PASSWORD")

# Ejecutar el binario nativo de TShock (no DLL, es ELF Linux)
exec ./TShock.Server "${ARGS[@]}"
