#Toon alle parameters van Sort-Object en Select-Object
Get-Help Sort-Object -parameter *
Get-Help Select-Object -parameter *
#De 10 processen met het meest aantal handles
Get-Process | Sort-Object -property Handles -descending | Select-Object -first 10
#ingekorte versie
Get-Process | Sort Handles -des | select -first 10
