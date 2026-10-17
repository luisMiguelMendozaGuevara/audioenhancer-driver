@echo off
title Instalar driver de prueba (AudioEnhancer Virtual Cable)
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Se abrira un aviso de Windows ^(UAC^): pulsa "Si".
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set ROOT=%~dp0..
set DEVCON=C:\Program Files (x86)\Windows Kits\10\Tools\10.0.26100.0\x64\devcon.exe
set INF=%ROOT%\driver\sysvad\Package\x64\Debug\package\ComponentizedAudioSample.inf
set CER=%ROOT%\driver\sysvad\TabletAudioSample\x64\Debug\TabletAudioSample.cer

echo ================================================================
echo   Instalacion del driver en MODO DE PRUEBAS (test signing)
echo ================================================================
echo.

echo == 1/4 Estado de BitLocker ==
manage-bde -status C: 2>nul | findstr /i "100%% Protection"
echo    (si aparece 100%% o Protection On, suspende BitLocker antes de tocar Secure Boot)
echo.

echo == 2/4 Activando modo test signing ==
bcdedit /set testsigning on
if %errorlevel% neq 0 (
    echo.
    echo ERROR: no se pudo activar. Desactiva Secure Boot en la BIOS y vuelve a intentarlo.
    pause
    exit /b 1
)
echo.

echo == 3/4 Instalando el certificado de prueba ==
certutil -addstore -f Root "%CER%"
certutil -addstore -f TrustedPublisher "%CER%"
echo.

echo == 4/4 Instalando el driver ==
"%DEVCON%" install "%INF%" Root\sysvad_ComponentizedAudioSample
echo.

echo LISTO. REINICIA el equipo para que se active el modo de pruebas
echo y el altavoz virtual aparezca en Configuracion de sonido.
pause
