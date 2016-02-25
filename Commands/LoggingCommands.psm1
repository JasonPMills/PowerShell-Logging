<# .Synopsis
		Provides basic logging functions
   .Description
		Allow logging of messages to screen, event logs, and/or e-mail depending on severity.
   .Example
		Write-LogMessage -message $_.Exception.Message -severity 2
 #Requires -Version 2.0 #>
function Write-LogMessage{
	param(
		[Parameter(ParameterSetName="default", Mandatory=$true)] [string] $message,
		[Parameter(ParameterSetName="default", Mandatory=$true)] [int] $severity
	)
	switch($severity){
		0   { #Critical
			Write-Host $message -ForegroundColor Red;
			if($syslog){
				$syslog.Send($message,2,[System.DateTime]::Now.ToString());
			}
		}
		1 	{ #Error
			Write-Host $message -ForegroundColor Yellow;
			if($syslog){
				$syslog.Send($message,3,[System.DateTime]::Now.ToString());
			}
		}
		2	{ #Warning
			Write-Host $message -ForegroundColor White;
			if($syslog){
				$syslog.Send($message,4,[System.DateTime]::Now.ToString());
			}
		}
		3	{ #Notice
			Write-Host $message -ForegroundColor Cyan;
			if($syslog){
				$syslog.Send($message,5,[System.DateTime]::Now.ToString());
			}
		}
		4   { #Information
			Write-Host $message -ForegroundColor Blue;
			if($syslog){
				$syslog.Send($message,6,[System.DateTime]::Now.ToString());
			}
		}
		7   { #Debug
			Write-Host $message -ForegroundColor Gray;
			if($syslog){
				$syslog.Send($message,7,[System.DateTime]::Now.ToString());
			}
		}
		99  { #Console Only
			Write-Host $message -ForegroundColor Green;
		}
	}

}

function Get-EventSource($source, $logName){
	try
	{
		New-EventLog -Source $source -LogName $logName;
	}
	catch [System.Exception]
	{
		Write-LogMessage -message $_.Exception.Message -severity 4
	}
}

function Get-Syslog{
	$syslog = New-Syslogger -destination $ConnectionConfig.Syslog.IP -port $ConnectionConfig.Syslog.Port -Facility $NotificationConfig.Syslog.Facility;
	return $syslog
}

