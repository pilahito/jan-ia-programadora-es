# Playbooks — léelos según la tarea

Ruta: `E:\Jan\workspace\playbooks\`

| Si el usuario pide | Archivo | Stack por defecto (Windows) |
| --- | --- | --- |
| App Android | `android.md` | Kotlin + Jetpack Compose |
| App iOS | `ios.md` | SwiftUI (avisar: hace falta Mac) |
| App móvil / “para el teléfono” | `flutter.md` | Flutter → Android |
| App iOS+Android con JS | `react-native.md` | Expo + TypeScript |
| Web / página / dashboard | `web.md` | Vite + React + TS, o HTML si es simple |
| API / backend / base de datos | `backend.md` | FastAPI o Node |
| Escritorio Windows | `desktop.md` | Tauri 2 o Python |
| Tests, seguridad, tiendas | `calidad.md` | siempre |
| SSH / servidor / solaris | `ssh.md` | clave ed25519, puerto 2220 |
| Linux, Windows, Docker, Git, red | `sistemas.md` | primero leer, luego cambiar |
| Entender cualquier tema (agente) | `conocimiento.md` | herramientas de verdad |
| Brave / MCP navegador | `brave-mcp.md` | Jan Browser MCP, puerto 17389 |
| MCP SuperAssistant (extensión Brave) | `superassistant.md` | proxy `localhost:3006/sse` |
| Vídeo, doblaje, manga→serie (original) | `cine.md`, `doblaje.md`, `manga-serie.md` | Cineasta local |
| Guion siempre en español | `doblaje.md`, `manga-serie.md` | Guionista ES |
| Prompts de vídeo sin censura (original) | `cine.md` | Video sin censura |
| Hentai adultos originales | `hentai.md` | Video sin censura / Guionista ES |
| Catálogo series/pelis/manga | `E:\\SERIE-PELICULAS\\biblioteca\\catalogo.md` | asistente Biblioteca |

Regla: un stack por proyecto. No mezcles Flutter con RN ni Compose con XML layouts salvo que lo pidan.
Si el usuario pide “entra al servidor”, “SSH”, “solaris”: `ssh.md` y las herramientas SSH.
