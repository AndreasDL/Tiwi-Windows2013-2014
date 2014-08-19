#met com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")

$instanties = $service.execQuery("select * from Win32_Process where Name='Notepad.exe'");
$instanties | foreach{ $_.Properties_.Item("Handle").Value}

#met cmdlets en PS-WMI-objecten
#beperk met where 
Get-WmiObject -class Win32_Process | where {$_.Name -eq "Notepad.exe"} | select Handle,Name

#met filter 
Get-WmiObject -class Win32_Process -filter "Name='Notepad.exe'" | select Name, Handle 

#met query
Get-WmiObject -query "select * from Win32_Process where Name='Notepad.exe'" | select Name,Handle

#met specifieke cmdlet voor processen (geen WMI-objecten) Id bevat de informatie van het WMI-attribuut Handle
Get-Process | where {$_.Name -eq "Notepad"}  | select Name,Id,Handle


