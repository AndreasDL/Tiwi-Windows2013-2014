#Zoek een klasse ivm eventfiles
Get-WmiObject -List  *Event*File*
#Snel zoeken naar het attribuut kan je met
Get-WmiObject -Class Win32_NTEventLogFile | Get-Member "*Last*"
#lijst van eventfiles, geordend op laatst-gewijzigd
Get-WmiObject Win32_NTEventLogFile | sort LastModified -descending| select LogFileName,LastModified

#alle scriptmethodes van dit soort objecten
Get-WmiObject -Class Win32_NTEventLogFile | Get-Member -memberType *method*
#Je vindt ConvertToDateTime

#Initialiseer een eventfile - neem bijvoorbeeld de eerste in de lijst
$object=(Get-WmiObject Win32_NTEventLogFile | select -first 1)
#converteer de datum 
$object.ConvertToDateTime($object.LastModified)

#bouw onderstaand commando stap voor stap op
Get-WmiObject -Class Win32_NTEventLogFile | sort LastModified | 
         select FileName, @{Name="LastModified"; Expression={$_.ConvertToDateTime($_.LastModified)}}


