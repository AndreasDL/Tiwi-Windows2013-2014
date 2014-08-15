use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $monik = "CN=Administrator,CN=Users,DC=iii,DC=hogent,DC=be";
my $obj   = bindObj($monik);
print $obj->{GUID} , "\n";

my $objj  = bindObj("<GUID=$obj->{GUID}>");
print $objj ->AdsPath , "\n", $objj->{GUID} , "\n";

sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
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