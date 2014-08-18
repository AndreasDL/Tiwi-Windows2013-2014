use strict;
use warnings;
use Win32::OLE;
use Win32::OLE::Const 'Microsoft WMI Scripting';
$Win32::OLE::Warn = 3;


my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost","root/cimv2");

my $instances = $wbem->instancesOf("Win32_OperatingSystem");
########### of via class object
#my $class = $wbem->Get("Win32_OperatingSystem");
#my $instances = $class->Instances_();
########### of via query
#my $instances = $wbem->ExecQuery("Select * from Win32_OperatingSystem");

my ($instance) = in $instances;
print $instance->{Caption},"versie ",$instance->{Version},"\n",
	$instance->{CSDVersion},"\n",
	$instance->{OSArchitecture};
