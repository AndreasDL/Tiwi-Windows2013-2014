#cmdlet's
$instantie =Get-WmiObject -Class Win32_Service -filter "Name='Browser'"
$instantie.Properties + $instantie.SystemProperties| foreach{
   $isArray=""
   if ($_.isArray){$isArray="(Array)"}
   $_.Name+" "+ $isArray+" ("+$_.Type+") "+ $_.Value
}

#WMI-com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")

$instantie = $service.get("Win32_Service.Name='Browser'")

$instantie.Properties_ + $instantie.SystemProperties_ | foreach{
   $isArray=""
   if ($_.isArray){$isArray="(Array)"}
   $_.Name+" "+ $isArray+" ("+$_.CIMType+") "+ $_.Value
}

