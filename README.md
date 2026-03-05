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

```powershell
# 1. Clonar el repositorio
git clone https://github.com/luzarin/Extractor-Tiles.git
cd tiles_downloader

# 2. Crear y activar entorno virtual
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# 3. Instalar dependencias
pip install -U pip setuptools wheel
pip install -r requirements.txt
```
### Proveedor Apple (opcional)
```powershell
$env:PYTHONUTF8 = "1" # forzar UTF-8 por si acaso
pip install --no-deps --no-build-isolation git+https://github.com/Jimut123/jimutmap.git
```

## Uso

```powershell
.\scripts\run_workflow_ui.ps1 -Port 8095
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
