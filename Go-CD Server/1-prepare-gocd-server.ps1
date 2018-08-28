##############################################################################
#This Script presents the way to install and configure GoCD server on windows
#instances. Apart from the steps mentioned here, there are many other things,
#which can be customised for the preparation of the server.
#
#Complete documentation of the Go-CD configuration can be found here:
#https://docs.gocd.org/current/
#
#Apart from this, we can also make use of Go-CD APIs for various configuration
#after installation of Go-CD softwares. Complete documentation about APIs can
#be found here:
#https://api.gocd.org/current/
#
#we can invoke this script using below mentioned command:
#1-prepare-gocd-server.ps1 -env test -gocdserverdir 'C:\go\server' -artifactsdir 'c:\artifacts'
#
#we can also customize the location of Go-CD server installation place by adding
#one more parameter.
##############################################################################

param (
	[string]$env = 'test',
	[string]$gocdserverdir = 'C:\go\server',
	[string]$artifactsdir = 'c:\artifacts'	
)

#assuming that all scripts are in current directory only.

.\2-installgocdserver.ps1 -gocdserverdir 'C:\go\server'

.\3-configuregocdserver.ps1 -env $env -gocdserverdir 'C:\go\server' -artifactsdir $artifactsdir

#This is for those who are configuring Go-CD server ldap auth section
..\domainjoin.ps1