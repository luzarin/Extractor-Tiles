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
git clone https://github.com/luzarin/Extractor_Tiles.git
cd Extractor_Tiles

# 2. Instalar y configurar versión de Python
pyenv install 3.13.11
pyenv local 3.13.11

# 3. Crear y activar entorno virtual
python -m venv .venv
source .venv/bin/activate

# 4. Instalar dependencias
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

