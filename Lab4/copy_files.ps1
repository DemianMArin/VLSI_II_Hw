# ── Remote-to-Local File Copy Script ──────────────────────────────────────
# Prerequisites: OpenSSH client (built into Windows 10/11)
# Usage: update $RemoteHost and $RemoteUser, then run in PowerShell

# ── Configuration ─────────────────────────────────────────────────────────
$RemoteHost = "128.238.147.11"   # e.g. "192.168.1.10" or "lab.university.edu"
$RemoteUser = "dm6430"
$RemoteBase = "/home/dm6430/SynthesisLab/DCNXT_2021.06/lab1"
$LocalDest  = "C:\Users\demia\Downloads\Deliver"

# Files to copy (relative paths from RemoteBase)
$Files = @(
    "rm_setup/common_setup_hvt.tcl",
    "rm_setup/common_setup_lvt.tcl",
    "scripts/TOP_lvt.con",
    "scripts/TOP_hvt.con"
)

# ── Setup ──────────────────────────────────────────────────────────────────
if (-not (Test-Path $LocalDest)) {
    New-Item -ItemType Directory -Path $LocalDest -Force | Out-Null
    Write-Host "Created local directory: $LocalDest" -ForegroundColor Cyan
}

# ── Copy loop ──────────────────────────────────────────────────────────────
$success = 0; $fail = 0

foreach ($file in $Files) {
    $remotePath = "${RemoteUser}@${RemoteHost}:${RemoteBase}/${file}"
    $fileName   = Split-Path $file -Leaf
    $localFile  = Join-Path $LocalDest $fileName

    Write-Host "Copying $file ..." -NoNewline

    scp "-q" $remotePath $localFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host " OK" -ForegroundColor Green
        $success++
    } else {
        Write-Host " FAILED" -ForegroundColor Red
        $fail++
    }
}

# ── Summary ────────────────────────────────────────────────────────────────
Write-Host "`nDone: $success copied, $fail failed." -ForegroundColor Cyan
if ($fail -gt 0) { Write-Host "Check hostname, credentials, or file paths." -ForegroundColor Yellow }
