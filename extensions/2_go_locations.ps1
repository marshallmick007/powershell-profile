if ( $global:go_locations -eq $null)
{
    $global:go_locations = @{}
}
if ( $global:go_rdp_locations -eq $null)
{
    $global:go_rdp_locations = @{}
}
if ( $global:go_web_locations -eq $null)
{
    $global:go_web_locations = @{}
}

function go([string] $location)
{
    $processed = $false
    if ( $global:go_web_locations.ContainsKey($location) )
    {

        $processed = $true
    }
    elseif ($global:go_locations.ContainsKey($location) )
    {
        Set-Location $global:go_locations[$location]
        $processed = $true
    }

    if ( $processed -eq $false )
    {
        Write-Output "The following locations are defined:"
        $print = $global:go_locations.GetEnumerator() | Sort-Object Name
        Write-Output $print
    }
}