#met cmdlets
#Haalt alle instanties op en toont enkel het relatief pad
Get-WmiObject -Class Win32_LogicalDisk |select __RELPATH

#aantal instanties
(Get-WmiObject -Class Win32_LogicalDisk).count

#met com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$klasse=$service.get("Win32_LogicalDisk")

#aantal:
$klasse.Instances_().count

$klasse.Instances_()| foreach {$_.SystemProperties_.Item("__RELPATH").Value}
#of
$klasse.Instances_()| foreach {$_.Path_.RelPath}


