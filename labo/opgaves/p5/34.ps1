#cmdlets
$lijst=Get-WmiObject -List WIN32* -amended #amended kan hier ook weg
#maak een nieuwe lijst met alle abstracte klassen

$result = ($lijst | foreach{ 
 if ($_.Qualifiers | where {$_.Name -eq "abstract"})  #met $_.Qualifiers.Item("abstract").Value lukt het niet echt, omdat er ook foutmeldingen komen. Het aantal klopt echter wel
 {
    $_.__CLASS
    }
 })

"geeft "+ $result.count + " abstracte klassen op "+$lijst.count + " Win32 klassen"
#WMI-com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$alleklassen=$service.execquery("select * from meta_class")  

$abstract=0
$alleklassen |
  where {$_.SystemProperties_.Item("__CLASS").Value -like "Win32*"} |
  foreach {
      if ( ($_.Qualifiers_|  where {$_.Name -eq "abstract"} ).Value)
      {
         $_.SystemProperties_.Item("__CLASS").Value
         $abstract++
      }      
   }
   
"geeft "+ $abstract+ " abstracte klassen op "+$alleklassen.count + " Win32 klassen"

