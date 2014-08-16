use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

sub bind_object{
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


my $RootObj = bind_object("RootDSE");
my $cont = bind_object("OU=Studenten,OU=iii,".$RootObj->get("defaultNamingContext"));

print $cont->{PropertyCount}, " properties in Property Cache\n";
$cont->getInfo();
print $cont->{PropertyCount}, " properties in Property Cache\n";
$cont->getInfoEx(["ou","canonicalName","msDS-Approx-Immed-Subordinates","objectclass"],0);
print $cont->{PropertyCount}, " properties in Property Cache\n";