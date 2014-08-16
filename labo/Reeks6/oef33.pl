use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;


sub bindObj{
	my $par = shift;
	if ( uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par);
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ?  "" : "LDAP://193.190.126.71/") . $par,
			"",
			"",
			1
		);
	}
}


my $rootDSE = bindObj("rootDSE");
my $schema  = bindObj($rootDSE->Get("SchemaNamingContext"));
   $schema->{Filter} = ["attributeSchema"];

my $multi  = 0;
my $global = 0;
my $index  = 0;
my $notrep = 0;
my $constr = 0;
my $limit  = 0;
my $msspef = 0;
my $syston = 0;

foreach $a (in $schema){
	$multi++  unless $a->{isSingleValued};
	$global++ if $a->{isMemberOfPartialAttributeSet};
	$index++  if $a->{searchflags} & 1;
	$notrep++ if $a->{systemFlags} & 1;
	$constr++ if $a->{systemFlags} & 4;
	$limit++  if ( defined($a->{rangeLower}) || defined($a->{rangeUpper}) );
	$msspef++ if substr( $a->{attributeID},0,15 ) eq "1.2.840.113556";
	$syston++ if $a->{systemOnly};
}

print "\nZijn multivalued                      : " , $multi ;
print "\nWorden opgenomen in de Global Catalog : " , $global;
print "\nWorden geindexeerd                    : " , $index ;
print "\nWorden niet gerepliceerd              : " , $notrep;
print "\nWorden geconstrueerd                  : " , $constr;
print "\nHebben waarden met beperking op bereik: " , $limit ;
print "\nActive Directory specifiek            : " , $msspef;
print "\nKunnen niet gewijzigd worden          : " , $syston;