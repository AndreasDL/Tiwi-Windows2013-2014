use strict;
use warnings;
use Win32::OLE;
use Win32::OLE::Const 'Microsoft WMI Scripting';
$Win32::OLE::Warn = 3;

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost", "root/cimv2");

#manier1
my $adapters = $wbem->ExecQuery("SELECT * from Win32_NetworkAdapter");
#uitschrijven
print "Found " , $adapters->{Count}  , " adapters! \n";
print $_->{DeviceID} , "\n" foreach (in $adapters);

#manier2
$adapters = $wbem->InstancesOf("Win32_NetworkAdapter");
print "Found " , $adapters->{Count}  , " adapters! \n";

#manier3
my $class = $wbem->Get("Win32_NetworkAdapter");
$adapters = $class->Instances_();
print "Found " , $adapters->{Count}  , " adapters! \n";