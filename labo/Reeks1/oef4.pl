use strict;
use warnings;
use Win32::OLE;

my $cdo = Win32::OLE->new("CDO.Message");
print "CDO.Message: ", ref($cdo), " --  ", join(" / ",Win32::OLE->QueryObjectType($cdo));