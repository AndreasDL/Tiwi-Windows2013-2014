use strict;
use warnings;
use Win32::OLE;
 #$Win32::OLE::Warn = 3; mag niet want we vangen fouten op

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");


sub getNamespaces{
	my $ns = shift;
	print $ns , "\n";
	my $wbem = $loc->ConnectServer("localhost",$ns);
	return if (Win32::OLE->LastError()); #verbinding maken niet mogelijk

	my $instances = $wbem->ExecQuery("select * from __NAMESPACE");
	return unless $instances->{Count};
	getNamespaces($_) foreach sort {uc($a) cmp uc($b)} map {$_->{Name}} in $instances;
}

getNamespaces("root"); #start at root