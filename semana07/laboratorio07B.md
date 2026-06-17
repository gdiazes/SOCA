# **Guía de Laboratorio Avanzada: Módulo 2**
* **Tema:** Extracción, Orden y Deduplicación de Datos (cut, sort, uniq)

* **Contexto del Sysadmin:** El servidor web está recibiendo un ataque de denegación de servicio (DDoS). Necesitas extraer rápidamente una lista limpia y única de las direcciones IP que están atacando el servidor para pasársela al firewall.

* **Paso 0: Preparación del Entorno (Setup Realista)**
Ejecuta esto para crear un log de acceso web simulado con IPs repetidas:
```bash
cat << 'EOF' > web_access.log
192.168.1.10 - - [12/Oct/2023:10:00:00] "GET /index.html" 200
10.0.0.5 - - [12/Oct/2023:10:00:05] "GET /about.html" 200
192.168.1.10 - - [12/Oct/2023:10:00:10] "GET /contact.html" 200
172.16.0.2 - - [12/Oct/2023:10:01:00] "POST /login" 401
10.0.0.5 - - [12/Oct/2023:10:01:05] "GET /images/logo.png" 200
192.168.1.10 - - [12/Oct/2023:10:02:00] "GET /api/data" 500
EOF
```

* **Nivel Básico:** El Organizador (sort)
* **Objetivo:** Comprender cómo se reordenan las líneas de texto (Pág. 9).

* **La Tarea:** Necesitas ver el log ordenado por dirección IP (que es el primer carácter de cada línea) para agrupar visualmente el tráfico.
* **El Comando:**
```bash
sort web_access.log
```

* **Pregunta de Análisis Crítico:** Si usas `sort -r`, ¿qué comportamiento adoptaría el comando y en qué escenario de administración de sistemas sería útil esto?

* **Reto Práctico:** Ordena el archivo `web_access.log` en orden inverso y guarda el resultado en `log_inverso.txt`.

---

* **Nivel Intermedio:** El Eliminador de Duplicados (uniq)
* **Objetivo:** Aplicar la regla de oro del Sysadmin expuesta en la página 10 del material.

* **La Tarea:** Quieres ver los registros eliminando las líneas idénticas adjuntas.
* **El Comando:**
```bash
sort web_access.log | uniq
```

* **Pregunta de Análisis Crítico:** Según el "Tip Visual" de la página 10, ¿por qué es un error técnico ejecutar `uniq web_access.log` directamente sin pasar por `sort` primero?

* **Reto Práctico:** Utiliza un comando de tubería para contar (con `wc -l`) cuántas líneas únicas en total existen en tu log de acceso web.

---

* **Nivel Avanzado:** El One-Liner Definitivo de Extracción
* **Objetivo:** Aislar un campo específico, ordenarlo y deduplicarlo (Emulando el Reto de la Pág. 10 y 13).

* **La Tarea:** Firewall necesita SOLO la lista de direcciones IP únicas que han visitado el sitio. Nada de fechas ni códigos HTTP. El delimitador en tu log es el espacio en blanco.
* **El Comando:**
```bash
cat web_access.log | cut -d' ' -f1 | sort | uniq
```

* **Pregunta de Análisis Crítico:** Analizando la tubería: `cut -d' ' -f1` le dice al sistema "corta por espacios y dame la columna 1". Si las IPs en tu servidor estuvieran separadas por comas (formato CSV) en lugar de espacios, ¿cómo modificarías exclusivamente la sección del comando `cut`?

* **Reto Práctico (Reto Final Pág. 13 adaptado):** Construye una sola tubería que: Lea el archivo `/etc/passwd`, extraiga los nombres de usuario (columna 1, separada por el delimitador `:`), los ordene alfabéticamente y guarde los resultados limpios en un archivo llamado `usuarios_sistema.txt`.
