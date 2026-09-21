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

Regla: un stack por proyecto. No mezcles Flutter con RN ni Compose con XML layouts salvo que lo pidan.
