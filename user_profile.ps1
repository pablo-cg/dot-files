# # #ICONS
# Import-Module -Name Terminal-Icons

# # #PSReadLine
Set-PSReadLineOption -Editmode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History

# Find out if the current user identity is elevated (has admin rights)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Set up command prompt and window title. Use UNIX-style convention for identifying 
# whether user is elevated (root) or not. Window title shows current version of PowerShell
# and appends [ADMIN] if appropriate for easy taskbar identification
function prompt 
{ 
    if ($isAdmin) 
    {
        "[" + (Get-Location) + "] # " 
    }
    else 
    {
        "[" + (Get-Location) + "] $ "
    }
}

$Host.UI.RawUI.WindowTitle = "PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
if ($isAdmin)
{
    $Host.UI.RawUI.WindowTitle += " [ADMIN]"
}

# We don't need these any more; they were just temporary variables to get to $isAdmin. 
# Delete them to prevent cluttering up the user profile. 
Remove-Variable identity
Remove-Variable principal

# Make it easy to edit this profile once it's installed
function Edit-Profile
{
    code $env:USERPROFILE\.config\powershell\user_profile.ps1
}

# ALIAS
Set-Alias -Name su -Value sudo
function ll { Get-ChildItem -Path $pwd -File }
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Users\ramirez\scoop\apps\git\current\usr\bin\tig.exe'
Set-Alias less 'C:\Users\ramirez\scoop\apps\git\current\usr\bin\less.exe'
function reload-profile { & $profile }
function touch($file) { "" | Out-File $file -Encoding ASCII }

# LOAD PROMPT
function Get-ScriptDirectory { Split-Path $MyInvocation.ScriptName }
$PROMPT_CONFIG = Join-Path (Get-ScriptDirectory) 'my.omp.json'
oh-my-posh --init --shell pwsh --config $PROMPT_CONFIG | Invoke-Expression
