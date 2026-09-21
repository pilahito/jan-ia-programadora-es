#Requires -Version 5.1
<#
.SYNOPSIS
  Copia asistentes y playbooks a la carpeta de datos de Jan.
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
  Write-Host "Asistente: $($_.Name)"
}

$playSrc = Join-Path $here "playbooks"
$playDst = Join-Path $destRoot "workspace\playbooks"
if (Test-Path $playSrc) {
  New-Item -ItemType Directory -Force -Path $playDst | Out-Null
  Copy-Item -Force (Join-Path $playSrc "*.md") $playDst
  Write-Host "Playbooks: $playDst"
}

Write-Host ""
Write-Host "Listo. Carpeta Jan: $destRoot"
Write-Host "Reinicia Jan. Asistentes: Jan, Programadora local, Apps móviles, Traductora EN→ES."
Write-Host "Modelo recomendado para apps: Qwen2.5-Coder 7B. Para entender más: Qwen3-14B."
