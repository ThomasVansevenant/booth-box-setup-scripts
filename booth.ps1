# Description: Boxstarter Script
# Setup booth laptops
# Based on https://github.com/microsoft/windows-dev-box-setup-scripts

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$baseUri = $Boxstarter['ScriptToCall']
$strpos = $baseUri.IndexOf($bstrappackage)
$baseUri = $baseUri.Substring($strpos + $bstrappackage.Length)
$baseUri = $baseUri.TrimStart("'", " ")
$baseUri = $baseUri.TrimEnd("'", " ")
$baseUri = $baseUri.Substring(0, $baseUri.LastIndexOf("/"))
$helperUri = $baseUri
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "CommonDevTools.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "Docker.ps1";
executeScript "Browsers.ps1";
executeScript "CommonApps.ps1";

#--- Tools ---
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge

#--- Tools ---
choco install -y visualstudio2019professional

Update-SessionEnvironment #refreshing env due to Git install
choco install -y visualstudio2019-workload-azure
choco install -y nodejs-lts # Node.js LTS, Recommended for most users
choco install -y visualstudio2019buildtools
choco install -y python2 # Node.js requires Python 2 to build native modules



Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
