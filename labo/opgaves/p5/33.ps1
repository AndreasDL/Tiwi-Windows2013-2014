#WMI-com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$klasse=$service.get("Win32_LogicalDisk")
$klasse.Properties_ | foreach {     
             Write-Host $_.Name $_.CIMTYPE  "(" $_.Qualifiers_.Item("CIMTYPE").Value ")"
}
#cmdlets - attribuutqualifiet CIMTYPE ontbreekt in onderstaande lijst
(Get-WmiObject -List Win32_LogicalDisk -amended).Qualifiers


