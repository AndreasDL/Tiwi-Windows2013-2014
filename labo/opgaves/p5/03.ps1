Get-Command | Group-Object -property Verb | Sort-Object -property Count -descending | Select-Object -first 10

#enkel cmdlet - commando's (met ingekorte namen)
Get-Command -commandType cmdlet | group verb | sort count -desc | select -first 10

