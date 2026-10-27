param(
    [string]$CommandResult = 'unknown'
)

$ErrorActionPreference = 'Stop'
$outputDirectory = Join-Path (Get-Location) 'target/evidence'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
$sha = (git rev-parse HEAD).Trim()
$javaVersion = (& java -version 2>&1 | Select-Object -First 1)
$mavenVersion = (& mvn -version 2>&1 | Select-Object -First 1)

@(
    'Repositorio: karateNttdataDemo'
    "Commit SHA: $sha"
    "Fecha UTC: $([DateTime]::UtcNow.ToString('o'))"
    "Java: $javaVersion"
    "Maven: $mavenVersion"
    'Comando: mvn -B -ntp clean test'
    "Resultado real: $CommandResult"
) | Set-Content -LiteralPath (Join-Path $outputDirectory 'execution-summary.txt') -Encoding UTF8
