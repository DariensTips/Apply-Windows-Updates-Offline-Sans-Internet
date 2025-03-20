
function doUpdateAndRestartUsingWUSALoop {
    cmd /c ver ; Get-HotFix
    $rebootMessage="Rebooting in 60 seconds following installation of updates."
    $updFolder="C:\Updates"
    $pkgs=(Get-ChildItem $updFolder | Sort-Object name).FullName
    Write-Host "Updating Microsoft Defender Security Intelligence Definition"
    Start-Process -Wait -FilePath $updFolder\mpam-fe.exe
    Write-Host "Updating Microsoft Edge"
    Start-Process -Wait -FilePath $env:windir\System32\msiexec.exe -ArgumentList "/i $updFolder\MicrosoftEdgeEnterpriseX64.msi /qn"
    Write-Host "Updating Using Windows Update Standalone Installer (wusa)"
    foreach ($curPgk in $pkgs) {
        Start-Process -Wait -FilePath "C:\Windows\System32\wusa.exe" -ArgumentList "$curPgk /quiet /norestart"
    }
    & $env:windir\System32\shutdown.exe /r /t 60 /c $rebootMessage
}


# DISM -- May have to run twice
function doUpdateAndRestartUsingDISM {
    cmd /c ver ; Get-HotFix
    $rebootMessage="Rebooting in 60 seconds following installation of updates."
    $updFolder="C:\Updates"
    Write-Host "Updating Microsoft Defender Security Intelligence Definition"
    Start-Process -Wait -FilePath $updFolder\mpam-fe.exe
    Write-Host "Updating Microsoft Edge"
    Start-Process -Wait -FilePath $env:windir\System32\msiexec.exe -ArgumentList "/i $updFolder\MicrosoftEdgeEnterpriseX64.msi /qn"
    Write-Host "Updating Using Deployment Image Servicing and Management (DISM)"
    DISM /Online /Add-Package /PackagePath:$updFolder /NoRestart
    & $env:windir\System32\shutdown.exe /r /t 60 /c $rebootMessage
}


# Add-WindowsPackage -- May have to run twice
function doUpdateAndRestartUsingAddWinPkg {
    cmd /c ver ; Get-HotFix
    $rebootMessage="Rebooting in 60 seconds following installation of updates."
    $updFolder="C:\Updates"
    Write-Host "Updating Microsoft Defender Security Intelligence Definition"
    Start-Process -Wait -FilePath $updFolder\mpam-fe.exe
    Write-Host "Updating Microsoft Edge"
    Start-Process -Wait -FilePath $env:windir\System32\msiexec.exe -ArgumentList "/i $updFolder\MicrosoftEdgeEnterpriseX64.msi /qn"
    Write-Host "Updating Using Add-WindowsPackage CMDLET"
    Add-WindowsPackage -Online -PackagePath $updFolder -NoRestart
    & $env:windir\System32\shutdown.exe /r /t 60 /c $rebootMessage
}
