<#
    Script name: 	Remove-Windows10DefaultApps.ps1
	Version:     	0.1
	Purpose:		Remove unwanted default apps from a Windows 10 1803 Enterprise install
    Author:      	Matt Hilton
    Contact:     	matthilt@gmail.com
    DateCreated: 	2018-08-16
    LastUpdate:  	2018-08-16
#>

Write-Output "Uninstalling default apps"
$apps = @(
	# default Windows 10 apps
	"Microsoft.BingNews"
	"Microsoft.BingWeather"
	#"Microsoft.DesktopAppInstaller"
	"Microsoft.FreshPaint"
	"Microsoft.GetHelp"
	"Microsoft.Getstarted"
	#"Microsoft.Messaging"
	"Microsoft.Microsoft3DViewer"
	"Microsoft.MicrosoftOfficeHub"
	"Microsoft.MicrosoftSolitaireCollection"
	"Microsoft.MicrosoftStickyNotes"
	#"Microsoft.MSPaint"
	"Microsoft.NetworkSpeedTest"
	#"Microsoft.Office.OneNote"
	"Microsoft.OneConnect"
	"Microsoft.People"
	"Microsoft.Print3D"
	"Microsoft.SkypeApp"
	#"Microsoft.StorePurchaseApp"
	"Microsoft.Wallet"
	#"Microsoft.WebMediaExtensions"
	"Microsoft.Windows.Photos"
	"Microsoft.WindowsAlarms"
	#"Microsoft.WindowsCalculator"
	"Microsoft.WindowsCamera"
	"microsoft.windowscommunicationsapps"
	"Microsoft.WindowsFeedbackHub"
	"Microsoft.WindowsMaps"
	#"Microsoft.WindowsSoundRecorder"
	#"Microsoft.WindowsStore"
	"Microsoft.XboxApp"
	"Microsoft.Xbox.TCUI"
	"Microsoft.XboxGameOverlay"
	"Microsoft.XboxGamingOverlay"
	"Microsoft.XboxIdentityProvider"
	"Microsoft.XboxSpeechToTextOverlay"
	"Microsoft.ZuneMusic"
	"Microsoft.ZuneVideo"

	# non-Microsoft
	"*AdobePhotoshopExpress*" #Adobe Photoshop Express
	"*ActiproSoftwareLLC*" #Code Writer
	"*Duolingo*" #Duolingo
	"*EclipseManager*"
)

foreach ($app in $apps) {
	Write-Output "Trying to remove $app"
	Get-AppxPackage -Name $app | Remove-AppxPackage
	Get-AppXProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online
}

foreach ($app in $apps) {
	Write-Output "Trying to remove $app from all users"
	Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers
}