# Nightshift: install, update, start. First time, paste into PowerShell:
#   irm https://raw.githubusercontent.com/TuralIT/.412/main/install.ps1 | iex
# It puts a Nightshift shortcut on the desktop that runs this script before every start: a newer version on GitHub is
# downloaded first (only the changed files, a few MB, when it can), then Nightshift opens. No internet: it just opens.
# Your settings and learned answers live in %APPDATA%\Nightshift and are never touched.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'                # PowerShell 5's progress bar makes downloads crawl
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$repo = 'TuralIT/.412'
$test = [bool]$env:NIGHTSHIFT_DIR                       # test run: another folder, no shortcut, nothing started
$dir = if ($test) { $env:NIGHTSHIFT_DIR } else { Join-Path $env:LOCALAPPDATA 'Programs\Nightshift' }
$exe = Join-Path $dir 'Nightshift\Nightshift.exe'
$ver = Join-Path $dir 'version.txt'                     # "<installed tag> <base tag>"

function Get-Zip($url, $into) {
    $zip = Join-Path $env:TEMP ([IO.Path]::GetRandomFileName() + '.zip')
    try {
        Invoke-WebRequest $url -OutFile $zip -UseBasicParsing
        tar -xf $zip -C $into
        if ($LASTEXITCODE) { throw 'extracting failed' }
    } finally { Remove-Item $zip -ErrorAction SilentlyContinue }
}

try {
    if (Get-Process Nightshift -ErrorAction SilentlyContinue) {
        Write-Host 'Nightshift is open: close it and start it again to update.'
    } else {
        $rel = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest" -UseBasicParsing -TimeoutSec 20
        $tag = $rel.tag_name
        if (Test-Path $ver) { $have, $base = (Get-Content $ver -Raw).Trim() -split '\s+' }
        elseif (Test-Path $exe) { $have, $base = 'v1.0', 'v1.0' }      # installed by the first installer
        else { $have, $base = $null, $null }
        $small = $rel.assets | Where-Object { $_.name -eq "Nightshift-update-from-$base.zip" }
        $full = $rel.assets | Where-Object { $_.name -eq 'Nightshift.zip' }
        if ($have -eq $tag) {
            Write-Host "Nightshift $tag is up to date."
        } elseif ($small -and (Test-Path $exe)) {
            Write-Host "Updating Nightshift $have -> $tag ($([math]::Round($small.size / 1MB, 1)) MB)..."
            Get-Zip $small.browser_download_url $dir
            Set-Content $ver "$tag $base"
        } else {
            Write-Host "Downloading Nightshift $tag ($([math]::Round($full.size / 1MB)) MB)..."
            if (Test-Path $exe) { Remove-Item (Join-Path $dir 'Nightshift') -Recurse -Force }
            elseif (Test-Path $dir) { throw "$dir exists but isn't a Nightshift install - move it away and run this again" }
            New-Item -ItemType Directory $dir -Force | Out-Null
            Get-Zip $full.browser_download_url $dir
            # this full zip is the base for later small updates: the base its own small update starts from, or itself
            $up = $rel.assets | Where-Object { $_.name -like 'Nightshift-update-from-*.zip' } | Select-Object -First 1
            $base = if ($up) { $up.name -replace '^Nightshift-update-from-(.+)\.zip$', '$1' } else { $tag }
            Set-Content $ver "$tag $base"
            $learned = Join-Path $env:USERPROFILE 'Desktop\meth_learned.json'   # Nightshift offers to import it once
            $src = Join-Path $dir 'meth_learned.json'
            if (-not $test -and (Test-Path $src) -and (Test-Path (Split-Path $learned)) -and -not (Test-Path $learned)) {
                Copy-Item $src $learned
            }
        }
        if (-not $test) {                                   # this script, kept next to the app for the shortcut
            $self = Join-Path $dir 'Nightshift-update.ps1'
            Invoke-WebRequest "https://raw.githubusercontent.com/$repo/main/install.ps1" -OutFile $self -UseBasicParsing
            $lnk = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'Nightshift.lnk'))
            $lnk.TargetPath = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
            $lnk.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$self`""
            $lnk.WorkingDirectory = $dir
            $lnk.IconLocation = "$exe,0"
            $lnk.Save()
        }
    }
} catch {
    Write-Warning "Update skipped: $_"
}
if ($test) { return }
if (Test-Path $exe) { Start-Process $exe }
else { Write-Host 'Nightshift is not installed yet - check your internet and run the install line again.' -ForegroundColor Red }
