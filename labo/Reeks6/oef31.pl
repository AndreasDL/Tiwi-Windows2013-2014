use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

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

my $rootDSE     = bindObj("RootDSE");
my $reeelschema = bindObj( $rootDSE->Get("schemaNamingContext") );

my %reeel;
foreach (in $reeelschema){
	$reeel{$_->{class}}++;
}

while ( my($k => $v) = each %reeel){
	print $k , "\t", $v , "\n";
}