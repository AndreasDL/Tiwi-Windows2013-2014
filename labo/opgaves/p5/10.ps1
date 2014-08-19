#wmi-com-object
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")

#een instantie ophalen met het relatief pad
$instantie=$service.get("Win32_LogicalDisk.DeviceID='C:'")
#alle properties - analoog als bij de klasse: enk
$instantie | select *
$instantie | get-Member -membertype "property"

#alle WMI-properties van het bijhorend WMI-object
$instantie.Properties_ | foreach{ $_.Name}
$instantie.SystemProperties_ | foreach{ $_.Name}

#De inhoud van de WMI-properties
$instantie.Properties_ | foreach{ 
    Write-Host $_.Name ": " $_.Value
}

#ophalen van een aantal interessante WMI-eigenschappen (niet te combineren met systemproperties)
$instantie.Properties_ | where{$_.Name -eq "DeviceId" -or $_.Name -eq "VolumeName" -or $_.Name -eq "Description"} |
    foreach{ 
         Write-Host $_.Name ": " $_.Value
    }
#of elk apart ophalen
$instantie.Properties_.Item("DeviceId").Value

#ophalen van systeemattribuut
$instantie.SystemProperties_.Item("__DERIVATION").Value

#het PS-WMI object - neem de eerste instantie
Get-WmiObject -class Win32_LogicalDisk | select -first 1
#alle properties voor een instanties met inhoud 
Get-WmiObject -class Win32_LogicalDisk | select -first 1 | select *  

#overzicht van mogelijke properties op dit soort objecten - volledig overzicht van enkel WMI-properties indien je dit vraagt op een instantie
Get-WmiObject -Class Win32_LogicalDisk | select -first 1 | get-Member -memberType property

#inhoud van interessante eigenschappen - kan direct worden uitgebreid met systeemattributen
Get-WmiObject -Class Win32_LogicalDisk | select -first 1 | select DeviceID, VolumeName, Description
Get-WmiObject -Class Win32_LogicalDisk | select -first 1 | select __DERIVATION,DeviceID | format-list

#voor alle instanties (is heel wat complexer met WMI-COM-objecten
Get-WmiObject -Class Win32_LogicalDisk | select DeviceID, VolumeName, Description



