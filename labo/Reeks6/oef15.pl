use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $pater = "OU=225,OU=PC's,OU=iii,DC=iii,DC=hogent,DC=be";
my $obj   = bindObj($pater);
foreach (in $obj){
	print $_->{cn} , "\n";
}

print "\n\n\n";

my $monik = "cn=system,dc=iii,dc=hogent,dc=be";
my $objj  = bindObj($monik);
foreach (in $objj){
	print $_->{cn} , ":" , $_->{class},  "\n";
}

sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par );
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject( 
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			"",
			"",
			1
		);
	}
}