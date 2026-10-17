# Compila el driver y su paquete (por defecto x64 Debug) con MSBuild de VS2022.
# Requisitos: Visual Studio 2022 (Desktop C++) + WDK + Windows SDK.
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

# SkipPackageVerification: el DPVerifier (InfVerif) no carga en este entorno;
# no afecta al binario, solo a la verificacion de calidad del paquete INF.
$common = @("/p:Configuration=$Config", "/p:Platform=$Platform", "/p:SkipPackageVerification=true", "/m")

$projects = @(
    "driver\sysvad\EndpointsCommon\EndpointsCommon.vcxproj",
    "driver\sysvad\TabletAudioSample\TabletAudioSample.vcxproj",
    "driver\sysvad\Package\package.VcxProj"
)

foreach ($p in $projects) {
    Write-Host "== $p =="
    & $msbuild (Join-Path $root $p) @common
    if ($LASTEXITCODE -ne 0) { throw "Fallo el build: $p" }
}

Write-Host "OK. Salida en driver\sysvad\TabletAudioSample\$Platform\$Config\ y driver\sysvad\Package\"
