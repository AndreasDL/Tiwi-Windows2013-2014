use strict;
use warnings;
use Win32::OLE::Const 'Microsoft WMI Scripting';
$Win32::OLE::Warn = 3;

my $ns = "root/cimv2";
my $cn = "localhost";

my $obj = Win32::OLE->GetObject("winmgmts://$cn/$ns:Win32_Directory.Name='c:\\'");
print $obj->{FSName} , "\n";

