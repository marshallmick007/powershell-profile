function mkcd 
{
    if($args.Count -eq 1)
    {
        mkdir $args[0] | set-location
    } 
}

function Get-Base64($textIn)
{
    $b = [System.Text.Encoding]::UTF8.GetBytes($textIn)
    return [System.Convert]::ToBase64String( $b )
}

function Read-Base64($textBase64)
{
    $b = [System.Convert]::FromBase64String($textBase64)
    return [System.text.Encoding]::UTF8.GetString($b)
}

function guid
{
    return [Guid]::NewGuid().ToString()
}

function newguid
{
    guid | Set-Clipboard
}

function get-vimShortPath([string] $path)
{
    $loc = $path.Replace($env:HOME, '~')
    $loc = $loc.Replace($env:WINDIR, '[Windows]')
    #remove prefix for UNC paths
    $loc = $loc -replace '^[^:]+::', ''

    if ( $loc.Length -lt 64 )
    {
        return $loc
    }

    return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)', '\$1$2')
}

function Get-IsAdminUser()
{
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $wp = new-object Security.Principal.WindowsPrincipal($id)

    return $wp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-CommandLocation
{
    Param(
        [string]$command = $(Throw New-Object System.ArgumentException "A command must be specified", "command")
    )

    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'

    Try
    {
        $cmd = Get-Command $command
        if ( $cmd.CommandType -eq "Function" )
        {
            Write-Host $cmd.ScriptBlock
        }
        elseif ( $cmd.CommandType -eq "Alias" )
        {
            Write-Host $cmd.ResolvedCommand
        }
        elseif ( $cmd.CommandType -eq "Application" )
        {
            Write-Host $cmd.Path
        }
    }
    Catch [System.Management.Automation.CommandNotFoundException]
    {
        Write-Host "Command '$command' not found."
    }
    Catch
    {
        Write-Host "Unknown Error"
    }
    Finally
    {
        $ErrorActionPreferece = $oldPreference
    }
}