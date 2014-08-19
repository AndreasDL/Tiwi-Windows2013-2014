#met cmdlets
#Haalt alle klassen op in de standaard namespace
Get-WmiObject -List
#Aantal klassen
(Get-WmiObject -List).count

#klassen die iets met network te maken hebben
Get-WmiObject *network* -List

#uit de klasse "root", en beginnend met __
Get-WmiObject  "__*" -namespace "root" -List

#met com-objecten
$Location=New-Object -comobject "WbemScripting.SWbemLocator"
$service = $Location.ConnectServer(".","root\cimV2")

$klassen = $service.execQuery("select * from Meta_class");
$klassen.count
#toont alle klassen
$klassen | foreach{ $_.Path_.relPath}
#beperk het overzicht
$klassen| where {$_.Path_.RELPATH -like "*network*"} | foreach{ $_.Path_.relPath}

