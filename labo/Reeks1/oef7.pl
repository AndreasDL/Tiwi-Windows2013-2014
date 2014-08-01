use strict;
use warnings;
use Win32::OLE;
$Win32::OLE::Warn = 3;
#Win32::OLE->Option(Warn => 3);

my $errObj = Win32::OLE->new("CO.Mesage");