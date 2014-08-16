use strict;
use warnings;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 1; #niet instellen op 3 of 4 - weglaten kan wel

# implementatie bind_object functie: zie sectie 5b
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

#LDAP-attribuut ophalen met get
my $RootObj = bind_object("RootDSE");
#print "Domeingegevens:        ",$RootObj->get("defaultNamingContext"),"\n";
#print "Configuratie gegevens: ",$RootObj->get("configurationNamingContext"),"\n";
#print "Schema:                ",$RootObj->get("schemaNamingContext"),"\n";

#onthoud de domeinnaam voor serverless binding
my $domein = $RootObj->get("defaultNamingContext");

#AD-object naar keuze
my $object=bind_object("ou=iii,$domein");
printf "\n\nEerste poging - geeft geen fout, maar ook geen waarde  \ncanonicalName = %s\n",$object->{canonicalName};
printf "\nFout:%s", Win32::OLE->LastError();

printf "\n\nTweede poging  \ncanonicalName = %s\n",@{$object->getEx("canonicalName")};
printf "\nFout:%s", Win32::OLE->LastError(); #resulteert in de fout 0x8000500D

$object->getInfo();
printf "\n\nDerde poging  \ncanonicalName = %s\n",@{$object->getEx("canonicalName")};
printf "\nFout:%s", Win32::OLE->LastError();

$object->GetInfoEx(["canonicalName"],0);
printf "\n\nVierde poging  \ncanonicalName = %s\n",@{$object->getEx("canonicalName")};
