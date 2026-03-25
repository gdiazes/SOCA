### Nivel 1: El Junior (Lectura de Instrumentos)
El error de novato es mirar `top` y ver solo "letras moviéndose". Hay que saber leer el **resumen superior**.

**1. El Resumen de Salud (Header)**
*   **Comando:** `top`
*   **Qué mirar:** 
    *   **Load Average:** Tres números (1, 5 y 15 min). Si estos números superan el número de núcleos de tu CPU, el servidor está saturado.
    *   **%CPU / MiB Mem:** Te dice qué tan cerca estás del colapso total.
*   **Uso real:** Saber en 2 segundos si el problema es de procesamiento o de memoria.

**2. Salida rápida: `q` (Quit)**
*   **Acción:** Presionar la tecla `q` mientras `top` corre.
*   **Uso real:** Entrar, mirar la carga y salir para seguir trabajando.

---

### Nivel 2: El Administrador Intermedio (Control Interactivo)
Aquí es donde dejas de ser un espectador y empiezas a **ordenar el caos**. Mientras `top` está abierto, usa estas teclas:

**3. Ordenar por Recursos: `M` y `P`**
*   **Acción:** Presionar **`M`** (Mayúscula) para ordenar por Memoria o **`P`** para ordenar por CPU.
*   **Uso real:** En nuestro laboratorio, cuando el disco se llena y los procesos escriben, presiona `P` para ver qué agente malicioso está consumiendo más ciclos de CPU.

**4. Ver todos los núcleos: `1` (Uno)**
*   **Acción:** Presionar la tecla `1`.
*   **Qué hace:** Desglosa el uso de CPU por cada núcleo (CPU0, CPU1, etc.).
*   **Uso real:** Detectar si un proceso "Single-threaded" está bloqueando un núcleo entero al 100% mientras los demás están libres.

---

### Nivel 3: El SysAdmin Senior (Troubleshooting Selectivo)
A este nivel, filtramos el ruido para enfocarnos en la amenaza.

**5. Filtrar por Usuario: `u`**
*   **Acción:** Presionar `u` y escribir el nombre del usuario (ej: `master`).
*   **Uso real:** En un servidor con 50 usuarios, quieres ver solo los procesos de `master` para saber qué script de su carpeta está dando problemas.

**6. Matar desde adentro: `k` (Kill)**
*   **Acción:** Presionar `k`, escribir el PID y luego la señal (9 para SIGKILL).
*   **Uso real:** Es mucho más rápido que salir de `top`, buscar el PID y usar `kill`. Lo haces todo "en vivo".

**7. Resaltar lo activo: `z` y `b`**
*   **Acción:** Presionar `z` (color) y `b` (negrita).
*   **Uso real:** Ayuda visual para que los procesos activos "brillen" y los inactivos se apaguen. Indispensable para auditorías rápidas bajo estrés.

---

### Nivel 4: El "Gurú" del Sistema (Forense y Automatización)

**8. Modo Forest (Árbol): `V`**
*   **Acción:** Presionar `V` (Mayúscula).
*   **Qué hace:** Muestra la jerarquía de procesos (quién es el padre de quién).
*   **Uso real:** Descubrir que un proceso sospechoso fue lanzado por un script oculto en `cron`.

**9. Modo Batch (Para Logs): `top -b -n 1`**
*   **Comando:** `top -b -n 1 > reporte_estado.txt`
*   **Qué hace:** Toma una "foto" instantánea de `top` y la guarda en un archivo de texto.
*   **Uso real:** Programar una tarea que guarde el estado de los procesos cada 5 minutos cuando no estás frente a la pantalla.

**10. Guardar Preferencias: `W`**
*   **Acción:** Configura tus colores, filtros y orden, luego presiona `W` (Mayúscula).
*   **Uso real:** La próxima vez que abras `top`, estará configurado exactamente como te gusta (ej: siempre ordenado por Memoria y con colores).
