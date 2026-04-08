
#  Operación Misión Marte: Reto de Administración Linux (SadServer Style)

¡Bienvenido, Administrador de Sistemas! Has sido asignado al centro de control de la **Misión Marte**. El administrador anterior ha dejado el servidor en un estado crítico antes de desaparecer. El sistema está inestable, hay brechas de seguridad y la ventana de comunicación con la nave se cierra pronto.

**¿Tienes lo necesario para salvar la misión en 20 minutos?**

---

##  Requisitos
* Una instancia de **Ubuntu 22.04 LTS o superior**.
* Acceso a Internet (solo para la instalación inicial).
* Usuario con permisos de `sudo`.

##  Instalación del Reto (Solo para el Instructor)
Ejecuta este comando como **root** para preparar el entorno de caos, descargar los binarios y activar los temporizadores:

```bash
curl -sSL https://raw.githubusercontent.com/gdiazes/SOCA/refs/heads/main/semana04/laboratorio04/lab4.sh | sudo bash
```

---

##  Reglas del Juego

1.  **Identidades:** 
    *   Entrarás como el usuario **`estudiante`** (Clave: `Tecsup00`).
    *   Este usuario **no tiene permisos de administración**. Deberás encontrar la forma de usar la cuenta de respaldo **`alumno`** (Clave: `Linux2024`) para gestionar el sistema.
2.  **Ingeniería de Caos:** 
    *   El servidor tiene un fallo de hardware y **se reiniciará automáticamente cada 5 minutos**. ¡Asegúrate de que tus cambios sean persistentes!
3.  **Tiempo Límite:** 
    *   Tienes exactamente **20 minutos**. Pasado este tiempo, la herramienta de validación se autodestruirá.
4.  **Límite de Intentos:** 
    *   Solo tienes **3 intentos** para validar cada uno de los 5 retos. ¡No adivines, audita antes de ejecutar!

---

##  Los 5 Retos

| Reto | Misión | Concepto Técnico |
| :--- | :--- | :--- |
| **1** | **Directorios Marte** | Configurar colaboración con **SetGID**. |
| **2** | **Caza al Intruso** | Bloquear accesos y eliminar persistencia de procesos. |
| **3** | **Poder Granular** | Configurar reglas específicas en **sudoers.d**. |
| **4** | **Enlace de Equipos** | Gestión de membresía múltiple de grupos. |
| **5** | **Caja Fuerte** | Protección de integridad con el **Sticky Bit**. |

---

##  Cómo Validar
Para obtener tus códigos de nivel **ORO** y sumarlos al Dashboard, usa el comando:

```bash
sudo check-retos [NÚMERO_DE_RETO]
```

**Ejemplo:** `sudo check-retos 1`

Si el reto es correcto, recibirás un **Token**. Cópialo y pégalo en el Formulario de Google proporcionado por el instructor.

---

##  Limpieza (Post-Reto)
Para detener los reinicios automáticos y limpiar el sistema una vez terminada la clase, ejecuta como root:
```bash
sudo rm /etc/cron.d/caos_reboot && sudo reboot
```
