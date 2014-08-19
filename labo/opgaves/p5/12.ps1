#alle WMI-attributen bekom je eenvoudig op een instantie, zonder de PS-properties te gebruiken - deze lijst bevat dus ook systeemattributen
Get-WmiObject -Class Win32_LogicalDisk | select -first 1 | get-Member -memberType property

#enkel "eigen" WMI-attributen - op de klasse vragen
(Get-WmiObject -List Win32_Directory).Properties | foreach {$_.Name}
#enkel "systeemattributen" - niet gevraagd
(Get-WmiObject -List Win32_Directory).SystemProperties | select Name

