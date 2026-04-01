### Caso de Estudio: Configuración de Infraestructura para "TechFlow Startup"

**Contexto:** Eres el nuevo SysAdmin de TechFlow. La empresa aún no tiene un servidor DNS interno, por lo que debes configurar manualmente el archivo `hosts` en un servidor central para que los servicios se comuniquen entre sí. Si cometes un error, los desarrolladores perderán acceso a las bases de datos o a los servidores de despliegue.

---

### Guía de Laboratorio Paso a Paso

#### Fase 1: Inicialización del entorno
Crea tu espacio de trabajo y prepara el archivo:

```bash
mkdir lab_infra
cd lab_infra
cp /etc/hosts .
git init
git add hosts
git commit -m "COMMIT 0: Estado base del sistema"
```

---

#### Fase 2: Ciclo de 5 Cambios (Construcción Incremental)

Realizaremos 5 modificaciones simulando el crecimiento de la empresa. Después de cada cambio, haremos un commit.

**Cambio 1: Servidor Web Principal**
```bash
echo "10.0.0.10  web-prod.techflow.com" >> hosts
git add hosts
git commit -m "COMMIT 1: Añadido servidor web de producción"
```

**Cambio 2: Servidor de Base de Datos (PostgreSQL)**
```bash
echo "10.0.0.20  db-prod.techflow.com" >> hosts
git add hosts
git commit -m "COMMIT 2: Añadido nodo de base de datos"
```

**Cambio 3: Servidor de Correo (SMTP)**
```bash
echo "10.0.0.30  mail.techflow.com" >> hosts
git add hosts
git commit -m "COMMIT 3: Configurado acceso a servidor de correo"
```

**Cambio 4: Servidor de Monitoreo (Zabbix)**
```bash
echo "10.0.0.40  monitor.techflow.com" >> hosts
git add hosts
git commit -m "COMMIT 4: Añadido servidor de monitoreo"
```

**Cambio 5: Entorno de Desarrollo (Staging)**
```bash
echo "10.0.0.50  staging.techflow.com" >> hosts
git add hosts
git commit -m "COMMIT 5: Añadido entorno de pruebas"
```

---

#### Fase 3: Visualización del Historial (Auditoría)

Como SysAdmin, necesitas ver qué has hecho. Ejecuta este comando que es oro puro para el análisis:

```bash
git log --oneline --graph
```

Verás una lista como esta (tus códigos de commit variarán):
* `a5f1e2c COMMIT 5: Añadido entorno de pruebas`
* `b4e2d1a COMMIT 4: Añadido servidor de monitoreo`
* `c3d3c1b COMMIT 3: Configurado acceso a servidor de correo`
* `d2c4b1f COMMIT 2: Añadido nodo de base de datos`
* `e1b5a10 COMMIT 1: Añadido servidor web de producción`
* `f0a6z99 COMMIT 0: Estado base del sistema`

---

#### Fase 4: Escenarios de Recuperación (La Máquina del Tiempo)

Aquí es donde Git salva tu carrera de SysAdmin.

**Escenario A: El error catastrófico (Borrado accidental)**
Imagina que ejecutas por error: `> hosts` (esto vacía el archivo por completo).
*   **Recuperación rápida:**
    ```bash
    git restore hosts
    ```
    *El archivo vuelve a estar como en el COMMIT 5 instantáneamente.*

**Escenario B: Volver a un punto específico (El rollback)**
El jefe dice: *"El servidor de monitoreo y el de staging están dando problemas, vuelve a cuando solo teníamos Web, DB y Mail"*.
1. Identificamos que ese es el **COMMIT 3**.
2. Miramos el código de ese commit en nuestro `git log` (ejemplo: `c3d3c1b`).
3. **Viajamos en el tiempo:**
    ```bash
    # Esto pone el archivo hosts exactamente como estaba en el commit 3
    git restore --source c3d3c1b hosts
    ```
4. Verificamos: `cat hosts`. ¡Los servidores de monitoreo y staging han desaparecido!

**Escenario C: "Resetear" todo el proyecto**
Si quieres deshacer los últimos cambios de forma permanente y situarte en el COMMIT 2:
```bash
git reset --hard d2c4b1f
```
*Cuidado: Esto borra los commits 3, 4 y 5 de tu historial.*
