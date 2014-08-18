use strict;
use warnings;
use Win32::OLE::Const 'Microsoft WMI Scripting';
$Win32::OLE::Warn = 3;

my $ns = "Root/cimv2";
my $cn = "localhost";
my $classname = "Win32_NetworkAdapter";
my $DeviceID = 1;

#klasse
my $monik = "winmgmts://$cn/$ns:$classname";
my $obj   = Win32::OLE->GetObject($monik);
print "connection good!" if ref ($obj);
Win32::OLE->LastError() == 0 || die "niet gelukt\n";
print Win32::OLE->QueryObjectType($obj) , "\n";

#instantie
my $pater = "winmgmts://$cn/$ns:$classname.DeviceID=\"$DeviceID\"";
my $objj  = Win32::OLE->GetObject($pater);
print Win32::OLE->QueryObjectType($objj) , "\n";
print $objj->{Name} , "\n";