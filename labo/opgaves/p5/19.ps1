#cmdlets
(Get-WmiObject -List Win32_Process -Amended).Methods | select Name,Qualifiers

#WMI-com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")
$klasse=$service.Get("Win32_Process",131072)
$klasse.Methods_ | foreach{  #duidelijke opmaak is iets moeilijker te realiseren
    Write-Host "***" $_.Name "***"
    $_.Qualifiers_|select Name  
    ""
    }

