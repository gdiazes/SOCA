
# 🚀 Operación: Rescate del Servidor Misión Marte

**Contexto:**
Has sido reclutado de emergencia. El servidor central de la Misión Marte ha sido comprometido y está fallando. El tiempo de comunicación con la nave se agota. Tu misión es estabilizar el sistema y asegurar los datos antes de que sea tarde.

### ⚠️ Reglas de Supervivencia:
1.  **Identidad:** Entras como el usuario `estudiante` (Clave: `Tecsup00`). Este usuario no tiene poder. Deberás encontrar la forma de usar la cuenta de administrador `alumno` (Clave: `Linux2024`) para realizar los cambios.
2.  **Modo Caos:** El servidor tiene un fallo de hardware y **se reiniciará automáticamente cada 5 minutos**. ¡Si tu solución no es permanente, desaparecerá al reiniciar!
3.  **Ventana de Tiempo:** Tienes exactamente **20 minutos**. Pasado este tiempo, el sistema de validación se borrará.
4.  **Munición Limitada:** Solo tienes **3 intentos** para validar cada reto. Si fallas los 3, te quedarás con la última puntuación obtenida. **¡Audita con comandos antes de validar!**

---

### 🎯 Tus 5 Misiones:

#### Reto 1: Colaboración Interrumpida
El equipo de ingenieros no puede trabajar en su carpeta de proyectos.
*   **Problema:** La carpeta `/projects/mision_marte` está bloqueada.
*   **Misión:** Configúrala para que el grupo `ingenieros` tenga acceso total. **OJO:** Cualquier archivo que se cree dentro debe pertenecer automáticamente al grupo `ingenieros` (Herencia).
*   **Validación:** `sudo check-retos 1`

#### Reto 2: El Espía en el Sistema
Se ha detectado un usuario llamado `infiltrado` que está robando CPU.
*   **Problema:** El intruso tiene procesos activos y acceso al sistema.
*   **Misión:** Bloquea su cuenta para que no pueda entrar y detén todos sus procesos de forma definitiva (que no vuelvan al reiniciar).
*   **Validación:** `sudo check-retos 2`

#### Reto 3: Privilegios de Emergencia
Como `estudiante`, necesitas poder actualizar la lista de software, pero no debes tener poder total sobre el sistema.
*   **Misión:** Configura una regla de `sudo` específica para que el usuario `estudiante` pueda ejecutar `apt update` sin que se le pida contraseña. No debe poder hacer nada más como root.
*   **Validación:** `sudo check-retos 3`

#### Reto 4: El Enlace Multi-Equipo
Para coordinar la misión, tu usuario debe tener acceso a las comunicaciones de todos los departamentos.
*   **Misión:** Asegúrate de que el usuario `estudiante` pertenezca simultáneamente a los grupos: `ingenieros`, `astronautas` y `comunicaciones`. ¡Cuidado con no borrarte de tus grupos actuales!
*   **Validación:** `sudo check-retos 4`

#### Reto 5: La Caja Fuerte de Datos
Necesitamos un buzón donde todos puedan dejar reportes, pero nadie pueda borrar el trabajo de sus compañeros.
*   **Problema:** La carpeta `/tmp/caja_fuerte` permite que cualquiera borre archivos de otros.
*   **Misión:** Configura la carpeta para que todos puedan escribir, pero **solo el dueño de un archivo pueda borrarlo**.
*   **Validación:** `sudo check-retos 5`

---

### 📋 Cómo entregar tus resultados:
Cada vez que logres un reto, el comando `check-retos` te entregará un **Token de Oro**.
1.  Copia el código (ej: `ORO_SGID_MARTE_estudiante`).
2.  Captura de pantalla del reto completado.

**¡Mucha suerte, Administrador. El reloj empieza ahora!** 🐧🚀

---

### 💡 Consejos para el Alumno (Tu "Cheat Sheet" sugerido):
*   Para cambiar de identidad: `su - alumno`
*   Para ver permisos: `ls -la` o `stat`
*   Para ver grupos: `id` o `groups`
*   Para permisos especiales: Investiga qué es **SGID (2)** y **Sticky Bit (1)**.
*   Para procesos: `ps -u` o `top`.
*   Para privilegios: Revisa la carpeta `/etc/sudoers.d/`.
