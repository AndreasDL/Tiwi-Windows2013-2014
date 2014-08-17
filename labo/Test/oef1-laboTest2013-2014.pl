use strict;
use warnings;
use Win32::OLE 'in';
use Win32::OLE::Const "Active DS Type Library";
use Data::Dumper;
$Win32::OLE::Warn = 3;

sub bindObj{
	my $par = shift;
	if (uc($ENV{USERDOMAIN}) eq "III"){
		return Win32::OLE->GetObject( (uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://" ) . $par );
	}else{
		return (Win32::OLE->GetObject("LDAP:"))->OpenDSObject(
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			"",
			"",
			1
		);
	}
}

my $contName = "CN=Andreas De Lille,OU=EM7INF,OU=STUDENTEN,OU=iii";

my $rootDSE = bindObj("rootDSE");
   $rootDSE->GetInfo();
my $object  = bindObj($contName . "," . $rootDSE->{"defaultNamingContext"});

#zoek alle attributen van het object
my $definition = bindObj($object->{Schema});
my @allProp = @{$definition->{MandatoryProperties}};
push @allProp, @{$definition->{OptionalProperties}};

#haal voor elk attribuut het type binnen
my %intProp = ();
foreach ( @allProp ){
	my $attr = bindObj("schema/$_"); #attribuut object ophalen uit abstract schema
	$intProp{$attr->{"name"}} = 1 if $attr->{Syntax} eq "INTEGER"; #de integers bijhouden
}

#haal steek alle int attributen in de cache (zien welke ingevuld zijn)
my @inf = keys %intProp; #rechstreeks met die keys werkte niet bij mij
   $object->getInfoEx( \@inf , 0 );
print "Er zijn " , scalar @inf , " integer attributen, waarvan " 
	, $object->{"PropertyCount"} , " in cache \n";

#haal de opgevulde eruit
for (my $i = 0 ; $i < $object->{"PropertyCount"} ; $i++){
	my $attr = $object->Next()->{Name};
	#print "$attr\n";
	$intProp{$attr} = 0; #false met strict is 0
}
#print Dumper(\%intProp);

#goeie naar @posProp
my @posProp = ();
foreach my $k ( keys %intProp ){
	#print "$k => $intProp{$k} \n";
	push @posProp, $k if ($intProp{$k} == 1);
}
print "Er zijn " , scalar @posProp , " gevonden attributen:\n";
print "$_\n" foreach @posProp;


#verhoog postalcode met 1$
#zou in de buurt moeten komen, mogelijks werkt de update niet als het attribuut nog niet ingesteld is
#kan niet testen vermits ik geen schrijf rechten had
my $countryCode = $object->{countryCode} || 0 ; #indien postcode niet ingesteld is komt er een nul (zie oef 8.7)
   $countryCode++; #verhogen (ofc)
my @tabel = [$countrycode];
   $object->PutEx(ADS_PROPERTY_UPDATE,"countrycode",\@tabel);
   $object->SetInfo();