###############################################################################
#This script will prepare the cruise-config for Go-CD server. Initially, it will
#prepare ldap section and pipeline section. Then, it will replace the specific
#sections according to environments.
#
#For this script to run, we need to have following files avaialble (for your,
#reference, we have attached the samples in this repository).
#ldapconfig.xml
#pipeline.xml
#{env}-Go-Param.json
#
#In ldapconfig and pipline, there are sections like {param}, There are configurables
#according to the environments.
#
#we can invoke this script using below mentioned command:
#3-configgocdserver.ps1 -env test -gocdserverdir 'C:\go\server' -artifactsdir 'c:\artifacts'
#artifacts can be used to maintain the history of Go-CD pipelines executions. So,
#at the time of back-up, we can directly use this directory.
###############################################################################

param (
	[string]$env = 'test',
	[string]$gocdserverdir = 'C:\go\server',
	[string]$artifactsdir = 'C:\artifacts'
)

################### prepare cruise config ###################

# Load the origional cruise-config in object
$origcruiseconfigpath = $gocdserverdir + '\config\cruise-config.xml'
[xml]$origcruiseconfig = Get-Content $origcruiseconfigpath
Remove-Item $origcruiseconfigpath
echo 'Origional Cruise Config loaded.'

# set artifacts dir
$origcruiseconfig.cruise.server.artifactsdir = $artifactsdir
echo 'artifacts changed.'

# load ldap-configuration section, instead of ldap, we can also have normal auth method also. we can also avoid having any kind of authentication.
$localldappath = '.\ldapconfig.xml'
[xml]$ldapconfiguration = Get-Content $localldappath
Remove-Item $localldappath
$origcruiseconfig.cruise.server.AppendChild($origcruiseconfig.ImportNode($ldapconfiguration.security, $true))
echo 'ldap section added.'

# load pipeline section
$localpipelinepath = '.\pipeline.xml'
[xml]$pipeline = Get-Content $localpipelinepath
Remove-Item $localpipelinepath
$origcruiseconfig.cruise.InsertAfter($origcruiseconfig.ImportNode($pipeline.pipelines, $true), $origcruiseconfig.cruise.Item("server"))
echo 'pipelines added.'

$origcruiseconfig.Save($origcruiseconfigpath)
echo 'first version of cruise-config saved.'
echo 'at this point, we have prepared the auth sections and pipeline sections for our server.'

$localcruiseconfig = $origcruiseconfigpath

$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter ldap user name and password for Go-CD to ldap connection.", "", "")

### Prepare Cruise Config by replacing the parameters
### Replace all available params
### Read the json and replace all params in file

#1)
(get-content $localcruiseconfig) -replace ('{yourldapuser}',$Credential.Username) | out-file $localcruiseconfig
(get-content $localcruiseconfig) -replace ('{secret}',$Credential.GetNetworkCredential().password) | out-file $localcruiseconfig

#2)
$localgoparamconfig = $env + "-Go-Param.json"

#3)
$goparamjson = [IO.File]::ReadAllText($localgoparamconfig)
Remove-Item $localgoparamconfig

(ConvertFrom-Json $goparamjson).psobject.properties |
Foreach { 
	$keytoreplace = "{" + $_.Name + "}"
	(get-content $localcruiseconfig) -replace ($keytoreplace,$_.Value) | out-file $localcruiseconfig
}
echo 'final version of cruise-config saved.'

#Converting file to UTF-8
[xml]$xml = Get-Content $origcruiseconfigpath

$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
$sw = New-Object System.IO.StreamWriter($origcruiseconfigpath, $false, $utf8WithoutBom)

$xml.Save( $sw )
$sw.Close()
echo 'file conversion completed'

