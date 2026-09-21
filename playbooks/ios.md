# iOS nativo

**Aviso:** en Windows no se compila ni se sube a App Store. Genera el código y el plan; el build es en Mac + Xcode.

**Stack:** Swift 5.9+, SwiftUI, iOS 16+, MV (View + Observable ViewModel). Sin Storyboards.

**Estructura**
```
App.swift                 // @main
Features/<Nombre>View.swift
Features/<Nombre>ViewModel.swift
Services/                 // API, persistencia
Resources/Localizable.xcstrings
```

**UI:** `NavigationStack`, `List`, `safeArea`, Dynamic Type, Dark Mode. Permisos en `Info.plist` con texto real.

**Datos:** `URLSession` + `async/await` o un cliente fino. `@Observable` / `ObservableObject`. Keychain para tokens, no `UserDefaults`.

**Probar (Mac):** Cmd+R en simulador iPhone. Preview de SwiftUI para cada vista.
