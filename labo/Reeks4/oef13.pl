use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost", "root/cimv2");

my $obj = $wbem->Get("Win32_Service.Name='Browser'");
printf "%-30s %s\n",
	$_->{Name},
	ref $_->{Value} eq "ARRAY" ? join "," , @{$_->{Value}} : $_->{Value}
foreach sort{uc($a->{Name}) cmp uc($b->{Name})} in $obj->{Properties_} , $obj->{SystemProperties_};