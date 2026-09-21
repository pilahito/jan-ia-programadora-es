# Flutter (app móvil en Windows → Android)

**Por qué:** un código para Android ahora e iOS cuando haya Mac. El usuario está en Windows.

**Stack:** Dart 3, Flutter 3.x, Material 3, null-safety. Estado: `flutter_riverpod` si hay 2+ pantallas; si no, `StatefulWidget`.

**Arranque**
```
flutter create --org es.local --project-name nombre_app nombre_app
flutter run
```

**Estructura**
```
lib/
  main.dart
  app.dart              // MaterialApp.router o routes
  features/<feat>/      // pantalla + provider + repo
  shared/               // theme, widgets, api client
```

**UI:** `ThemeData` Material 3, `GoRouter` o `routes` simples, listas con `ListView.builder`, imágenes con tamaño y placeholder. Textos en `.arb` o un `l10n` mínimo si hay más de 8 strings.

**Plataforma:** `AndroidManifest` permisos. iOS `Info.plist` listo aunque no compiles aquí. No uses plugins que exijan Mac si el usuario solo tiene Windows.

**Calidad:** `flutter analyze` limpio. No ignores `const` y tipos. Maneja `snapshot.hasError`.

**Probar:** `flutter test` + `flutter run -d windows` si hay desktop, o `-d android`.
