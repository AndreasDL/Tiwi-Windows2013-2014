Get-WmiObject  -List | where {$_.__DERIVATION -eq "__ExtrinsicEvent"}

Get-WmiObject  -List | where {$_.__DERIVATION -eq "__ExtrinsicEvent"} | sort __Property_Count -desc | 
                       select __CLASS, __Property_Count

#toont ook de properties zelf van de twee klassen met het meeste eigen properties

Get-WmiObject  -list | where {$_.__DERIVATION -eq "__ExtrinsicEvent"} | sort __Property_Count -desc | 
    select -first 2 | 
    foreach{ 
       $_.__CLASS +"("+$_.__Property_Count+" properties)" 
       $_.Properties | select Name |Format-Wide -autosize
    }


