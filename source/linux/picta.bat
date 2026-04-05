::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFDpGWBGQM1eeCaIS5Of66/m7pEwLXeEwdsHS2bvu
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDpGWBGQM1eeCaIS5Of66/m76QYhROs8bI6W3ruZLuwc60HhZ9gozn86
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
title Descargador de Videos - PictaCU v2.0
cd /d "%~dp0"
setlocal enabledelayedexpansion

:: ========================================
:: CARPETAS DEL SISTEMA
:: ========================================
set EXTRAS_DIR=%~dp0extras
set FFMPEG_DIR=%EXTRAS_DIR%\ffmpeg
set YTDLP_EXE=%EXTRAS_DIR%\yt-dlp.exe
set FFMPEG_EXE=%FFMPEG_DIR%\bin\ffmpeg.exe
set MP4BOX_EXE=%EXTRAS_DIR%\gpac\mp4box.exe

if not exist "%EXTRAS_DIR%" mkdir "%EXTRAS_DIR%"
if not exist "%FFMPEG_DIR%" mkdir "%FFMPEG_DIR%"
if not exist "%FFMPEG_DIR%\bin" mkdir "%FFMPEG_DIR%\bin"

:: ========================================
:: INSTALAR YT-DLP SI NO EXISTE
:: ========================================
if not exist "%YTDLP_EXE%" (
    echo ========================================
    echo INSTALANDO YT-DLP...
    echo ========================================
    echo.
    echo Descargando yt-dlp...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile '%YTDLP_EXE%'"
    echo yt-dlp instalado correctamente
    echo.
)

:: ========================================
:: INSTALAR FFMPEG SI NO EXISTE
:: ========================================
if not exist "%FFMPEG_EXE%" (
    echo ========================================
    echo INSTALANDO FFMPEG...
    echo ========================================
    echo.
    echo Descargando ffmpeg...
    powershell -Command "Invoke-WebRequest -Uri 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip' -OutFile '%EXTRAS_DIR%\ffmpeg.zip'"
    echo Extrayendo...
    powershell -Command "Expand-Archive -Path '%EXTRAS_DIR%\ffmpeg.zip' -DestinationPath '%EXTRAS_DIR%' -Force"
    echo Instalando...
    for /d %%i in ("%EXTRAS_DIR%\ffmpeg-*") do (
        xcopy "%%i\*" "%FFMPEG_DIR%\" /E /I /Y >nul 2>&1
        rmdir /s /q "%%i" >nul 2>&1
    )
    del "%EXTRAS_DIR%\ffmpeg.zip" >nul 2>&1
    echo ffmpeg instalado correctamente
    echo.
)

cls
echo ========================================
echo DESCARGADOR DE VIDEOS - PICTACU v2.0
echo ========================================
echo.
echo Seleccione modo de descarga:
echo    [1] Un solo video
echo    [2] Multiples videos (archivo videos.txt)
echo.
set /p "MODO=Modo (1 o 2): "

if "%MODO%"=="1" goto :MODO_UNICO
if "%MODO%"=="2" goto :MODO_MULTIPLE
echo ERROR: Opcion invalida
goto :FIN


:: ================================================================
:: MODO 1: UN SOLO VIDEO
:: ================================================================
:MODO_UNICO
echo.
echo ========================================
echo MODO: UN SOLO VIDEO
echo ========================================
echo.
set /p "VIDEO_ID=ID del video: "

if "!VIDEO_ID!"=="" (
    echo ERROR: No se ingreso un ID de video
    goto :FIN
)

set URL=https://videos.picta.cu/videos/!VIDEO_ID!/manifest.mpd
echo.
echo URL generada: !URL!
echo.
echo Obteniendo formatos disponibles...
echo ========================================
"%YTDLP_EXE%" -F "!URL!" 2>nul
echo ========================================
echo.

echo Audios disponibles:
echo   [default] - Mejor audio disponible
echo   es        - Espanol
echo   en        - Ingles
echo.
set /p "SEL_AUDIO=Seleccione idioma de audio (default): "
if "!SEL_AUDIO!"=="" set SEL_AUDIO=default

echo.
echo Subtitulos disponibles:
echo   [ninguno] - Sin subtitulos
echo   es        - Espanol
echo   en        - Ingles
echo.
set /p "SEL_SUB=Seleccione idioma de subtitulos (ninguno): "
if "!SEL_SUB!"=="" set SEL_SUB=ninguno

echo.
set /p "NOMBRE_VIDEO=Nombre del archivo de salida (sin extension): "
if "!NOMBRE_VIDEO!"=="" set NOMBRE_VIDEO=video

echo.
echo Calidades disponibles: 144, 240, 360, 480, 720, 1080
set /p "CALIDAD=Calidad (default 720): "
if "!CALIDAD!"=="" set CALIDAD=720

echo.
set /p "OUTPUT_DIR=Carpeta destino (Enter para descargas): "
if "!OUTPUT_DIR!"=="" set OUTPUT_DIR=descargas
if not exist "%~dp0!OUTPUT_DIR!" mkdir "%~dp0!OUTPUT_DIR!"
set OUTPUT_DIR=%~dp0!OUTPUT_DIR!

set CMD_BASE="%YTDLP_EXE%" --ffmpeg-location "%FFMPEG_DIR%\bin" --merge-output-format mp4

echo.
echo ========================================
echo RESUMEN:
echo   ID:          !VIDEO_ID!
echo   Nombre:      !NOMBRE_VIDEO!
echo   Calidad:     !CALIDAD!p
echo   Audio:       !SEL_AUDIO!
echo   Subtitulos:  !SEL_SUB!
echo   Destino:     !OUTPUT_DIR!
echo ========================================
echo.
echo Descargando... esto puede tomar varios minutos...
echo.

if "!SEL_AUDIO!"=="default" (
    if "!SEL_SUB!"=="ninguno" (
        %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio/best" -o "!OUTPUT_DIR!\!NOMBRE_VIDEO!.%%(ext)s" "!URL!"
    ) else (
        %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio/best" --write-subs --sub-lang !SEL_SUB! -o "!OUTPUT_DIR!\!NOMBRE_VIDEO!.%%(ext)s" "!URL!"
    )
) else if "!SEL_AUDIO!"=="es" (
    if "!SEL_SUB!"=="ninguno" (
        %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio[language=es]/best" -o "!OUTPUT_DIR!\!NOMBRE_VIDEO!.%%(ext)s" "!URL!"
    ) else (
        %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio[language=es]/best" --write-subs --sub-lang !SEL_SUB! -o "!OUTPUT_DIR!\!NOMBRE_VIDEO!.%%(ext)s" "!URL!"
    )
) else if "!SEL_AUDIO!"=="en" (
    if "!SEL_SUB!"=="ninguno" (
        %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio[language=en]/best" -o "!OUTPUT_DIR!\!NOMBRE_VIDEO!.%%(ext)s" "!URL!"
    ) else (
        %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio[language=en]/best" --write-subs --sub-lang !SEL_SUB! -o "!OUTPUT_DIR!\!NOMBRE_VIDEO!.%%(ext)s" "!URL!"
    )
)

if !errorlevel! neq 0 (
    echo.
    echo ========================================
    echo ERROR EN LA DESCARGA
    echo ========================================
    goto :FIN
)

echo.
echo ========================================
echo DESCARGA COMPLETADA: !NOMBRE_VIDEO!
echo ========================================

if not "!SEL_SUB!"=="ninguno" (
    set SUB_NOMBRE=!NOMBRE_VIDEO!
    set SUB_LANG=!SEL_SUB!
    set SUB_DESTINO=!OUTPUT_DIR!
    call :PROCESAR_SUBTITULOS
)

goto :FIN


:: ================================================================
:: MODO 2: MULTIPLES VIDEOS
:: ================================================================
:MODO_MULTIPLE
echo.
echo ========================================
echo MODO: MULTIPLES VIDEOS
echo ========================================
echo.
if not exist "%~dp0videos.txt" (
    echo No se encuentra videos.txt
    echo.
    echo Creando videos.txt de ejemplo...
    echo 0002012166c1428881c0af7359a6243d > "%~dp0videos.txt"
    echo Archivo creado. Editalo con tus IDs y ejecuta nuevamente.
    goto :FIN
)

echo Calidades disponibles: 144, 240, 360, 480, 720, 1080
set /p "CALIDAD=Calidad para todos los videos (default 720): "
if "!CALIDAD!"=="" set CALIDAD=720

echo.
set /p "OUTPUT_DIR=Carpeta destino (Enter para descargas): "
if "!OUTPUT_DIR!"=="" set OUTPUT_DIR=descargas
if not exist "%~dp0!OUTPUT_DIR!" mkdir "%~dp0!OUTPUT_DIR!"
set OUTPUT_DIR=%~dp0!OUTPUT_DIR!

set CMD_BASE="%YTDLP_EXE%" --ffmpeg-location "%FFMPEG_DIR%\bin" --merge-output-format mp4

set CONTADOR=0
for /f "usebackq delims=" %%i in ("%~dp0videos.txt") do set /a CONTADOR+=1

echo.
echo ========================================
echo Se procesaran %CONTADOR% video(s)
echo Calidad: !CALIDAD!p  --  Destino: !OUTPUT_DIR!
echo Se pediran nombre, audio y subtitulos por cada video.
echo ========================================

set NUM=0
set EXITOS=0
set FALLOS=0

for /f "usebackq delims=" %%i in ("%~dp0videos.txt") do (
    set /a NUM+=1
    set VID=%%i
    set URL_MULTI=https://videos.picta.cu/videos/!VID!/manifest.mpd

    echo.
    echo ========================================
    echo VIDEO [!NUM!/%CONTADOR%]  --  ID: !VID!
    echo ========================================
    echo URL: !URL_MULTI!
    echo.
    echo Obteniendo formatos disponibles...
    "%YTDLP_EXE%" -F "!URL_MULTI!" 2>nul
    echo.

    echo Audios disponibles:
    echo   [default] - Mejor audio disponible
    echo   es        - Espanol
    echo   en        - Ingles
    echo.
    set /p "M_AUDIO=Audio (default): "
    if "!M_AUDIO!"=="" set M_AUDIO=default

    echo.
    echo Subtitulos disponibles:
    echo   [ninguno] - Sin subtitulos
    echo   es        - Espanol
    echo   en        - Ingles
    echo.
    set /p "M_SUB=Subtitulos (ninguno): "
    if "!M_SUB!"=="" set M_SUB=ninguno

    echo.
    set /p "M_NOMBRE=Nombre del archivo (sin extension): "
    if "!M_NOMBRE!"=="" set M_NOMBRE=!VID!

    echo.
    echo Descargando !M_NOMBRE!...
    echo.

    if "!M_AUDIO!"=="default" (
        if "!M_SUB!"=="ninguno" (
            %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio/best" -o "!OUTPUT_DIR!\!M_NOMBRE!.%%(ext)s" "!URL_MULTI!"
        ) else (
            %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio/best" --write-subs --sub-lang !M_SUB! -o "!OUTPUT_DIR!\!M_NOMBRE!.%%(ext)s" "!URL_MULTI!"
        )
    ) else if "!M_AUDIO!"=="es" (
        if "!M_SUB!"=="ninguno" (
            %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio[language=es]/best" -o "!OUTPUT_DIR!\!M_NOMBRE!.%%(ext)s" "!URL_MULTI!"
        ) else (
            %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio[language=es]/best" --write-subs --sub-lang !M_SUB! -o "!OUTPUT_DIR!\!M_NOMBRE!.%%(ext)s" "!URL_MULTI!"
        )
    ) else if "!M_AUDIO!"=="en" (
        if "!M_SUB!"=="ninguno" (
            %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio[language=en]/best" -o "!OUTPUT_DIR!\!M_NOMBRE!.%%(ext)s" "!URL_MULTI!"
        ) else (
            %CMD_BASE% -f "bestvideo[height<=!CALIDAD!]+bestaudio[language=en]/best" --write-subs --sub-lang !M_SUB! -o "!OUTPUT_DIR!\!M_NOMBRE!.%%(ext)s" "!URL_MULTI!"
        )
    )

    if !errorlevel! equ 0 (
        set /a EXITOS+=1
        echo    [OK] !M_NOMBRE!
        if not "!M_SUB!"=="ninguno" (
            set SUB_NOMBRE=!M_NOMBRE!
            set SUB_LANG=!M_SUB!
            set SUB_DESTINO=!OUTPUT_DIR!
            call :PROCESAR_SUBTITULOS
        )
    ) else (
        set /a FALLOS+=1
        echo    [ERROR] !VID!
    )
    echo.
)

echo ========================================
echo RESUMEN FINAL
echo ========================================
echo Total:     %CONTADOR%
echo Exitosos:  !EXITOS!
echo Fallidos:  !FALLOS!
echo Carpeta:   !OUTPUT_DIR!
echo ========================================

goto :FIN


:: ================================================================
:: SUBRUTINA: PROCESAR SUBTITULOS
:: Variables requeridas: SUB_NOMBRE, SUB_LANG, SUB_DESTINO
:: ================================================================
:PROCESAR_SUBTITULOS
echo.
echo ----------------------------------------
echo Procesando subtitulos: %SUB_NOMBRE%
echo ----------------------------------------

set _SUB_MP4=%SUB_DESTINO%\%SUB_NOMBRE%.%SUB_LANG%.mp4
set _SUB_VTT=%SUB_DESTINO%\%SUB_NOMBRE%.vtt
set _SUB_SRT=%SUB_DESTINO%\%SUB_NOMBRE%.srt

echo Paso 1: Extrayendo subtitulos con MP4Box...
"%MP4BOX_EXE%" -raw 0 "%_SUB_MP4%" -out "%_SUB_VTT%"

if not exist "%_SUB_VTT%" (
    echo ERROR: MP4Box no genero el archivo VTT
    echo Verifique que exista: %_SUB_MP4%
    goto :eof
)

echo Paso 2: Convirtiendo VTT a SRT con ffmpeg...
"%FFMPEG_EXE%" -y -i "%_SUB_VTT%" "%_SUB_SRT%"

if exist "%_SUB_SRT%" (
    echo Subtitulo listo: %_SUB_SRT%
    del "%_SUB_VTT%" >nul 2>&1
    del "%_SUB_MP4%" >nul 2>&1
) else (
    echo ERROR: No se pudo convertir VTT a SRT
)
goto :eof


:: ================================================================
:: FIN - siempre se llega aqui
:: ================================================================
:FIN
echo.
echo ========================================
echo PROCESO FINALIZADO
echo ========================================
echo.
pause
