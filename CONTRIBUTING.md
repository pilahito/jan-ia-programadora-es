# Contribuir

Este pack es para [Jan](https://jan.ai): asistentes, presets y MCP de ejemplo. **No** subas modelos GGUF ni claves.

## Cómo ayudar

- Mejorar instrucciones de `assistants/*/assistant.json` (español claro, sin relleno).
- Añadir un preset para otro GPU (8 GB, 16 GB, Apple Silicon) en `presets/`.
- Traducir el README a otro idioma **además** del español, no en su lugar.

## Formato de un asistente

Una carpeta por asistente, con `assistant.json`. El `id` debe coincidir con el nombre de la carpeta.

```
assistants/mi-asistente/assistant.json
```

Temperatura orientativa: código `0.2`, traducción `0.25`, general `0.3`.

## Pruebas mínimas

1. Instala con `install.ps1` o `install.sh`.
2. En Jan, elige el asistente.
3. Prueba:
   - «Escribe una función Python que reciba una lista y quite duplicados conservando el orden.»
   - «App Flutter de lista de tareas con dos pantallas.»
   - Pega un párrafo en inglés y pide «traduce».
4. Confirma que responde en español, no traduce identificadores, y que una app nueva cita el playbook del stack.
