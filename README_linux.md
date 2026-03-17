# Extractor de Tiles (Linux / WSL2)

Herramienta web para descargar tiles satelitales a partir de un AOI y fusionarlos en un GeoTIFF.

## Proveedores soportados

| Proveedor | Requiere | Notas |
|---|---|---|
| **Apple Maps Satellite** | Access key (expira cada 15 min) | Instalación adicional requerida (ver abajo) |
| **ESRI World Imagery** | — | URL preconfigurada |
| **Google Satellite** | — | URL preconfigurada |
| **Custom XYZ** | URL con `{z}/{x}/{y}` | Cualquier tile server |

## Requisitos

- WSL2 (Ubuntu/Debian) o Linux
- `pyenv` para el manejo de versiones de Python
- Python 3.13+
- Bash

## Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/luzarin/Extractor-Tiles.git
cd tiles_downloader

# 2. Instalar y configurar una versión de Python con pyenv
pyenv install 3.13.11
pyenv local 3.13.11

# 3. Crear y activar el entorno virtual
python -m venv .venv
source .venv/bin/activate

# 4. Instalar dependencias base
pip install -U pip setuptools wheel
pip install -r requirements.txt
```

### Proveedor Apple (opcional)

```bash
# En sistemas basados en Linux no suele ocurrir el problema de encoding, 
# pero puedes forzar UTF-8 de ser necesario.
export PYTHONUTF8=1
pip install --no-deps --no-build-isolation git+https://github.com/Jimut123/jimutmap.git
```

## Uso

Para levantar la API e iniciar la UI de forma local:

```bash
uv run uvicorn app:app --reload --host 127.0.0.1 --port 8095
```

Abre en tu navegador la dirección web: [http://127.0.0.1:8095](http://127.0.0.1:8095)

### Flujo básico

1. Subir archivo AOI (ZIP, GPKG o GeoJSON)
2. Elegir proveedor y nivel de zoom
3. Completar los campos del proveedor seleccionado (si aplica)
4. Hacer clic en **Descargar**
5. El TIFF resultante se guarda en la carpeta `output/`

## Estructura

```
tiles_downloader/
├── api/
│   └── workflow_ui_api.py          # API FastAPI
├── scripts/
│   ├── download_tiles_from_aoi.py  # Motor de descarga y mosaico
│   └── run_workflow_ui.ps1         # Launcher
├── ui/
│   └── workflow.html               # UI
├── output/                         # TIFFs generados
└── requirements.txt                # Dependencias
```

## API

| Método | Endpoint | Descripción |
|---|---|---|
| `GET` | `/` | Sirve la UI |
| `GET` | `/health` | Health check |
| `POST` | `/tiles/start` | Inicia un job de descarga |
| `GET` | `/tiles/jobs` | Lista todos los jobs |
| `GET` | `/tiles/jobs/{job_id}` | Estado de un job |
| `GET` | `/tiles/jobs/{job_id}/logs` | Logs de un job |
| `POST` | `/tiles/jobs/{job_id}/cancel` | Cancela un job |
