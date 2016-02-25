#switch to current executing directory
cd $PSScriptRoot

#import the logging models
. .\Models\SysloggerModel.ps1
#. .\Models\EventLoggerModel.ps1
#. .\Models\SlackLoggerModel.ps1

#import the Logger Module
$out = Import-Module .\Commands\LoggingCommands.psm1

#write to defined logs
Write-LogMessage -message "Logging a message" -severity 4
