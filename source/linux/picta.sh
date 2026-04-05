#!/usr/bin/env bash
# ========================================
# DESCARGADOR DE VIDEOS - PICTACU v2.0
# ========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ========================================
# CARPETAS DEL SISTEMA
# ========================================
EXTRAS_DIR="$SCRIPT_DIR/extras"
YTDLP_EXE="$EXTRAS_DIR/yt-dlp"

mkdir -p "$EXTRAS_DIR"

# ========================================
# INSTALAR YT-DLP SI NO EXISTE
# ========================================
if [[ ! -x "$YTDLP_EXE" ]]; then
    echo "========================================"
    echo "INSTALANDO YT-DLP..."
    echo "========================================"
    echo
    echo "Descargando yt-dlp..."
    curl -L "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux" -o "$YTDLP_EXE"
    chmod +x "$YTDLP_EXE"
    echo "yt-dlp instalado correctamente"
    echo
fi

# ========================================
# VERIFICAR FFMPEG
# ========================================
if ! command -v ffmpeg &>/dev/null; then
    echo "========================================"
    echo "FFMPEG NO ENCONTRADO"
    echo "========================================"
    echo "Instálalo con tu gestor de paquetes:"
    echo "  Ubuntu/Debian:  sudo apt install ffmpeg -y"
    echo "  Fedora:         sudo dnf install ffmpeg"
    echo "  Arch:           sudo pacman -S ffmpeg"
    echo
    read -rp "Presiona Enter para salir..."
    exit 1
fi

# ========================================
# VERIFICAR / INSTALAR GPAC (MP4Box)
# ========================================
if ! command -v MP4Box &>/dev/null; then
    echo "========================================"
    echo "GPAC (MP4Box) NO ENCONTRADO"
    echo "========================================"
    echo "Intentando instalar automáticamente..."
    echo

    if command -v apt &>/dev/null; then
        sudo apt install gpac -y
    elif command -v dnf &>/dev/null; then
        echo "Fedora detectado. Instala manualmente:"
        echo "  sudo dnf install gpac"
        read -rp "Presiona Enter para salir..."
        exit 1
    elif command -v pacman &>/dev/null; then
        echo "Arch detectado. Instala manualmente:"
        echo "  sudo pacman -S gpac"
        read -rp "Presiona Enter para salir..."
        exit 1
    else
        echo "Gestor de paquetes no reconocido."
        echo "Instala gpac manualmente desde: https://gpac.io"
        read -rp "Presiona Enter para salir..."
        exit 1
    fi

    if ! command -v MP4Box &>/dev/null; then
        echo "ERROR: No se pudo instalar GPAC correctamente."
        read -rp "Presiona Enter para salir..."
        exit 1
    fi

    echo "GPAC instalado correctamente"
    echo
fi

# ========================================
# SUBRUTINA: PROCESAR SUBTITULOS
# Args: $1=nombre $2=lang $3=destino
# ========================================
procesar_subtitulos() {
    local nombre="$1"
    local lang="$2"
    local destino="$3"

    local sub_mp4="$destino/$nombre.$lang.mp4"
    local sub_vtt="$destino/$nombre.vtt"
    local sub_srt="$destino/$nombre.srt"

    echo
    echo "----------------------------------------"
    echo "Procesando subtítulos: $nombre"
    echo "----------------------------------------"

    echo "Paso 1: Extrayendo subtítulos con MP4Box..."
    MP4Box -raw 0 "$sub_mp4" -out "$sub_vtt"

    if [[ ! -f "$sub_vtt" ]]; then
        echo "ERROR: MP4Box no generó el archivo VTT"
        echo "Verifique que exista: $sub_mp4"
        return 1
    fi

    echo "Paso 2: Convirtiendo VTT a SRT con ffmpeg..."
    ffmpeg -y -i "$sub_vtt" "$sub_srt" 2>/dev/null

    if [[ -f "$sub_srt" ]]; then
        echo "Subtítulo listo: $sub_srt"
        rm -f "$sub_vtt" "$sub_mp4"
    else
        echo "ERROR: No se pudo convertir VTT a SRT"
    fi
}

# ========================================
# FUNCION: construir formato yt-dlp
# ========================================
build_format() {
    local audio="$1"
    local calidad="$2"
    case "$audio" in
        es)  echo "bestvideo[height<=${calidad}]+bestaudio[language=es]/best" ;;
        en)  echo "bestvideo[height<=${calidad}]+bestaudio[language=en]/best" ;;
        *)   echo "bestvideo[height<=${calidad}]+bestaudio/best" ;;
    esac
}

clear
echo "========================================"
echo "DESCARGADOR DE VIDEOS - PICTACU v2.0"
echo "========================================"
echo

# ========================================
# MODO
# ========================================
echo "Seleccione modo de descarga:"
echo "   [1] Un solo video"
echo "   [2] Múltiples videos (archivo videos.txt)"
echo
read -rp "Modo (1 o 2): " MODO

CMD_BASE=("$YTDLP_EXE" --merge-output-format mp4)

# ================================================================
# MODO 1: UN SOLO VIDEO
# ================================================================
if [[ "$MODO" == "1" ]]; then
    echo
    echo "========================================"
    echo "MODO: UN SOLO VIDEO"
    echo "========================================"
    echo
    read -rp "ID del video: " VIDEO_ID

    if [[ -z "$VIDEO_ID" ]]; then
        echo "ERROR: No se ingresó un ID de video"
        read -rp "Presiona Enter para salir..."
        exit 1
    fi

    URL="https://videos.picta.cu/videos/${VIDEO_ID}/manifest.mpd"
    echo
    echo "URL generada: $URL"
    echo
    echo "Obteniendo formatos disponibles..."
    echo "========================================"
    "$YTDLP_EXE" -F "$URL" 2>/dev/null || true
    echo "========================================"
    echo

    echo "Audios disponibles:"
    echo "  [default] - Mejor audio disponible"
    echo "  es        - Español"
    echo "  en        - Inglés"
    echo
    read -rp "Seleccione idioma de audio (default): " SEL_AUDIO
    SEL_AUDIO="${SEL_AUDIO:-default}"

    echo
    echo "Subtítulos disponibles:"
    echo "  [ninguno] - Sin subtítulos"
    echo "  es        - Español"
    echo "  en        - Inglés"
    echo
    read -rp "Seleccione idioma de subtítulos (ninguno): " SEL_SUB
    SEL_SUB="${SEL_SUB:-ninguno}"

    echo
    read -rp "Nombre del archivo de salida (sin extensión): " NOMBRE_VIDEO
    NOMBRE_VIDEO="${NOMBRE_VIDEO:-video}"

    echo
    echo "Calidades disponibles: 144, 240, 360, 480, 720, 1080"
    read -rp "Calidad (default 720): " CALIDAD
    CALIDAD="${CALIDAD:-720}"

    echo
    read -rp "Carpeta destino (Enter para descargas): " OUTPUT_DIR
    OUTPUT_DIR="${OUTPUT_DIR:-descargas}"
    OUTPUT_DIR="$SCRIPT_DIR/$OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"

    echo
    echo "========================================"
    echo "RESUMEN:"
    echo "  ID:         $VIDEO_ID"
    echo "  Nombre:     $NOMBRE_VIDEO"
    echo "  Calidad:    ${CALIDAD}p"
    echo "  Audio:      $SEL_AUDIO"
    echo "  Subtítulos: $SEL_SUB"
    echo "  Destino:    $OUTPUT_DIR"
    echo "========================================"
    echo
    echo "Descargando... esto puede tomar varios minutos..."
    echo

    FORMAT="$(build_format "$SEL_AUDIO" "$CALIDAD")"

    if [[ "$SEL_SUB" != "ninguno" ]]; then
        "${CMD_BASE[@]}" -f "$FORMAT" --write-subs --sub-lang "$SEL_SUB" \
            -o "$OUTPUT_DIR/$NOMBRE_VIDEO.%(ext)s" "$URL"
    else
        "${CMD_BASE[@]}" -f "$FORMAT" \
            -o "$OUTPUT_DIR/$NOMBRE_VIDEO.%(ext)s" "$URL"
    fi

    if [[ $? -ne 0 ]]; then
        echo
        echo "========================================"
        echo "ERROR EN LA DESCARGA"
        echo "========================================"
        read -rp "Presiona Enter para salir..."
        exit 1
    fi

    echo
    echo "========================================"
    echo "DESCARGA COMPLETADA: $NOMBRE_VIDEO"
    echo "========================================"

    if [[ "$SEL_SUB" != "ninguno" ]]; then
        procesar_subtitulos "$NOMBRE_VIDEO" "$SEL_SUB" "$OUTPUT_DIR"
    fi

# ================================================================
# MODO 2: MULTIPLES VIDEOS
# ================================================================
elif [[ "$MODO" == "2" ]]; then
    echo
    echo "========================================"
    echo "MODO: MÚLTIPLES VIDEOS"
    echo "========================================"
    echo

    if [[ ! -f "$SCRIPT_DIR/videos.txt" ]]; then
        echo "No se encuentra videos.txt"
        echo
        echo "Creando videos.txt de ejemplo..."
        echo "0002012166c1428881c0af7359a6243d" > "$SCRIPT_DIR/videos.txt"
        echo "Archivo creado. Edítalo con tus IDs y ejecuta nuevamente."
        read -rp "Presiona Enter para salir..."
        exit 0
    fi

    echo "Calidades disponibles: 144, 240, 360, 480, 720, 1080"
    read -rp "Calidad para todos los videos (default 720): " CALIDAD
    CALIDAD="${CALIDAD:-720}"

    echo
    read -rp "Carpeta destino (Enter para descargas): " OUTPUT_DIR
    OUTPUT_DIR="${OUTPUT_DIR:-descargas}"
    OUTPUT_DIR="$SCRIPT_DIR/$OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"

    VIDEOS_FILE="$SCRIPT_DIR/videos.txt"
    CONTADOR=$(grep -c . "$VIDEOS_FILE" || true)

    echo
    echo "========================================"
    echo "Se procesarán $CONTADOR video(s)"
    echo "Calidad: ${CALIDAD}p  --  Destino: $OUTPUT_DIR"
    echo "Se pedirán nombre, audio y subtítulos por cada video."
    echo "========================================"

    NUM=0
    EXITOS=0
    FALLOS=0

    while IFS= read -r VID || [[ -n "$VID" ]]; do
        [[ -z "$VID" ]] && continue
        (( NUM++ )) || true

        URL_MULTI="https://videos.picta.cu/videos/${VID}/manifest.mpd"

        echo
        echo "========================================"
        echo "VIDEO [$NUM/$CONTADOR]  --  ID: $VID"
        echo "========================================"
        echo "URL: $URL_MULTI"
        echo
        echo "Obteniendo formatos disponibles..."
        "$YTDLP_EXE" -F "$URL_MULTI" 2>/dev/null || true
        echo

        echo "Audios disponibles:"
        echo "  [default] - Mejor audio disponible"
        echo "  es        - Español"
        echo "  en        - Inglés"
        echo
        read -rp "Audio (default): " M_AUDIO
        M_AUDIO="${M_AUDIO:-default}"

        echo
        echo "Subtítulos disponibles:"
        echo "  [ninguno] - Sin subtítulos"
        echo "  es        - Español"
        echo "  en        - Inglés"
        echo
        read -rp "Subtítulos (ninguno): " M_SUB
        M_SUB="${M_SUB:-ninguno}"

        echo
        read -rp "Nombre del archivo (sin extensión): " M_NOMBRE
        M_NOMBRE="${M_NOMBRE:-$VID}"

        echo
        echo "Descargando $M_NOMBRE..."
        echo

        FORMAT="$(build_format "$M_AUDIO" "$CALIDAD")"

        if [[ "$M_SUB" != "ninguno" ]]; then
            "${CMD_BASE[@]}" -f "$FORMAT" --write-subs --sub-lang "$M_SUB" \
                -o "$OUTPUT_DIR/$M_NOMBRE.%(ext)s" "$URL_MULTI"
        else
            "${CMD_BASE[@]}" -f "$FORMAT" \
                -o "$OUTPUT_DIR/$M_NOMBRE.%(ext)s" "$URL_MULTI"
        fi

        if [[ $? -eq 0 ]]; then
            (( EXITOS++ )) || true
            echo "   [OK] $M_NOMBRE"
            if [[ "$M_SUB" != "ninguno" ]]; then
                procesar_subtitulos "$M_NOMBRE" "$M_SUB" "$OUTPUT_DIR"
            fi
        else
            (( FALLOS++ )) || true
            echo "   [ERROR] $VID"
        fi
        echo
    done < "$VIDEOS_FILE"

    echo "========================================"
    echo "RESUMEN FINAL"
    echo "========================================"
    echo "Total:    $CONTADOR"
    echo "Exitosos: $EXITOS"
    echo "Fallidos: $FALLOS"
    echo "Carpeta:  $OUTPUT_DIR"
    echo "========================================"

else
    echo "ERROR: Opción inválida"
fi

# ================================================================
# FIN - siempre se llega aquí
# ================================================================
echo
echo "========================================"
echo "PROCESO FINALIZADO"
echo "========================================"
echo
read -rp "Presiona Enter para salir..."
