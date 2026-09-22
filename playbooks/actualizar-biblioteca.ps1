# Recorre E:\SERIE-PELICULAS y escribe biblioteca\catalogo.json + catalogo.md
$ErrorActionPreference = "Stop"
$root = "E:\SERIE-PELICULAS"
$outDir = Join-Path $root "biblioteca"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

function Get-Ficha($dir, $tipo) {
  $readme = Get-ChildItem $dir -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^(README|NO-CREAR|ficha)\.(md|txt)$' } |
    Select-Object -First 1
  $resumen = ""
  if ($readme) {
    $resumen = ((Get-Content $readme.FullName -TotalCount 8) -join " ").Trim()
    if ($resumen.Length -gt 280) { $resumen = $resumen.Substring(0, 280) }
  }
  $nMp4 = @(Get-ChildItem $dir -Recurse -Filter *.mp4 -ErrorAction SilentlyContinue).Count
  [pscustomobject]@{
    id     = $dir.Name
    titulo = $dir.Name
    tipo   = $tipo
    ruta   = $dir.FullName
    puede_crear = ($tipo -ne "no-crear")
    mp4    = $nMp4
    nota   = $resumen
  }
}

$items = @()
foreach ($sub in @("series", "peliculas", "hentai", "_entrada-manga", "_no-crear")) {
  $tipo = switch ($sub) {
    "series" { "serie" }
    "peliculas" { "pelicula" }
    "hentai" { "hentai" }
    "_entrada-manga" { "manga-propio" }
    "_no-crear" { "no-crear" }
  }
  $base = Join-Path $root $sub
  if (-not (Test-Path $base)) { continue }
  Get-ChildItem $base -Directory | ForEach-Object { $items += Get-Ficha $_ $tipo }
}

$catalog = [pscustomobject]@{
  actualizado = (Get-Date).ToString("s")
  raiz        = $root
  total       = $items.Count
  items       = $items
}
$jsonPath = Join-Path $outDir "catalogo.json"
$mdPath = Join-Path $outDir "catalogo.md"
$catalog | ConvertTo-Json -Depth 6 | Set-Content $jsonPath -Encoding utf8

$md = @("# Biblioteca", "", "Actualizado: $($catalog.actualizado)", "", "| Titulo | Tipo | Crear | mp4 | Ruta |", "| --- | --- | --- | --- | --- |")
foreach ($i in $items) {
  $ok = if ($i.puede_crear) { "si" } else { "NO" }
  $ruta = [string]$i.ruta
  $md += "| $($i.titulo) | $($i.tipo) | $ok | $($i.mp4) | $ruta |"
}
if ($items.Count -eq 0) { $md += "| (vacia) | | | | |" }
$md -join "`n" | Set-Content $mdPath -Encoding utf8
Write-Host "OK $($items.Count) fichas -> $mdPath"
