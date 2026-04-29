# **Guía de Laboratorio Avanzada: Módulo 3**
* **Tema:** Inspección Rápida, Monitoreo y Bases de Datos (head, tail, less, <)

* **Contexto del Sysadmin:** Estás preparando el servidor para un pase a producción. Necesitas instalar el motor de base de datos, cargar un respaldo gigante sin interacción humana y monitorear los logs del sistema en tiempo real para asegurar que no haya fallas durante el despliegue.

* **Paso 0:** Preparación del Entorno (Setup Realista y Servidor MySQL)
Para ejecutar este módulo, instalaremos MySQL, configuraremos credenciales e insertaremos datos de prueba. Ejecuta los comandos línea por línea:

```bash
# 1. Generar log de sistema gigante para pruebas de monitoreo
for i in {1..1000}; do echo "Log entry $i: Status OK" >> big_syslog.log; done

# 2. Instalar MySQL Server (Entorno Debian/Ubuntu)
sudo apt-get update
sudo apt-get install -y mysql-server
sudo /etc/init.d/mysql status
sudo /etc/init.d/mysql start

# 3. Configurar contraseña de root a "Tecsup00" y crear base de datos vacía
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Tecsup00'; FLUSH PRIVILEGES;"
mysql -u root -pTecsup00 -e "CREATE DATABASE produccion_db;"

# 4. Crear el archivo de backup falso en formato SQL
echo "USE produccion_db; CREATE TABLE users (name VARCHAR(50)); INSERT INTO users VALUES ('admin_tecsup');" > backup_db.sql
```

**Nivel Básico:** Los Extremos del Archivo (head & tail)
* **Objetivo:** Limitar la vista de datos (Pág. 11 y 20).

* **La Tarea:** Necesitas verificar rápidamente si el archivo `big_syslog.log` tiene la estructura correcta leyendo solo las primeras 3 líneas, y luego verificar cuál fue el último evento registrado leyendo las últimas 3 líneas.
* **El Comando:**
```bash
head -n 3 big_syslog.log
tail -n 3 big_syslog.log
```

* **Pregunta de Análisis Crítico:** ¿Por qué un administrador de sistemas preferiría usar `tail` para revisar errores tras la caída de un servicio, en lugar de usar `head`?

* **Reto Práctico:** Extrae las últimas 15 líneas de `big_syslog.log` y envíalas directamente a la herramienta de conteo de caracteres (`wc -c`) para saber cuánto "pesan" exactamente esas líneas combinadas.

---

**Nivel Intermedio:** El Monitor en Tiempo Real (tail -f)
* **Objetivo:** Observabilidad en vivo (Pág. 11 y 20).

* **La Tarea:** Estás reiniciando el servicio web y quieres ver los nuevos logs en el momento exacto en que se generan en pantalla, sin tener que ejecutar el comando una y otra vez.
* **El Comando:**
```bash
tail -f big_syslog.log
```
*(Nota: Usa Ctrl+C para salir del monitoreo en tu terminal).*

**Pregunta de Análisis Crítico:** Si combinas `tail -f` con un `grep` mediante una tubería (Ej: `tail -f log | grep "error"`), ¿qué estarías logrando a nivel de monitoreo del sistema?

---

**Nivel Avanzado:** Redirección de Entrada y Restauración de BD (<)
* **Objetivo:** Automatizar la carga de datos (Pág. 5 y 18).

* **La Tarea:** Necesitas contar las líneas del archivo de respaldo antes de subirlo, pero sin que la consola imprima el nombre del archivo en el resultado. Para ello, inyectarás el archivo al flujo de entrada estándar (FD 0) de `wc`.
* **El Comando:**
```bash
wc -l < backup_db.sql
```

**Pregunta de Análisis Crítico:** Si ejecutas `wc -l backup_db.sql`, la salida es `1 backup_db.sql`. Pero al usar `<`, la salida es solo `1`. ¿Por qué la redirección de entrada `<` oculta el nombre del archivo?

**Reto Práctico Final:** Utilizando el entorno MySQL que instalaste en el Paso 0 y basándote en la página 5 del material, restaura el archivo `backup_db.sql` dentro de la base de datos `produccion_db`. Debes usar el usuario `root` y la contraseña `Tecsup00` (puedes pasar la contraseña pegada a la flag `-p` para automatizarlo en una sola línea de código).
