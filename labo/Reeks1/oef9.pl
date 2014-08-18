use strict;
use warnings;
use Win32::OLE;
use Win32::OLE::Const;

$Win32::OLE::Warn = 3;


my $lib = Win32::OLE::Const->Load(".*CDO");
while ( my($k,$v) = each %{$lib} ){
	print "$k : $v \n";
}