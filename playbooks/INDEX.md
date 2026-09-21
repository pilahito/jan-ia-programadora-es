# Playbooks — léelos según la tarea

Ruta: `workspace/playbooks/` (dentro de la carpeta de datos de Jan).

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
| SSH / servidor remoto | `ssh.md` | clave, no contraseña en el chat |
| Linux, Windows, Docker, Git, red | `sistemas.md` | primero leer, luego cambiar |
| Entender cualquier tema (agente) | `conocimiento.md` | herramientas de verdad |

Regla: un stack por proyecto. Si piden SSH o “el servidor”, usa `ssh.md` y las herramientas SSH.
