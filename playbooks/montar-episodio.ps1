# Une planos .mp4 de una carpeta en orden de nombre (ep01_sc01_001.mp4 ...).
param(
  [Parameter(Mandatory = $true)][string]$Carpeta,
  [string]$Salida = "episodio.mp4"
)
$ErrorActionPreference = "Stop"
$files = Get-ChildItem $Carpeta -Filter *.mp4 | Sort-Object Name
if ($files.Count -eq 0) { throw "No hay mp4 en $Carpeta" }
$list = Join-Path $Carpeta "concat.txt"
$files | ForEach-Object { "file '$($_.FullName.Replace('\','/'))'" } | Set-Content -Encoding ascii $list
$out = Join-Path $Carpeta $Salida
ffmpeg -y -f concat -safe 0 -i $list -c copy $out
Write-Host "OK $($files.Count) planos -> $out"
