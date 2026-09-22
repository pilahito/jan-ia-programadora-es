#Requires -Version 5.1
<#
.SYNOPSIS
  Repara los fallos tipicos de llama.cpp en Jan (Windows + NVIDIA/CUDA).

.DESCRIPTION
  Comprueba y, si procede, arregla:

   1) La GPU no aparece en llama.cpp (--list-devices sin CUDA0). Sintomas:
        - "invalid device: CUDA0"
        - "Model <id> failed to load" con exit_code 1
        - generacion a ~0.2 tok/s (esta tirando de CPU)
      Si no aparece, re-extrae el runtime CUDA del propio cuda13.tar.gz del
      backend (las DLLs truncadas son la causa habitual) y vuelve a comprobar.

   2) Puerto 17389 ocupado por un MCP huerfano (Jan cerrado). Sintoma:
        - "MCP server Jan Browser MCP failed to initialize: Port 17389 is in use"

   3) Modelos de router.preset.ini que apuntan a archivos que ya no existen.

.PARAMETER JanData
  Carpeta de datos de Jan. Por defecto E:\Jan o %APPDATA%\Jan\data.

.PARAMETER Version
  Version de llama.cpp instalada. Por defecto b9967.

.PARAMETER Backend
  Backend a revisar. Por defecto win-cuda-13-common_cpus-x64.

.PARAMETER DryRun
  Solo informa, no cambia nada.

.PARAMETER RestartJan
  Cierra y vuelve a abrir Jan al terminar (necesario para que relea la config).

.EXAMPLE
  .\tools\reparar-llamacpp.ps1 -DryRun
.EXAMPLE
  .\tools\reparar-llamacpp.ps1 -RestartJan
#>
param(
  [string]$JanData = "",
  [string]$Version = "b9967",
  [string]$Backend = "win-cuda-13-common_cpus-x64",
  [switch]$DryRun,
  [switch]$RestartJan
)

$ErrorActionPreference = "Continue"
$stamp = Get-Date -Format "yyyyMMddHHmmss"
$problemas = 0

function Say([string]$msg, [string]$color = "Gray") { Write-Host $msg -ForegroundColor $color }
function Ok([string]$msg)   { Say "  [OK]    $msg" "Green" }
function Warn([string]$msg) { $script:problemas++; Say "  [AVISO] $msg" "Yellow" }
function Info([string]$msg) { Say "  [info]  $msg" }

# ---------------------------------------------------------------- carpeta de Jan
if (-not $JanData) {
  foreach ($c in @("E:\Jan", (Join-Path $env:APPDATA "Jan\data"), (Join-Path $env:APPDATA "jan\data"))) {
    if ($c -and (Test-Path (Join-Path $c "llamacpp"))) { $JanData = $c; break }
  }
}
if (-not $JanData -or -not (Test-Path $JanData)) {
  Say "No encuentro la carpeta de datos de Jan. Usa -JanData 'D:\ruta\a\Jan'." "Red"
  exit 1
}
$bin    = Join-Path $JanData "llamacpp\backends\$Version\$Backend\build\bin"
$server = Join-Path $bin "llama-server.exe"

function Get-Devices {
  if (-not (Test-Path $server)) { return @() }
  $out = (& $server --list-devices 2>&1 | Out-String)
  return @(($out -split "`r?`n") | Where-Object { $_ -match ":\s" -and $_ -notmatch "Available devices" } | ForEach-Object { $_.Trim() })
}

Say ""
Say "Carpeta de Jan : $JanData"
Say "Backend        : $Version / $Backend"
Say ""

# ------------------------------------------------ 1) la GPU se ve desde llama.cpp?
Say "1) La GPU se ve desde llama.cpp" "White"
if (-not (Test-Path $server)) {
  Warn "No existe $server (revisa -Version / -Backend, o reinstala el motor en Jan)."
} else {
  $devices = Get-Devices
  if ($devices.Count -gt 0) {
    foreach ($d in $devices) { Ok $d }
  } else {
    Warn "llama.cpp no ve ninguna GPU: --list-devices viene vacio."
    Info "Intentando re-extraer el runtime CUDA del backend..."

    # ---------------------------------- 2) runtime CUDA del backend (DLLs truncadas)
    Say ""
    Say "1b) Runtime CUDA del backend" "White"
    $archives = @(Get-ChildItem $bin -Filter "cuda*.tar.gz" -ErrorAction SilentlyContinue)
    if ($archives.Count -eq 0) {
      Warn "No hay cuda*.tar.gz en el backend; no puedo reparar las DLLs solo."
      Info "En Jan: Ajustes > llama.cpp > Backend = win-vulkan-x64 (o CPU) y deja 'Devices for Offload' vacio."
    } else {
      foreach ($arc in $archives) {
        $tmp = Join-Path $env:TEMP ("jan-cuda-" + [guid]::NewGuid().ToString("N").Substring(0, 8))
        New-Item -ItemType Directory -Force -Path $tmp | Out-Null
        tar -xzf $arc.FullName -C $tmp 2>$null
        $dlls = @(Get-ChildItem $tmp -File -Filter "*.dll" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike "._*" })
        if ($dlls.Count -eq 0) { Warn "No pude extraer $($arc.Name) (archivo incompleto?)." }
        foreach ($d in $dlls) {
          $target = Join-Path $bin $d.Name
          if (-not (Test-Path $target)) {
            Warn "$($d.Name) no esta en el backend."
            if (-not $DryRun) { Copy-Item $d.FullName $target -Force; Ok "$($d.Name) copiada desde $($arc.Name)." }
            continue
          }
          $a = (Get-Item $d.FullName).Length
          $b = (Get-Item $target).Length
          $same = $false
          if ($a -eq $b) {
            $same = (Get-FileHash $d.FullName -Algorithm SHA256).Hash -eq (Get-FileHash $target -Algorithm SHA256).Hash
          }
          if ($same) { Ok "$($d.Name) intacta ($b bytes)." }
          elseif ($DryRun) { Warn "$($d.Name) mal: en disco $b bytes, en $($arc.Name) $a bytes." }
          else {
            Copy-Item $target "$target.bak-$stamp" -Force
            Copy-Item $d.FullName $target -Force
            Ok "$($d.Name) estaba mal ($b bytes, deberia ser $a): restaurada desde $($arc.Name) (backup .bak-$stamp)."
          }
        }
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
      }

      if (-not $DryRun) {
        $devices = Get-Devices
        if ($devices.Count -gt 0) {
          foreach ($d in $devices) { Ok "ahora si: $d" }
          Say "  Reinicia Jan (-RestartJan) para que use la GPU." "Green"
        } else {
          Warn "sigue sin ver la GPU. Comprueba el driver NVIDIA, o usa otro backend (win-vulkan-x64 / CPU)."
        }
      }
    }
  }
}

# ------------------------------------------------------------- 3) puerto 17389 libre
Say ""
Say "2) Puerto 17389 (Jan Browser MCP)" "White"
$conn = Get-NetTCPConnection -LocalPort 17389 -State Listen -ErrorAction SilentlyContinue
$janAbierto = [bool](Get-Process Jan -ErrorAction SilentlyContinue)
if (-not $conn) { Ok "libre." }
elseif ($janAbierto) {
  foreach ($c in $conn) { Info "ocupado por PID $($c.OwningProcess): Jan esta abierto, es su propio MCP (no lo toco)." }
}
else {
  foreach ($c in $conn) {
    $proc = Get-Process -Id $c.OwningProcess -ErrorAction SilentlyContinue
    $cmd = (Get-CimInstance Win32_Process -Filter "ProcessId=$($c.OwningProcess)" -ErrorAction SilentlyContinue).CommandLine
    $esMcp = $cmd -and ($cmd -match "search-mcp-server|mcp-server|mcp-ssh|server-filesystem|npx")
    Info "ocupado por PID $($c.OwningProcess) $($proc.ProcessName)"
    if (-not $esMcp) { Warn "No parece un MCP de Jan; no lo toco (cierra el programa a mano)."; continue }
    if ($DryRun) { Warn "Es un MCP huerfano; sin -DryRun lo cerraria." }
    else {
      Stop-Process -Id $c.OwningProcess -Force -ErrorAction SilentlyContinue
      Ok "proceso $($c.OwningProcess) cerrado; el puerto queda libre para Jan."
    }
  }
}

# ------------------------------------------------- 4) modelos con rutas inexistentes
Say ""
Say "3) Modelos del preset (rutas)" "White"
$preset = Join-Path $JanData "llamacpp\router.preset.ini"
if (-not (Test-Path $preset)) { Info "No hay router.preset.ini todavia." }
else {
  $modelo = ""
  $faltan = 0
  foreach ($line in Get-Content $preset) {
    if ($line -match "^\s*\[(.+)\]\s*$") { $modelo = $Matches[1]; continue }
    if ($line -match "^\s*model\s*=\s*(.+?)\s*$") {
      $ruta = $Matches[1] -replace '^\\\\\?\\', ''
      if (-not (Test-Path -LiteralPath $ruta)) { $faltan++; Warn "[$modelo] falta el archivo: $ruta" }
    }
  }
  if ($faltan -eq 0) { Ok "todas las rutas existen." }
  else { Info "Quita esos modelos en Jan (Ajustes > Modelos) o reimporta el .gguf." }
}

# ------------------------------------------------------------------- 5) reiniciar Jan
if ($RestartJan) {
  Say ""
  Say "4) Reiniciando Jan" "White"
  Get-Process Jan -ErrorAction SilentlyContinue | ForEach-Object { $_.CloseMainWindow() | Out-Null }
  Start-Sleep -Seconds 6
  Get-Process Jan,llama-server -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 2
  $exe = Join-Path $env:LOCALAPPDATA "Programs\Jan\Jan.exe"
  if (Test-Path $exe) { Start-Process $exe; Ok "Jan abierto de nuevo." }
  else { Warn "No encuentro Jan.exe en $exe; abrelo a mano." }
}

Say ""
if ($problemas -eq 0) { Say "Todo correcto." "Green" } else { Say "$problemas aviso(s). Revisa las lineas [AVISO]." "Yellow" }
