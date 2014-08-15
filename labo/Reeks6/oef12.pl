use strict;
use warnings;
use Win32::OLE qw(in);
$Win32::OLE::Warn = 3;

sub GetDomeinDN {
    my $RootObj = bindObj("RootDSE");

    print "Server DNS:               $RootObj->{dnsHostName}\n";
    print "       SPN:               $RootObj->{ldapServiceName}\n";
    print "       Datum & tijd:      $RootObj->{currentTime}\n";
    print "       Global Catalog ?   $RootObj->{isGlobalCatalogReady}\n";
    print "       gesynchronizeerd ? $RootObj->{isSynchronized}\n";
    print "       DN:                $RootObj->{serverName}\n";

    print "Domeingegevens:           $RootObj->{defaultNamingContext}\n";
    print "Configuratiegegevens:     $RootObj->{configurationNamingContext}\n";
    print "Schema:                   $RootObj->{schemaNamingContext}\n";

    print "Functioneel niveau \n";
    print "    Forest:               $RootObj->{forestFunctionality}\n";
    print "    Domein:               $RootObj->{domainFunctionality}\n";

    return $RootObj->{defaultNamingContext};
}

my $DomeinDN = GetDomeinDN();

my $o = bindObj("CN=Administrator,CN=Users,$DomeinDN");
print "\n";
print "RDN:                   $o->{Name}\n";
print "klasse:                $o->{Class}\n";
print "objectGUID:            $o->{GUID}\n";
print "ADsPath:               $o->{ADsPath}\n";
print "ADsPath Parent:        $o->{Parent}\n";
print "ADsPath schema klasse: $o->{Schema}\n";


sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III" ){
		return  Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" :"LDAP://") . $par );
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			"",
			"",
			1
		);
	}

}