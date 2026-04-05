# Picta-Simple-Downloader

> 🇬🇧 [English](#english) | 🇪🇸 [Español](#español)

---

<a name="english"></a>
# 🇬🇧 English

A cross-platform tool to download videos from [Picta.cu](https://videos.picta.cu) — Cuba's national video platform — using `yt-dlp` and `ffmpeg`. Available as a **Windows batch script** (`.bat`) and a **Linux Bash script** (`.sh`). Supports single or batch downloads, quality selection, audio language, and subtitle embedding.

## 📦 Versions

| File | Platform | Auto-installs yt-dlp | Auto-installs ffmpeg |
|---|---|---|---|
| `picta.bat` | Windows 10/11 | ✅ Yes | ✅ Yes |
| `picta.sh` | Linux | ✅ Yes | ❌ Manual |

---

## 🪟 Windows — `picta.bat`

### Requirements

- Windows 10 or 11
- PowerShell (included by default)
- Internet connection on first run

That's it. **No manual installation needed.** The script automatically downloads and sets up both `yt-dlp` and `ffmpeg` on first run, storing them locally in an `extras/` folder next to the script.

### Usage

1. Double-click `picta.bat`  
   *(or run it from Command Prompt)*
2. Follow the on-screen prompts

On first launch, you will see:

```
========================================
INSTALANDO YT-DLP...
========================================
Descargando yt-dlp...

========================================
INSTALANDO FFMPEG...
========================================
Descargando ffmpeg...
Extrayendo...
Instalando...
```

This only happens once. Subsequent runs start directly at the main menu.

### Directory structure (Windows)

```
picta.bat
videos.txt            ← IDs for batch mode
extras\
├── yt-dlp.exe        ← auto-downloaded
└── ffmpeg\
    └── bin\
        └── ffmpeg.exe  ← auto-downloaded and extracted
descargas\            ← default output folder
```

---

## 🐧 Linux — `picta.sh`

### Requirements

| Dependency | How to install |
|---|---|
| `bash` | Pre-installed on all Linux distros |
| `curl` | `sudo apt install curl` |
| `ffmpeg` | `sudo apt install ffmpeg` |
| `yt-dlp` | Auto-downloaded by the script on first run |

> **Note:** Unlike the Windows version, `ffmpeg` must be installed manually on Linux. The script will check for it and show install instructions if it's missing.

### Usage

```bash
# 1. Give execute permission
chmod +x picta.sh

# 2. Run the script
./picta.sh
```

### Directory structure (Linux)

```
picta.sh
videos.txt          ← IDs for batch mode
extras/
└── yt-dlp          ← auto-downloaded on first run
descargas/          ← default output folder (created automatically)
```

---

## ✨ Features (both versions)

- 📥 **Single video download** by video ID
- 📋 **Batch download** from a `videos.txt` file (one ID per line)
- 🎞️ **Quality selection**: 144p, 240p, 360p, 480p, 720p, 1080p
- 🔊 **Audio language selection**: default, Spanish (`es`), English (`en`)
- 💬 **Subtitle support**: embed Spanish subtitles into the output file
- 📂 **Custom output folder**
- 📦 Output merged as `.mp4`

---

## 🎬 How to find a video ID

Picta does not show the video ID directly on the page. You need to inspect the network traffic while the video is playing:

1. **Open the video** on Picta.cu and let it start playing
2. **Press `F12`** to open the browser DevTools, then go to the **Network** tab (may appear as *Red* depending on your browser language)
3. **Look for requests** that start with `segment_` and end in `.m4s` — for example `segment_001.m4s`, `segment_002.m4s`, etc.
4. **Click on any of those requests** and check the full URL in the request details. It will look like this:

```
https://videos.picta.cu/videos/e5935327979e415b9f235afd590b1793/video/480p/segment_001.m4s
                                └─────────────── video ID ───────────────┘
```

5. The video ID is the long alphanumeric string between `/videos/` and `/video/` — in this example:

```
e5935327979e415b9f235afd590b1793
```

> 💡 **Tip:** If you don't see any `segment_*.m4s` requests, try refreshing the page with DevTools already open, or seek to a different point in the video to trigger new segment requests.

---

## 📋 Mode 1 — Single video

Run the script, choose mode `1`, and enter the video ID when prompted.

The script will:
1. Show all available formats (via `yt-dlp -F`)
2. Ask for audio language preference
3. Ask whether to embed subtitles
4. Ask for quality and output folder
5. Download and merge into `.mp4`

## 📋 Mode 2 — Batch download

1. Create a `videos.txt` file in the same folder as the script
2. Add one video ID per line:

```
e5935327979e415b9f235afd590b1793
0002012166c1428881c0af7359a6243d
a1b2c3d4e5f6...
```

3. Run the script and choose mode `2`

At the end, a summary shows how many videos succeeded or failed.

> In batch mode, audio is always set to best available (no language filtering).

---

## ⚠️ Notes

- If `videos.txt` doesn't exist when using mode 2, the script creates a sample file and exits.
- Downloads are saved as `%(title)s.mp4` using the video's original title.
- On Windows, `ffmpeg` is extracted to `extras\ffmpeg\` and never added to the system PATH — everything is self-contained.

---
---

<a name="español"></a>
# 🇪🇸 Español

Herramienta multiplataforma para descargar videos de [Picta.cu](https://videos.picta.cu) — la plataforma nacional de video de Cuba — usando `yt-dlp` y `ffmpeg`. Disponible como **script para Windows** (`.bat`) y **script para Linux** (`.sh`). Soporta descarga individual o por lotes, selección de calidad, idioma de audio e incrustación de subtítulos.

## 📦 Versiones

| Archivo | Plataforma | Auto-instala yt-dlp | Auto-instala ffmpeg |
|---|---|---|---|
| `picta.bat` | Windows 10/11 | ✅ Sí | ✅ Sí |
| `picta.sh` | Linux | ✅ Sí | ❌ Manual |

---

## 🪟 Windows — `picta.bat`

### Requisitos

- Windows 10 u 11
- PowerShell (incluido por defecto)
- Conexión a internet en la primera ejecución

Eso es todo. **No se necesita instalar nada manualmente.** El script descarga y configura automáticamente tanto `yt-dlp` como `ffmpeg` en la primera ejecución, guardándolos en una carpeta `extras/` junto al script.

### Uso

1. Haz doble clic en `picta.bat`  
   *(o ejecútalo desde el Símbolo del sistema)*
2. Sigue las instrucciones en pantalla

En la primera ejecución verás:

```
========================================
INSTALANDO YT-DLP...
========================================
Descargando yt-dlp...

========================================
INSTALANDO FFMPEG...
========================================
Descargando ffmpeg...
Extrayendo...
Instalando...
```

Esto ocurre solo una vez. Las ejecuciones siguientes van directamente al menú principal.

### Estructura de directorios (Windows)

```
picta.bat
videos.txt              ← IDs para el modo por lotes
extras\
├── yt-dlp.exe          ← se descarga automáticamente
└── ffmpeg\
    └── bin\
        └── ffmpeg.exe  ← se descarga y extrae automáticamente
descargas\              ← carpeta de salida por defecto
```

---

## 🐧 Linux — `picta.sh`

### Requisitos

| Dependencia | Cómo instalar |
|---|---|
| `bash` | Preinstalado en todas las distros Linux |
| `curl` | `sudo apt install curl` |
| `ffmpeg` | `sudo apt install ffmpeg` |
| `yt-dlp` | El script lo descarga automáticamente en la primera ejecución |

> **Nota:** A diferencia de la versión Windows, `ffmpeg` debe instalarse manualmente en Linux. El script verificará si está disponible y mostrará instrucciones si no lo encuentra.

### Uso

```bash
# 1. Dar permisos de ejecución
chmod +x picta.sh

# 2. Ejecutar el script
./picta.sh
```

### Estructura de directorios (Linux)

```
picta.sh
videos.txt          ← IDs para el modo por lotes
extras/
└── yt-dlp          ← se descarga automáticamente en la primera ejecución
descargas/          ← carpeta de salida por defecto (se crea automáticamente)
```

---

## ✨ Características (ambas versiones)

- 📥 **Descarga de un solo video** por ID
- 📋 **Descarga múltiple** desde un archivo `videos.txt` (un ID por línea)
- 🎞️ **Selección de calidad**: 144p, 240p, 360p, 480p, 720p, 1080p
- 🔊 **Selección de idioma de audio**: predeterminado, Español (`es`), Inglés (`en`)
- 💬 **Soporte de subtítulos**: incrusta subtítulos en español en el archivo de salida
- 📂 **Carpeta de destino personalizable**
- 📦 Salida combinada en `.mp4`

---

## 🎬 Cómo encontrar el ID de un video

Picta no muestra el ID del video directamente en la página. Es necesario inspeccionar el tráfico de red mientras el video se reproduce:

1. **Abre el video** en Picta.cu y deja que comience a reproducirse
2. **Presiona `F12`** para abrir las herramientas de desarrollo del navegador, luego ve a la pestaña **Network** (o **Red**, según el idioma del navegador)
3. **Busca peticiones** que comiencen con `segment_` y terminen en `.m4s` — por ejemplo `segment_001.m4s`, `segment_002.m4s`, etc.
4. **Haz clic en cualquiera de esas peticiones** y revisa la URL completa en los detalles de la solicitud. Tendrá este aspecto:

```
https://videos.picta.cu/videos/e5935327979e415b9f235afd590b1793/video/480p/segment_001.m4s
                                └──────────────── ID del video ────────────────┘
```

5. El ID del video es la cadena alfanumérica larga que aparece entre `/videos/` y `/video/` — en este ejemplo:

```
e5935327979e415b9f235afd590b1793
```

> 💡 **Consejo:** Si no aparecen peticiones `segment_*.m4s`, intenta recargar la página con las herramientas de desarrollo ya abiertas, o avanza a otro punto del video para forzar nuevas peticiones de segmentos.

---

## 📋 Modo 1 — Un solo video

Ejecuta el script, selecciona el modo `1` e ingresa el ID del video cuando se solicite.

El script realizará los siguientes pasos:
1. Mostrará los formatos disponibles (mediante `yt-dlp -F`)
2. Preguntará el idioma de audio preferido
3. Preguntará si deseas incrustar subtítulos
4. Pedirá la calidad y la carpeta de destino
5. Descargará y combinará el video en `.mp4`

## 📋 Modo 2 — Descarga múltiple

1. Crea un archivo `videos.txt` en la misma carpeta del script
2. Escribe un ID de video por línea:

```
e5935327979e415b9f235afd590b1793
0002012166c1428881c0af7359a6243d
a1b2c3d4e5f6...
```

3. Ejecuta el script y selecciona el modo `2`

Al finalizar, se muestra un resumen con la cantidad de videos descargados correctamente y los que fallaron.

> En el modo múltiple, el audio siempre se descarga en la mejor calidad disponible (sin filtro de idioma).

---

## ⚠️ Notas

- Si `videos.txt` no existe al usar el modo 2, el script crea un archivo de ejemplo y termina.
- Los archivos se guardan como `%(title)s.mp4` usando el título original del video.
- En Windows, `ffmpeg` se extrae en `extras\ffmpeg\` y nunca se agrega al PATH del sistema — todo es autocontenido.

---
