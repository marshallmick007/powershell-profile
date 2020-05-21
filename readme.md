
## Configuring your Profile

Profiles are located in multiple locations

- `%windir%\system32\WindowsPowersShell\v1.0\profile.ps1` This profile applies to all users and all shells
- `%UserProfile%\My Documents\WindowsPowerShell\Microsoft.Powershell_profile.ps1` - applies to the current user and just the Powershell prompt (ie: not nuget package manager shell or other custom shells). This path is aliased as `$profile` in powershell

## Enable Script Execution

First, open a Powershell Administrators shell

```powershell
PS> Set-ExecutionPolicy RemoteSigned
```