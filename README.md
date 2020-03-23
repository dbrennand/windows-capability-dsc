# WindowsCapabilityDsc

There's default DSC resources for WindowsFeature and WindowsOptionalFeature,
but not WindowsCapability.

I want to install OpenSSH Server!

**This has been tested on Azure Stack Hub 1910**

## Usage - Portal

```powershell
# Create a zip file which is uploaded using the DSC extension.
Compress-Archive -Path "windows-capability-dsc\*" -DestinationPath "windows-capability-dsc.zip" -Force
```

Configure the DSC extension through the portal as follows:

![DSC Extension Config](extension.png)

## Usage - PowerShell

```powershell
# Copy to local modules as DSC extension publish command requires the modules to be in local modules repo as it is using them to put them inside the zip bundle.
# https://powershell.org/2017/10/using-azure-desired-state-configuration-part-iv/
Copy-Item -Path ".\windows-capability-dsc\WindowsCapabilityDsc" -Destination "C:\Program Files\WindowsPowerShell\Modules" -Recurse -Verbose
# Add DSC files to Azure storage account.
$UrlOutput = Publish-AzureRmVMDscConfiguration -ConfigurationPath ".\windows-capability-dsc\SSHdInstall.ps1" -ResourceGroupName "rg1" -StorageAccountName "mystorageaccount" -SkipDependencyDetection -Force -ErrorAction "Stop" -Verbose:($PSBoundParameters["Verbose"] -eq $true)
# Obtain the .zip file name from the url output.
$UrlOutput = $UrlOutput.Split("/")[-1]
[...]
# Apply the configuration to the VM.
Set-AzureRmVMDscExtension -Version "2.77" -ResourceGroupName "rg1" -VMName "somevm" -ArchiveStorageAccountName "mystorageaccount" -ArchiveBlobName $UrlOutput -AutoUpdate -ConfigurationName "SSH" -Verbose
```
