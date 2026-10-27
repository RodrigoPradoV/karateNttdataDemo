param(
    [string[]]$Paths = @('target')
)

$ErrorActionPreference = 'Stop'
$extensions = @('.html', '.json', '.xml', '.txt', '.log')
$findings = [System.Collections.Generic.List[string]]::new()
$patterns = @(
    '(?i)"username"\s*:\s*"(?!\*{3,})[^"]+"',
    '(?i)"password"\s*:\s*"(?!\*{3,})[^"]+"',
    '(?i)"token"\s*:\s*"(?!\*{3,})[^"]+"',
    '(?im)^(?:\d+\s*[<>]\s*)?(?:Authorization|Cookie|Set-Cookie):\s*(?!\*{3,})\S+'
)

$files = foreach ($path in $Paths) {
    if (Test-Path -LiteralPath $path) {
        Get-ChildItem -LiteralPath $path -Recurse -File |
            Where-Object { $extensions -contains $_.Extension.ToLowerInvariant() }
    }
}

foreach ($file in $files) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction Stop
    if ($env:BOOKER_PASSWORD -and $content.Contains($env:BOOKER_PASSWORD)) {
        $findings.Add("Valor de BOOKER_PASSWORD detectado en $($file.FullName)")
    }
    if ($env:BOOKER_USERNAME -and $content.Contains($env:BOOKER_USERNAME)) {
        $findings.Add("Valor de BOOKER_USERNAME detectado en $($file.FullName)")
    }
    foreach ($pattern in $patterns) {
        if ($content -match $pattern) {
            $findings.Add("Patrón sensible sin enmascarar detectado en $($file.FullName)")
        }
    }
}

$summaryDirectory = Join-Path (Get-Location) 'target/security'
New-Item -ItemType Directory -Force -Path $summaryDirectory | Out-Null
$summaryPath = Join-Path $summaryDirectory 'secret-scan-summary.txt'

if ($findings.Count -gt 0) {
    @(
        'Resultado: FALLIDO'
        "Fecha UTC: $([DateTime]::UtcNow.ToString('o'))"
        "Archivos inseguros: $($findings.Count)"
        'Los archivos afectados no deben publicarse como artifacts.'
        $findings
    ) | Set-Content -LiteralPath $summaryPath -Encoding UTF8
    throw "Se detectaron $($findings.Count) posibles exposiciones. Consulte el resumen sanitizado."
}

@(
    'Resultado: APROBADO'
    "Fecha UTC: $([DateTime]::UtcNow.ToString('o'))"
    "Archivos de texto revisados: $(@($files).Count)"
    'No se detectaron contraseñas, tokens ni headers de autenticación sin enmascarar.'
) | Set-Content -LiteralPath $summaryPath -Encoding UTF8

Write-Output "Comprobación de secretos aprobada: $(@($files).Count) archivos revisados."
