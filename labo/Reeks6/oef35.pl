use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Variant;
$Win32::OLE::Warn  = 1;

my $klasse = "user";# "Ldap-Display-Name";
# "user";

my @classAttributes = qw(cn distinguishedName canonicalName ldapDisplayName
        governsID subClassOf systemAuxiliaryClass AuxiliaryClass
        objectClassCategory systemPossSuperiors possSuperiors
        systemMustContain mustContain systemMayContain mayContain);

my @attrAttributes = qw (cn distinguishedName canonicalName ldapDisplayName
        attributeID attributeSyntax rangeLower rangeUpper
        isSingleValued isMemberOfPartialAttributeSet
        searchFlags  systemFlags);

my %E_ADS = (
    "BAD_PATHNAME"            => Win32::OLE::HRESULT(0x80005000),
    "UNKNOWN_OBJECT"          => Win32::OLE::HRESULT(0x80005004),
    "PROPERTY_NOT_SET"        => Win32::OLE::HRESULT(0x80005005),
    "PROPERTY_INVALID"        => Win32::OLE::HRESULT(0x80005007),
    "BAD_PARAMETER"           => Win32::OLE::HRESULT(0x80005008),
    "OBJECT_UNBOUND"          => Win32::OLE::HRESULT(0x80005009),
    "PROPERTY_MODIFIED"       => Win32::OLE::HRESULT(0x8000500B),
    "OBJECT_EXISTS"           => Win32::OLE::HRESULT(0x8000500E),
    "SCHEMA_VIOLATION"        => Win32::OLE::HRESULT(0x8000500F),
    "COLUMN_NOT_SET"          => Win32::OLE::HRESULT(0x80005010),
    "ERRORSOCCURRED"          => Win32::OLE::HRESULT(0x00005011),
    "NOMORE_ROWS"             => Win32::OLE::HRESULT(0x00005012),
    "NOMORE_COLUMNS"          => Win32::OLE::HRESULT(0x00005013),
    "INVALID_FILTER"          => Win32::OLE::HRESULT(0x80005014),
    "INVALID_DOMAIN_OBJECT"   => Win32::OLE::HRESULT(0x80005001),
    "INVALID_USER_OBJECT"     => Win32::OLE::HRESULT(0x80005002),
    "INVALID_COMPUTER_OBJECT" => Win32::OLE::HRESULT(0x80005003),
    "PROPERTY_NOT_SUPPORTED"  => Win32::OLE::HRESULT(0x80005006),
    "PROPERTY_NOT_MODIFIED"   => Win32::OLE::HRESULT(0x8000500A),
    "CANT_CONVERT_DATATYPE"   => Win32::OLE::HRESULT(0x8000500C),
    "PROPERTY_NOT_FOUND"      => Win32::OLE::HRESULT(0x8000500D) );

sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject((uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://") . $par);
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
my $object  = bindObj("cn=$klasse," . $rootDSE->Get("SchemaNamingContext"));

my @attr;
if ($object->{Class} eq "classSchema"){
	@attr = @classAttributes;
}elsif ($object->{Class} eq "attributeSchema"){
	@attr = @attrAttributes;
}else{
	die "$klasse not valid or not found\n";
}

foreach my $prefix (@attr){
	
	my $tabel = $object->GetEx($prefix);

	if (Win32::OLE->LastError() == $E_ADS{"PROPERTY_NOT_FOUND"}){
		printLijn(\$prefix , "<niet ingesteld>");
	}else{
		printLijn(\$prefix, $_) foreach(@{$tabel});
	}
}

sub printLijn{
	my ( $refPref , $suffix) = @_;
	printf "%-35s|%35s\n" , ${$refPref} , $suffix;
	#${$refPref} = "";
}