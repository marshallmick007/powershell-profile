# Used by posh-git (if using)
$env:TERM="msys"

# Install posh-git and import the module
#Import-Module c:\path\to\posh-git.psm1
#$using_git_prompt_support=$true

# Location of workstation configurations
$config_dir="C:\home\configs"

$scripts = join-path $config_dir "powershell"

$env:HOME = $env:USERPROFILE
$desktop_dir = (join-path $env:HOME "Desktop")
$env:DESKTOP = $desktop_dir

# unix (git) friendly environment variables
$env:EDITOR = "C:\\bin\\vim\\vim74\\gvim.exe"
$env:VISUAL = $env:EDITOR
$env:GIT_EDITOR = $env:EDITOR

# Source global aliases
. (join-path $scripts "Aliases.ps1")

# Source global functions
. (join-path $scripts "Functions.ps1")

# Setup Module paths
$env:PSScriptHome = $scripts
$env:PSModulePath = $env:PSModulePath + ";" + $(join-path $scripts "modules")

# Add scripts folder to PATH
$env:PATH += ";$(join-path $scripts 'scripts')"

function _report_time($stopwatch)
{
    $stopwatch.Stop()
    $output = $([string]::Format(" [{0:d2}:{1:d2}.{2:d3}]",
        $stopwatch.Elapsed.minutes,
        $stopwatch.Elapsed.seconds,
        $stopwatch.Elapsed.milliseconds
    ))
    Write-Host " $output"
}

$global:promptTheme = @{
    prefixColor = [ConsoleColor]::Blue
    pathColor = [ConsoleColor]::Magenta
    pathBracesColor = [ConsoleColor]::DarkGray
    hostNameColor = [ConsoleColor]::DarkGreen
    dateTimeColor = [ConsoleColor]::DarkGray
    returnStatusColor = [ConsoleColor]::Red
    yellow = [ConsoleColor]::Yellow
}

function prompt {
    $realLASTEXITCODE = $LASTEXITCODE + 0
    $prefix = "`n"
    $promptLine = "" + [char]0x00BB + ""
    $shortPath = get-vimShortPath(get-location)
    $dateTime = $(Get-Date).ToString( "ddd. HH:mm:ss" )

    $host.ui.RawUI.WindowTitle = $shortPath
    Write-Host $prefix -NoNewline -ForegroundColor $global:promptTheme.prefixColor

    if ( get-isAdminUser )
    {
        #$hostName = [net.dns]::GetHostName().ToLower()
        #$global:promptTheme.hostNameColor = [ConsoleColor]::Red
        $global:promptTheme.pathColor = [ConsoleColor]::Red
    }

    Write-Host $shortPath -NoNewline -ForegroundColor $global:promptTheme.pathColor

    Write-Host ' {' -NoNewline -ForegroundColor $global:promptTheme.pathBracesColor
    Write-Host $dateTime -NoNewline -ForegroundColor $global:promptTheme.dateTimeColor
    Write-Host '} ' -NoNewline -ForegroundColor $global:promptTheme.pathBracesColor

    if ( $using_git_prompt_support )
    {
        Write-VcsStatus
    }

    Write-Host "`n#:" -NoNewline -ForegroundColor $global:promptTheme.prefixColor

    if ( $realLASTEXITCODE -ne 0 )
    {
        Write-Host "($realLASTEXITCODE)" -NoNewline -ForegroundColor $global:promptTheme.returnStatusColor
    }

    Write-Host $promptLine -NoNewLine

    $global:LASTEXITCODE = 0
    return ' '   
}

# Load All Functions
$p = join-path $scripts "functions"
$files = Get-ChildItem $p -recurse | Where-Object {$_.extension -eq ".ps1"}
foreach ( $file in $files)
{
    . $file.FullName
}

# Load All Extensions
$p = join-path $scripts "extensions"
$files = Get-ChildItem $p -recurse | Where-Object {$_.extension -eq ".ps1"}
foreach ( $file in $files)
{
    Write-Host "$([char]0x25BA) " -ForegroundColor $global:promptTheme.prefixColor -NoNewline
    Write-Host $file -NoNewline -ForegroundColor $global:promptTheme.yellow
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    . $file.FullName
    _report_time $stopwatch
}