##############################################################################
# Samples for git configuration and msbuild configurations. Modify them as per need
##############################################################################

################### Download ssh and place it ###################

$localsshpath = '.\ssh.zip'

Expand-Archive $localsshpath -DestinationPath C:\Windows\System32\config\systemprofile\.ssh

Remove-Item $localsshpath

################### Download Microsoft folder and place it under Msbuild ###################

$localmpath = "C:\\microsoft.zip"

Expand-Archive $localmpath -DestinationPath 'C:\Program Files (x86)\MSBuild\Microsoft'

Remove-Item $localmpath