# Jan IA programadora (español)

Pack para [Jan](https://jan.ai): asistentes en **español** para programar en local (web, **apps móviles**, escritorio, APIs) y **traducir inglés → español**. Sin nube y sin modelos `.gguf` en el repo.

Pensado para RTX 3060 12 GB / 32 GB RAM; sirve en cualquier PC que ya ejecute Jan con GGUF.

## Qué incluye

| Asistente | Para qué |
| --- | --- |
| **Jan** | General: entiende pedidos vagos, programa, explica, traduce |
| **Programadora local** | Full-stack: web, API, escritorio, Android, Flutter, Expo, iOS |
| **Apps móviles** | Kotlin/Compose, Flutter, Expo, SwiftUI (iOS se genera; se compila en Mac) |
| **Traductora EN→ES** | Docs, UI, `strings.xml`, ARB, fichas de tienda. No toca el código |

Playbooks en `playbooks/` (Android, Flutter, iOS, RN, web, backend, escritorio, calidad): recetas cortas que las IAs deben leer al crear un proyecto.

También: preset llama.cpp 12 GB, MCP de ejemplo, instalador Windows/Unix.

## Requisitos

- [Jan Desktop](https://jan.ai/download) 0.6+ (probado en 0.8)
- Un modelo **GGUF** de código — [docs/modelos.md](docs/modelos.md)
- NVIDIA: backend **CUDA**
- Node.js si quieres MCP de archivos
- Para **ver** una app Android: Android Studio / emulador, o Flutter. iOS nativo exige Mac.

## Instalación

```powershell
git clone https://github.com/pilahito/jan-ia-programadora-es.git
cd jan-ia-programadora-es
.\install.ps1
```

Carpeta de datos distinta:

```powershell
.\install.ps1 -JanData "E:\Jan"
```

Linux / macOS:

```bash
chmod +x install.sh
./install.sh "$HOME/.local/share/Jan/data"
```

Reinicia Jan. Aparecen los cuatro asistentes. El instalador copia también `workspace/playbooks/`.

## Configuración (12 GB VRAM)

Ajustes → llama.cpp: CUDA, `CUDA0`, Flash Attention on, Fit on, 1 modelo cargado, n-gpu-layers 99, KV `q8_0`.

Contexto: 16k (7B), 32k (4B), **8k** (14B). No uses 50k–100k en una 3060.

### Qué modelo

| Objetivo | Modelo |
| --- | --- |
| Escribir apps (recomendado) | Qwen2.5-Coder 7B Instruct Q4_K_M |
| Entender más / arquitectura | Qwen3-14B Q4_K_M (8k) |
| Ir rápido | Jan-code 4B Q4 |

## Uso

**App de móvil:** asistente *Apps móviles* + Qwen2.5-Coder 7B. Di “app Flutter de notas” o “Android Kotlin con login”. En Windows el default es Flutter→Android.

**Web o API:** *Programadora local*.

**Traducir UI:** *Traductora EN→ES* (sirve `strings.xml` y listados de Play Store).

**MCP:** copia `mcp/mcp_config.example.json` a tu `mcp_config.json` y pon la ruta de tu repo.

## Qué no va aquí

`.gguf`, chats, claves, binarios de CUDA. Licencia MIT; los modelos tienen la suya en Hugging Face.

## Contribuir

[CONTRIBUTING.md](CONTRIBUTING.md).
