### Nivel 1: El Junior (Comunicación Básica)
El error de novato es pensar que `kill` siempre borra el proceso de inmediato. Primero, hay que saber pedir las cosas.

**1. El estándar de cortesía: `kill [PID]` (SIGTERM)**
*   **Comando:** `kill 14595`
*   **Qué hace:** Envía la señal 15 (Terminar). Le pide al proceso que cierre sus archivos, guarde su estado y se retire ordenadamente.
*   **Uso real:** Detener un servidor web o una base de datos sin corromper los datos.

**2. El Diccionario de Señales: `kill -l` (List)**
*   **Comando:** `kill -l`
*   **Qué hace:** Muestra todas las señales disponibles en tu sistema Ubuntu (normalmente 64).
*   **Uso real:** Consultar si no recuerdas el número de una señal específica (como `SIGUSR1`).

---

### Nivel 2: El Administrador Intermedio (Troubleshooting)
Aquí es donde el Sysadmin empieza a usar la fuerza cuando los procesos dejan de responder.

**3. La Opción Nuclear: `kill -9 [PID]` (SIGKILL)**
*   **Comando:** `kill -9 14595`
*   **Qué hace:** Envía la señal 9. El kernel detiene el proceso de forma fulminante. No hay limpieza, no hay guardado.
*   **Uso real:** Cuando un proceso de nuestro "caos" se queda bloqueado escribiendo en disco y ya no escucha a nadie.

**4. El Rifle de Francotirador: `pkill` (Process Kill by name)**
*   **Comando:** `pkill -f ".sys_res"`
*   **Qué hace:** Busca procesos que coincidan con el nombre o patrón y les envía la señal. La `f` busca en toda la línea de comandos del proceso.
*   **Uso real:** Ideal para nuestro laboratorio: matar los 10 agentes de una vez sin tener que buscar sus 10 PIDs.

---

### Nivel 3: El SysAdmin Senior (Gestión de Servicios)
A este nivel, controlamos el flujo de trabajo de los servicios sin interrumpirlos del todo.

**5. El "Recargar sin apagar": `kill -1 [PID]` (SIGHUP)**
*   **Comando:** `kill -HUP 1234`
*   **Qué hace:** Envía la señal 1 (Hangup). Muchos servicios (Nginx, Apache, SSHD) interpretan esto como: "Vuelve a leer tu archivo de configuración pero no te detengas".
*   **Uso real:** Aplicar cambios en un servidor de producción sin desconectar a los usuarios.

**6. El Botón de Pausa: `kill -STOP` y `kill -CONT`**
*   **Comando:** `kill -STOP 14595` y luego `kill -CONT 14595`
*   **Qué hace:** Congela el proceso en la RAM (STOP) y luego lo reanuda (CONT). 
*   **Uso real:** Cuando un proceso de respaldo (backup) está consumiendo demasiado CPU en horario pico; lo "pausas" y lo reanudas en la madrugada.

---

### Nivel 4: El "Gurú" del Sistema (Automatización y Grupos)

**7. La Matanza Masiva: `killall`**
*   **Comando:** `killall dd`
*   **Qué hace:** Mata a **todos** los procesos que se llamen exactamente `dd`. 
*   **Uso real:** Limpiar procesos repetitivos que se salieron de control (como los agentes de nuestro script).

**8. El "Harakiri" de Grupo: `kill -- -[PGID]`**
*   **Comando:** `kill -9 -14500` (El signo menos antes del ID es clave).
*   **Qué hace:** Mata a un proceso y a **todos sus hijos** simultáneamente usando el Process Group ID.
*   **Uso real:** Detener un script complejo que lanzó decenas de subprocesos (como un servidor de aplicaciones con muchos hilos).

