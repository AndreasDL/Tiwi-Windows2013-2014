use strict;
use warnings;
use Win32::OLE;
$Win32::OLE::Warn = 3;

my $rootDSE = bindObj("RootDSE");
$rootDSE->GetInfo();
print "Domeingegevens:        $rootDSE->{defaultNamingContext}\n";
print "Configuratie gegevens: $rootDSE->{configurationNamingContext}\n";
print "Schema:                $rootDSE->{schemaNamingContext}\n";

sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par);
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			"",
			"",
			1
		);
	}
}