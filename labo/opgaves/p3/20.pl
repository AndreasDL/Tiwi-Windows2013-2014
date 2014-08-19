    SELECT * FROM Win32_Directory WHERE name="c:\\"
of
   SELECT * FROM Win32_Directory WHERE name='c:\\'

Je gebruikt dus best het sleutelattribuut om de instantie te beschrijven. 
Je mag de ' ' of " "-tekens niet weglaten, en backslashen backslashen !

De partitie die bij deze rootdirectory hoort vind je met:

    SELECT * FROM Win32_LogicalDisk WHERE DeviceId="c:"
of
    SELECT * FROM Win32_LogicalDisk WHERE DeviceId='c:'

Beide WMI-objecten zijn aan elkaar geassocieerd via de associatorklasse Win32_LogicalDiskRootDirectory.



