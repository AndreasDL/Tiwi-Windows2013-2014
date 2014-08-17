use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

sub bindObj {
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

my $who 	= "Andreas De Lille";
my $attr	= "distinguishedName";

my $rootDSE = bindObj("rootDSE");
my $cont    = bindObj("OU=EM7INF,OU=Studenten,OU=iii," . $rootDSE->get("defaultNamingContext"));
my $user    = $cont->getObject("user", "cn=$who");

#niet gevonden? => zoeken bij docenten
unless ($user){
	$cont = bindObj("OU=Docenten,OU=iii," . $rootDSE->get("defaultNamingContext"));
	$user = $cont->getObject("user","cn=$who");
}

die "$who not found!\n" unless $user;

print $user->Get($attr) , "\n";