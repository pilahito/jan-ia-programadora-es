# Une planos .mp4 en orden de nombre. Por defecto sale en 04-montaje si existe.
param(
  [Parameter(Mandatory = $true)][string]$Carpeta,
  [string]$Salida = ""
)
$ErrorActionPreference = "Stop"
$files = Get-ChildItem $Carpeta -Filter *.mp4 | Sort-Object Name
if ($files.Count -eq 0) { throw "No hay mp4 en $Carpeta" }
$list = Join-Path $Carpeta "concat.txt"
$files | ForEach-Object { "file '$($_.FullName.Replace('\','/'))'" } | Set-Content -Encoding ascii $list
if (-not $Salida) {
  $montaje = Join-Path (Split-Path (Split-Path $Carpeta -Parent) -Parent) "04-montaje"
  if (Test-Path $montaje) {
    $Salida = Join-Path $montaje ("{0}.mp4" -f (Split-Path $Carpeta -Leaf))
  } else {
    $Salida = Join-Path $Carpeta "episodio.mp4"
  }
}
ffmpeg -y -f concat -safe 0 -i $list -c copy $Salida
Write-Host "OK $($files.Count) planos -> $Salida"
