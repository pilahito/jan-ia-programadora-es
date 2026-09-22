# Reparar llama.cpp en Jan (Windows + NVIDIA)

Guía de los fallos reales que hemos visto con Jan 0.8.4 + backend CUDA
(`win-cuda-13-common_cpus-x64`, motor `b9967`) y cómo se arreglan.

Script automático: [`tools/reparar-llamacpp.ps1`](../tools/reparar-llamacpp.ps1)

```powershell
# solo informa
.\tools\reparar-llamacpp.ps1 -DryRun
# arregla y reinicia Jan
.\tools\reparar-llamacpp.ps1 -RestartJan
```

---

## 1. "Generation failed / Failed to query /models" y el router muerto

Mensaje típico en Jan:

```
Failed to create model: Failed to start model: Failed to query /models:
error sending request for url (http://127.0.0.1:60621/models)
```

Ese puerto es el **router interno** de llama.cpp que Jan arranca al abrir la app
(`llama-server --models-preset ... --port <aleatorio>`). Si el router ya no
escucha, todo lo que dependa de él falla: crear modelo, generar, listar modelos.

Comprobación (el puerto lo ves en `logs\app.log`, línea `Router started on port`):

```powershell
Invoke-WebRequest http://127.0.0.1:<puerto>/models -UseBasicParsing   # debe dar 200
```

Si da error de conexión: cierra Jan del todo, mata los `llama-server.exe`
huérfanos y vuelve a abrir Jan (Jan crea un router nuevo con otro puerto).

```powershell
Get-Process llama-server -ErrorAction SilentlyContinue | Stop-Process -Force
```

Nota: en modo router, las rutas de escritura (`POST /v1/chat/completions`,
`/models/load`) exigen la API key interna de Jan; `GET /models` y `/health`
son libres. Un `401 Invalid API Key` en el log al arrancar es normal
(sondea sin clave) y no rompe nada.

## 2. "Model X failed to load" con `exit_code=1` (el caso más común)

En `llama.cpp` el hijo del modelo muere al arrancar y Jan solo dice
`exit_code=1`. Casi siempre es **una de estas dos**:

### 2a. `--device CUDA0` inválido porque el runtime CUDA está roto

Si el backend CUDA no puede cargar sus DLLs, llama.cpp arranca **sin ninguna
GPU** y entonces:

```powershell
# esto es la prueba: debe listar CUDA0
E:\Jan\llamacpp\backends\b9967\win-cuda-13-common_cpus-x64\build\bin\llama-server.exe --list-devices
# Available devices:            <-- vacío = roto
```

Con la lista vacía, cualquier `--device CUDA0` (el que recomienda este repo)
falla con:

```
error while handling argument "--device": invalid device: CUDA0
```

→ `exit_code=1` → "Model ... failed to load".

**Causa real encontrada:** las DLLs de CUDA del backend estaban
**truncadas** (descarga/extracción interrumpida). Ejemplo: `cublasLt64_13.dll`
con 376.455.920 bytes en disco frente a 480.401.520 bytes dentro del propio
`cuda13.tar.gz` del backend. Con una DLL a medias, `LoadLibrary` falla y no hay
GPU.

**Arreglo** (lo hace el script): re-extraer el runtime desde el `cuda13.tar.gz`
que ya viene con el backend y sustituir las DLLs mal, guardando copia `.bak`:

```powershell
$bin = "E:\Jan\llamacpp\backends\b9967\win-cuda-13-common_cpus-x64\build\bin"
$tmp = "$env:TEMP\cuda13"
tar -xzf "$bin\cuda13.tar.gz" -C $tmp
Copy-Item "$tmp\*.dll" $bin -Force      # sobrescribe las que estén mal
& "$bin\llama-server.exe" --list-devices   # ahora: CUDA0: NVIDIA GeForce RTX 3060
```

Si no quieres tocar DLLs: en Jan, **Ajustes → llama.cpp → Backend**, cambia a
`win-vulkan-x64` (o CPU) y deja **Devices for Offload** vacío. Pierdes algo de
velocidad, pero deja de fallar.

### 2b. Sin VRAM suficiente

Con el "Fit" activado, llama.cpp reparte el modelo y el contexto en la VRAM
libre. Si otro programa (juego, navegador, wallpaper animado, Discord) está
usando la GPU, el hijo puede no arrancar o quedarse a 0,2 tok/s.

- Cierra lo que consuma VRAM antes de usar el modelo.
- Baja el contexto del modelo (Ajustes → Modelos → Contexto): 8k para 14B,
  16k para 7-9B, 32k para 4B.
- En una 12 GB, `Max Concurrently Loaded Models = 1` y un solo modelo a la vez.

Referencia sana: un 8B Q4 en una RTX 3060 12 GB genera **~35 tok/s** con todo
en GPU. Si ves 0,2 tok/s, no está usando la GPU: vuelve al punto 2a.

## 3. "MCP server Jan Browser MCP failed to initialize: Port 17389 is in use"

El MCP `search-mcp-server` (bridge del navegador) usa el puerto **17389**. Si
Jan se cierra de golpe, ese proceso queda huérfano y bloquea el puerto para la
siguiente sesión.

```powershell
Get-NetTCPConnection -LocalPort 17389 -State Listen |
  ForEach-Object { Stop-Process -Id $_.OwningProcess -Force }
```

Resultado esperado en el log: `MCP server initialization complete: 7 successful, 0 failed`.

## 4. Modelos que apuntan a rutas que ya no existen

Cuando mueves o renombras `.gguf` importados (por ejemplo en `G:\IA\modelos`),
Jan conserva la ruta vieja en `llamacpp\models\<id>\model.yml` y en el log sale:

```
Failed to check tool support for model llama3.gguf: Failed to open local file ...
```

Arreglo: reimporta el archivo desde Jan o borra el modelo en Ajustes → Modelos.
Puedes ver las rutas de golpe:

```powershell
(Get-Content E:\Jan\llamacpp\router.preset.ini) -match '^model\s*='
```

## 5. Dónde mirar siempre

| Archivo | Qué contiene |
| --- | --- |
| `E:\Jan\logs\app.log` | Arranque del router, puerto, errores del plugin |
| `E:\Jan\llamacpp\router.preset.ini` | Preset generado por Jan (modelos y args) |
| `E:\Jan\llamacpp\settings.json` | Ajustes de llama.cpp (fit, device, KV, threads) |
| `E:\Jan\llamacpp\models\<id>\model.yml` | Ruta, contexto y nombre de cada modelo |

Orden de diagnóstico rápido: **router escucha → la GPU se ve → el modelo carga →
genera a velocidad de GPU**.
