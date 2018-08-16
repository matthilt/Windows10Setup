<#
    Script name: 	Set-RegistrySettings.ps1
	Version:     	1803.1.0
	Purpose:		Sets my desired registry settings for a default install
    Author:      	Matt Hilton
    Contact:     	matthilt@gmail.com
    DateCreated: 	2018-08-16
    LastUpdate:  	2018-08-16
#>

$KeyCUMicrosoft = "HKCU:\SOFTWARE\Microsoft"
Set-ItemProperty -Path "$KeyCUMicrosoft\Gamebar" -Name "ShowStartupPanel" -Value 0 # Disable GameBar Tips

$KeyCUCurrentVersion = "$KeyCUMicrosoft\Windows\CurrentVersion"
If (-Not (Test-Path "$KeyCUCurrentVersion\AdvertisingInfo")) { New-Item -Path $KeyCUCurrentVersion -Name "AdvertisingInfo" | Out-Null}
Set-ItemProperty -Path "$KeyCUCurrentVersion\AdvertisingInfo" -Name Enabled -Type DWord -Value 0 # Disable Let apps use my advertising ID
Set-ItemProperty -Path "$KeyCUCurrentVersion\AppHost" -Name EnableWebContentEvaluation -Type DWord -Value 0 # Disable SmartScreen Filter for Store Apps

$KeyCUExplorer = "$KeyCUCurrentVersion\Explorer"
Set-ItemProperty -Path $KeyCUExplorer -Name EnableAutoTray -Value 0 # Show all icons in tray
Set-ItemProperty -Path $KeyCUExplorer -Name ShowRecent -Type DWord -Value 0 # Disable Quick Access: Recent Files
Set-ItemProperty -Path $KeyCUExplorer -Name ShowFrequent -Type DWord -Value 0 # Disable Quick Access: Frequent Folders

$KeyCUAdvanced = "$KeyCUExplorer\Advanced"
Set-ItemProperty -Path $KeyCUAdvanced -Name AutoCheckSelect -Value 0 # Disable check boxes
Set-ItemProperty -Path $KeyCUAdvanced -Name HideFileExt 0 # Show File Extensions
Set-ItemProperty -Path $KeyCUAdvanced -Name LaunchTo -Type DWord -Value 1 # Change Explorer home screen back to "This PC"
Set-ItemProperty -Path $KeyCUAdvanced -Name MMTaskbarMode -Value 0 # Show taskbar buttons on all taskbars
Set-ItemProperty -Path $KeyCUAdvanced -Name NavPaneExpandToCurrentFolder -Value 1 # Expand This PC to open folder in Nav Pane
Set-ItemProperty -Path $KeyCUAdvanced -Name NavPaneShowAllFolders -Value 1 # Show all folders in Nav Pane in Explorer
Set-ItemProperty -Path $KeyCUAdvanced -Name ShowTaskViewButton -Value 0 # Hide task view button on taskbar
Set-ItemProperty -Path $KeyCUAdvanced -Name TaskbarGlomLevel 0 # Taskbar Combine Icons
Set-ItemProperty -Path $KeyCUAdvanced -Name TaskbarSmallIcons 1 # Taskbar Size Small

Set-ItemProperty -Path "$KeyCUAdvanced\People" -Name PeopleBand -Type DWord -Value 0 # Turn off People in Taskbar

Set-ItemProperty -Path "$KeyCUCurrentVersion\GameDVR" -Name AppCaptureEnabled -Type DWord -Value 0 # Disable Xbox Gamebar
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name GameDVR_Enabled -Type DWord -Value 0 # Disable Xbox Gamebar

$KeyCUSearch = "$KeyCUCurrentVersion\Search"
Set-ItemProperty -Path $KeyCUSearch -Name "BingSearchEnabled" -Value 0 # Disable Bing Search
Set-ItemProperty -Path $KeyCUSearch -Name SearchboxTaskbarMode -Type DWord -Value 0 # TaskBar Hide Cortana Search

$KeyLMWiFi = "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\"
$KeyLMAllowWiFiHotSpotReporting = "$KeyLMWiFi\AllowWiFiHotSpotReporting"
If (-Not (Test-Path $KeyLMAllowWiFiHotSpotReporting)) { New-Item -Path $KeyLMWiFi -Name "AllowWiFiHotSpotReporting" | Out-Null}
Set-ItemProperty -Path $KeyLMAllowWiFiHotSpotReporting -Name value -Type DWord -Value 0 # Disable Hotspot Sharing
Set-ItemProperty -Path "$KeyLMWifi\AllowAutoConnectToWiFiSenseHotspots" -Name value -Type DWord -Value 0 # Disable Shared HotSpot Auto-Connect

$KeyLMWindows = "HKLM:\SOFTWARE\Policies\Microsoft\Windows"
If (-Not (Test-Path "$KeyLMWindows\Cloud Content")) { New-Item -Path $KeyLMWindows -Name "Cloud Content" -Force | Out-Null }
New-ItemProperty -Path "$KeyLMWindows\Cloud Content" -Name "DisableWindowsConsumerFeatures" -Value 1 -PropertyType DWORD -Force| Out-Null # Prevents "Suggested Applications" returning
If (-Not (Test-Path "$KeyLMWindows\Explorer")) { New-Item -Path $KeyLMWindows -Name Explorer -Force | Out-Null }
New-ItemProperty -Path "$KeyLMWindows\Explorer" -Name "ShowRunasDifferentuserinStart" -Value 1 -PropertyType DWORD -Force| Out-Null #Add RunAs another user to Start Menu

# Disable the Lock Screen (the one before password prompt - to prevent dropping the first character)
If (-Not (Test-Path $KeyLMWindows\Personalization)) { New-Item -Path $KeyLMWindows -Name Personalization | Out-Null }
Set-ItemProperty -Path $KeyLMWindows\Personalization -Name NoLockScreen -Type DWord -Value 1

# Add photoviewer as open option for pictures
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

$KeyCRApplications = "HKCR:\Applications"
$KeyCRPhotoviewer = "$KeyCRApplications\photoviewer.dll"
$KeyCRShell = "$KeyCRPhotoviewer\shell"

New-Item -Path $KeyCRApplications -Name "photoviewer.dll" -Force | Out-Null
New-Item -Path $KeyCRPhotoviewer -Name "shell" -Force | Out-Null
New-Item -Path $KeyCRShell -Name "open" -Force | Out-Null
New-Item -Path "$KeyCRShell\open" -Name "command" -Force | Out-Null
New-Item -Path "$KeyCRShell\open" -Name "DropTarget" -Force | Out-Null
New-ItemProperty -Path "$KeyCRShell\open" -Name "MuiVerb" -Value "@photoviewer.dll,-3043" -PropertyType string -Force | Out-Null
New-ItemProperty -Path "$KeyCRShell\open\command" -Name "(Default)" -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path "$KeyCRShell\open\DropTarget" -Name "Clsid" -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" -PropertyType string -Force | Out-Null
New-Item -Path "$KeyCRShell" -Name "print" -Force | Out-Null
New-Item -Path "$KeyCRShell\print" -Name "command" -Force | Out-Null
New-Item -Path "$KeyCRShell\print" -Name "DropTarget" -Force | Out-Null
New-ItemProperty -Path "$KeyCRShell\print\command" -Name "(Default)" -Value '%SystemRoot%\System32\rundll32.exe "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %1' -PropertyType ExpandString -Force | Out-Null
New-ItemProperty -Path "$KeyCRShell\print\DropTarget" -Name "Clsid" -Value "{60fd46de-f830-4894-a628-6fa81bc0190d}" -PropertyType string -Force | Out-Null

Remove-PSDrive -Name HKCR

Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "Off" #Disables Smart screen filter

Stop-Process -Name explorer