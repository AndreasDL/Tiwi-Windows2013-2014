use strict;
use warnings;
use Win32::OLE;
use Win32::OLE::Const;

$Win32::OLE::Warn = 3;


my %lib =%{Win32::OLE->new("CDO.Message")};
foreach ( sort {$b cmp $a} keys %lib){
	printf "%30s : %s\n",$_, $lib{$_};

}