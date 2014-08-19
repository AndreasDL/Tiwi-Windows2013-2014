#Initialiseer een variabele met een tijd
$tijd=(Get-ChildItem | select -first 1).LastWriteTime
#zoek alle methodes en attributen
$tijd | Get-Member

Get-ChildItem | where {$_.LastWriteTime.DayOfWeek -eq "Sunday"} | 
           select Name, @{Name="Last Acces";Expression={$_.LastWriteTime.TimeOfDay}}

