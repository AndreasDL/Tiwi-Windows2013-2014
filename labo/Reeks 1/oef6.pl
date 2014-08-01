use strict;
use warnings;
use Win32::OLE;

my $Errobject = Win32::OLE->new("CDO.Mesage");
print "\nlast error= ",Win32::OLE->LastError() ;