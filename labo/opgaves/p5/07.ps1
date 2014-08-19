#Je vindt de cmdlet via de gekende alias dir
Get-Alias dir
#Antwoord
Get-ChildItem | where {$_.LastWriteTime -ge "10/1/2013"} | sort LastWriteTime -desc| select Name,LastWriteTime

