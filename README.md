# Picta Simple Downloader

---

## ⚠️ Disclaimer / Aviso Legal

**[EN]** This tool is made purely for entertainment purposes. It requires no complex software installation — just run and download. It is not a professional product and no commercial benefit is sought. The source code is open for anyone to review. If you want something more polished, I personally recommend this repo, which in my opinion is excellent — though it requires installing a download manager and a few extra steps, the final result is much better:
👉 https://github.com/Spheres-cu/picta-fdm

**[ES]** Esta herramienta es simplemente con motivos de entretenimiento. No requiere instalar software complicado — básicamente ejecutar y descargar. No presenta un desarrollo profesional ni se busca ningún beneficio. El código fuente puede ser revisado por cualquier persona. Si usted desea algo más profesional, puede utilizar este repo que en mi opinión está muy bueno, aunque requiere la instalación de un gestor de descargas y algunos pasos extras, el producto final es mucho mejor:
👉 https://github.com/Spheres-cu/picta-fdm

---

## 🎬 How to find a Video ID / Cómo encontrar el ID de un video

**[EN]** Picta does not show the video ID directly on the page. You need to inspect the network traffic while the video is playing:

1. Open the video on Picta.cu and let it start playing
2. Press `F12` to open the browser DevTools, then go to the **Network** tab (may appear as **Red** depending on your browser language)
3. Look for requests that start with `segment_` and end in `.m4s` — for example `segment_001.m4s`, `segment_002.m4s`, etc.
4. Click on any of those requests and check the full URL in the request details. It will look like this:

```
https://videos.picta.cu/videos/e5935327979e415b9f235afd590b1793/video/480p/segment_001.m4s
                                └─────────────── video ID ───────────────┘
```

5. The video ID is the long alphanumeric string between `/videos/` and `/video/` — in this example:

```
e5935327979e415b9f235afd590b1793
```

💡 **Tip:** If you don't see any `segment_*.m4s` requests, try refreshing the page with DevTools already open, or seek to a different point in the video to trigger new segment requests.

---

**[ES]** Picta no muestra el ID del video directamente en la página. Necesitas inspeccionar el tráfico de red mientras el video se está reproduciendo:

1. Abre el video en Picta.cu y deja que comience a reproducirse
2. Presiona `F12` para abrir las DevTools del navegador, luego ve a la pestaña **Red** (puede aparecer como **Network** según el idioma de tu navegador)
3. Busca solicitudes que comiencen con `segment_` y terminen en `.m4s` — por ejemplo `segment_001.m4s`, `segment_002.m4s`, etc.
4. Haz clic en cualquiera de esas solicitudes y revisa la URL completa en los detalles. Tendrá este aspecto:

```
https://videos.picta.cu/videos/e5935327979e415b9f235afd590b1793/video/480p/segment_001.m4s
                                └────────ID del video ────────┘
```

5. El ID del video es la cadena alfanumérica larga que está entre `/videos/` y `/video/` — en este ejemplo:

```
e5935327979e415b9f235afd590b1793
```

💡 **Consejo:** Si no ves solicitudes `segment_*.m4s`, intenta recargar la página con las DevTools ya abiertas, o avanza a otro punto del video para forzar nuevas solicitudes de segmentos.

---

## 🪟 Windows — `picta.bat`

### Requirements / Requisitos

**[EN]** No manual installation needed. The script downloads everything automatically on first run:
- **yt-dlp** — downloaded automatically to `extras/yt-dlp.exe`
- **ffmpeg** — downloaded automatically to `extras/ffmpeg/`
- **MP4Box (GPAC)** — must be installed manually and placed at `extras/gpac/mp4box.exe`

> To get MP4Box: download the GPAC installer from https://gpac.io, install it, then copy `mp4box.exe` from the installation folder (usually `C:\Program Files\GPAC\`) into `extras\gpac\`.  
> MP4Box is only needed if you want to download subtitles.

**[ES]** No necesitas instalar nada manualmente. El script descarga todo automáticamente en el primer uso:
- **yt-dlp** — se descarga automáticamente en `extras/yt-dlp.exe`
- **ffmpeg** — se descarga automáticamente en `extras/ffmpeg/`
- **MP4Box (GPAC)** — debe instalarse manualmente y colocarse en `extras/gpac/mp4box.exe`

> Para obtener MP4Box: descarga el instalador de GPAC desde https://gpac.io, instálalo y copia `mp4box.exe` de la carpeta de instalación (normalmente `C:\Program Files\GPAC\`) dentro de `extras\gpac\`.  
> MP4Box solo es necesario si deseas descargar subtítulos.

---

### How to use / Cómo usar

**[EN]**
1. Place `picta.bat` in any folder you like
2. Double-click `picta.bat` to run it
3. On the first run it will download yt-dlp and ffmpeg automatically — this takes a moment
4. Choose a mode:
   - **[1] Single video** — enter one video ID
   - **[2] Multiple videos** — reads IDs from a `videos.txt` file in the same folder (one ID per line)
5. Follow the on-screen prompts:
   - Select video quality (144, 240, 360, 480, 720, 1080)
   - Select audio language (default, Spanish, English)
   - Select subtitle language (none, Spanish, English)
   - Enter a name for the output file (without extension)
   - Choose a destination folder (default: `descargas`)
6. The video will be saved as `.mp4`. If subtitles were selected, a `.srt` file with the same name will also be created.

**[ES]**
1. Coloca `picta.bat` en cualquier carpeta
2. Haz doble clic en `picta.bat` para ejecutarlo
3. En el primer uso descargará yt-dlp y ffmpeg automáticamente — esto tarda un momento
4. Elige un modo:
   - **[1] Video único** — introduce un ID de video
   - **[2] Múltiples videos** — lee los IDs desde un archivo `videos.txt` en la misma carpeta (un ID por línea)
5. Sigue las instrucciones en pantalla:
   - Selecciona la calidad del video (144, 240, 360, 480, 720, 1080)
   - Selecciona el idioma del audio (default, español, inglés)
   - Selecciona el idioma de los subtítulos (ninguno, español, inglés)
   - Escribe un nombre para el archivo de salida (sin extensión)
   - Elige una carpeta de destino (por defecto: `descargas`)
6. El video se guardará como `.mp4`. Si seleccionaste subtítulos, también se creará un archivo `.srt` con el mismo nombre.

---

### videos.txt format / Formato de videos.txt

```
e5935327979e415b9f235afd590b1793
0002012166c1428881c0af7359a6243d
a1b2c3d4e5f6...
```

One video ID per line. No spaces, no URLs — just the ID. / Un ID por línea. Sin espacios ni URLs — solo el ID.

---

## 🐧 Linux — `picta.sh`

### Requirements / Requisitos

**[EN]** The script handles yt-dlp automatically. You only need to have these installed on your system:

| Tool | Ubuntu/Debian | Fedora | Arch |
|------|--------------|--------|------|
| ffmpeg | `sudo apt install ffmpeg -y` | `sudo dnf install ffmpeg` | `sudo pacman -S ffmpeg` |
| gpac (MP4Box) | `sudo apt install gpac -y` *(auto-installed)* | `sudo dnf install gpac` | `sudo pacman -S gpac` |

> On Ubuntu/Debian, GPAC is installed automatically by the script if missing.  
> On other distributions, the script will show you the command to run and exit.  
> GPAC is only needed if you want to download subtitles.

**[ES]** El script gestiona yt-dlp automáticamente. Solo necesitas tener instalado en tu sistema:

| Herramienta | Ubuntu/Debian | Fedora | Arch |
|-------------|--------------|--------|------|
| ffmpeg | `sudo apt install ffmpeg -y` | `sudo dnf install ffmpeg` | `sudo pacman -S ffmpeg` |
| gpac (MP4Box) | `sudo apt install gpac -y` *(se instala automáticamente)* | `sudo dnf install gpac` | `sudo pacman -S gpac` |

> En Ubuntu/Debian, GPAC se instala automáticamente si no está presente.  
> En otras distribuciones, el script te mostrará el comando a ejecutar y saldrá.  
> GPAC solo es necesario si deseas descargar subtítulos.

---

### How to use / Cómo usar

**[EN]**
1. Place `picta.sh` in any folder
2. Open a terminal in that folder
3. Give it execute permission (only needed once):
   ```bash
   chmod +x picta.sh
   ```
4. Run it:
   ```bash
   ./picta.sh
   ```
5. On the first run it will download yt-dlp automatically
6. Choose a mode:
   - **[1] Single video** — enter one video ID
   - **[2] Multiple videos** — reads IDs from a `videos.txt` file in the same folder (one ID per line)
7. Follow the on-screen prompts:
   - Select video quality (144, 240, 360, 480, 720, 1080)
   - Select audio language (default, Spanish, English)
   - Select subtitle language (none, Spanish, English)
   - Enter a name for the output file (without extension)
   - Choose a destination folder (default: `descargas`)
8. The video will be saved as `.mp4`. If subtitles were selected, a `.srt` file with the same name will also be created.

**[ES]**
1. Coloca `picta.sh` en cualquier carpeta
2. Abre una terminal en esa carpeta
3. Dale permisos de ejecución (solo la primera vez):
   ```bash
   chmod +x picta.sh
   ```
4. Ejecútalo:
   ```bash
   ./picta.sh
   ```
5. En el primer uso descargará yt-dlp automáticamente
6. Elige un modo:
   - **[1] Video único** — introduce un ID de video
   - **[2] Múltiples videos** — lee los IDs desde un archivo `videos.txt` en la misma carpeta (un ID por línea)
7. Sigue las instrucciones en pantalla:
   - Selecciona la calidad del video (144, 240, 360, 480, 720, 1080)
   - Selecciona el idioma del audio (default, español, inglés)
   - Selecciona el idioma de los subtítulos (ninguno, español, inglés)
   - Escribe un nombre para el archivo de salida (sin extensión)
   - Elige una carpeta de destino (por defecto: `descargas`)
8. El video se guardará como `.mp4`. Si seleccionaste subtítulos, también se creará un archivo `.srt` con el mismo nombre.

---

## 📁 Folder structure / Estructura de carpetas

After the first run the folder will look like this / Después del primer uso la carpeta tendrá este aspecto:

```
📂 your-folder/
├── picta.bat          ← Windows script
├── picta.sh           ← Linux script
├── README.md          ← This file
├── videos.txt         ← (optional) list of video IDs for batch mode
├── descargas/         ← downloaded videos go here by default
│   ├── MyVideo.mp4
│   └── MyVideo.srt
└── extras/            ← auto-created, tools stored here
    ├── yt-dlp.exe     ← (Windows) auto-downloaded
    ├── yt-dlp         ← (Linux) auto-downloaded
    ├── ffmpeg/        ← (Windows) auto-downloaded
    └── gpac/
        └── mp4box.exe ← (Windows) place manually
```

---

## ❓ Frequently Asked Questions / Preguntas Frecuentes

**[EN] The window closes immediately on Windows.**  
Make sure you double-click `picta.bat` directly. Do not run it from inside a zip file — extract everything first.

**[ES] La ventana se cierra inmediatamente en Windows.**  
Asegúrate de hacer doble clic directamente en `picta.bat`. No lo ejecutes desde dentro de un archivo zip — extrae todo primero.

---

**[EN] I get a "permission denied" error on Linux.**  
Run `chmod +x picta.sh` in the terminal first.

**[ES] Me aparece un error de "permiso denegado" en Linux.**  
Ejecuta primero `chmod +x picta.sh` en la terminal.

---

**[EN] The download fails or shows an error.**  
Double-check the video ID — copy it carefully from the network inspector. Also make sure the video is actually accessible (some videos may be region-restricted or require a login).

**[ES] La descarga falla o muestra un error.**  
Verifica el ID del video — cópialo con cuidado desde el inspector de red. También asegúrate de que el video sea accesible (algunos videos pueden tener restricciones regionales o requerir inicio de sesión).

---

**[EN] Subtitles are not being generated.**  
Make sure MP4Box is available: on Windows, verify that `extras\gpac\mp4box.exe` exists; on Linux, run `MP4Box -version` in the terminal to confirm it's installed.

**[ES] No se generan los subtítulos.**  
Asegúrate de que MP4Box esté disponible: en Windows, verifica que exista `extras\gpac\mp4box.exe`; en Linux, ejecuta `MP4Box -version` en la terminal para confirmar que está instalado.

---

*PictaCU Downloader v2.0 — for entertainment use only / solo para uso recreativo*
