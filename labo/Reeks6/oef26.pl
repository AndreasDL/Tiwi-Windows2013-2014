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
			(uc(substr($par,0,7)) eq "LDAP://" ? "" : "LDAP://193.190.126.71/") . $par,
			"",
			"",
			1
		);
	}
}



my $rootObj = bindObj("RootDSE");
my $cont = bindObj("OU=Studenten,OU=iii,".$rootObj->get("defaultNamingContext"));

print "groepjes:\n";
$cont->{Filter} = ["organizationalUnit"];
foreach my $subcont (in $cont){
	$subcont->GetInfoEx(["ou","msDS-Approx-Immed-Subordinates"],0);
	my $waarde = $subcont->Get("msDS-Approx-Immed-Subordinates");
	printf "% 7s: %d\n" ,$subcont->{ou}, $waarde;
}