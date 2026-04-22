# GUÍA DE LABORATORIO: Infraestructura de Red, Servicios DHCP y Análisis de Tráfico
* **Entorno:**  Ubuntu Server (CLI) y Windows (GUI) sobre VMware Workstation.
* **Topología:**  Segmento de Red `10.160.10.0/24`.
* **Objetivo:**  Configurar correctamente un servicio de red y un servidor DHCP.


## FASE 1: Preparación del Entorno Virtual (Capa Física Virtualizada)
Antes de interactuar con el sistema operativo, el administrador debe asegurar el dominio de colisión y difusión a nivel de hipervisor.

**1. Configuración de aislamiento de red:**
*   Apague ambas Máquinas Virtuales (Ubuntu Server y Windows).
*   En las propiedades de red (Network Adapter) de **ambas** máquinas en VMware, cambie la conexión a **"LAN Segment"**.
*   Haga clic en el botón *LAN Segments*, cree uno nuevo llamado **"LAN1"** y asígnelo a ambas máquinas.
*   **Fundamento Técnico:** El aislamiento en un *LAN Segment* crea un switch virtual cerrado (aislamiento de Capa 2) que no tiene conexión con el adaptador físico del host.
*   >   **Pregunta de Análisis:** Si en lugar de usar "LAN Segment (LAN1)", configuráramos estas máquinas en modo "Bridged" (Puente) conectándolas a la red física, ¿qué impacto catastrófico tendría encender nuestro propio servidor DHCP en esa red de producción?



## FASE 2: Nivel Básico - Exploración del Servidor Linux
Identificación del hardware lógico asignado por el Kernel.

**2. Identificar la nomenclatura de la interfaz:**
*   **Comando:** `ip link show`
*   **Fundamento Técnico:** Muestra la Capa 2 (Enlace). Permite identificar la dirección MAC y el nombre lógico asignado por el sistema `systemd/udev` (ej. `ens33`).
*   >   **Pregunta de Análisis Crítico 2:** ¿Por qué los sistemas operativos modernos como Linux abstraen las tarjetas de red con nombres lógicos (como `ens33`) en lugar de permitir que las aplicaciones se comuniquen directamente con las direcciones físicas (MAC) del hardware?

**3. Verificar asignaciones previas:**
*   **Comando:** `ip address show`
*   **Fundamento Técnico:** Audita la Capa 3 (Red) para confirmar si la interfaz retiene configuraciones que deban ser sobrescritas antes de la intervención.
*   >   **Pregunta de Análisis Crítico 3:** Si al ejecutar este comando nota que la interfaz tiene un estado operativo 'UP' a nivel de Capa 2, pero NO tiene ninguna dirección IP asignada en Capa 3, ¿qué tipo de tráfico o protocolos de red aún pueden transitar por esa tarjeta?


## FASE 3: Nivel Intermedio - Direccionamiento Estático (Netplan)
Consolidación de la identidad del servidor en el segmento `10.160.10.0/24`.

**4. Edición del manifiesto de red:**
*   **Comando:** `sudo nano /etc/netplan/00-installer-config.yaml` *(el nombre puede variar)*.
*   **Configuración:**
    ```yaml
    network:
      version: 2
      ethernets:
        ens33:                # Verifique si su interfaz se llama así
          dhcp4: no           
          addresses:
            - 10.160.10.10/24 # IP estática del Servidor
    ```
*   **Comando:** `sudo netplan apply`
*   **Fundamento Técnico:** Netplan abstrae la configuración mediante YAML. Establecer una IP estática es mandatorio para los nodos que proveen servicios de infraestructura.
*   >   **Pregunta de Análisis Crítico 4:** Matemáticamente, si un servidor DHCP estuviera configurado para obtener su propia IP de manera dinámica, ¿cómo afectaría esto a la tabla de enrutamiento de los clientes y a la fiabilidad del proceso de renovación de concesiones (leases)?



## FASE 4: Nivel Avanzado - Despliegue del Servicio DHCP
Transformamos el servidor de un simple nodo a un proveedor de servicios de infraestructura para la red LAN1.

**5. Instalación del Demonio DHCP:**
*   **Comando:** `sudo apt update && sudo apt install isc-dhcp-server -y`
*   **Fundamento Técnico:** Descarga e integra el servicio `dhcpd` en el árbol de procesos del sistema.
*   >   **Pregunta de Análisis Crítico 5:** ¿Por qué es una mala práctica de administración instalar un paquete como `isc-dhcp-server` sin ejecutar previamente una sincronización de repositorios (`apt update`) en un entorno de producción?

**6. Declaración de Autoridad y Ámbito (Scope):**
*   **Comando:** `sudo nano /etc/dhcp/dhcpd.conf`
*   **Configuración a agregar al final del archivo:**
    ```text
    authoritative;
    subnet 10.160.10.0 netmask 255.255.255.0 {
      range 10.160.10.100 10.160.10.150;
      option routers 10.160.10.1;
      default-lease-time 600;
      max-lease-time 7200;
    }
    ```
*   **Comando:** `sudo systemctl restart isc-dhcp-server`
*   **Fundamento Técnico:** El bloque `subnet` define matemáticamente el segmento permitido. La directiva `authoritative` declara que este servidor dictamina la "verdad" en esta red frente a peticiones inválidas.
*   >   **Pregunta de Análisis Crítico 6:** Si omitimos la palabra `authoritative;` y un cliente Windows recién conectado solicita una IP que usaba ayer en su casa (ej. `192.168.1.50`), ¿cómo reaccionaría nuestro servidor Linux de forma diferente a si la directiva estuviera activa?



## FASE 5: Análisis de Protocolos con Wireshark (El Proceso DORA)
Validación empírica de la negociación cliente-servidor desde la máquina Windows.

**7. Preparación de la captura en Windows:**
*   Inicie la máquina virtual Windows. (Asegúrese de que su adaptador virtual también esté en el **LAN Segment: LAN1**).
*   Abra **Wireshark** e inicie la captura en la tarjeta Ethernet.
*   En la barra de filtros, escriba `dhcp` (o `bootp`) y presione Enter.
*   **Fundamento Técnico:** La aplicación de filtros de visualización aísla los datagramas UDP en los puertos 67 y 68, ocultando el ruido de fondo (ARP, NetBIOS).
*   >   **Pregunta de Análisis Crítico 7:** Considerando la naturaleza del proceso DHCP inicial, ¿por qué los ingenieros que diseñaron el protocolo eligieron UDP (orientado a no conexión) en lugar de TCP (orientado a conexión) para la asignación de direcciones?

**8. Identificación del momento de negociación (Análisis DORA en Wireshark):**
*   En el CMD de Windows ejecute: `ipconfig /release` seguido de `ipconfig /renew`.
*   Observe en Wireshark el intercambio de 4 paquetes:
    1.  **DHCP Discover:** Origen `0.0.0.0` hacia `255.255.255.255`.
    2.  **DHCP Offer:** Origen `10.160.10.10` hacia el cliente ofreciendo (ej. `10.160.10.100`).
    3.  **DHCP Request:** El cliente responde hacia `255.255.255.255`.
    4.  **DHCP ACK:** Origen `10.160.10.10` confirma la asignación.
*   **Fundamento Técnico:** El proceso DORA evidencia cómo un nodo sin identidad en Capa 3 logra obtener parámetros de red comunicándose primero a nivel de difusión (Broadcast).
*   >   **Pregunta de Análisis Crítico 8:** En el paso 3 (DHCP Request), si el cliente ya recibió una oferta directa del servidor con una IP específica, ¿por qué vuelve a enviar la solicitud a la dirección de Broadcast (`255.255.255.255`) en lugar de enviarla directamente por Unicast a la IP del servidor `10.160.10.10`? ¿Qué problema arquitectónico resuelve esto si hubieran dos servidores DHCP en la red "LAN1"?



## RETO FINAL DE INTEGRACIÓN (Evaluación Práctica)
*Demuestre su dominio de la herramienta respondiendo con base en la captura de Wireshark:*

1.  Haga clic en el paquete **DHCP Offer** en Wireshark. Despliegue la capa *Dynamic Host Configuration Protocol* en el panel inferior.
2.  Navegue por las opciones (*Options*). Identifique e indique el código hexadecimal exacto de la opción donde viaja el parámetro `option routers 10.160.10.1` que usted configuró.
3.  **Prueba de modificación:** Vuelva al servidor Linux, cambie el `default-lease-time` a 120 segundos. Reinicie el servicio (`systemctl restart`), ejecute un `renew` en Windows y demuestre en Wireshark capturando la pantalla de la opción específica donde el servidor le informa a Windows su nuevo tiempo de caducidad.
