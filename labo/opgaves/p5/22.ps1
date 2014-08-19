#voor de WMI-klasse Win32_Process - enkel systeemattributen en de statische methode Create
Get-WmiObject  -List Win32_Process | get-Member
#voor de WMI-instantie Win32_Process : alle attributen, en de niet-statische methodes
Get-WmiObject  -Class Win32_Process | get-Member

#Alle WMI-methodes kan je beter opvragen zoals in de vorige oefening:
(Get-WmiObject  -List Win32_Process).Methods | select Name
#Alle eigen WMI-attributen
(Get-WmiObject  -List Win32_Process).Properties | select Name

#met cmdlet get-Process : andere methodes, ook events, lijst met attributen is ook verschillend
Get-Process|Get-Member


