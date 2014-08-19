#met com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")

$instantie = $service.get("Win32_LogicalDisk.DeviceID='C:'") #direct de juiste instantie ophalen 
#kan ook met execQuery (is noodzakelijk indien je de sleutel niet kent)
 
Write-Host ($instantie.Properties_.Item("Caption").value, " ", 
            $instantie.Properties_.Item("Description").value," ",
            $instantie.Properties_.Item("FileSystem").value)

#Het laatste kan je ook ophalen als je combineert met de Where-Object en Select-Object cmdlet
$instantie.Properties_ | 
     where {$_.Name -eq "Caption" -or $_.Name -eq "Description" -or $_.Name -eq "FileSystem"} | 
     select Value


#met cmdlets - beperk de lijst van alle instanties
#met Where-Object
Get-WmiObject -class Win32_LogicalDisk | where {$_.DeviceID -eq "C:"}  | select Caption,Description,FileSystem
#met -filter
Get-WmiObject -class Win32_LogicalDisk -filter "DeviceID='C:'" | select Caption,Description,FileSystem
#met -query
Get-WmiObject -query "select * from Win32_LogicalDisk where DeviceID='C:'" | select Caption,Description,FileSystem

