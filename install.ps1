
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}


$currentPolicy = Get-ExecutionPolicy
if ($currentPolicy -eq 'Restricted' -or $currentPolicy -eq 'AllSigned')
{
    Write-Warning "Current execution policy is $currentPolicy, which might prevent some scripts from running.`nConsider setting the policy to RemoteSigned or Bypass if you encounter issues."
}
else
{
    Write-Host "Current execution policy is $currentPolicy. The script will proceed."
}


if (!(Get-Command 'scoop' -ErrorAction SilentlyContinue))
{
    Write-Host "Installing Scoop..."
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}


scoop bucket add java
scoop bucket add main 
# Adding Node.js LTS 20 installation
scoop install nodejs-lts

if (!(scoop list | Select-String "temurin22-jdk"))
{
    Write-Host "Installing Java 22 (Temurin JDK)..."
    scoop install java/temurin22-jdk
}


if (!(scoop list | Select-String "maven"))
{
    Write-Host "Installing Maven..."
    scoop install maven
}

Write-Host "Installation complete!"

