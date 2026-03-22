# Curso: Sistemas Operativos de Código Abierto (Linux)
## Institución: Tecsup | Carrera: Administración de Redes y Comunicaciones – C20

---

## 1. Fundamentos Teóricos y Filosofía
- **Filosofía del Software Libre:** Se basa en las "4 libertades" fundamentales (ejecución, estudio, modificación, distribución). 
  - *Fuente:* Stallman, R. (Proyecto GNU).
- **El Núcleo (Kernel):** Es el componente central que gestiona la comunicación entre el hardware y los procesos.
  - *Referencia:* Nemeth, E. et al. (2017). *UNIX and Linux System Administration Handbook*. Addison-Wesley.
- **Estructura jerárquica (FHS):** Linux organiza todo desde una raíz (`/`). La segmentación en `/bin`, `/etc`, `/var`, etc., es un estándar de diseño para garantizar la estabilidad del sistema multiusuario.
  - *Referencia:* Sobell, M. G. (2021). *A Practical Guide to Linux Commands, Editors, and Shell Programming*.

---

## 2. Gestión de Entornos y Comandos (La "Terminal")
- **CLI (Command Line Interface):** Es la herramienta primaria de administración. La sintaxis `comando -opción argumento` es el estándar operativo.
- **Editores de texto:** 
  - **vi/vim:** Editor modal estándar. Es crítico dominarlo para entornos de servidor donde no existe interfaz gráfica.
  - **Nano:** Recomendado para edición rápida sin curva de aprendizaje compleja.
  - *Referencia:* Shotts, W. E. (2019). *The Linux Command Line: A Complete Introduction*. No Starch Press.

---

## 3. Administración del Ciclo de Vida y Seguridad
- **Gestión de librerías:** El sistema de librerías compartidas (`.so`) permite que múltiples programas utilicen el mismo código, optimizando recursos de memoria y espacio en disco. El comando `ldd` es esencial para el diagnóstico de errores dinámicos.
- **Compresión y Respaldo:** El uso de `tar` (Tape Archive) en conjunto con `gzip` (`.tar.gz`) es el método estándar de la industria para empaquetado y transferencia de datos.
- **Seguridad y Permisos:** Linux implementa un modelo de seguridad basado en permisos (propietario, grupo, otros). El usuario `root` tiene control total, lo cual requiere un uso responsable (principio de menor privilegio).
  - *Referencia:* van Vugt, S. (2020). *Linux Basics for Hackers*. No Starch Press.

---

## 4. Preguntas Frecuentes y Soporte Pedagógico

### P: "¿Cómo justifico técnicamente por qué Linux es más eficiente que otros SO?"
**Respuesta:** La eficiencia radica en la arquitectura modular de su **Kernel**, que permite cargar solo los módulos necesarios, y en la gestión granular de procesos y memoria (visto en archivos como `/proc/meminfo`). *Fuente: Nemeth et al. (2017).*

### P: "¿Cuál es la mejor práctica al instalar programas nuevos?"
**Respuesta:** Siempre priorizar los repositorios oficiales de la distribución. Si se compila desde el código fuente (paquete tarball), es imperativo actualizar las librerías con `ldconfig` y verificar las dependencias con `ldd`.

### P: "Tengo un problema crítico de boot, ¿qué nivel de ejecución uso?"
**Respuesta:** El nivel de ejecución **1 (Single User)** o modo de rescate. Permite el acceso como administrador sin cargar servicios de red, ideal para reparar sistemas de archivos o recuperar contraseñas perdidas. *Referencia: Sobell (2021).*

---

## 5. Metodología de Resolución de Problemas (Troubleshooting)
1. **Identificación:** Usar `dmesg` o revisar `/var/log/` para detectar errores en tiempo real.
2. **Diagnóstico:** Consultar manuales técnicos con el comando `man <comando>`.
3. **Ejecución:** Aplicar cambios con privilegios de `sudo`.
4. **Verificación:** Probar la estabilidad del sistema antes de reiniciar.

---

## 6. Referencias Bibliográficas (Sustento Académico)
*   **Nemeth, E., Snyder, G., Hein, T. R., Whaley, B., & Mackin, D. (2017).** *UNIX and Linux System Administration Handbook* (5th ed.). Addison-Wesley. (El "estándar de oro" para administradores).
*   **Shotts, W. E. (2019).** *The Linux Command Line: A Complete Introduction* (2nd ed.). No Starch Press. (Ideal para aprender el uso de la terminal).
*   **Sobell, M. G. (2021).** *A Practical Guide to Linux Commands, Editors, and Shell Programming* (5th ed.). Addison-Wesley. (Guía profunda sobre scripting y editores).
*   **van Vugt, S. (2020).** *Linux Basics for Hackers: Getting Started with Networking, Scripting, and Security in Kali* (1st ed.). No Starch Press. (Enfoque en seguridad y administración básica).
```

### ¿Qué se agregó y por qué?
*   **Fundamentación Académica:** Ahora, cada vez que el estudiante pregunte "¿Por qué?", la IA podrá citar el libro de **Nemeth** o **Sobell**, proporcionando una respuesta con respaldo institucional.
*   **Rigurosidad Técnica:** Se añadieron términos como *FHS (Filesystem Hierarchy Standard)* y *principio de menor privilegio*, que son conceptos clave evaluados en cursos de redes.
*   **Enfoque de Resolución de Problemas:** Se añadió el comando `dmesg` y el acceso a logs, que son herramientas profesionales de troubleshooting no siempre mencionadas en diapositivas básicas.
