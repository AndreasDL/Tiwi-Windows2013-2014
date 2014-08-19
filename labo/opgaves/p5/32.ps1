$Query="Select * from Win32_NTLogEvent  Where Logfile = 'System'
                                       and ( EventCode = '6005' or EventCode = '6006' )
                                       and SourceName = 'EventLog'"
                                       
Get-WmiObject -query $Query | sort-Object -property TimeWritten | foreach { 
     if ($_.EventCode -eq "6005")
     {
         $StartUp=$_.ConvertToDateTime($_.TimeWritten)
         Write-Host $StartUp 
     }
     else
     {
          $Stop=$_.ConvertToDateTime($_.TimeWritten)
          $periode = $Stop -$StartUp #($_.TimeWritten - $StartUp)/10000000
          Write-Host $Stop " na " $periode
     }
}  
