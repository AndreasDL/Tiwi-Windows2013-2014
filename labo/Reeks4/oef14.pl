use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Variant;

my $loc  = Win32::OLE->new("wbemScripting.SWbemLocator");
my $wbem = $loc->ConnectServer("localhost","root/cimv2");

my $dateTime = Win32::OLE->new("WBemScripting.SWbemDateTime");

my $instance = $wbem->Get("Win32_OperatingSystem=@");

print "Het object bevat " , $instance->{properties_}->{Count},
 " properties en " , $instance->{systemProperties_}->{Count} , " systemProperties\n"; 

foreach (in $instance->{systemProperties_}, $instance->{properties_}){
	if ($_->{CIMType} == 101){ #datum
		$dateTime->{Value} = $_->{Value};     
		printf "%-42s : %s \n",$_->{Name},$dateTime->GetVarDate;
	}
	else {
		printf "%-42s : %s %s \n",$_->{Name},
			($_->{Isarray} ? "(ARRAY)" : "",
			($_->{Isarray} ? join ",",@{$_->{Value}} : $_->{Value}));
	}
}