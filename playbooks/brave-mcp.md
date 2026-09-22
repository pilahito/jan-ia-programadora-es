# Brave (tu navegador) + Jan

Jan controla **Brave**, no Chrome. Ya tienes la extensión **Jan Browser MCP** instalada.

## Uso

1. Abre Jan (MCP **Jan Browser MCP** en verde, puerto **17389**).
2. En Brave, icono **Jan Browser MCP** → **Connect**.
3. Opcional: “Set current tab” para usar la pestaña que tienes abierta.
4. En el chat: «abre esta URL en Brave», «haz clic en…», «captura la página».

Atajo: `E:\Jan\abrir-brave-mcp.ps1`

## Qué no uses

- `browsermcp` (puerto 9009): es otra extensión que **no** tienes en Brave. Está apagado a propósito.
- Brave Search API: eso es buscar en internet, no manejar el navegador.

Si Connect falla: Jan tiene que estar abierto primero (el puente `ws://127.0.0.1:17389`).
