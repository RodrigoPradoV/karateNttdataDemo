param(
    [string]$CommandResult = 'unknown',
    [string]$ExecutedCommand = 'mvn -B -ntp clean test'
)

$ErrorActionPreference = 'Stop'
$outputDirectory = Join-Path (Get-Location) 'target/evidence'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
$sha = (git rev-parse HEAD).Trim()
$javaVersion = (& java --version | Select-Object -First 1).ToString()
$mavenVersion = (& mvn -version 2>&1 | Select-Object -First 1).ToString()

@(
    'Repositorio: karateNttdataDemo'
    "Commit SHA: $sha"
    "Fecha UTC: $([DateTime]::UtcNow.ToString('o'))"
    "Java: $javaVersion"
    "Maven: $mavenVersion"
    "Comando: $ExecutedCommand"
    "Resultado real: $CommandResult"
) | Set-Content -LiteralPath (Join-Path $outputDirectory 'execution-summary.txt') -Encoding UTF8
