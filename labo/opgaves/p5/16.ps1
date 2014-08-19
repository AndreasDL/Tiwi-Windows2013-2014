#cmdlets
(Get-WmiObject -List Win32_LogicalDisk).Methods | select Name 

#wmi-com-object
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$klasse=$service.get("Win32_LogicalDisk")
$klasse.Methods_ | select Name

