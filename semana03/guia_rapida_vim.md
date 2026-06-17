### 1. Nivel de Iniciación: Operaciones de Supervivencia
En este nivel, se busca la superación de la barrera de entrada del modelo modal. Se establecen los fundamentos para la edición básica de archivos de configuración.

| Comando | Acción en Tercera Persona | Categoría |
| :--- | :--- | :--- |
| `i` | Se activa el modo de inserción antes del cursor. | Modo Inserción |
| `Esc` | Se retorna al modo normal (estado de reposo). | Control de Modo |
| `:w` | El archivo es escrito en el disco (guardado). | Ex-Command |
| `:q!` | Se abandona el editor sin salvar las modificaciones. | Ex-Command |
| `:wq` | Se guarda el contenido y se cierra el búfer. | Ex-Command |
| `h, j, k, l` | El cursor es desplazado (izq, abajo, arriba, der). | Navegación |

---

### 2. Nivel Intermedio: Eficiencia Operativa y Manipulación de Texto
Una vez que el modelo modal es asimilado, se introducen comandos que minimizan el desplazamiento físico de las manos, optimizando la carga de trabajo (Sweller, 1988).

| Comando | Acción en Tercera Persona | Categoría |
| :--- | :--- | :--- |
| `x` | Se elimina el carácter situado bajo el cursor. | Edición |
| `dw` | Es eliminada la palabra desde la posición actual. | Edición |
| `dd` | Se procede al borrado (o corte) de la línea completa. | Edición |
| `yy` | La línea actual es copiada al registro temporal. | Copiado |
| `p` | El contenido del registro es pegado tras el cursor. | Pegado |
| `u` | Se deshace la última acción ejecutada (*Undo*). | Historial |
| `/patrón` | Se inicia la búsqueda de una cadena de texto. | Búsqueda |
| `n / N` | Se navega hacia la siguiente o anterior coincidencia. | Búsqueda |

---

### 3. Nivel Avanzado: Administración de Sistemas y Automatización
En la etapa avanzada, el SysAdmin integra Vim con el entorno del sistema operativo. Se hace uso de la capacidad multi-búfer y de la automatización de tareas repetitivas.

| Comando | Acción en Tercera Persona | Propósito SysAdmin |
| :--- | :--- | :--- |
| `:%s/viejo/nuevo/g` | Se sustituyen todas las apariciones en el archivo. | Refactorización de config. |
| `:sp` / `:vsp` | La pantalla es dividida horizontal o verticalmente. | Comparación de archivos. |
| `:!comando` | Se ejecuta un comando del sistema (ej. `ls`, `ip a`). | Interacción con el Shell. |
| `v` / `V` / `Ctrl+v` | Se activan los modos visuales (carácter, línea, bloque). | Edición de columnas/tablas. |
| `qa` ... `q` | Se graba una secuencia de comandos en el registro `a`. | Automatización de tareas. |
| `@a` | Es ejecutada la macro almacenada en el registro `a`. | Ejecución por lotes. |
| `:e /path/file` | Se abre un nuevo archivo en un búfer distinto. | Gestión multi-archivo. |
| `:ls` / `:bN` | Se listan y conmutan los búferes activos en memoria. | Gestión de flujo de trabajo. |

---



###  Referencias Bibliográficas (APA 7.ª Edición)

*   Chacon, S., & Straub, B. (2014). *Pro Git* (2.ª ed.). Apress. https://git-scm.com/book/es/v2
*   Robbins, A., Hannah, E., & Lamb, L. (2008). *Learning the vi and Vim Editors* (7.ª ed.). O'Reilly Media.
*   Sweller, J. (1988). Cognitive load during problem solving: Effects on learning. *Cognitive Science*, 12(2), 257–285. https://doi.org/10.1207/s15516709cog1202_4
*   The IEEE and The Open Group. (2018). *The Open Group Base Specifications Issue 7, 2018 edition: Section Utility: vi*. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/vi.html
