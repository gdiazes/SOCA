# 📘 GUÍA DE LABORATORIO 8 (SECCIÓN B): "El Legado del SysAdmin Caótico en SysNova Corp"

## 👨‍💻 PARTE I: ENUNCIADO PARA EL ESTUDIANTE


### 📖 Contexto del Caso
Eres el nuevo Administrador de Redes y Sistemas Junior en **SysNova Corp**. El administrador anterior renunció repentinamente dejando el servidor central (Ubuntu 22.04) completamente desconfigurado. 

Los equipos de Calidad (QA) y Base de Datos están paralizados. El Gerente de TI te ha dado **1 hora** para estabilizar el entorno. Además, hay un incidente crítico en curso: **el servidor tiene una cuenta regresiva oculta y se reinicia solo constantemente**, destruyendo el trabajo no guardado.

### 🎭 Actores Involucrados
*   **`admin_junior`** *(Tú)*: Cuenta con privilegios de root.
*   **`qa_lucia`** *(Ingeniera de Pruebas)*: Necesita ejecutar scripts de validación, pero su entorno está roto.
*   **`dba_marcos`** *(Admin de Base de Datos)*: Necesita reiniciar servicios, pero sus privilegios actuales son un hueco de seguridad masivo.

### 🚀 Inicialización del Laboratorio
Al ingresar a tu máquina virtual, abre la terminal y ejecuta el siguiente comando para simular el entorno heredado. **Advertencia: A partir de presionar Enter, el reloj corre.**
```bash
sudo setup_lab8_B
```

### 🚨 Misiones a Resolver (Troubleshooting)

*   **💥 Incidente 0 (CRÍTICO): El Servidor Poseído (Variante B)**
    El servidor se reinicia cada 10 minutos. A diferencia del servidor A, el admin anterior no dejó un archivo en `/etc/cron.d/`, sino que programó la tarea directamente en la **tabla cron personal del usuario root**. ¡Encuéntrala y elimínala inmediatamente!
*   **🛠️ Incidente 1: La analista sin acceso**
    La usuaria `qa_lucia` necesita instalar dependencias con `apt`. El sistema le bloquea el uso de `sudo`. Ella ya pertenece al grupo `testing` y **no debe perder ese acceso**. Otórgale permisos de administrador de forma segura.
*   **🔒 Incidente 2: Privilegios descontrolados en Sudoers**
    Haciendo auditoría, descubres que el admin anterior configuró a `dba_marcos` para ejecutar **CUALQUIER comando sin contraseña** (`NOPASSWD: ALL`). 
    Debes usar la herramienta segura de edición para borrar esa vulnerabilidad. Luego, crea un `Cmnd_Alias` llamado `DB_ADMIN` que contenga solo `/bin/systemctl restart postgresql, /usr/bin/journalctl`. Asígnale ese alias a Marcos para que trabaje sin pedirle clave, pero limitado a esos comandos.
*   **📁 Incidente 3: Los scripts perdidos ($PATH)**
    Lucía (`qa_lucia`) intenta ejecutar su script escribiendo `run_tests`, pero obtiene *"Command not found"*. El software está instalado en `/usr/local/testing_scripts/`. Repara su sesión añadiendo esta ruta a sus variables de entorno.
*   **⚡ Incidente 4: Atajos de Monitoreo**
    El equipo de infraestructura pierde mucho tiempo escribiendo `sudo systemctl status apache2` para revisar el servidor web. Configura tu perfil de administrador (`~/.bashrc`) creando el alias persistente `webstatus`.
*   **🕵️ Incidente 5: Auditoría Forense**
    El Gerente necesita saber: 1) ¿Cuál es la ruta absoluta del lenguaje `perl` en este servidor? 2) ¿Qué variables de entorno extrañas dejó cargadas el root? (Busca la palabra `MALICIOUS` en las variables globales actuales). 3) Revisa el historial oculto de `root` para ver los últimos comandos que ejecutó.

## 📝 PARTE II: CUESTIONARIO DE REFLEXIÓN (Debate Post-Lab)
1. **En el Incidente 0 de esta sección, el cron no estaba en `/etc/cron.d/`. ¿Cuál es la diferencia entre los cron del sistema y usar `crontab -e`?**
   
2. **Lucía cerró su consola por error. Al volver a abrirla, `run_tests` volvió a fallar. ¿Por qué el comando `export` no fue suficiente?**
   
3. **¿Por qué `NOPASSWD: ALL` es considerado uno de los peores errores de configuración en Linux?**
   

## 📊 PARTE III: RÚBRICA DE EVALUACIÓN (Escala Vigesimal 0-20)

| Criterio de Evaluación | Excelente (Logrado) | Bueno (En Proceso) | Deficiente (No Logrado) | Puntaje Max |
| :--- | :--- | :--- | :--- | :---: |
| **1. Respuesta a Incidentes (Crontab)** | Identifica la tabla de root con `crontab -l` y elimina la tarea (`crontab -r`) antes del reinicio. **(3 pts)** | Solo cancela el apagado con `shutdown -c` pero no logra borrar el cron. **(1.5 pts)** | No detecta la tarea programada. **(0 pts)** | **3** |
| **2. Edición Crítica (Sudoers)** | Usa `visudo`. Borra el NOPASSWD masivo y aplica el `Cmnd_Alias` DB_ADMIN correctamente. Verifica efectividad. **(5 pts)** | Crea el Alias pero olvida borrar la vulnerabilidad original, dejando a Marcos como root. **(2.5 pts)** | Edita con editores inseguros (`nano`) o rompe la sintaxis. **(0 pts)** | **5** |
| **3. Permisos y Entorno (PATH y Bashrc)** | Agrega a qa_lucia a sudo. Configura la ruta de scripts correcta y hace persistente el alias de monitoreo. **(5 pts)** | Configura el entorno pero sobrescribe la variable PATH en lugar de añadirla (`$PATH:`). **(2.5 pts)** | No logra completar las modificaciones de entorno. **(0 pts)** | **5** |
| **4. Auditoría Forense** | Utiliza `which`, lee el historial y usa `env grep` para filtrar la variable oculta. **(3 pts)** | Localiza los archivos pero usa métodos ineficientes (leer todo env sin filtrar). **(1.5 pts)** | Falla en localizar los comandos de auditoría. **(0 pts)** | **3** |
| **5. Sustentación (Cuestionario)** | Responde con fundamentos técnicos, diferenciando tipos de cron y persistencia de variables. **(4 pts)** | Respuestas parciales. Entiende el error pero no la teoría subyacente. **(2 pts)** | Respuestas incorrectas o nulas. **(0 pts)** | **4** |
| **PUNTAJE TOTAL** | | | | **20** |
infierno de SysNova Corp.
