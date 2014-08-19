#met comlets
function get-Namespace ($name)
{
   #haal alle instanties van de klasse __NAMESPACE
   Get-WmiObject -Namespace $name -class __NAMESPACE | 
   foreach{
      "Namespace  = "+ $name+"\" + $_.Name
      get-Namespace($name+"\" + $_.Name)
   }
 }
 
get-Namespace("root\cimV2")

#met com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"

function get-Namespace ($name)
{
   $service = $Location.ConnectServer(".",$name)
   #haal alle instanties van de klasse __NAMESPACE
   $service.execQuery("select * from __NAMESPACE") | 
   foreach{
      "Namespace  = "+ $name+"\" + $_.Properties_.Item("Name").Value
      get-Namespace($name+"\" + $_.Properties_.Item("Name").Value)
   }
 }
get-Namespace("root\cimV2")


