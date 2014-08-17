use strict;
use warnings;
use Win32::OLE 'in';
$Win32::OLE::Warn = 3;

my $ldap = "subClassOf";
my @attr = qw(OID AuxDerivedFrom Abstract Auxiliary PossibleSuperiors MandatoryProperties OptionalProperties Container Containment);

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

my $obj = bindObj("schema/$ldap");


foreach my $a (@attr){
	printf "%-20s \t=>>\t %s\n" , $a , $obj->{$a} ;
}


foreach my $prefix (@attr){
    my $attribuut = $obj->{$prefix};
    printlijn( \$prefix, $_ ) foreach ref $attribuut eq "ARRAY" ? @{$attribuut} : $attribuut;
}

sub printlijn {
    my ( $refprefix, $suffix ) = @_;
    printf "%-35s%s\n", ${$refprefix}, $suffix;
    ${$refprefix} = "";
}