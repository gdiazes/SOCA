#!/bin/bash

# --- COLORES PARA MEJOR LECTURA ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}   CONFIGURADOR DE REPOSITORIO SOCA    ${NC}"
echo -e "${BLUE}=======================================${NC}"

# 1. Solicitar datos al usuario
read -p "👤 Introduce tu usuario de GitHub: " GITHUB_USER
read -p "📦 Nombre del repositorio [SOCA]: " REPO_NAME
REPO_NAME=${REPO_NAME:-SOCA}  # Si está vacío, usa SOCA

read -p "🌿 Nombre de la rama principal [main]: " BRANCH
BRANCH=${BRANCH:-main}        # Si está vacío, usa main

# Construir URL
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

echo -e "\n${BLUE}🔄 Iniciando configuración en la carpeta actual...${NC}"

# 2. Inicializar Git si no existe
if [ ! -d ".git" ]; then
    git init
    echo -e "${GREEN}✔ Git inicializado localmente.${NC}"
else
    echo -e "ℹ Git ya estaba inicializado."
fi

# 3. Configurar el Remoto (Origin)
# Si ya existe un remoto, lo borramos para poner el nuevo
if git remote | grep -q "origin"; then
    git remote remove origin
fi
git remote add origin "$REPO_URL"
echo -e "${GREEN}✔ Vinculado a: $REPO_URL${NC}"

# 4. Sincronización Inicial (Pull)
echo -e "\n${BLUE}📥 Intentando descargar cambios previos de GitHub...${NC}"
# Usamos un pull para evitar conflictos iniciales
git pull origin $BRANCH --rebase 2>/dev/null

# 5. Guardar cambios locales (Add + Commit)
echo -e "\n${BLUE}📝 Preparando archivos locales...${NC}"
git add .

# Verificar si hay algo que guardar
if git diff-index --quiet HEAD --; then
    echo -e "✨ No hay cambios nuevos que guardar."
else
    read -p "💬 Introduce un mensaje para el commit (ej. 'mis avances'): " COMMIT_MSG
    COMMIT_MSG=${COMMIT_MSG:-"Actualización SOCA"}
    git commit -m "$COMMIT_MSG"
fi

# 6. Subir cambios (Push)
echo -e "\n${BLUE}📤 Subiendo archivos a GitHub...${NC}"
git branch -M $BRANCH
git push -u origin $BRANCH

echo -e "\n${GREEN}=======================================${NC}"
echo -e "${GREEN} ✅ PROCESO COMPLETADO CON ÉXITO ${NC}"
echo -e "${GREEN}=======================================${NC}"
