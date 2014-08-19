#cmdlets
#aantal eigen properties van WMI-object of klasse
(Get-WmiObject  -List Win32_LogicalDisk).Properties.count
(Get-WmiObject  -List Win32_LogicalDisk).__Property_Count 
#met instantie (moet uniek zijn)
(Get-WmiObject  -class Win32_LogicalDisk|select -first 1).__Property_Count 
(Get-WmiObject  -class Win32_LogicalDisk|select -first 1).Properties.count

#WMI-com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$klasse=$service.Get("Win32_LogicalDisk")
$klasse.Properties_.Count
($klasse.SystemProperties_|  where {$_.Name -eq "__Property_Count"} ).Value
#of met de methode Item
$klasse.SystemProperties_.Item("__Property_Count").Value

