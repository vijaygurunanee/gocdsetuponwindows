#############################################################################
#We can directly use chocolatey package manager for installation of Go-CD directly.
#Recently, Go-CD changed their way of arrangements in config sections. That is why,
#I planned to install fixed version of Go-CD.
#
#This script is used to install Go-CD server
#
#Go-CD server and agent both come with in-built Java packages. If we don't mention any
#thing, then in-built versions will be installed and used. we can also install our own
#JAVA version and specify it.
#
#To user this script, directly invoke it from power-shell command prompt (shell should
#have administrative privileges).
#Command : 2-installgocdserver.ps1 -gocdserverdir 'C:\go\server'
#############################################################################

param (
	[string]$gocdserverdir = 'C:\go\server'
)

################### Download Go-Server ###################

$url = "https://download.gocd.org/binaries/18.6.0-6883/win/go-server-18.6.0-6883-jre-64bit-setup.exe"
$output = "C:\\go-server-setup.exe"
$start_time = Get-Date

Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "Time taken to download go-server: $((Get-Date).Subtract($start_time).Seconds) second(s)"

################### Install Go-Server ###################

C:\go-server-setup.exe /S /D=$gocdserverdir | Out-Null
Remove-Item C:\go-server-setup.exe