use strict;
use warnings;
use Win32::OLE;


my $cdo = Win32::OLE->new("CDO.Message");
print ref $cdo;