#zoek een cmdlet met Service in de naam
Get-Command *service* -commandtype cmdlet
#OF
Get-Command | where {$_.Name -like "*Service*"}

#Toon alle attributen (enkel properties,...)
Get-Service | Get-Member -Membertype property

#alle services die gestopt zijn
Get-Service  | where {$_.status -eq "Stopped"}

#aantal services per status
Get-Service | group Status

#alle services die minstens 1 afhankelijke service hebben
Get-Service | where {$_.DependentServices -ne {}} |select DisplayName,DependentServices

#alle services die minstens 2 afhankelijke services hebben
Get-Service | where {$_.DependentServices.count -gt 1} |sort-Object -property DependentServices | select Name,DependentServices

