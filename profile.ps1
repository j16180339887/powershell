# Python2 UTF8
$env:PYTHONIOENCODING = "UTF-8"
# Java UTF8
$env:JAVA_TOOL_OPTIONS = " -Dfile.encoding=UTF8 "
# Python2 Disable ssl checking
$env:PYTHONHTTPSVERIFY = 0

# Increase history size
$global:MaximumHistoryCount = 10000

try {
  # UTF8
  [Console]::InputEncoding = [Text.UTF8Encoding]::UTF8
  [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

  # Increase history in console buffer
  [Console]::BufferHeight = 20000
} catch [Exception] {
  # Older version of powershell does't support [Console]
  chcp 65001
}

if (Get-Command Set-PSReadlineOption -errorAction SilentlyContinue)
{
  # Disable beep
  Set-PSReadlineOption -BellStyle None

  # Bash-like keys
  Set-PSReadlineOption -EditMode Emacs
}

if (Get-Command Set-PSReadlineKeyHandler -errorAction SilentlyContinue)
{
  # Zsh-like completion
  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

  # Key mappings
  Set-PSReadlineKeyHandler -Key UpArrow   -Function HistorySearchBackward
  Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
  Set-PSReadlineKeyHandler -Chord Ctrl+RightArrow -Function ForwardWord
  Set-PSReadlineKeyHandler -Chord Ctrl+LeftArrow  -Function BackwardWord
  Set-PSReadlineKeyHandler -Chord Ctrl+X -Function Cut
  # Set-PSReadlineKeyHandler -Chord Ctrl+V -Function Paste
  Set-PSReadlineKeyHandler -Chord Ctrl+G -Function SelectAll
  Set-PSReadlineKeyHandler -Chord Ctrl+K -Function DeleteLine
  Set-PSReadlineKeyHandler -Chord Ctrl+Z -Function Undo
  Set-PSReadlineKeyHandler -Chord Ctrl+Y -Function Redo
  Set-PSReadlineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord
  Set-PSReadlineKeyHandler -Chord Shift+Insert -Function Paste
  Set-PSReadlineKeyHandler -Chord Ctrl+O -ScriptBlock {
    explorer.exe .
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+T -ScriptBlock {
    # To do
    Invoke-Item $env:USERPROFILE'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk'
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+L -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("clear")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+F -ScriptBlock {
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert( "while(1){ " + $line + " ; if(`$?){break} }")
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+V -ScriptBlock {
    $clipboard = Get-Clipboard -Raw
    $clipboard = $clipboard -replace "&","``&"
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($clipboard)
  }
}


# Set default starting path to USERPROFILE
Set-Location $([Environment]::GetFolderPath("Desktop"))

# Theme
$Host.UI.RawUI.ForegroundColor = "Gray"
# $Host.UI.RawUI.BackgroundColor = "Black"

if (Get-Command Set-PSReadlineOption -errorAction SilentlyContinue)
{
  Set-PSReadlineOption -TokenKind None      -ForegroundColor Red
  Set-PSReadlineOption -TokenKind Comment   -ForegroundColor Gray
  Set-PSReadlineOption -TokenKind Keyword   -ForegroundColor White
  Set-PSReadlineOption -TokenKind String    -ForegroundColor Yellow
  Set-PSReadlineOption -TokenKind Operator  -ForegroundColor White
  Set-PSReadlineOption -TokenKind Variable  -ForegroundColor White
  Set-PSReadlineOption -TokenKind Command   -ForegroundColor Green
  Set-PSReadlineOption -TokenKind Parameter -ForegroundColor White
  Set-PSReadlineOption -TokenKind Type      -ForegroundColor White
  Set-PSReadlineOption -TokenKind Number    -ForegroundColor Cyan
  Set-PSReadlineOption -TokenKind Member    -ForegroundColor White
}

Function Prompt {
  try {
   Write-Host  "$([Char]9581)$([Char]9472)" -NoNewline
  } catch [Exception] {
    # Older version of powershell doesn't support special characters
  }
  Write-Host  "$env:username" -NoNewline -ForegroundColor Red
  If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host  "(Admin)" -NoNewline -ForegroundColor Yellow
  }
  Write-Host "@" -NoNewline
  Write-Host "$env:computername" -NoNewline -ForegroundColor Green
  Write-Host " " -NoNewline
  # Use full path since it's easier to understand for newbies
#   Write-Host "$PWD".Replace("$HOME", "~") -ForegroundColor Yellow
  Write-Host "$PWD" -ForegroundColor Cyan
  try {
   Write-Host  "$([Char]9584)$([Char]9472)" -NoNewline
  } catch [Exception] {
    # Older version of powershell doesn't support special characters
  }
  Write-Host "$" -NoNewline
  Return " "
}

# alias bash/zsh command
If (Test-Path alias:which)  {Remove-Item alias:which}
If (Test-Path alias:cd)     {Remove-Item alias:cd}
If (Test-Path alias:grep)   {Remove-Item alias:grep}
If (Test-Path alias:ls)     {Remove-Item alias:ls}
If (Test-Path alias:rm)     {Remove-Item alias:rm}

if (Get-Command curl.exe -errorAction SilentlyContinue) {
    If (Test-Path alias:curl)  {Remove-Item alias:curl}
}

Function cd {
  if ($args.count -gt 0) {
    Set-Location $($args)
  } else {
    Set-Location $($env:USERPROFILE)
  }
}
Function find {
  Get-ChildItem -Recurse -Force -Filter "*$args*" | Where-Object { $_.fullname -NotLike "*.git\*" }
}
Function grep {
  $pipeline = $input | Out-String -stream
  if ($pipeline.length -gt 0) {
    $pipeline | Out-String -stream | Select-String $args | Select Path, LineNumber, Line | Format-List
  } else {
    Get-ChildItem -Recurse -Force | Where-Object { $_.fullname -NotLike "*.git\*" } | Select-String $args | Select Path, LineNumber, Line | Format-List
  }
}
Function ls {
  Get-ChildItem -Force $args
}
Function rm {
  $numOfArgs = $args.Length
  for ($i=0; $i -lt $numOfArgs; $i++) {
    Remove-Item -Recurse -Force $($args[$i])
  }
}
Function touch {
  $numOfArgs = $args.Length
  for ($i=0; $i -lt $numOfArgs; $i++) {
    echo $null >> $($args[$i])
  }
}
Function uname {
  try {
    systeminfo
    Write-Host "All of the Graphics cards Informations " -BackgroundColor DarkRed
    wmic path win32_VideoController get Name
    wmic path win32_VideoController get VideoModeDescription
    wmic path win32_VideoController get CurrentRefreshRate
    wmic path win32_VideoController get MaxRefreshRate
    wmic path win32_VideoController get MinRefreshRate
    wmic path win32_VideoController get DriverDate
    wmic path win32_VideoController get DriverVersion
  } catch [Exception] {
    # Older version of powershell doesn't support Get-CimInstance
    systeminfo
    Get-WmiObject Win32_OperatingSystem
  }
  Get-PSDrive -PSProvider 'FileSystem'
}
Function which {
  $cmd = $args
  try {
    Get-Command -All $cmd
    Get-Command -All -ShowCommandInfo $cmd
  } catch [Exception] {
    # Old version doesn't support -All and -ShowCommandInfo
    Get-Command $cmd
  }
}

# Choco tab completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Choco variables
try {
  [Environment]::SetEnvironmentVariable("ChocolateyBinRoot", $env:ALLUSERSPROFILE, [EnvironmentVariableTarget]::Machine)
  [Environment]::SetEnvironmentVariable("ChocolateyToolsLocation", $env:ALLUSERSPROFILE, [EnvironmentVariableTarget]::Machine)
  [Environment]::SetEnvironmentVariable("ChocolateyBinRoot", $env:ALLUSERSPROFILE, [EnvironmentVariableTarget]::User)
  [Environment]::SetEnvironmentVariable("ChocolateyToolsLocation", $env:ALLUSERSPROFILE, [EnvironmentVariableTarget]::User)
} catch [Exception] {
  $env:ChocolateyBinRoot = $env:ALLUSERSPROFILE
  $env:ChocolateyToolsLocation = $env:ALLUSERSPROFILE
}

# Import modules from Powershell Gallery
if (Get-Module -ListAvailable -Name posh-git) {
  Import-Module posh-git
}
if (Get-Module -ListAvailable -Name posh-docker) {
  Import-Module posh-docker
}

# Command to upgrade all chocolatey packages
Function upgradeChoco {
  choco upgrade all -y --pre
}

# Command to upgrade all powershell modules
Function upgradeModule {
  Update-Module
}

# Command to upgrade all Conda packages
Function upgradeConda {
  conda update -n base conda -y
  conda update --all --yes
}
Function upgradeYoutube-dl {
  pip3 install --upgrade https://github.com/rg3/youtube-dl/archive/master.zip
}
Function upgradeYou-get {
  pip3 install --upgrade https://github.com/soimort/you-get/archive/develop.zip
}
Function upgradePip {
  pip freeze -l > requirements.txt
  (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
  pip install -r requirements.txt --upgrade
  Remove-Item requirements.txt
  pip install --upgrade https://github.com/pyca/pyopenssl/archive/master.zip
  pip install --upgrade https://github.com/requests/requests/archive/master.zip
}
Function upgradeNpm {
  npm update -g
}
Function upgradeProfile {
  $url = "https://raw.githubusercontent.com/j16180339887/powershell/master/profile.ps1"
  $path = $Profile.CurrentUserAllHosts

  if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) {
    $targetFile = Join-Path $pwd (Split-Path -leaf $path)
  }

  (New-Object System.Net.WebClient).DownloadFile($url, $path)
}
Function upgradeVimrc {
  $url = "https://raw.githubusercontent.com/j16180339887/vimrc/master/.vimrc"
  $path = "$env:USERPROFILE\.vimrc"

  if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) {
    $targetFile = Join-Path $pwd (Split-Path -leaf $path)
  }

  (New-Object System.Net.WebClient).DownloadFile($url, $path)
}

Function gvim {
  $Commandvim = "$env:ALLUSERSPROFILE\chocolatey\bin\gvim.exe"
  $Parmsvim = ""
  if ($args.count -gt 0) {
    $Parmsvim = "-p --remote-tab-silent $args"
    $Parmsvim = $Parmsvim.Split(" ")
  }
  & "$Commandvim" $Parmsvim
}

$env:DOWNLOADARGS="--continue=true --file-allocation=none --check-certificate=false --content-disposition-default-utf8=true --max-tries=0 --max-concurrent-downloads=150 --max-connection-per-server=16 --split=16 --min-split-size=1M --bt-max-peers=0 --bt-request-peer-speed-limit=100M --seed-ratio=0 --bt-detach-seed-only=true --parameterized-uri=true"
Function aria2c {
  Invoke-Expression "aria2c.exe $env:DOWNLOADARGS '$args'"
}
Function aria2c-asus-proxy-kungfu {
  Invoke-Expression "aria2c.exe $env:DOWNLOADARGS --all-proxy=kungfu:howkungfu@10.78.20.186:3128 --all-proxy-user=kungfu --all-proxy-passwd=howkungfu '$args'"
}
Function aria2c-asus-proxy-zscaler {
  Invoke-Expression "aria2c.exe $env:DOWNLOADARGS --all-proxy=gateway.zscaler.net:80 '$args'"
}
Function aria2c-asus-cert {
  Invoke-Expression "aria2c.exe --check-certificate=true --ca-certificate=$env:USERPROFILE\\Documents\\asus.com.crt -c -s16 -k1M -x16 '$args'"
}
Function youtube-dl {
  youtube-dl.exe -o "%(title)s.%(ext)s" -f "bestvideo[height<=1080][fps<=30]+bestaudio/best" --write-sub --sub-lang zh-TW,zh-Hant,zh-CN,zh-Hans,en,enUS,English --ignore-errors --external-downloader aria2c --external-downloader-args $env:DOWNLOADARGS $args
}
Function youtube-dl-mp3 {
  youtube-dl.exe -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 --write-sub --sub-lang zh-TW,zh-Hant,zh-CN,zh-Hans,en,enUS,English --ignore-errors --external-downloader aria2c --external-downloader-args $env:DOWNLOADARGS $args
}
set-alias mp3 youtube-dl-mp3

Function Reset-Networking {
  ipconfig /release
  ipconfig /renew
  arp -d *
  nbtstat -R
  nbtstat -RR
  ipconfig /flushdns
  ipconfig /registerdns
  netsh winsock reset
}
Function Reset-Networking-Per10m {
  while($true)
  {
    Reset-Networking
    Start-Sleep -s 600
  }
}

Function MtuForWifiGaming {
  netsh interface ipv4 set subinterface Wi-Fi mtu=296  store=persistent
}
Function MtuForWifiNormal {
  netsh interface ipv4 set subinterface Wi-Fi mtu=1500 store=persistent
}

if(Test-Path -Path "$env:ALLUSERSPROFILE\chocolatey\bin") {
  # Just in case
  if($env:Path -NotLike "*$env:ALLUSERSPROFILE\chocolatey\bin*") {
    $env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"
  }
}

if (Test-Path -Path "$env:USERPROFILE\.pythonrc") {
  $env:PYTHONSTARTUP = "$env:USERPROFILE\.pythonrc"
} elseif (Test-Path -Path "$env:USERPROFILE\.pythonrc.py") {
  $env:PYTHONSTARTUP = "$env:USERPROFILE\.pythonrc.py"
}

Function getConda2path()
{
  # choco install miniconda
  if(Test-Path -Path "C:\ProgramData\Miniconda2")         { return "C:\ProgramData\Miniconda2" }
  if(Test-Path -Path "$env:ALLUSERSPROFILE\Miniconda2")   { return "$env:ALLUSERSPROFILE\Miniconda2" }
  if(Test-Path -Path "$env:ALLUSERSPROFILE\miniconda2")   { return "$env:ALLUSERSPROFILE\miniconda2" }
  if(Test-Path -Path "$env:ALLUSERSPROFILE\Anaconda2")    { return "$env:ALLUSERSPROFILE\Anaconda2" }
  if(Test-Path -Path "$env:ALLUSERSPROFILE\anaconda2")    { return "$env:ALLUSERSPROFILE\anaconda2" }
  if(Test-Path -Path "$env:LOCALAPPDATA\Continuum\Miniconda2")   { return "$env:LOCALAPPDATA\Continuum\Miniconda2" }
  if(Test-Path -Path "$env:LOCALAPPDATA\Continuum\miniconda2")   { return "$env:LOCALAPPDATA\Continuum\miniconda2" }
  if(Test-Path -Path "$env:LOCALAPPDATA\Continuum\Anaconda2")    { return "$env:LOCALAPPDATA\Continuum\Anaconda2" }
  if(Test-Path -Path "$env:LOCALAPPDATA\Continuum\anaconda2")    { return "$env:LOCALAPPDATA\Continuum\anaconda2" }
  return ""
}


$c2 = getConda2path
if ($c2 -ne "") {
  $env:Path = "$c2;$env:Path"
  $env:Path = "$c2\Scripts;$env:Path"
  Set-Alias pip2 "$c2\Scripts\pip.exe"
  Set-Alias conda2 "$c2\Scripts\conda.exe"
  Set-Alias python2 "$c2\python.exe"
  Function upgradeConda2 {
    Invoke-Expression "$c2\Scripts\conda.exe update -n base conda -y"
    Invoke-Expression "$c2\Scripts\conda.exe update --all --yes"
  }
  Function upgradePip2 {
    Invoke-Expression "$c2\Scripts\pip.exe freeze -l > requirements.txt"
    (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
    Invoke-Expression "$c2\Scripts\pip.exe install -r requirements.txt --upgrade"
    Remove-Item requirements.txt
    Invoke-Expression "$c2\Scripts\pip.exe install --upgrade https://github.com/pyca/pyopenssl/archive/master.zip"
    Invoke-Expression "$c2\Scripts\pip.exe install --upgrade https://github.com/requests/requests/archive/master.zip"
  }
}

Function getConda3path()
{
  # choco install miniconda3
  if(Test-Path -Path "C:\ProgramData\Miniconda3")         { return "C:\ProgramData\Miniconda3" }
  if(Test-Path -Path "$env:ALLUSERSPROFILE\Miniconda3")   { return "$env:ALLUSERSPROFILE\Miniconda3" }
  if(Test-Path -Path "$env:ALLUSERSPROFILE\miniconda3")   { return "$env:ALLUSERSPROFILE\miniconda3" }
  if(Test-Path -Path "$env:ALLUSERSPROFILE\Anaconda3")    { return "$env:ALLUSERSPROFILE\Anaconda3" }
  if(Test-Path -Path "$env:ALLUSERSPROFILE\anaconda3")    { return "$env:ALLUSERSPROFILE\anaconda3" }
  if(Test-Path -Path "$env:LOCALAPPDATA\Continuum\Miniconda3")  { return "$env:LOCALAPPDATA\Continuum\Miniconda3" }
  if(Test-Path -Path "$env:LOCALAPPDATA\Continuum\miniconda3")  { return "$env:LOCALAPPDATA\Continuum\miniconda3" }
  if(Test-Path -Path "$env:LOCALAPPDATA\Continuum\Anaconda3")   { return "$env:LOCALAPPDATA\Continuum\Anaconda3" }
  if(Test-Path -Path "$env:LOCALAPPDATA\Continuum\anaconda3")   { return "$env:LOCALAPPDATA\Continuum\anaconda3" }
  return ""
}

$c3 = getConda3path
if ($c3 -ne "") {
  $env:Path = "$c3;$env:Path"
  $env:Path = "$c3\Scripts;$env:Path"
  Set-Alias pip3 "$c3\Scripts\pip.exe"
  Set-Alias conda3 "$c3\Scripts\conda.exe"
  Set-Alias python3 "$c3\python.exe"
  Function upgradeConda3 {
    Invoke-Expression "$c3\Scripts\conda.exe update -n base conda -y"
    Invoke-Expression "$c3\Scripts\conda.exe update --all --yes"
  }
  Function upgradePip3 {
    Invoke-Expression "$c3\Scripts\pip.exe freeze -l > requirements.txt"
    (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
    Invoke-Expression "$c3\Scripts\pip.exe install -r requirements.txt --upgrade"
    Remove-Item requirements.txt
    Invoke-Expression "$c3\Scripts\pip.exe install --upgrade https://github.com/pyca/pyopenssl/archive/master.zip"
    Invoke-Expression "$c3\Scripts\pip.exe install --upgrade https://github.com/requests/requests/archive/master.zip"
  }
}

if(Test-Path -Path "C:\Program Files\OpenSSH-Win64") {
  # choco install openssh
  if($env:Path -NotLike "*C:\Program Files\OpenSSH-Win64*") {
    $env:Path += ";C:\Program Files\OpenSSH-Win64"
  }
}
if(Test-Path -Path "C:\Program Files\Sublime Text 3") {
  # choco install sublimetext3
  if($env:Path -NotLike "*C:\Program Files\Sublime Text 3*") {
    $env:Path += ";C:\Program Files\Sublime Text 3"
  }
}
if(Test-Path -Path "C:\Program Files\Sublime Text 2") {
  # choco install sublimetext2
  if($env:Path -NotLike "*C:\Program Files\Sublime Text 2*") {
    $env:Path += ";C:\Program Files\Sublime Text 2"
  }
}
if(Test-Path -Path "C:\Program Files\Microsoft VS Code") {
  # VS code insider
  if($env:Path -NotLike "*C:\Program Files\Microsoft VS Code*") {
    $env:Path += ";C:\Program Files\Microsoft VS Code"
  }
}
if(Test-Path -Path "C:\Program Files\Microsoft VS Code Insiders") {
  # VS code insider
  if($env:Path -NotLike "*C:\Program Files\Microsoft VS Code Insiders*") {
    $env:Path += ";C:\Program Files\Microsoft VS Code Insiders"
  }
}
if(Test-Path -Path "C:\Program Files\Nmap") {
  # choco install nmap
  if($env:Path -NotLike "*C:\Program Files\Nmap*") {
    $env:Path += ";C:\Program Files\Nmap"
  }
}
if(Test-Path -Path "C:\Program Files (x86)\Nmap") {
  # choco install nmap
  if($env:Path -NotLike "*C:\Program Files (x86)\Nmap*") {
    $env:Path += ";C:\Program Files (x86)\Nmap"
  }
}
if (Test-Path -Path "C:\zulu"){
  # Download openjdk from Zulu
  $env:JAVA_HOME="C:\zulu"
  if($env:Path -NotLike "*C:\zulu\bin*") {
    $env:Path += ";C:\zulu\bin"
  }
}
if (Test-Path -Path "C:\Program Files\Oracle\VirtualBox"){
  # choco install virtualbox
  if($env:Path -NotLike "*C:\Program Files\Oracle\VirtualBox*") {
    $env:Path += ";C:\Program Files\Oracle\VirtualBox"
  }
}
