#!/bin/bash

# 1. Verificar si se proporcionó un nombre de carpeta
if [ -z "$1" ]; then
    echo "❌ Error: Debes proporcionar el nombre del laboratorio."
    echo "Ejemplo: ./setup.sh laboratorio03"
    exit 1
fi

# 2. Variables de configuración
TARGET_FOLDER=$1  # Ej: laboratorio03
# Extraer el número del argumento (ej. de 'laboratorio03' extrae '03')
NUM_WEEK=$(echo "$TARGET_FOLDER" | tr -dc '0-9')
REPO_URL="https://github.com/gdiazes/SOCA.git"
REMOTE_PATH="semana$NUM_WEEK/$TARGET_FOLDER"
BRANCH="main"

echo "🔍 Buscando '$TARGET_FOLDER' en la semana '$NUM_WEEK'..."

# 3. Proceso de Git
mkdir -p "$TARGET_FOLDER"
cd "$TARGET_FOLDER" || exit

git init -q
git remote add -f origin "$REPO_URL" &> /dev/null
git sparse-checkout init --cone
git sparse-checkout set "$REMOTE_PATH"

echo "📥 Descargando archivos..."
git pull origin "$BRANCH" --quiet

# 4. Limpieza (Mover archivos a la raíz de la carpeta actual)
# Esto hace que no tengas que entrar a semana03/laboratorio03/archivo
if [ -d "$REMOTE_PATH" ]; then
    mv "$REMOTE_PATH"/* .
    rm -rf "semana$NUM_WEEK"
    echo "✅ ¡Listo! Los archivos de '$TARGET_FOLDER' están en la carpeta actual."
else
    echo "❌ Error: No se encontró la ruta '$REMOTE_PATH' en el repositorio."
    cd ..
    rm -rf "$TARGET_FOLDER"
fi
