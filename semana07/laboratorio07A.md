# **Guía de Laboratorio Avanzada: Módulo 1**
* **Tema:** Filtrado de Texto y Control de Flujos (grep + Tuberías + FD)

* **Contexto del Sysadmin:** Ha saltado una alerta de madrugada. El servidor de producción prod-srv-01 está experimentando degradación de servicio y posibles intentos de intrusión. Tu misión es extraer la telemetría exacta para el equipo de respuesta a incidentes.

* **Paso 0:** Preparación del Entorno (Setup Realista)
Copia y pega este bloque en tu terminal. Generará un archivo `server_prod.log` simulando una mezcla de syslog, auth.log y logs de Nginx/MySQL:

```bash
cat << 'EOF' > server_prod.log
Oct 12 10:14:02 prod-srv-01 sshd[1243]: Accepted publickey for admin from 192.168.1.50 port 54322 ssh2
Oct 12 10:15:10 prod-srv-01 sshd[1288]: Failed password for invalid user root from 103.45.67.89 port 22 ssh2
Oct 12 10:15:15 prod-srv-01 sshd[1288]: Failed password for invalid user admin from 103.45.67.89 port 22 ssh2
Oct 12 10:16:05 prod-srv-01 nginx[893]: 192.168.1.100 - - [12/Oct/2023:10:16:05 +0000] "GET /api/v1/users HTTP/1.1" 200 1043 "-" "Mozilla/5.0"
Oct 12 10:17:22 prod-srv-01 nginx[893]: 10.0.0.5 - - [12/Oct/2023:10:17:22 +0000] "POST /api/v1/payment HTTP/1.1" 500 245 "-" "curl/7.68.0"
Oct 12 10:18:01 prod-srv-01 mysqld[1022]: [Note] Aborted connection 2 to db: 'app_db' (Got timeout reading communication packets)
Oct 12 10:19:55 prod-srv-01 kernel: [54321.9] Out of memory: Killed process 3452 (java) total-vm:4096000kB, anon-rss:2048000kB
Oct 12 10:20:01 prod-srv-01 CRON[4012]: (root) CMD (/usr/local/bin/backup.sh > /dev/null 2>&1)
EOF
```

* **Nivel Básico:** Aislamiento de Alertas de Seguridad
* **Objetivo:** Extraer eventos de autenticación fallida y crear un reporte.

* **La Tarea:** El equipo de seguridad necesita un archivo que contenga únicamente los intentos fallidos de conexión por SSH para bloquear las IPs.
* **El Comando:**
```bash
grep "Failed password" server_prod.log > reporte_bruteforce.txt
```

* **Pregunta de Análisis Crítico:** Si configuras este comando en un Cronjob (tarea automatizada) para que se ejecute cada 5 minutos sobre un log en vivo, ¿cuál es el peligro letal que esconde el operador > para el equipo de seguridad al finalizar el día? ¿Cómo lo solucionarías basándote en la página 17 del material?


* **Reto Práctico:** El equipo de auditoría ahora te pide aislar los inicios de sesión exitosos. Identifica el patrón de éxito en el log y crea un comando que guarde esas líneas en un archivo llamado `accesos_exitosos.txt`, pero asegúrate de utilizar el operador correcto para que, si ejecutas el comando dos veces, la información no se sobrescriba, sino que se acumule.

---

* **Nivel Intermedio:** Tuberías para Métricas (El Contador)
* **Objetivo:** Combinar el filtrado con herramientas de conteo para obtener métricas accionables.

* **La Tarea:** Desarrollo te pregunta: "¿Cuántos errores 500 (Internal Server Error) devolvió la API de pagos de Nginx hoy?" No quieren leer el log, solo necesitan el número exacto.
* **El Comando:**
```bash
grep "HTTP/1.1\" 500" server_prod.log | wc -l
```

* **Pregunta de Análisis Crítico:** Imagina que el archivo original pesa 50 Gigabytes. Explicado desde la "Filosofía Unix" (Pág. 16), ¿por qué usar la tubería `| wc -l` es infinitamente superior a nivel de memoria RAM y CPU, en lugar de intentar abrir el archivo de 50GB en un editor de texto como Vim o Nano para contar las líneas manualmente?


* **Reto Práctico:** El equipo de Base de Datos está experimentando interrupciones. Escribe una tubería que cuente cuántas veces aparece la palabra "timeout" en el log. Tu comando no debe ser sensible a mayúsculas/minúsculas y la salida debe ser solo un número.


---

* **Nivel Avanzado:** Auditoría Multidireccional con Supresión de Ruido
* **Objetivo:** Emular el escenario de "El Detective de Logs" (Pág. 7).

* **La Tarea:** Estás investigando falta de RAM. Buscarás "Out of memory" en tu log Y en `/etc/shadow` (para provocar un error de permisos). Registra el éxito en un log histórico y velo en pantalla simultáneamente, aniquilando la basura (errores).
* **El Comando:**
```bash
grep -i "out of memory" server_prod.log /etc/shadow 2> /dev/null | tee -a auditoria_memoria.log
```

* **Pregunta de Análisis Crítico:** La tubería `|` toma la salida de grep y la pasa a tee. Si un junior borra accidentalmente la parte `2> /dev/null`, ¿el mensaje de error de permisos de /etc/shadow se guardaría dentro del archivo auditoria_memoria.log gracias al comando tee?

**Reto * Práctico:** Busca la palabra "root" en el log y recursivamente en `/var/log/`. Envía errores de "Permiso denegado" al agujero negro, y usa `tee` para guardar resultados limpios en `rastreo_root.txt` (sobrescribiendo contenido previo), viéndolo en terminal en vivo.

