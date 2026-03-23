# Extractor de Tiles (Windows PowerShell)

Herramienta web para descargar tiles satelitales a partir de un AOI y fusionarlos en un GeoTIFF.

## Proveedores soportados

| Proveedor | Requiere | Notas |
|---|---|---|
| **Apple Maps Satellite** | Access key (expira cada 15 min) | Instalación adicional requerida (ver abajo) |
| **ESRI World Imagery** | — | URL preconfigurada |
| **Google Satellite** | — | URL preconfigurada |
| **Custom XYZ** | URL con `{z}/{x}/{y}` | Cualquier tile server |

## Requisitos

- Python 3.13.11
- PowerShell

## Instalación

Se recomienda el uso de **`uv`** para instalar una versión específica de Python.

```powershell
# 1. Instalar uv
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

# 2. Instalar versión de Python
uv python install 3.13.11

# 3. Clonar el repositorio
git clone https://github.com/luzarin/Extractor_Tiles.git
cd Extractor_Tiles

# 4. Crear y activar entorno virtual
uv venv --python 3.13.11 .venv
.\.venv\Scripts\Activate.ps1

# 5. Instalar dependencias
uv pip install -r requirements.txt
```
### Proveedor Apple (opcional)
```powershell
$env:PYTHONUTF8 = "1" # forzar UTF-8 por si acaso
uv pip install --no-deps --no-build-isolation git+https://github.com/Jimut123/jimutmap.git
```

## Uso

```powershell
uv run uvicorn app:app --reload --host 127.0.0.1 --port 8095
```

Abrir en el navegador: [http://127.0.0.1:8095](http://127.0.0.1:8095)

### Flujo básico

1. Subir archivo AOI (ZIP, GPKG o GeoJSON)
2. Elegir proveedor y nivel de zoom
3. Completar los campos del proveedor seleccionado (si aplica)
4. Hacer clic en **Descargar**
5. El TIFF resultante se guarda en `output/`

## Estructura

```
extractor_tiles/
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

Base path actual: `/api/v1`
Compatibilidad: `/api/v0` (legacy).

| Metodo | Endpoint | Status | Descripcion |
|---|---|---|---|
| `GET` | `/` | `200` | Sirve la UI (fuera del schema OpenAPI) |
| `GET` | `/api/v1/health` | `200` | Health check |
| `POST` | `/api/v1/tiles/start` | `202`, `400`, `422` | Inicia un job asincrono y devuelve `job_id` |
| `GET` | `/api/v1/tiles/jobs` | `200` | Lista jobs |
| `GET` | `/api/v1/tiles/jobs/{job_id}` | `200`, `404`, `422` | Estado completo de un job |
| `GET` | `/api/v1/tiles/jobs/{job_id}/logs` | `200`, `404`, `422` | Logs de un job |
| `POST` | `/api/v1/tiles/jobs/{job_id}/cancel` | `200`, `404`, `422` | Solicita cancelacion |