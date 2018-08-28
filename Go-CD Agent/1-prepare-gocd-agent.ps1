##############################################################################
#This Script presents the way to install and configure GoCD agent on windows
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
#1-prepare-gocd-server.ps1 -gocdagentrdir 'C:\go\agent'
#
#we should add one more step of configuring cruise-config for automation in
#registering go-agent to server. For that, we should have one more param of
#Go-CD Server endpoint. (so that we can either call api or some other arrangements).
##############################################################################

param (
	[string]$gocdagentrdir = 'C:\go\agent'
)

#assuming that all scripts are in current directory only.

.\2-installgocdagent.ps1 -gocdagentrdir 'C:\go\agent'

.\3-agentdepdencies.ps1

.\4-expandandplacezipcontent.ps1

#This is for those who are configuring Go-CD server ldap auth section
..\domainjoin.ps1