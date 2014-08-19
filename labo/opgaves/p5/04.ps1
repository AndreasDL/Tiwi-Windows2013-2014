get-command -commandtype cmdlet | Get-Member -Membertype property
#alle commando's zonder verb
Get-Command | where { $_.verb -match "^$"}
#groepeer per type om na te gaan wat het meest voorkomt in deze lijst
Get-command | Where-Object {$_.Verb -match "^$"}  | Group-Object -property commandType

