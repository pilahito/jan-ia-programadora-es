# Jan IA programadora (español)

Pack para [Jan](https://jan.ai): asistentes en **español**, listos para programar en local y **traducir inglés → español**. Sin nube, sin telemetría extra, sin modelos binarios en el repo.

Pensado para una RTX 3060 12 GB / 32 GB RAM, pero sirve en cualquier PC que ya ejecute Jan con GGUF.

## Qué incluye

| Asistente | Para qué |
| --- | --- |
| **Jan** | Día a día: código + explicación en español + traducción cuando se pida |
| **Programadora local** | Ingeniería: diffs, depuración, PRs. Temperatura 0.2 |
| **Traductora EN→ES** | Pegas inglés (docs, UI, README) y sale español natural, sin tocar el código |

También:

- Preset llama.cpp para GPU 12 GB (`presets/rtx3060-12gb.ini`)
- MCP de ejemplo: archivos + fetch + pensamiento secuencial
- Instalador para Windows y Unix

## Requisitos

- [Jan Desktop](https://jan.ai/download) 0.6+ (probado en 0.8)
- Un modelo **GGUF** de código (ver [docs/modelos.md](docs/modelos.md))
- NVIDIA: backend **CUDA** en Ajustes → llama.cpp
- Node.js (para MCP `npx`) si quieres herramientas de archivos

## Instalación

```powershell
git clone https://github.com/pilahito/jan-ia-programadora-es.git
cd jan-ia-programadora-es
.\install.ps1
```

Si tu carpeta de datos no es la de por defecto:

```powershell
.\install.ps1 -JanData "E:\Jan"
```

Linux / macOS:

```bash
chmod +x install.sh
./install.sh "$HOME/.local/share/Jan/data"
```

Reinicia Jan. En el selector de asistentes aparecen los tres.

## Configuración óptima (12 GB VRAM)

En Jan → **Ajustes → llama.cpp**:

- Backend: `win-cuda-13-common_cpus-x64` (o el CUDA que te recomiende Jan)
- Devices: `CUDA0`
- Flash Attention: on
- Fit: on
- Max models loaded: 1
- n-gpu-layers: 99
- KV cache K/V: `q8_0`
- Context: 16k en 7B, 32k en 4B, **8k** en 14B

No uses contextos de 50k–100k en una 3060: el modelo carga y luego se queda sin VRAM al generar.

### Qué modelo elegir

1. **Código rápido:** Jan-code 4B Q4  
2. **Mejor código:** Qwen2.5-Coder 7B Instruct Q4_K_M  
3. **Más calidad / traducción larga:** Qwen3 14B Q4_K_M con 8k de contexto  

Detalles y enlaces: [docs/modelos.md](docs/modelos.md).

## Uso

**Programar**

1. Asistente: *Programadora local*  
2. Modelo: Qwen2.5-Coder 7B o Jan-code 4B  
3. Pega el error o el archivo. Pide el cambio concreto.

**Traducir inglés → español**

1. Asistente: *Traductora EN→ES*  
2. Pega el texto. No hace falta decir «traduce» (el sistema ya asume EN→ES).  
3. Conserva fences, identificadores y markdown.

**MCP de archivos**

Copia `mcp/mcp_config.example.json` sobre `mcp_config.json` de tu carpeta Jan y cambia las rutas a tu workspace. Luego Ajustes → MCP.

## Qué no va en este repo

- Archivos `.gguf` (descárgalos tú)
- Conversaciones, logs, claves API
- Binarios de CUDA / llama.cpp (los gestiona Jan)

## Licencia

MIT. Los modelos GGUF tienen su propia licencia en Hugging Face.

## Contribuir

Ver [CONTRIBUTING.md](CONTRIBUTING.md). Issues y PRs en español o inglés.
