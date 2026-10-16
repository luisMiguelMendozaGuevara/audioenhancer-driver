# Compila el driver y su paquete (por defecto x64 Debug) con MSBuild de VS2022.
# Requisitos: Visual Studio 2022 (Desktop C++) + Windows Driver Kit (WDK) + Windows SDK.
# Uso: powershell -ExecutionPolicy Bypass -File tools\build.ps1 [-Config Debug|Release] [-Platform x64]
param(
    [string]$Config = "Debug",
    [string]$Platform = "x64"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path $vswhere)) { throw "No se encontro vswhere (instalador de VS)" }
$vsPath = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if (-not $vsPath) { throw "No hay Visual Studio con herramientas de C++ instalado" }
$msbuild = Join-Path $vsPath "MSBuild\Current\Bin\MSBuild.exe"
Write-Host "MSBuild: $msbuild"

Write-Host "== Driver (TabletAudioSample) =="
& $msbuild "$root\driver\TabletAudioSample\TabletAudioSample.vcxproj" /p:Configuration=$Config /p:Platform=$Platform /m
if ($LASTEXITCODE -ne 0) { throw "Fallo el build del driver" }

Write-Host "== Paquete (INF/CAT) =="
& $msbuild "$root\driver\Package\package.VcxProj" /p:Configuration=$Config /p:Platform=$Platform /m
if ($LASTEXITCODE -ne 0) { throw "Fallo el build del paquete" }

Write-Host "OK. Salida en driver\$Platform\$Config\"
