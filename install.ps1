
if (!(Get-Command 'scoop' -ErrorAction SilentlyContinue)) {
Write-Host "Installing Scoop..."
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

scoop bucket add java
scoop bucket add main 
# Adding Node.js LTS 20 installation
scoop install nodejs-lts


Write-Host "Installing Java 22 (Temurin JDK)..."
scoop install java/temurin22-jdk

Write-Host "Installing Maven..."
scoop install maven

Write-Host "Installation complete!"

