use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost","root/cimv2");

printf"%-20s = %20s [%s] [%s]\n",
	$_->{Name}, $_->{VariableValue}, $_->{UserName}, $_->{SystemVariable}
foreach sort {uc($a->{Name}) cmp uc($b->{Name})} in $wbem->instancesOf("Win32_Environment");