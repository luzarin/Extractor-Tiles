param(
    [int]$Port = 8090
)

$ErrorActionPreference = "Stop"

$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Push-Location $Root
try {
    uv run uvicorn app:app --reload --host 127.0.0.1 --port $Port
}
finally {
    Pop-Location
}
