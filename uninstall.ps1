$ErrorActionPreference = 'Stop'

$installDirectory = [IO.Path]::GetFullPath(
    (Join-Path $env:LOCALAPPDATA 'Programs\StudyLight')
)
$scriptDirectory = [IO.Path]::GetFullPath($PSScriptRoot)

if (-not [string]::Equals(
    $scriptDirectory.TrimEnd([char]92),
    $installDirectory.TrimEnd([char]92),
    [StringComparison]::OrdinalIgnoreCase
)) {
    Write-Error 'Refusing to uninstall: this script is not running from the StudyLight install directory.'
    exit 1
}

try {
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if ($null -ne $userPath) {
        $remainingEntries = @(
            $userPath.Split(';') | Where-Object {
                -not [string]::Equals(
                    $_.Trim().TrimEnd([char]92),
                    $installDirectory.TrimEnd([char]92),
                    [StringComparison]::OrdinalIgnoreCase
                )
            }
        )
        [Environment]::SetEnvironmentVariable(
            'Path',
            ($remainingEntries -join ';'),
            'User'
        )
    }

    $logName = 'StudyLight-uninstall-{0}.log' -f [Guid]::NewGuid().ToString('N')
    $logPath = Join-Path $env:TEMP $logName
    $cleanupScript = @'
Start-Sleep -Seconds 2
$installDirectory = Join-Path $env:LOCALAPPDATA 'Programs\StudyLight'
try {
    Remove-Item -LiteralPath $installDirectory -Recurse -Force -ErrorAction Stop
} catch {
    $_ | Out-String | Set-Content -LiteralPath $env:STUDYLIGHT_UNINSTALL_LOG
}
'@
    $encodedCleanup = [Convert]::ToBase64String(
        [Text.Encoding]::Unicode.GetBytes($cleanupScript)
    )
    $env:STUDYLIGHT_UNINSTALL_LOG = $logPath
    Start-Process -FilePath 'powershell.exe' `
        -ArgumentList @('-NoProfile', '-EncodedCommand', $encodedCleanup) `
        -WindowStyle Hidden
    Remove-Item Env:\STUDYLIGHT_UNINSTALL_LOG
} catch {
    Write-Error "Uninstall could not be completed: $_"
    exit 1
}

Write-Output 'StudyLight was removed from your user PATH.'
Write-Output 'Its installed files are being removed in the background.'
Write-Output 'Close and reopen Command Prompt to refresh PATH.'
Write-Output "If file cleanup fails, check: $logPath"
