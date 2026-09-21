#Requires -Version 5.1
<#
.SYNOPSIS
  Copia los asistentes de este pack a la carpeta de datos de Jan.
#>
param(
  [string]$JanData = ""
)

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

function Find-JanData {
  param([string]$Hint)
  if ($Hint -and (Test-Path (Join-Path $Hint "assistants"))) { return $Hint }
  $candidates = @(
    "E:\Jan",
    (Join-Path $env:APPDATA "Jan\data"),
    (Join-Path $env:APPDATA "jan\data")
  )
  foreach ($c in $candidates) {
    if (Test-Path (Join-Path $c "assistants")) { return $c }
  }
  return $null
}

$destRoot = Find-JanData -Hint $JanData
if (-not $destRoot) {
  Write-Host "No encuentro la carpeta de datos de Jan."
  Write-Host "Pásala así:  .\install.ps1 -JanData 'D:\ruta\a\Jan'"
  Write-Host "En Jan: Ajustes → General → carpeta de datos."
  exit 1
}

$src = Join-Path $here "assistants"
$dst = Join-Path $destRoot "assistants"
New-Item -ItemType Directory -Force -Path $dst | Out-Null

Get-ChildItem $src -Directory | ForEach-Object {
  $target = Join-Path $dst $_.Name
  if (Test-Path (Join-Path $target "assistant.json")) {
    Copy-Item (Join-Path $target "assistant.json") (Join-Path $target "assistant.json.bak") -Force
  }
  New-Item -ItemType Directory -Force -Path $target | Out-Null
  Copy-Item (Join-Path $_.FullName "assistant.json") (Join-Path $target "assistant.json") -Force
  Write-Host "Instalado: $($_.Name)"
}

Write-Host ""
Write-Host "Listo. Carpeta Jan: $destRoot"
Write-Host "Reinicia Jan y elige el asistente: Jan, Programadora local o Traductora EN→ES."
