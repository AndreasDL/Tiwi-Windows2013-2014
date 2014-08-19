#wmi-com-object
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")

#de klasse 
$klasse=$service.get("Win32_LogicalDisk")
#alle properties van dit object - bevat geen WMI-properties, maar wel de PS-properties .Properties_ en .SystemProperties
$klasse | Select-Object *
$klasse | Get-Member -membertype "property"

#met .Properties_ en .SystemProperties kan je de WMI-properties ophalen van de klasse
$klasse.Properties_ | foreach{ $_.Name}
$klasse.SystemProperties_ | foreach{ $_.Name}
#De waarde van het systeemattrubuut __DERIVATON
$klasse.SystemProperties_.Item("__Derivation").Value

#het PS-WMI object
#de klasse ophalen is vrij traag omdat eerst alle klassen worden opgehaald - toont enkel de WMI-systemproperties, aangevuld met nieuwe PS-properties
Get-WmiObject -List Win32_LogicalDisk |select *
#alle mogelijke properties voor het PS-object - toont enkel de WMI-systemproperties
Get-WmiObject -List Win32_LogicalDisk | get-Member -memberType property
#gebruik .Properties om de ook de eigen WMI-properties op te halen
(Get-WmiObject -List Win32_LogicalDisk).Properties | select Name
#De waarde van het systeemattrubuut __DERIVATON wordt beter rechtstreeks opgehaald
(Get-WmiObject -List Win32_LogicalDisk).__DERIVATION


