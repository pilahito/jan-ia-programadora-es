# Android nativo (Windows)

**Stack:** Kotlin 2, Jetpack Compose, Material 3, Gradle Kotlin DSL, minSdk 26, target/compileSdk 35, Java 17.

**Estructura mínima**
```
app/src/main/java/<paquete>/
  MainActivity.kt          // setContent { App() }
  ui/theme/                // Color, Type, Theme
  ui/<pantalla>/           // Screen + ViewModel
  data/                    // repository, api, db
AndroidManifest.xml
app/build.gradle.kts
```

**Arquitectura:** UI (Compose) → ViewModel (StateFlow) → Repository → DataSource (Room / Retrofit o Ktor). Un ViewModel por pantalla con estado.

**UI**
- `Scaffold` + `TopAppBar` + `NavigationBar` si hay 2+ destinos.
- `Navigation Compose` con rutas tipadas.
- Tamaños táctiles ≥ 48.dp. IME padding. Predice el botón Atrás.
- Dark theme con `isSystemInDarkTheme()`.
- Strings en `res/values/strings.xml` (nada hardcodeado de UI).

**Permisos:** decláralos en el Manifest y pidelos en runtime. Cámara, ubicación y notificaciones no se dan por hecho.

**Red:** timeouts, `Result`/`sealed`, mensaje de error en UI, no crashes por JSON raro.

**No hagas:** Activities XML, AsyncTask, `GlobalScope`, secretos en el repo, `targetSdk` viejo.

**Probar:** `.\gradlew.bat assembleDebug` y `.\gradlew.bat test`. Emulador o `adb install`.
