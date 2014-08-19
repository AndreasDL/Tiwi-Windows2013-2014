#cmdlets
(Get-WmiObject -List Win32_Process -Amended).Methods |  foreach{
        if ( $_.Qualifiers | where{$_.Name -eq "Values"} )
        {
           Write-Host
           $_.Name
           $Values=$_.Qualifiers.Item("Values").Value
           if ( $_.Qualifiers | where{$_.Name -eq "ValueMap"} )
           {
                $ValueMap=$_.Qualifiers.Item("ValueMap").Value
                $i=0
                $Values | foreach {
                    $ValueMap[$i]+" "+ $Values[$i]
                    $i++
                }
            }
            else #geen ValueMap
            { 
                $Values
            }
         }
 }
#WMI-com objecten is volledig analoog, maar gebruik Qualifiers_ 
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$klasse=$service.Get("Win32_Process",131072)
$klasse.Methods_ | foreach{  
    if ( $_.Qualifiers_ | where{$_.Name -eq "Values"} )
        {
           Write-Host
           $_.Name
           $Values=$_.Qualifiers_.Item("Values").Value
           if ( $_.Qualifiers_ | where{$_.Name -eq "ValueMap"} )
           {
                $ValueMap=$_.Qualifiers_.Item("ValueMap").Value
                $i=0
                $Values | foreach {
                    $ValueMap[$i]+" "+ $Values[$i]
                    $i++
                }
            }
            else #geen ValueMap
            { 
                $Values
            }
         }
    }


