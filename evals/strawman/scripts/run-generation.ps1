param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('A', 'B')]
    [string]$Variant,

    [Parameter(Mandatory = $true)]
    [string[]]$CaseIds
)

$ErrorActionPreference = 'Stop'

$evalRoot = Split-Path -Parent $PSScriptRoot
$casesPath = Join-Path $evalRoot 'generation-cases.jsonl'
$templatePath = if ($Variant -eq 'A') {
    Join-Path $evalRoot 'prompts\baseline.md'
} else {
    Join-Path $evalRoot 'prompts\guarded.md'
}
$rawRoot = Join-Path $evalRoot 'results\raw'
$logRoot = Join-Path $evalRoot 'results\logs'
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) 'humantone-strawman-eval'

New-Item -ItemType Directory -Path $rawRoot -Force | Out-Null
New-Item -ItemType Directory -Path $logRoot -Force | Out-Null
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

$allCases = @(
    Get-Content -LiteralPath $casesPath |
        ForEach-Object { $_ | ConvertFrom-Json }
)
$template = Get-Content -LiteralPath $templatePath -Raw

foreach ($caseId in $CaseIds) {
    $case = $allCases | Where-Object { $_.id -eq $caseId }
    if ($null -eq $case) {
        throw "Unknown case id: $caseId"
    }

    $outputPath = Join-Path $rawRoot "$caseId-$Variant.txt"
    $logPath = Join-Path $logRoot "$caseId-$Variant.log"
    if (Test-Path -LiteralPath $outputPath) {
        throw "Refusing to overwrite existing result: $outputPath"
    }

    $prompt = $template.Replace('{{core_thesis}}', [string]$case.core_thesis)
    $prompt = $prompt.Replace('{{writing_task}}', [string]$case.writing_task)

    $runDirectory = Join-Path $tempRoot ([guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $runDirectory | Out-Null

    try {
        $cliOutput = $prompt |
            & codex exec --ephemeral --ignore-user-config --skip-git-repo-check --sandbox read-only --color never -c 'model_reasoning_effort="medium"' -C $runDirectory -o $outputPath - 2>&1 |
            Out-String
        $exitCode = $LASTEXITCODE
        Set-Content -LiteralPath $logPath -Value $cliOutput -Encoding utf8

        if ($exitCode -ne 0) {
            throw "Codex run failed for $caseId-$Variant with exit code $exitCode. See $logPath"
        }
        if (-not (Test-Path -LiteralPath $outputPath) -or (Get-Item -LiteralPath $outputPath).Length -eq 0) {
            throw "Codex run produced no final output for $caseId-$Variant."
        }

        Write-Output "Completed $caseId-$Variant"
    }
    finally {
        if (Test-Path -LiteralPath $runDirectory) {
            $resolvedTempRoot = [System.IO.Path]::GetFullPath($tempRoot).TrimEnd('\') + '\'
            $resolvedRunDirectory = [System.IO.Path]::GetFullPath($runDirectory)
            if (-not $resolvedRunDirectory.StartsWith($resolvedTempRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                throw "Unsafe temporary cleanup target: $resolvedRunDirectory"
            }
            Remove-Item -LiteralPath $resolvedRunDirectory -Recurse -Force
        }
    }
}
