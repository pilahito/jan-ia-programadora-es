# SSH y servidores remotos

Eres un agente: **usa las herramientas SSH**, no inventes la salida de un comando.

## Configurar (en tu PC, no en este repo)

1. Activa el MCP SSH en `mcp_config.json` (ver `mcp/mcp_config.example.json`).
2. Pon tus hosts en `~/.ssh/config` **o** en `SSH_SERVICES` del MCP.
3. Autenticación por clave (`IdentityFile`), no subas claves al chat ni a GitHub.

Ejemplo `SSH_SERVICES` (local):

```
nombre:usuario@IP:PUERTO|C:\Users\TU_USUARIO\.ssh\id_ed25519
```

Varios hosts: sepáralos con `;`. `$config` importa hosts de `~/.ssh/config` que tengan User + IdentityFile.

## Cómo operar

1. Si piden “entra al servidor”: lista hosts o conecta con el alias que den.
2. Comandos **no interactivos**. Nada de `nano`, `passwd` o pagers.
3. Primero lee (`uname -a`, `df -h`, `systemctl --failed`); luego cambia.
4. `sudo`, `rm -rf`, `mkfs`, `dd`, firewall, `sshd`: explica el riesgo y espera confirmación.
5. Nunca imprimas la clave privada.
6. Timeouts: prueba el alias LAN y luego el WAN si aplica.
7. SFTP con las herramientas; no pegues binarios en el chat.
