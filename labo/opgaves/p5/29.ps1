#cmdlets
$class = Get-WmiObject -List Win32_Directory
$class.SystemProperties + $class.Properties  | foreach{
   $isArray=""
   if ($_.isArray){$isArray="(Array)"}
   $_.Name+" "+ $isArray+" "+ $_.Type 
}

#WMI-com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$class = $service.get("Win32_Directory")
$class.SystemProperties_ + $class.Properties_  | foreach{
   $isArray=""   
   if ($_.isArray){$isArray="(Array)"}
   $_.Name+" "+ $isArray+" "+ $_.CIMType 
}


