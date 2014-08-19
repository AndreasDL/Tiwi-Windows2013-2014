#met comlets is dit vrij eenvoudig
Get-WmiObject -List Win32*NetWorkAdapter* -Amended |
foreach {
    $_.__CLASS
   ($_.Qualifiers | where {$_.Name -eq "Description"}).Value
    # of 
    # $_.Qualifiers.Item("Description").Value
    ""
}

#wmi-com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$alleklassen=$service.execquery("select * from meta_class","WQL",131072)  #om alle qualifiers op te halen

$alleklassen |
  where {$_.SystemProperties_.Item("__CLASS").Value -like "Win32*NetWorkAdapter*"} |
  foreach {
      $_.SystemProperties_.Item("__CLASS").Value
      ($_.Qualifiers_|  where {$_.Name -eq "Description"} ).Value
      #of
      #$_.Qualifiers_.Item("Description").Value
      ""
   }


