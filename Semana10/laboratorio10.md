
#  GUÍA DE LABORATORIO TÉCNICO: Implementación Híbrida de Servidor de Impresión (Linux/Windows)

**Módulo:** Sistemas Operativos de Código Abierto (Administración de Redes C20)
**Entorno de Trabajo:** VMware Workstation Pro / Player
**Subred Asignada:** `10.160.10.0/24` (Máscara: 255.255.255.0)

---

##  Topología Lógica del Laboratorio

```text
[ VMware Virtual Network: VMnet8 (NAT) o Host-Only ]
Subred: 10.160.10.0/24  |  Gateway VMware: 10.160.10.2
===================================================================
      |                                       |
+--------------------+                  +--------------------+
| SERVIDOR LINUX     |                  | CLIENTE WINDOWS    |
| (Print Server)     |                  | (PC del Alumno)    |
| OS: Ubuntu Server  |                  | OS: Windows 10/11  |
| IP: 10.160.10.50   |                  | IP: 10.160.10.100  |
| Rol: CUPS Daemon   |                  | Rol: Usuario / Adm |
+--------------------+                  +--------------------+
```

##  OBJETIVOS DEL LABORATORIO
1. Configurar direccionamiento IP estático en Ubuntu Server en un entorno virtualizado.
2. Desplegar el servicio CUPS y emular hardware mediante una impresora virtual (PDF).
3. Configurar la apertura de Sockets (TCP 631) aplicando políticas de acceso.
4. Integrar clientes Windows de forma transparente usando el protocolo IPP.
5. Diagnosticar el flujo de red mediante lectura técnica de logs y comandos CLI.

---

##  FASE 1: Preparación de la Red en VMware

**1. Verificar la IP actual asignada por VMware:**
```bash
ip a
```
>  **Análisis del Comando:**
> *   **Uso:** Visualizar las interfaces de red.
> *   **Qué hace (Técnico):** Interroga al Kernel de Linux para mostrar la configuración de Capa 2 (Direcciones MAC) y Capa 3 (Direcciones IP) de todas las tarjetas de red.
> *   **Para qué sirve en este lab:** Confirmar que nuestro servidor tiene asignada la IP correcta (`10.160.10.50`) dentro de la subred aislada antes de iniciar servicios que dependan de ella.

*(Opcional: Si necesitas fijar la IP estática porque VMware te dio otra)*
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```
>  **Análisis del Comando:**
> *   **Uso:** Editar la configuración de red persistente.
> *   **Qué hace (Técnico):** Abre el editor de texto `nano` con privilegios de superusuario (`sudo`) para modificar el archivo YAML del gestor Netplan.
> *   **Para qué sirve en este lab:** Evita que el servidor cambie de IP cada vez que la máquina virtual se reinicie (un servidor siempre debe tener IP fija).

---

##  FASE 2: Instalación del Motor de Impresión (Capa 7)

**2. Actualizar el catálogo de paquetes:**
```bash
sudo apt update
```
>  **Análisis del Comando:**
> *   **Uso:** Sincronizar repositorios de software.
> *   **Qué hace (Técnico):** Descarga el índice más reciente desde los servidores oficiales de Ubuntu, sin instalar nada aún.
> *   **Para qué sirve en este lab:** Evita el error "Paquete no encontrado" al intentar descargar software.

**3. Instalar los paquetes base del servidor:**
```bash
sudo apt install -y cups cups-pdf printer-driver-all
```
>  **Análisis del Comando:**
> *   **Uso:** Despliegue de servicios.
> *   **Qué hace (Técnico):** Instala el demonio central `cups`, una enorme librería de drivers (`printer-driver-all`), y `cups-pdf` (backend que convierte cualquier trabajo de impresión en un archivo `.pdf`).
> *   **Para qué sirve en este lab:** Dota al SO Linux del motor necesario para procesar y enrutar trabajos de impresión ahorrando papel real.

**4. Asignar permisos de administración al usuario local:**
```bash
sudo usermod -aG lpadmin $USER
```
>  **Análisis del Comando:**
> *   **Uso:** Gestión de privilegios (Role-Based Access).
> *   **Qué hace (Técnico):** Modifica (`usermod`) al usuario actual (`$USER`), añadiéndolo (`-a`) al grupo complementario (`-G`) llamado `lpadmin` (Line Printer Admin).
> *   **Para qué sirve en este lab:** Autoriza a tu usuario de Linux a iniciar sesión en la interfaz web administrativa de CUPS. *(Nota: Aplica los cambios cerrando y volviendo a iniciar sesión en la terminal).*

---

##  FASE 3: Apertura de Sockets y Acceso Remoto (Capa 4)

Por defecto, CUPS solo escucha en `localhost`. Abriremos el servicio a la subred `10.160.10.0`.

**5. Respaldar el archivo de configuración original (Regla de Oro):**
```bash
sudo cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.bak
```
>  **Análisis del Comando:**
> *   **Uso:** Backup de configuración.
> *   **Qué hace (Técnico):** Crea un duplicado exacto del archivo maestro con la extensión `.bak`.
> *   **Para qué sirve en este lab:** Permite un *rollback* (restauración) inmediato en caso de corromper la configuración en pasos posteriores.

**6. Habilitar acceso remoto seguro de forma automatizada:**
```bash
sudo cupsctl --remote-admin --remote-any --share-printers
```
>  **Análisis del Comando:**
> *   **Uso:** Reconfiguración en caliente de CUPS.
> *   **Qué hace (Técnico):** Inyecta directivas en `cupsd.conf` para permitir administración remota (`--remote-admin`), conexiones desde equipos externos (`--remote-any`) y difusión de impresoras en la LAN (`--share-printers`).
> *   **Para qué sirve en este lab:** Transforma el equipo de un "cliente de escritorio" a un verdadero "Servidor de Red".

**7. Reiniciar y asegurar persistencia del servicio:**
```bash
sudo systemctl restart cups
sudo systemctl enable cups
```
>  **Análisis del Comando:**
> *   **Uso:** Control del gestor Systemd.
> *   **Qué hace (Técnico):** `restart` obliga al servicio a leer la nueva configuración en RAM. `enable` crea un enlace simbólico de arranque.
> *   **Para qué sirve en este lab:** Garantiza que CUPS sobreviva a los reinicios de la máquina virtual.

**8. Validación de Sockets TCP:**
```bash
sudo ss -tuln | grep 631
```
>  **Análisis del Comando:**
> *   **Uso:** Auditoría de puertos.
> *   **Qué hace (Técnico):** Busca en la lista de conexiones activas el puerto 631 en estado LISTEN.
> *   **Para qué sirve en este lab:** Prueba irrefutable (Capa 4 OSI) de que el servidor está listo para recibir peticiones.

---

##  FASE 4: Administración y Troubleshooting Local (Linux CLI)

**9. Definir la impresora "PDF" por defecto:**
```bash
lpadmin -d PDF
```
>  **Análisis del Comando:**
> *   **Uso:** Configuración de colas base.
> *   **Qué hace (Técnico):** Define el destino (`-d`) predeterminado del sistema hacia la cola virtual `PDF`.

**10. Inyectar un trabajo de impresión directo (Headless test):**
```bash
echo "Prueba exitosa en la subred 10.160.10.0" | lp -t "Doc_Secreto"
```
>  **Análisis del Comando:**
> *   **Uso:** Test de carga de Capa 7.
> *   **Qué hace (Técnico):** Usa una tubería/pipe (`|`) para inyectar texto al comando de impresión (`lp`), dándole un título (`-t`).

**11. Comprobar la generación física del archivo:**
```bash
ls -lh /var/spool/cups-pdf/ANONYMOUS/
```
>  **Análisis del Comando:**
> *   **Uso:** Validación de backend.
> *   **Qué hace (Técnico):** Lista el contenido de la carpeta spooler de `cups-pdf`. 
> *   **Para qué sirve en este lab:** Verás un archivo `Doc_Secreto.pdf`, confirmando que el ciclo interno del servidor es 100% funcional.

---

##  FASE 5: Integración Híbrida desde Windows (El Mundo Real)

El objetivo ahora es conectar un cliente Windows (`10.160.10.100`) al servidor Linux (`10.160.10.50`) usando IPP.

**12. Invocar el administrador clásico de impresoras de Windows:**
* Ve a la máquina virtual / host con Windows, abre un CMD y escribe:
```cmd
control printers
```
>  **Análisis del Comando:**
> *   **Uso:** Acceso rápido a herramientas de gestión (Control Panel).
> *   **Qué hace (Técnico):** Llama a la DLL que muestra los periféricos, evadiendo el menú limitado de "Configuración" de Windows 10/11.

**13. Conectar al servidor mediante URI (URL):**
* Haz clic en **Agregar una impresora** > **La impresora que quiero no está en la lista**.
* Selecciona: **Seleccionar una impresora compartida por nombre**.
* Escribe la ruta exacta hacia el demonio Linux:
   `http://10.160.10.50:631/printers/PDF`
* Haz clic en Siguiente.

**14. Traducir el idioma (Selección de Driver / Capa 6):**
* Windows necesita saber cómo enviarle los datos a Linux.
* **Fabricante:** `Microsoft` o `Genérico`.
* **Impresora:** `Controlador Publisher Color` o `Generic / Text Only` (Drivers nativos PostScript).
* Acepta e imprime la **Página de Prueba**.

**15. Auditoría del SysAdmin (Validación en el Servidor):**
* Regresa a la consola de tu Ubuntu Server y verifica que el trabajo de Windows ingresó a la red:
```bash
lpstat -W completed
```
>  **Análisis del Comando:**
> *   **Uso:** Auditoría de la cola del Spooler.
> *   **Qué hace (Técnico):** Muestra el historial de trabajos finalizados. Deberías ver un trabajo con origen de la IP de Windows.
* Revisa la carpeta Spool (Paso 11) para ver el PDF generado de la página de prueba de Windows. ¡Éxito total de integración!

---

##  FASE 6: El Reto del SysAdmin (Evaluación)

**Situación en la empresa:** Eres el administrador de la red `10.160.10.0/24`. El Gerente te informa que la impresora "PDF" está atascada/en mantenimiento, pero los usuarios siguen enviando trabajos, lo que saturará la memoria del servidor. Se requiere detener temporalmente la recepción de trabajos sin apagar el servidor.

**Tu Misión:** Ejecuta el comando en Linux para rechazar trabajos y luego compruébalo.

**Solución Esperada (Comandos):**
```bash
sudo cupsreject PDF
lpstat -p PDF
```
>  **Análisis del Comando:**
> *   **Uso:** Control de incidencias IT.
> *   **Qué hace (Técnico):** Cambia el estado de la cola en tiempo real. Al usar `lpstat`, el sistema confirmará con un mensaje *"Rejecting jobs"* (Rechazando trabajos). Al terminar el mantenimiento, usarías `sudo cupsaccept PDF` para normalizar el flujo.

