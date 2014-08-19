#initialiseer een variabelen met het eerste process
$process=Get-Process|select -first 1

#alle threads: $process.Threads 
#aantal threads: $process.Threads.count

#Alle processen met exact twee threads
Get-Process | where {$_.Threads.Count -eq 2} | select ProcessName, Threads

