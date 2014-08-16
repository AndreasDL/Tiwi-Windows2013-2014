use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Const "Active DS Type Library";
$Win32::OLE::Warn = 3;

sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
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

my $rootDSE = bindObj("rootDSE");
my $schema  = bindObj($rootDSE->Get("SchemaNamingContext"));
   $schema->{Filter} = ["attributeSchema"];

my @constr = ();
my @syston = ();
foreach my$attribuut (in $schema){
	push @constr, $attribuut->{ldapDisplayName} if ($attribuut->{systemFlags} & ADS_SYSTEMFLAG_ATTR_IS_CONSTRUCTED );
	push @syston, $attribuut->{ldapDisplayName} if  $attribuut->{systemOnly};
}

print "\nWorden geconstrueerd         : \n" , join ("\n\t", @constr );
print "\nKunnen niet gewijzigd worden : \n" , join ("\n\t", @syston );