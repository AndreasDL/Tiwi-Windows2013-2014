use strict;
use warnings;
use Win32::OLE 'in';
use Math::BigInt;
$Win32::OLE::Warn = 3;

my $startDir = "C:\\\\Windows";
my $startDep = 2;

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost" , "root/cimv2");

my ($Directory) = (in $wbem->ExecQuery("Select * From Win32_Directory Where Name='$startDir'"));

dirSize($Directory , $startDep);

sub dirSize{
	my ($dir, $depth) = @_;
	my $size = Math::BigInt->new();

	my $query = "ASSOCIATORS OF {Win32_Directory='$dir->{Name}'} WHERE AssocClass=Cim_DirectoryContainsFile";
	$size += $_->{FileSize} foreach in $wbem->ExecQuery($query);

	$query    = "ASSOCIATORS OF {Win32_Directory='$dir->{Name}'} WHERE AssocClass=Win32_SubDirectory Role=GroupComponent";
	$size += dirSize($_,$depth-1) foreach in $wbem->ExecQuery($query);

	printf "%12s%s%s\n", $size,
		( "\t" x ($startDep - $depth + 1) ), 
		$dir->{Name} if $depth >= 0;
	return $size;
}