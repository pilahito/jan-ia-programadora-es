# Jan IA programadora (español)

Pack para [Jan](https://jan.ai): asistentes en **español** para programar en local (web, **apps móviles**, escritorio, APIs), **SSH a servidores**, sistemas y **traducir inglés → español**. Sin nube y sin modelos `.gguf` en el repo.

Pensado para RTX 3060 12 GB / 32 GB RAM; sirve en cualquier PC que ya ejecute Jan con GGUF.

## Qué incluye

| Asistente | Para qué |
| --- | --- |
| **Jan** | Agente general: entiende de todo, programa, SSH, explica, traduce |
| **Programadora local** | Full-stack: web, API, escritorio, Android, Flutter, Expo, iOS, deploy |
| **Apps móviles** | Kotlin/Compose, Flutter, Expo, SwiftUI (iOS se genera; se compila en Mac) |
| **Sistemas y SSH** | Linux, Windows, Docker, redes, Git; entra al servidor con MCP SSH |
| **Traductora EN→ES** | Docs, UI, `strings.xml`, ARB, fichas de tienda. No toca el código |
| **Biblioteca** | Catálogo de tu carpeta de series/pelis/manga: qué hay y qué se puede crear |
| **Cineasta** | Vídeo de ficción original en español: guion, planos, doblaje y montaje |
| **Guionista** | Guiones largos en español por capítulos: biblia, diálogos, doblaje |
| **Vídeo sin censura** | Producciones originales explícitas para adultos (18+) |

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

Reinicia Jan. Aparecen los nueve asistentes. El instalador copia también `workspace/playbooks/`.

SSH: en `mcp_config.json` deja `SSH_SERVICES` en `$config` si tus hosts están en `~/.ssh/config` (User + IdentityFile). No subas claves al repo.

## Configuración (12 GB VRAM)

Ajustes → llama.cpp: CUDA, `CUDA0`, Flash Attention on, Fit on, 1 modelo cargado, n-gpu-layers 99, KV `q8_0`.

Contexto: 16k (7B), 32k (4B), **8k** (14B). No uses 50k–100k en una 3060.

### Qué modelo

| Objetivo | Modelo |
| --- | --- |
| Entender de todo + SSH (recomendado) | Qwen3-14B Q4_K_M (8k) |
| Escribir mucho código / apps | Qwen2.5-Coder 7B Instruct Q4_K_M |
| Ir rápido | Jan-code 4B Q4 |

## Uso

**App de móvil:** asistente *Apps móviles* + Coder 7B. Di “app Flutter de notas”. En Windows el default es Flutter→Android.

**SSH / servidor:** *Sistemas y SSH* o *Jan* + Qwen3-14B. “Entra a solaris y dime el disco”.

**Web o API:** *Programadora local*.

**Traducir UI:** *Traductora EN→ES* (sirve `strings.xml` y listados de Play Store).

**MCP:** copia `mcp/mcp_config.example.json` a tu `mcp_config.json` y pon la ruta de tu repo.

## Qué no va aquí

`.gguf`, chats, claves, binarios de CUDA. Licencia MIT; los modelos tienen la suya en Hugging Face.

## Si algo falla

¿El modelo no carga, "Generation failed", el router de llama.cpp caído o la GPU
invisible? Guía paso a paso: [docs/reparar-llamacpp.md](docs/reparar-llamacpp.md).
Comprobación automática: `.\tools\reparar-llamacpp.ps1 -DryRun`.

## Contribuir

[CONTRIBUTING.md](CONTRIBUTING.md).
