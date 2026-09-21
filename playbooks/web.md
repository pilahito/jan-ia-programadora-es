# Web

**Simple (landing, ejercicio):** HTML + CSS + JS vanilla, un solo `index.html` si cabe. Responsive (móvil primero).

**App web:** Vite + React + TypeScript. No Next.js salvo que pidan SSR/SEO.

```
npm create vite@latest nombre -- --template react-ts
```

**UI:** semántica, contraste, teclado, `label` en formularios. CSS modules o un archivo `styles.css`. No Tailwind salvo que lo pidan.

**Estado:** React state; un store solo si hay estado global de verdad.

**API:** `fetch` con manejo de error. Tipos en `src/types.ts`.

**Probar:** `npm run dev`. Lighthouse no es obligatorio; sí que no rompa en 360px de ancho.
