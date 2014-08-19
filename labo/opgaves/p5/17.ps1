#comlets
#Haal de klasse op met de switch -Amended, dan heb je alle qualifiers
(Get-WmiObject -List Win32_LogicalDisk -Amended).Qualifiers | select Name,Value
#enkel de beschrijving 
((Get-WmiObject -List Win32_LogicalDisk -Amended).Qualifiers | where {$_.Name -eq "Description"} ).Value
#OF met Item maar het is niet duidelijk in de documantatie dat dit ook kan
(Get-WmiObject -List Win32_LogicalDisk -Amended).Qualifiers.Item("Description").Value
#Dit is wel te achterhalen via een extra lokale variabele
$qualifiers=(Get-WmiObject -List Win32_LogicalDisk -Amended).Qualifiers
#overloop nu alle mogelijke bewerkingen met de TAB-toets na intype van $qualifiers.

#WMI-com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$klasse=$service.get("Win32_LogicalDisk",131072)  #om alle qualifiers op te halen
$klasse.Qualifiers_| select Name,Value
#enkel de beschrijving
($klasse.Qualifiers_|  where {$_.Name -eq "Description"} ).Value
#Of met Item 
$klasse.Qualifiers_.Item("Description").Value

