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

my $rootDSE = bindObj("rootDSE");
my $schema  = bindObj($rootDSE->Get("SchemaNamingContext"));

my $top      = 0;
my $aux      = 0;
my $auxdep   = 0;
my $ms       = 0;
my $systonly = 0;
my $RDNnotCN = 0;

$schema->{Filter} = ["classSchema"]; #enkel klassen

foreach my $k (in $schema){
	$top++      if $k->{subClassOf} eq "top";
	$aux++      if $k->{objectClassCategory} == 3;
	$auxdep++   if ( defined($k->{systemAuxiliaryClass}) || defined($k->{AuxiliaryClass}) );
	$ms++       if substr($k->{governsID},0,15) eq "1.2.840.113556";
	$systonly++ if $k->{systemOnly};
	$RDNnotCN++ if $k->{rdnAttID} ne "cn";
}

print "\nKinderen van top             : " , $top;
print "\nHulpklassen                  : " , $aux;
print "\nAfhankelijk van hulpklasse(n): " , $auxdep;
print "\nActive Directory specifiek   : " , $ms;
print "\nKunnen niet gewijzigd worden : " , $systonly;
print "\nRDN niet van de vorm CN=...  : " , $RDNnotCN;