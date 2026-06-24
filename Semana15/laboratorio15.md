

#  GUÍA DE LABORATORIO 15: Troubleshooting y Respuesta a Incidentes (Metodología HP)

1. **Curso:** Sistemas Operativos de Código Abierto
2. **Metodología:** HP Troubleshooting Flowchart
3. **Entorno:** VMware NAT Aislado (`10.160.10.0/24`) | Ubuntu Server 26 (Víctima: `.200`) - Kali Linux (Atacante: `.100`)

###  Contexto del Escenario
Tu servidor web Apache (`10.160.10.200`) aloja un juego interactivo y una base de datos. Repentinamente, los usuarios reportan que el sistema está inoperativo o extremadamente lento (Jitter/Intermitencia). Tienes confirmación de que un nodo hostil (`10.160.10.100`) está operando en tu red. 

Tu misión es utilizar el método científico (Flujo HP) para aislar la falla, diagnosticar los vectores de ataque y mitigar la amenaza sin desconectar a los usuarios legítimos.

---

###  FASE 1: Recopilación de Información (HP Paso 1)
*Objetivo: Establecer la línea base y confirmar la anomalía documentando evidencia en todas las capas (Red, Hardware y Aplicación).*

Ejecuta estas herramientas por separado (abre varias terminales) y documenta tus hallazgos:

| Capa a Analizar | Comando de Diagnóstico | Reto Analítico para tu Reporte |
| :--- | :--- | :--- |
| **Transferencia de Red** | `nload ens33` | **Reto:** Lee el manual (`nload -h`). ¿Qué opciones debes agregar al comando para que el tráfico se muestre en **Megabytes (M)** y se refresque cada **200ms**? Si el TX (Salida) es muy alto, ¿qué significa? |
| **Estado de Sockets** | `ss -antp \| grep -E 'ESTAB\|SYN-RECV'` | Si ves cientos de conexiones `SYN-RECV`, ¿qué te dice esto sobre la naturaleza del tráfico que golpea la pila TCP del Kernel? |
| **Monitoreo de Logs** | `tail -f /var/log/apache2/access.log` | Usa `grep "db.sql"` sobre este comando. ¿A qué velocidad se registran las descargas? ¿Las peticiones provienen de una única IP o de varias? |
| **Uso de CPU/Memoria** | `htop` | Observa los procesos de `apache2`. ¿Están consumiendo CPU o Memoria de forma inusual? *(Presiona `q` para salir).* |
| **Uso de Disco (I/O)** | `iostat -x 1` | Observa la columna `%util`. Si el disco está al 100%, ¿es un fallo de hardware o consecuencia de las descargas masivas? *(Nota: Requiere `sudo apt install sysstat`).* |

---

###  FASE 2: Evaluar Subsistemas (HP Paso 2)
*Objetivo: Aislar los subsistemas afectados. ¿Es un fallo de Red (Capa 4) o de Aplicación (Capa 7)?*

**Análisis Socrático (Responde en tu reporte):**
1. Al capturar paquetes con `sudo tcpdump -i ens33 -n port 80`, notarás que las IPs cambian constantemente (Spoofing). ¿Por qué un simple bloqueo por IP (`iptables -A INPUT -s IP -j DROP`) es inútil aquí?
2. **Contexto Histórico:** Históricamente, usaríamos *TCP Wrappers* (`/etc/hosts.allow`) para controlar accesos. ¿Por qué en un ataque DDoS moderno preferimos mitigar a nivel de Kernel (Firewall/`iptables`) en lugar de usar TCP Wrappers?

---

###  FASE 3: Desarrollar Plan de Acción (HP Paso 3)
*Objetivo: Diseñar una solución priorizada y no destructiva.*

Debes redactar un script de Bash (`defensa.sh`) que ataque ambos vectores simultáneamente:
1.  **Mitigar la inestabilidad de Red (SYN Flood):** Implementar *Rate Limiting* (límite de conexiones).
2.  **Mitigar la carga de Servidor (Descargas pesadas):** Implementar filtrado de cadenas (*String matching*) para bloquear peticiones específicas al archivo pesado.

>  **Regla HP de Oro:** Tu script debe ser *idempotente*. Debe limpiar las reglas anteriores o verificar que no existan antes de aplicarlas, para evitar duplicados si lo ejecutas dos veces.

---

###  FASE 4: Ejecutar el Plan (HP Paso 4)
*Objetivo: Implementar y observar los resultados de tu defensa.*

**Referencias de comandos para tu Script:**
*   *Limpieza previa:* `iptables -F` (Solo si es seguro vaciar el firewall en tu entorno).
*   *Defensa Capa 4 (Rate Limiting):* `iptables -A INPUT -p tcp --syn --dport 80 -m limit --limit 10/s -j ACCEPT` seguido de un `DROP` para el exceso.
*   *Defensa Capa 7 (Filtro String):* `iptables -A INPUT -p tcp --dport 80 -m string --string "db.sql" --algo bm -j DROP`

> **Prueba Crítica:** Ejecuta tu script. Ve a tu navegador (en la máquina host) y recarga el juego web `http://10.160.10.200`. ¿El tiempo de carga vuelve a la normalidad? Documenta este cambio de estado.

---

###  FASE 5 y 6: Problema Resuelto y Medidas Preventivas
*Objetivo: Validar la solución y automatizar la protección.*

1.  **Verificación:** Revisa nuevamente `nload` e `iostat`. ¿El tráfico de salida (TX) y el uso de disco (`%util`) cayeron a niveles normales? Si no, regresa a la Fase 2 (Rediagnosticar).
2.  **Prevención:** ¿Cómo convertirías tu script de defensa en un servicio o tarea programada (`cron`) que se active solo si el tráfico supera un umbral de peligro?

---

###  RÚBRICA DE EVALUACIÓN

| Competencia |  Nivel Arquitecto (5 pts) |  Nivel Administrador (3 pts) |  Nivel Inicial (1 pt) |
| :--- | :--- | :--- | :--- |
| **Metodología HP** | Documenta cada paso del diagrama claramente, justificando cada hipótesis con capturas de pantalla. | Sigue la lógica pero falla en documentar la línea base (el antes y el después). | Ejecuta comandos al azar sin seguir un flujo de diagnóstico estructurado. |
| **Diagnóstico de Vectores** | Identifica la concurrencia del SYN Flood y el ataque L7 HTTP, utilizando correctamente `nload` e `iostat`. | Identifica solo un vector (ve el tráfico pero no deduce el problema de disco). | No logra interpretar la salida de los comandos. |
| **Ingeniería de Mitigación** | Script incluye `set -euo pipefail`, previene reglas duplicadas y no bloquea a usuarios legítimos. | Aplica reglas duras (Drop total) que afectan a usuarios sanos, o duplica reglas en `iptables`. | El script contiene errores de sintaxis o rompe totalmente el acceso al servidor. |
| **Cultura DevSecOps** | Entrega un repositorio Git ordenado con un script extra (`reset_lab.sh`) para restaurar el entorno. | Entrega los scripts sueltos, funcionales pero sin control de versiones. | Omite el control de versiones y el código es desordenado. |

---
**Entregable Final:** 
Sube a la plataforma un enlace a tu repositorio de GitHub que contenga:
1. El script de mitigación (`defensa.sh`).
2. El script de restauración (`reset_lab.sh`).
3. El archivo `INFORME_INCIDENTE.md` respondiendo a las preguntas de análisis socrático y mostrando la evidencia (capturas) de las fases de HP.
