#cmdlets
Get-WmiObject -List  | sort __Property_Count -desc | select -first 1 | Select Name,__Property_Count
#wmi-com-object
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$alleklassen=$service.execquery("select * from meta_class")  
$max=0;
$klasse="";
$alleklassen|foreach{
     $aantal=$_.Properties_.Count
     if ($aantal -gt $max){
          $max=$aantal
          $klasse = $_.SystemProperties_.Item("__CLASS").Value;
     }
}
Write-Host $klasse $max    

