#cmdlets
#alle services die gestopt zijn
Get-WmiObject -Class Win32_Service | where {$_.State -eq "Stopped"} | select Name
#aantal services per ingestelde status
Get-WmiObject -Class Win32_Service | group State 

#com-klassen
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$services=$service.execQuery("select * from Win32_Service where State='Stopped'")
$services |foreach  { $_.Properties_.Item("Name").Value}
#tellen per soort kan niet met  group-Object
#een mogelijke oplossing, waarbij je zelf de twee toestanden van State "hardcodeert":
($service.execQuery("select * from Win32_Service where State='Stopped'")).count
($service.execQuery("select * from Win32_Service where State='Running'")).count




