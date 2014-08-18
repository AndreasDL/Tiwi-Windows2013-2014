use strict;
use warnings;
use Win32::OLE::Const 'Microsoft WMI Scripting';
$Win32::OLE::Warn = 3;

my $cn = "localhost";
my $ns = "root/cimv2";

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer($cn,$ns);

my $instance = $wbem->Get("Win32_OperatingSystem=@");
print $instance->{Caption},"versie ",$instance->{Version},"\n"
	,$instance->{CSDVersion},"\n"
	,$instance->{OSArchitecture};