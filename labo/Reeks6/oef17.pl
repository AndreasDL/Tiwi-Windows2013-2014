use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $RootObj = bindObj("RootDSE");
$RootObj->{DnsHostName}; #cache brol, zie later

print "Domeingegevens:        $RootObj->{defaultNamingContext}\n";
print "Configuratie gegevens: $RootObj->{configurationNamingContext}\n";
print "Schema:                $RootObj->{schemaNamingContext}\n";

#alternatief, haalt alle partities op:
print join("\n",@{$RootObj->{"namingContexts"}});

sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par );
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") .$par,
			"",
			"",
			1
		);
	}
}