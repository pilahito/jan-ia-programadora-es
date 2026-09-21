# React Native — Expo (TypeScript)

**Cuándo:** el usuario quiere JS/TS y Android+iOS. En Windows: Expo Go / emulador Android.

**Stack:** Expo SDK reciente, TypeScript, React Navigation, StyleSheet o NativeWind si lo piden.

**Arranque**
```
npx create-expo-app@latest nombre -t expo-template-blank-typescript
npx expo start
```

**Estructura**
```
app/ o src/screens/
src/components/
src/lib/api.ts
```

**Reglas:** nada de `react-native init` bare salvo que lo pidan. Permisos en `app.json`. Imágenes con tamaño. Listas virtualizadas. Errores de red en UI.

**Probar:** Android emulator o Expo Go. iOS físico/simulador solo con Mac.
