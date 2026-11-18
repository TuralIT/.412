# Nightshift installer: downloads the latest release, installs it for this Windows user, adds a desktop shortcut and
# starts it. Run it again to update (your settings in %APPDATA%\Nightshift are kept).
#   irm https://raw.githubusercontent.com/TuralIT/.412/main/install.ps1 | iex
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'                # PowerShell 5's progress bar makes big downloads crawl
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$dir = Join-Path $env:LOCALAPPDATA 'Programs\Nightshift'
$exe = Join-Path $dir 'Nightshift\Nightshift.exe'
$zip = Join-Path $env:TEMP 'Nightshift.zip'

Write-Host 'Downloading Nightshift (~210 MB)...'
Invoke-WebRequest 'https://github.com/TuralIT/.412/releases/latest/download/Nightshift.zip' -OutFile $zip -UseBasicParsing

Get-Process Nightshift -ErrorAction SilentlyContinue | Stop-Process -Force    # updating: close the old one first
if (Test-Path $dir) {
    if (-not (Test-Path $exe)) { throw "$dir exists but isn't a Nightshift install - move it away and run this again" }
    Start-Sleep -Seconds 1
    Remove-Item $dir -Recurse -Force
}
New-Item -ItemType Directory $dir | Out-Null
Write-Host 'Extracting...'
tar -xf $zip -C $dir
if ($LASTEXITCODE) { throw 'Extracting failed' }
Remove-Item $zip

# learned meth answers: Nightshift offers to import a meth_learned.json from the Desktop on its first start
$learned = Join-Path $env:USERPROFILE 'Desktop\meth_learned.json'
if ((Test-Path (Split-Path $learned)) -and -not (Test-Path $learned)) { Copy-Item (Join-Path $dir 'meth_learned.json') $learned }

$lnk = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'Nightshift.lnk'))
$lnk.TargetPath = $exe
$lnk.WorkingDirectory = Split-Path $exe
$lnk.Save()
Write-Host "Installed to $dir - starting Nightshift (desktop shortcut: Nightshift)"
Start-Process $exe
