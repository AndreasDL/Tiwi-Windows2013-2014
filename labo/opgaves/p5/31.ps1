$instantie = Get-WmiObject -Class Win32_OperatingSystem
"Win32_OperatingSystem heeft "+$instantie.Properties.Count + " properties en " + $instantie.SystemProperties.count+" systeemproperties"
$instantie.Properties + $instantie.SystemProperties | foreach{
    $isArray=""
    if ($_.isArray){ $isArray="(Array)"}
    if ($_.Type -eq "DateTime")
    {
        $value=$instantie.ConvertToDateTime($_.Value)  #methode van de instantie
    }
    else
    {
        $value=$_.Value
    }
    $_.Name+" "+ $isArray+" ("+$_.Type+") "+ $value
}
