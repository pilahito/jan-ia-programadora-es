# Backend y datos

**Por defecto:** FastAPI (Python) o Express/Hono (Node) según el lenguaje del usuario.

**API**
- REST JSON, códigos HTTP correctos.
- Pydantic / Zod en la frontera.
- CORS explícito, no `*`.
- Auth: Bearer JWT o sesión; documenta cómo obtener el token. Nunca hardcodees secretos.

**Datos:** SQLite para local; PostgreSQL si lo piden. Migraciones. N+1 consciente.

**Archivos:** `.env.example` sin secretos reales. README con `uvicorn` / `npm run dev` y 3 curls de prueba.

**Probar:** un test del endpoint feliz y uno 400/401.
