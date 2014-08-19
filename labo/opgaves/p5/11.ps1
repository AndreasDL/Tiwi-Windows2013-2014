-view all  : toont alle properties - niet altijd...
-view base : toont enkel de extra properties voor WMI-objecten

#Toon alle properties van een klasse
Get-WmiObject -List Win32_LogicalDisk | get-Member -memberType property -view base
#kortere lijst voor de instantie
Get-WmiObject -Class Win32_LogicalDisk | get-Member -memberType property -view base

#Hier zie je ook de PS-properties: Properties, SystemProperties, Methods, Qualifiers

