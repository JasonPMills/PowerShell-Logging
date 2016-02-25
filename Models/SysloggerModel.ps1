#
# SysloggerModel.ps1
#
function New-Syslogger{
	param(
		$destination = "",
		$port = "",
		[int]$facility = 3
	)
	$syslogger = New-Object psobject -Property @{
		destination = $destination
		port = $port
		facility = $facility
	}
	$syslogger.PSObject.TypeNames.Insert(0,"syslogger");
	$syslogger | Add-Member -MemberType NoteProperty -Name UDPClient -Value $(New-Object System.Net.Sockets.UdpClient);
	$syslogger | Add-Member -MemberType ScriptMethod -Name Send -Value {
		Param
		(
			[string]$Message,
			[string]$Severity,
			[string]$Timestamp
		)
		$server = $env:COMPUTERNAME;
		$PRI = ([int]$this.facility * 8) + [int]$Severity;
		$formattedMessage = "<$PRI> $Timestamp $server ADSync 0 0 $message";
        write-host $formattedMessage

        $encodedMessage = $([System.Text.Encoding]::ASCII).GetBytes($formattedMessage);
		if($encodedMessage.Length -gt 1024)
		{
			$encodedMessage.Substring(0,1024);
		}
		$result = $this.UDPClient.Send($encodedMessage, $encodedMessage.Length)
        
	}
	$syslogger | Add-Member -MemberType ScriptMethod -Name Close -Value {
		$this.UDPClient.Close();
	}
	$syslogger.UDPClient.Connect($destination, $port);
    return $syslogger
	
}