#!/bin/bash
# ==========================================
# Autor: Instructor Sysadmin / Antigravity IDE
# Fecha: 2026-06-15
# Tema: Guía Docente - Scripts Interactivos (read y echo)
# Versión: 3.0
# Uso: Copiar y pegar cada bloque en la terminal. Usar las preguntas
#      predefinidas ANTES de ejecutar el código para fomentar la deducción.
# ==========================================

# ---------------------------------------------------------
# DEMO 1: CONTROLANDO EL FORMATO VISUAL CON ECHO
# ---------------------------------------------------------

# OBJETIVO: Mostrar cómo suprimir el salto de línea automático de echo.
# ESPERADO: El cursor de la terminal se quedará parpadeando exactamente al lado de la pregunta, no en la línea de abajo.
# PREGUNTA: "¿Alguna vez han ejecutado un instalador en Linux que pregunta '[Y/n]: ' y el cursor se queda esperando justo al lado? Si 'echo' siempre salta a la siguiente línea, ¿cómo logramos ese efecto visual profesional?"
echo -n "Ingrese su nombre: "


# ---------------------------------------------------------
# DEMO 2: LECTURA BÁSICA Y LA "VARIABLE FANTASMA" ($REPLY)
# ---------------------------------------------------------

# OBJETIVO: Demostrar cómo captura datos Bash si el programador olvida definir una variable.
# ESPERADO: El sistema quedará en pausa esperando que el usuario escriba. Al dar Enter, imprimirá lo escrito usando $REPLY.
# TIP DOCENTE: Ejecute solo el comando 'read'. Escriba su nombre y presione Enter. Luego, ejecute el 'echo' para revelar el "truco".
# PREGUNTA: "Si yo ejecuto 'read' para capturar texto pero no le digo a Bash en qué variable guardarlo... ¿Se pierde esa información en el vacío de la memoria o Bash tiene un 'bolsillo' de emergencia?"
read
echo "El sistema guardó secretamente esto: $REPLY"


# ---------------------------------------------------------
# DEMO 3: FUSIONANDO COMANDOS PARA CÓDIGO LIMPIO (read -p)
# ---------------------------------------------------------

# OBJETIVO: Usar el parámetro '-p' (prompt) para preguntar y guardar en un solo paso.
# ESPERADO: Muestra el mensaje y guarda la entrada directamente en la variable 'servidor'.
# PREGUNTA: "Hacer un 'echo' y en la siguiente línea un 'read' funciona, pero un buen Sysadmin odia escribir líneas de código innecesarias. ¿Cómo podemos decirle a Bash que pregunte y guarde al mismo tiempo?"
read -p "¿A qué servidor desea conectarse?: " servidor
echo "Iniciando protocolo hacia: $servidor"


# ---------------------------------------------------------
# DEMO 4: CONTROL DE CARACTERES Y SEGURIDAD (read -n / -s)
# ---------------------------------------------------------

# OBJETIVO: Limitar la entrada del usuario a exactamente 1 carácter y evitar que pulse 'Enter'.
# ESPERADO: Al teclear una sola letra (ej. 'S'), el script continuará automáticamente.
# TIP DOCENTE: Note que hay un 'echo' vacío después del comando. Explique que esto es para arreglar el salto de línea, ya que '-n 1' interrumpe el flujo normal de la terminal.
read -n 1 -p "Presione UNA tecla para confirmar el borrado de base de datos: " confirmacion
echo ""
echo "Usted presionó: $confirmacion"

# OBJETIVO: Ocultar la escritura (silent mode) para contraseñas o PINs.
# ESPERADO: El profesor tecleará pero no aparecerá nada en la pantalla.
# PREGUNTA: "Si nuestro script pide la contraseña de 'root' y alguien está parado detrás nuestro (shoulder surfing)... ¿Cómo escondemos lo que tecleamos sin romper el script?"
read -s -p "Ingrese la contraseña secreta de DB: " db_pass
echo ""
echo "Contraseña capturada de forma segura en memoria."


# ---------------------------------------------------------
# DEMO 5: CASO PRÁCTICO INTEGRADO (PING INTERACTIVO)
# ---------------------------------------------------------

# OBJETIVO: Juntar todo lo aprendido en una herramienta útil de diagnóstico de red.
# ESPERADO: Solicitará una IP. Hará ping en silencio (mandando la basura a /dev/null) y avisará si el server está vivo o caído.
# PREGUNTA: "Vamos a crear nuestro propio comando de diagnóstico. Usaremos 'read -p' para pedir una IP, y luego usaremos los operadores lógicos '&&' y '||' del capítulo anterior. ¿Qué creen que pasará si le pongo la IP 8.8.8.8 vs una IP inventada?"
read -p "Ingrese la IP a monitorear: " target_ip
ping -c 2 $target_ip > /dev/null 2>&1 && echo "ALERTA: ¡El servidor $target_ip está VIVO!" || echo "ERROR: El servidor $target_ip está CAÍDO."