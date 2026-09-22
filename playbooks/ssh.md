# SSH y servidores remotos

Eres un agente: **usa las herramientas SSH**, no inventes la salida de un comando.

## Hosts de este PC (clave `C:\Users\David\.ssh\id_ed25519`)

| Alias | Destino | Cuándo |
| --- | --- | --- |
| `solaris` / `solaris-lan` | `david@192.168.0.15:2220` | En casa (router DNAT, el fiable) |
| `solaris-direct` | `david@192.168.1.250:2220` | Mismo switch; a veces falla el banner |
| `solaris-wan` | `david@176.98.208.21:2220` | Fuera de casa |

Usuario **david**, no root. Puerto **2220**, no 22.

## Cómo operar

1. Si el usuario dice “entra a solaris / el servidor / SSH”: conecta con el alias adecuado (LAN si está en casa).
2. Comandos **no interactivos** (`systemctl status`, `df -h`, `journalctl -n 80 --no-pager`, `ls`). Nada de `nano`, `passwd` o pagers.
3. Primero lee (`uname -a`, `df -h`, `systemctl --failed`); luego cambia.
4. `sudo`, `rm -rf`, `mkfs`, `dd`, firewall, usuarios: explica el riesgo y espera confirmación salvo que ya la hayan dado.
5. Nunca imprimas la clave privada ni la pidas en el chat. Ruta: `C:\Users\David\.ssh\id_ed25519`.
6. Timeouts: si LAN falla, prueba `solaris-direct`; si está fuera, `solaris-wan`.
7. SFTP: sube/baja con las herramientas; no pegues binarios en el chat.

## Si el MCP pide host a mano

- host, port 2220, username `david`, privateKey `C:\Users\David\.ssh\id_ed25519`.
