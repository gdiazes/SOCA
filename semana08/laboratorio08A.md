#  GUÍA DE LABORATORIO 8: "El Legado del SysAdmin Caótico en SysNova Corp"

##  PARTE I: ENUNCIADO PARA EL ESTUDIANTE

###  Contexto del Caso
Eres el nuevo Administrador de Redes y Sistemas Junior en **SysNova Corp**. El administrador anterior renunció repentinamente tras un despliegue fallido. Has heredado un servidor central basado en Ubuntu Server 22.04 que actualmente es un caos de configuración. 

Los equipos de Desarrollo y Auditoría están detenidos porque no pueden realizar sus tareas, y el Gerente de TI te ha dado **1 hora** para estabilizar el entorno de los usuarios de forma segura. Además, los usuarios reportan un incidente crítico: **el servidor se está apagando y reiniciando solo a cada momento**, lo que hace que la situación sea extrema.

###  Actores Involucrados
*   **`admin_junior`** *(Tú)*: Cuenta principal con privilegios de root (o puedes usar la cuenta `root` si el lab lo permite).
*   **`dev_carlos`** *(Desarrollador)*: Necesita permisos y configurar su entorno para trabajar.
*   **`usuario_auditor`** *(Auditor)*: Necesita revisar logs urgentes, pero sus permisos actuales son un riesgo de seguridad.

###  Inicialización del Laboratorio
Al ingresar a tu máquina virtual, abre la terminal y ejecuta el siguiente comando para simular el entorno heredado. **Advertencia: A partir de presionar Enter, el reloj corre.**
```bash
sudo setup_lab8A
```

###  Misiones a Resolver (Troubleshooting)

*   **💥 Incidente 0 (CRÍTICO): El Servidor Poseído**
    Apenas entras al servidor, un temporizador está forzando un reinicio cada 10 minutos. ¡Debes localizar la tarea programada maliciosa y eliminarla antes de hacer cualquier otra cosa o perderás tu progreso!
*   **🛠️ Incidente 1: El desarrollador sin acceso**
    El usuario `dev_carlos` necesita instalar un paquete mediante `apt`. Sin embargo, al intentar usar `sudo`, el sistema le arroja un error. El gerente te advierte que Carlos ya pertenece al grupo `docker` y **no debe perder ese acceso** al darle nuevos privilegios. Otórgale permisos de administrador de forma correcta.
*   **🔒 Incidente 2: La puerta trasera en Sudoers**
    El admin anterior le dio al `usuario_auditor` permiso total `ALL=(ALL:ALL) ALL` en el archivo de sudoers. Debes eliminar este privilegio absoluto y crear un `Cmnd_Alias` llamado `LOG_READER` (solo con `/usr/bin/cat, /usr/bin/tail`) para asignarlo al auditor sin que el sistema le pida contraseña. *(Nota: Hazlo de forma segura o destruirás el servidor).*
*   **📁 Incidente 3: El entorno de desarrollo roto**
    Se instaló un software en `/opt/sysnova/bin`, pero al escribir `iniciar_app` con el usuario de Carlos, dice *"Command not found"*. Soluciona el problema para su sesión actual añadiendo la ruta a su variable de entorno.
*   **⚡ Incidente 4: Productividad estancada**
    El equipo está cansado de escribir `sudo tail -f /var/log/syslog`. Configura tu perfil de administrador (`~/.bashrc`) creando el alias persistente `verlogs`.
*   **🕵️ Incidente 5: Auditoría Forense Básica**
    El Gerente pide un reporte. Obtén: 1) La versión del kernel. 2) La ruta absoluta del binario `python3`. 3) Los últimos 20 comandos ejecutados por `root` en su historial oculto.



## 📝 PARTE II: CUESTIONARIO DE REFLEXIÓN (Debate Post-Lab)
1. **En el Incidente 2, ¿qué habría pasado si editabas `/etc/sudoers` usando `nano` y cometías un error de tipeo?**
   
2. **En el Incidente 3, si Carlos reinicia, ¿seguirá funcionando `iniciar_app`? ¿Dónde se debe guardar?**
   
3. **¿Cuál es la diferencia entre el "Alias" del Incidente 2 y el "Alias" del Incidente 4?**
   

## 📊 PARTE III: RÚBRICA DE EVALUACIÓN (Escala Vigesimal 0-20)

| Criterio de Evaluación | Excelente (Logrado) | Bueno (En Proceso) | Deficiente (No Logrado) | Puntaje Max |
| :--- | :--- | :--- | :--- | :---: |
| **1. Respuesta a Incidentes (Cron)** | Localiza y elimina la tarea programada antes de que el servidor se reinicie. **(3 pts)** | Elimina la tarea pero el servidor llegó a reiniciarse al menos una vez por lentitud. **(1.5 pts)** | No logra identificar ni detener el reinicio automático. **(0 pts)** | **3** |
| **2. Edición Crítica (Sudoers)** | Usa `visudo`. Borra la vulnerabilidad y crea el `Cmnd_Alias` con `NOPASSWD` correctamente. Verifica el resultado. **(5 pts)** | Usa `visudo`, pero comete errores menores de sintaxis o no comprueba si el auditor perdió privilegios. **(2.5 pts)** | Edita con `nano` (falta grave) o no logra configurar el Alias de seguridad. **(0 pts)** | **5** |
| **3. Permisos y Entorno (PATH y Bashrc)** | Agrega usuario a sudo sin borrar grupos (`-aG`). Configura el PATH y el alias en `.bashrc` haciéndolo persistente. **(5 pts)** | Omite el parámetro `-a` (borrando grupos) o no hace persistente el Alias (`source`). **(2.5 pts)** | No logra asignar permisos ni modificar el entorno de variables. **(0 pts)** | **5** |
| **4. Auditoría Forense** | Utiliza `uname`, `which` y lee el `history` correctamente sin errores de sintaxis. **(3 pts)** | Falla en localizar el historial oculto o usa comandos de forma ineficiente. **(1.5 pts)** | Desconoce los comandos básicos de auditoría del sistema. **(0 pts)** | **3** |
| **5. Sustentación (Cuestionario)** | Responde a las 3 preguntas con lenguaje técnico preciso diferenciando conceptos. **(4 pts)** | Responde de forma superficial o confunde los conceptos de los tipos de Alias. **(2 pts)** | No responde o las respuestas son técnicamente incorrectas. **(0 pts)** | **4** |
| **PUNTAJE TOTAL** | | | | **20** |


