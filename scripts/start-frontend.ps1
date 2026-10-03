$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$portableNode = Join-Path $root '.tools/node.exe'
Push-Location (Join-Path $root 'frontend')
try {
    if (Test-Path $portableNode) {
        $env:PATH = (Join-Path $root '.tools') + ';' + $env:PATH
        & $portableNode 'node_modules/@angular/cli/bin/ng.js' serve --host 127.0.0.1
    } else {
        npm start
    }
} finally { Pop-Location }
